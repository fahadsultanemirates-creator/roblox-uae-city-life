-- UAE CITY LIFE v6.1: QUALITY FOUNDATION / COLLISION SAFETY / VISUAL VARIETY
-- Dedicated corrective patch, NOT another claim of a finished Brookhaven-level game.
-- Apply to your SAVED v6.0 place in Roblox Studio EDIT mode only, Play stopped.
-- Back up the v6.0 .rbxl first; older city and scripts are not deleted.
local RunService=game:GetService("RunService")
assert(not RunService:IsRunning(),"Press STOP before running this installer.")
local world=workspace:FindFirstChild("UAE_City_Life")
assert(world,"Open your existing UAE City Life game. A blank Baseplate will not work.")
assert(world:FindFirstChild("Phase60_World") or world:FindFirstChild("Phase60_ProductionPass"),
 "Requires Version 6.0 saved place with Phase60_World or Phase60_ProductionPass.")
local server=game:GetService("ServerScriptService")
assert(world:FindFirstChild("EmergencyVehicles"),
 "Legacy drivable vehicle folder missing; cannot safely replace its driving controller.")
local old=world:FindFirstChild("Phase61_QualityFoundation")
if old then old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase61_QualityFoundation"
root.Parent=world
local replacements={
 -- The old driving system teleports anchored cars with PivotTo without a physics check.
 "UAE_Driving",
 -- Old Phase 6 decorative skins would cover the newly modeled vehicle silhouettes.
 "UAE60_Vehicles","UAE60_VehicleArt",
 -- Old Phase 6 background traffic overlaps our new lane traffic system.
 "UAE60_Traffic","UAE60_LaneTraffic",
 -- Legacy decorative car systems should not generate duplicate traffic after Play.
 "UAE55_TrafficAndVehicles",
}
local disabled={}
for _,name in ipairs(replacements) do
 local prior=server:FindFirstChild(name)
 if prior and prior:IsA("Script") then
  prior.Disabled=true
  prior:SetAttribute("DisabledForPhase61",true)
  disabled[#disabled+1]=name
 end
end
local function install(name,source)
 local existing=server:FindFirstChild(name)
 if existing then existing:Destroy() end
 local scriptObj=Instance.new("Script")
 scriptObj.Name=name
 scriptObj.Source=source
 scriptObj.Parent=server
 return scriptObj
end
install("UAE61_SafeDriving",[========[
-- UAE CITY LIFE v6.1: Collision-first anchored arcade driving controller.
-- Replaces UAE_Driving. Safely keeps the existing client UAE_DriveInput contract.
-- Vehicles remain anchored prototypes, but swept hull checks stop wall tunnelling.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local garage=world:WaitForChild("EmergencyVehicles")
local input=RS:FindFirstChild("UAE_DriveInput")
if not input then
 input=Instance.new("RemoteEvent")
 input.Name="UAE_DriveInput"
 input.Parent=RS
end
local controls={}
local connections={}
local lastCrash={}
local lastWarn={}
local speeds={Police=42,Ambulance=37,Fire=27,Taxi=37,Family=38,Sedan=42}
local sizes={
 Fire=Vector3.new(12,4.6,27),
 Ambulance=Vector3.new(11,4.8,22),
 Police=Vector3.new(10,4.2,19),
 Taxi=Vector3.new(9,4,16),
 Family=Vector3.new(10,4.2,19),
 Sedan=Vector3.new(9,4,16),
}
local notices=RS:FindFirstChild("UAE60_Notice")
local function findVehicle(seat)
 if typeof(seat)~="Instance" or not seat:IsA("VehicleSeat") then return nil end
 if seat.Name~="DriverSeat" then return nil end
 local model=seat.Parent
 if not model or not model:IsA("Model") then return nil end
 if model.Parent~=garage or model:GetAttribute("UAEVehicle")~=true then return nil end
 return model
end
local function ownedDriver(player,seat)
 local car=findVehicle(seat)
 if not car then return false end
 local owner=car:GetAttribute("OwnerUserId")
 if typeof(owner)=="number" and owner~=player.UserId then return false end
 local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
 return hum and hum.Health>0 and seat.Occupant==hum
end
local function notify(driver,text)
 if not driver or not driver.Parent then return end
 if not notices then notices=RS:FindFirstChild("UAE60_Notice") end
 if notices and notices:IsA("RemoteEvent") then
  notices:FireClient(driver,text)
 end
end
local function hull(car)
 local vehicleType=tostring(car:GetAttribute("VehicleType") or "Sedan")
 if sizes[vehicleType] then return sizes[vehicleType] end
 local name=string.lower(car.Name)
 if name:find("fire",1,true) or name:find("civil",1,true) then return sizes.Fire end
 if name:find("ambulance",1,true) then return sizes.Ambulance end
 if name:find("police",1,true) then return sizes.Police end
 return sizes.Sedan
end
local function isBlocked(car,goal,driver)
 local size=hull(car)
 local old=car:GetPivot()
 local delta=goal.Position-old.Position
 local excludes={car}
 if driver and driver.Character then table.insert(excludes,driver.Character) end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=excludes
 params.RespectCanCollide=true
 params.IgnoreWater=true
 local lift=4.8
 local start=old*CFrame.new(0,lift,0)
 local hit=nil
 if delta.Magnitude>.0001 then
  hit=workspace:Blockcast(start,size,delta+delta.Unit*.75,params)
 end
 if hit and hit.Instance and hit.Instance.CanCollide then
  return true,hit.Instance
 end
 -- Blockcast does not detect existing overlaps or a turn-in-place near walls.
 -- Check only collidable parts whose volume reaches car body height.
 local overlap=OverlapParams.new()
 overlap.FilterType=Enum.RaycastFilterType.Exclude
 overlap.FilterDescendantsInstances=excludes
 overlap.RespectCanCollide=true
 overlap.MaxParts=24
 local goalBox=goal*CFrame.new(0,lift,0)
 for _,p in ipairs(workspace:GetPartBoundsInBox(goalBox,size,overlap)) do
  if p.CanCollide and p:IsA("BasePart") then
   -- Do not confuse thin horizontal streets/floors with building facades.
   local highest=p.Position.Y+p.Size.Y*.5
   if highest>goal.Position.Y+2.3 then
    return true,p
   end
  end
 end
 return false,nil
end
local function impact(car,driver,other)
 local now=os.clock()
 if now-(lastCrash[car] or 0)<2.0 then return end
 lastCrash[car]=now
 local dmg=math.clamp((car:GetAttribute("UAE60Damage") or 0)+9,0,100)
 car:SetAttribute("UAE60Damage",dmg)
 car:SetAttribute("UAE61BlockedBy",other and other.Name or "Obstacle")
 notify(driver,"Vehicle stopped before an obstacle. Collision damage: "..dmg.."/100.")
end
input.OnServerEvent:Connect(function(player,seat,throttle,steer)
 local model=findVehicle(seat)
 if not model or not ownedDriver(player,seat) then return end
 if typeof(throttle)~="number" or typeof(steer)~="number" then return end
 if throttle~=throttle or steer~=steer then return end
 if math.abs(throttle)>1 or math.abs(steer)>1 then return end
 controls[model]={t=throttle,s=steer,player=player,updated=os.clock()}
end)
local function setup(obj)
 if not obj:IsA("VehicleSeat") then return end
 local car=findVehicle(obj)
 if not car or connections[obj] then return end
 local prompt=obj:FindFirstChild("EntryPrompt")
 local cons={}
 -- V5.2 privately-owned garage cars already have an owner-only prompt.
 -- Avoid installing a duplicate open-to-all entry handler.
 local owner=car:GetAttribute("OwnerUserId")
 if not owner and prompt and prompt:IsA("ProximityPrompt") then
  cons[#cons+1]=prompt.Triggered:Connect(function(player)
   local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
   local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
   if hum and hum.Health>0 and root and obj.Occupant==nil and
      (root.Position-obj.Position).Magnitude<19 then
    obj:Sit(hum)
   end
  end)
 end
 cons[#cons+1]=obj:GetPropertyChangedSignal("Occupant"):Connect(function()
  if not obj.Occupant then controls[car]=nil end
 end)
 connections[obj]=cons
end
for _,d in ipairs(garage:GetDescendants()) do setup(d) end
garage.DescendantAdded:Connect(function(obj)
 if obj:IsA("VehicleSeat") then task.delay(.1,function()
  if obj.Parent then setup(obj) end
 end) end
end)
local clock=0
RunService.Heartbeat:Connect(function(dt)
 clock=clock+math.min(dt,.1)
 if clock<1/30 then return end
 local step=math.min(clock,.09)
 clock=0
 for car,c in pairs(controls) do
  local seat=car.Parent and car:FindFirstChild("DriverSeat")
  if not seat or not seat.Occupant or not c.player.Parent or
      not ownedDriver(c.player,seat) or os.clock()-c.updated>.55 then
   controls[car]=nil
  else
   local vehicleType=tostring(car:GetAttribute("VehicleType") or "Sedan")
   local speed=(speeds[vehicleType] or 35)*c.t*step
   local turn=math.rad(50)*c.s*step
   local old=car:GetPivot()
   local goal=old*CFrame.Angles(0,-turn,0)*CFrame.new(0,0,-speed)
   local p=goal.Position
   if p.X < -1590 or p.X>1650 or p.Z < -1520 or p.Z>720 then
    if os.clock()-(lastWarn[car] or 0)>2 then
     lastWarn[car]=os.clock()
     notify(c.player,"City boundary reached. Turn around.")
    end
   else
    local blocked,obstacle=isBlocked(car,goal,c.player)
    if blocked then
     if math.abs(speed)>1.1 then impact(car,c.player,obstacle) end
     car:SetAttribute("UAE61MotionBlocked",true)
    else
     car:SetAttribute("UAE61MotionBlocked",false)
     car:PivotTo(goal)
    end
   end
  end
 end
end)
print("[UAE 6.1] Driving controller: swept collision checks installed for emergency and personal cars.")

]========])
install("UAE61_Traffic",[========[
-- UAE City Life v6.1: six distinct E11 traffic silhouettes and wall-aware lane movement.
-- Ambient traffic is kinematic scenery. It is NOT a fully physical road-driving AI.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:FindFirstChild("Phase60_World") or world:FindFirstChild("Phase60_ProductionPass")
if not root then warn("[UAE61] Traffic requires a Version 6 world.") return end
local prior=root:FindFirstChild("E11MovingTraffic")
if prior then prior:Destroy() end
local folder=Instance.new("Folder")
folder.Name="E11MovingTraffic"
folder.Parent=root
local function c(r,g,b) return Color3.fromRGB(r,g,b) end
local ink=c(27,33,39)
local chrome=c(172,188,195)
local glass=c(67,129,159)
local function part(model,name,size,cf,tint,mat)
 local obj=Instance.new("Part")
 obj.Name=name
 obj.Size=size;obj.CFrame=cf
 obj.Color=tint;obj.Material=mat or Enum.Material.Metal
 obj.Anchored=true;obj.CanCollide=false;obj.CanQuery=false;obj.CanTouch=false
 obj.Parent=model
 return obj
end
local models={
 {kind="Sedan",color=c(228,235,237),trim=c(36,63,81),w=9.5,l=19,h=8.5},
 {kind="Taxi",color=c(227,208,171),trim=c(190,60,53),w=9.6,l=19,h=8.7},
 {kind="SUV",color=c(51,94,117),trim=c(38,40,44),w=10.7,l=22,h=10},
 {kind="Hatchback",color=c(172,74,66),trim=c(45,55,61),w=9.2,l=16.2,h=9},
 {kind="Minibus",color=c(232,229,211),trim=c(41,125,116),w=11,l=27,h=12.2},
 {kind="Luxury Saloon",color=c(51,53,66),trim=c(168,150,117),w=10.2,l=22,h=8.8},
}
local function makeVehicle(i,conf)
 local model=Instance.new("Model")
 model.Name=conf.kind.." - Civilian Traffic "..i
 model:SetAttribute("UAE60NoArt",true)
 model:SetAttribute("UAE61Traffic",true)
 model.Parent=folder
 local pivot=part(model,"Pivot",Vector3.new(.2,.2,.2),CFrame.new(),ink)
 pivot.Transparency=1
 model.PrimaryPart=pivot
 local w,l,h=conf.w,conf.l,conf.h
 local f=-l*.5
 local r=l*.5
 part(model,"Painted chassis",Vector3.new(w,2.7,l-1),CFrame.new(0,4.2,0),conf.color)
 part(model,"Lower bumper line",Vector3.new(w+.5,.65,l),CFrame.new(0,3.1,0),ink)
 local cabinLength=(conf.kind=="Minibus") and l-4 or l*.48
 local cabinZ=(conf.kind=="Hatchback") and .8 or 1.5
 local cabinHeight=(conf.kind=="Minibus") and 6 or 2.8
 part(model,"Window cabin",Vector3.new(w-1.0,cabinHeight,cabinLength),
  CFrame.new(0,6.2+cabinHeight*.24,cabinZ),glass,Enum.Material.Glass).Transparency=.15
 part(model,"Cabin color roof",Vector3.new(w-1.3,.6,cabinLength+.5),
  CFrame.new(0,6.7+cabinHeight*.5,cabinZ),conf.color)
 if conf.kind~="Minibus" then
  local hood=Instance.new("WedgePart")
  hood.Name="Sloped front bonnet"
  hood.Size=Vector3.new(w-.2,1.5,5.7)
  hood.CFrame=CFrame.new(0,5.4,f+3)*CFrame.Angles(0,math.pi,0)
  hood.Color=conf.color;hood.Material=Enum.Material.Metal
  hood.Anchored=true;hood.CanCollide=false;hood.CanQuery=false
  hood.Parent=model
 else
  part(model,"Transit band",Vector3.new(w+.15,1.1,l-.4),
   CFrame.new(0,5,0),conf.trim)
 end
 for _,sgn in ipairs({-1,1}) do
  for _,z in ipairs({f+4.9,r-4.9}) do
   local wheel=part(model,"Four-round rubber tyre",
    Vector3.new(1.6,4.35,4.35),CFrame.new(sgn*(w/2+.1),2.65,z),ink,Enum.Material.Rubber)
   wheel.Shape=Enum.PartType.Cylinder
   local rim=part(model,"Alloy wheel hub",
    Vector3.new(.2,2.55,2.55),CFrame.new(sgn*(w/2+.98),2.65,z),chrome)
   rim.Shape=Enum.PartType.Cylinder
  end
  part(model,"Angular side mirrors",Vector3.new(1.2,.8,1.6),
   CFrame.new(sgn*(w*.5+.45),6.5,f+5.5),conf.trim)
  part(model,"White front daytime LEDs",Vector3.new(2.0,.6,.28),
   CFrame.new(sgn*(w*.5-1.6),5.2,f-.15),c(255,244,202),Enum.Material.Neon)
  part(model,"Red brake lamps",Vector3.new(2.1,.7,.27),
   CFrame.new(sgn*(w*.5-1.6),5.2,r+.15),c(210,55,58),Enum.Material.Neon)
 end
 if conf.kind=="Taxi" then
  part(model,"Dubai Taxi roof light",Vector3.new(4,1.2,2.0),
   CFrame.new(0,h+1,0),c(248,225,173),Enum.Material.Neon)
 elseif conf.kind=="SUV" then
  for _,sgn in ipairs({-1,1}) do
   part(model,"SUV roof rail",Vector3.new(.36,.5,cabinLength),
    CFrame.new(sgn*(w*.5-1.4),h+.4,cabinZ),chrome)
  end
 elseif conf.kind=="Minibus" then
  for _,z in ipairs({-6,0,6}) do
   part(model,"Bus passenger door line",Vector3.new(w+.1,.3,.4),
    CFrame.new(0,7.1,z),conf.trim)
  end
 end
 return model
end
local routes={
 {-56,-1420,-1025}, {-36,-1340,-990},
 {38,-985,-1420}, {57,-1000,-1380},
 {-56,-1190,-1020}, {38,-1250,-1430},
}
local active={}
local low=root:GetAttribute("LowPerformance")==true
for i,route in ipairs(routes) do
 if not low or i<=4 then
  local config=models[i]
  local model=makeVehicle(i,config)
  local from=Vector3.new(route[1],1.45,route[2])
  local to=Vector3.new(route[1],1.45,route[3])
  local forward=(to-from).Unit
  model:PivotTo(CFrame.lookAt(from,from+forward))
  active[#active+1]={model=model,pos=from,a=from,b=to,to=to,
    speed=0,cruise=17+(i%3)*3,wait=0}
 end
end
local castParams=RaycastParams.new()
castParams.FilterType=Enum.RaycastFilterType.Exclude
castParams.FilterDescendantsInstances={folder}
castParams.RespectCanCollide=true
castParams.IgnoreWater=true
local function wallAhead(car,dir)
 local p=car.pos+Vector3.new(0,5,0)
 local across=Vector3.new(1,0,0)
 for _,offset in ipairs({-3,0,3}) do
  local start=p+across*offset
  local hit=workspace:Raycast(start,dir*22,castParams)
  if hit and hit.Instance and hit.Instance.CanCollide then
   return true
  end
 end
 return false
end
local elapsed=0
RunService.Heartbeat:Connect(function(dt)
 elapsed=elapsed+math.min(dt,.1)
 if elapsed<.13 then return end
 local step=math.min(elapsed,.19)
 elapsed=0
 for _,car in ipairs(active) do
  if not car.model.Parent then continue end
  local diff=car.to-car.pos
  if diff.Magnitude<5 then
   car.to=car.to==car.a and car.b or car.a
   diff=car.to-car.pos
   car.wait=.9
  end
  if diff.Magnitude<.1 then continue end
  local forward=diff.Unit
  local blocked=wallAhead(car,forward)
  for _,p in ipairs(Players:GetPlayers()) do
   local rootPart=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   if rootPart then
    local rel=rootPart.Position-car.pos
    if rel.Magnitude<29 and rel:Dot(forward)>-2 then blocked=true end
   end
  end
  for _,other in ipairs(active) do
   if other~=car then
    local offset=other.pos-car.pos
    if offset.Magnitude<27 and offset:Dot(forward)>4 then blocked=true end
   end
  end
  if car.wait>0 then
   car.wait=math.max(0,car.wait-step)
   blocked=true
  end
  local desired=blocked and 0 or car.cruise
  local acceleration=blocked and 70 or 13
  car.speed=car.speed+math.clamp(desired-car.speed,-acceleration*step,acceleration*step)
  local travel=math.min(car.speed*step,diff.Magnitude)
  if travel>0 then
   car.pos=car.pos+forward*travel
   car.model:PivotTo(CFrame.lookAt(car.pos,car.pos+forward))
  end
 end
end)
print("[UAE 6.1] Six visually different E11 civilian cars, lane following + wall probes.")

]========])
install("UAE61_Fleet",[========[
-- UAE CITY LIFE 6.1: distinct original vehicle bodies for existing drivable fleets.
-- Requires external licensed meshes for photorealism; these are refined procedural prototypes.
local world=workspace:WaitForChild("UAE_City_Life")
local fleet=world:WaitForChild("EmergencyVehicles")
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local C={snow=rgb(237,240,239),black=rgb(26,29,33),steel=rgb(158,174,180),
 blue=rgb(38,98,153),green=rgb(22,98,70),red=rgb(200,48,60),yellow=rgb(237,188,67),
 glass=rgb(66,131,162),taxi=rgb(229,215,178),lux=rgb(45,67,81),
 gray=rgb(88,98,109),amber=rgb(255,229,171),silver=rgb(208,218,216)}
local configured={}
local function vehicleClass(model)
 local kind=tostring(model:GetAttribute("VehicleType") or "")
 local name=string.lower(model.Name.." "..kind)
 if name:find("aircraft") or name:find("helicopter") then return nil end
 if name:find("ambul",1,true) then return "Ambulance" end
 if name:find("fire",1,true) or name:find("civil",1,true) or name:find("rescue",1,true) then return "Fire" end
 if name:find("police",1,true) then return "Police" end
 if name:find("taxi",1,true) then return "Taxi" end
 if name:find("bus",1,true) then return "Bus" end
 if name:find("family",1,true) or name:find("suv",1,true) then return "SUV" end
 return "Sedan"
end
local configs={
 Sedan={w=9.4,l=19,roof=8.3,wheel=4.5,paint=C.lux,trim=C.steel},
 Taxi={w=9.6,l=19.4,roof=8.5,wheel=4.6,paint=C.taxi,trim=C.red},
 SUV={w=10.7,l=22.5,roof=9.7,wheel=5.1,paint=C.snow,trim=C.black},
 Police={w=10.5,l=22.8,roof=9.6,wheel=5.0,paint=C.snow,trim=C.green},
 Ambulance={w=11.6,l=26,roof=11.7,wheel=5.1,paint=C.snow,trim=C.blue},
 Fire={w=12.5,l=33,roof=12.8,wheel=5.8,paint=C.yellow,trim=C.red},
 Bus={w=12.2,l=33,roof=12.7,wheel=5.2,paint=C.snow,trim=C.green},
}
local function create(parent,class,name,size,cf,col,material,alpha)
 local obj=Instance.new(class)
 obj.Name=name
 obj.Size=size
 obj.CFrame=cf
 obj.Color=col
 obj.Material=material or Enum.Material.Metal
 obj.Anchored=true
 obj.CanCollide=false
 obj.CanQuery=false
 obj.CanTouch=false
 obj.Transparency=alpha or 0
 obj.TopSurface=Enum.SurfaceType.Smooth
 obj.BottomSurface=Enum.SurfaceType.Smooth
 obj.Parent=parent
 return obj
end
local function signage(parent,content,cf,w,h,bg)
 local plate=create(parent,"Part","Vehicle service label",
  Vector3.new(w,h,.24),cf,bg)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=35
 gui.Parent=plate
 local txt=Instance.new("TextLabel")
 txt.Size=UDim2.fromScale(1,1)
 txt.BackgroundTransparency=1
 txt.Font=Enum.Font.GothamBold
 txt.TextScaled=true
 txt.TextWrapped=true
 txt.TextColor3=C.snow
 txt.Text=content
 txt.Parent=gui
end
local function style(model)
 if configured[model] or not model.Parent or model:GetAttribute("UAE61NoSkin") then return end
 local kind=vehicleClass(model)
 local cfg=configs[kind]
 if not cfg then return end
 configured[model]=true
 -- Pivot preservation is mandatory: the driving script moves the Model using PivotTo.
 local pivot=model:GetPivot()
 local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
 local existing=model:FindFirstChild("UAE61_DistinctVehicleBody")
 if existing then existing:Destroy() end
 local new=Instance.new("Model")
 new.Name="UAE61_DistinctVehicleBody"
 new.Parent=model
 -- Original v4/v5/v6 cosmetics are hidden but preserved in the saved version.
 for _,obj in ipairs(model:GetDescendants()) do
  if obj:IsA("BasePart") and not obj:IsDescendantOf(new) and obj~=seat then
   if obj:GetAttribute("UAE61PrevTransparency")==nil then
    obj:SetAttribute("UAE61PrevTransparency",obj.Transparency)
   end
   obj.Transparency=1
   obj.CanCollide=false
   obj.CanQuery=false
  end
 end
 local function p(class,name,size,x,y,z,tint,mat,alpha,rotation)
  return create(new,class,name,size,
   pivot*CFrame.new(x,y,z)*(rotation or CFrame.new()),tint,mat,alpha)
 end
 local w,l,r=cfg.w,cfg.l,cfg.roof
 local front=-l*.5
 local rear=l*.5
 local tall=kind=="Ambulance" or kind=="Fire" or kind=="Bus"
 p("Part","Underbody deep sill",Vector3.new(w-.2,1.0,l-1),0,3.4,0,C.black)
 p("Part","Layered painted metal chassis",Vector3.new(w,2.1,l-.6),0,4.6,0,cfg.paint)
 p("Part","Rear contoured bumper",Vector3.new(w+.3,.8,.9),0,3.7,rear,C.steel)
 p("Part","Front grille and bumper",Vector3.new(w+.3,.85,1.0),0,3.75,front,C.black)
 local glazingH=2.6
 if tall then
  local cabinSection=kind=="Fire" and 10.4 or kind=="Bus" and l-3.5 or 9.1
  local cabZ=front+cabinSection*.5
  p("Part","Tall commercial driver's cab",Vector3.new(w-.5,r-4.6,cabinSection),
   0,(r+4.6)/2+2.2,cabZ,cfg.paint)
  p("Part","Full-height smoked windscreen",Vector3.new(w-1.2,3.1,.30),
   0,8.1,front+.45,C.glass,Enum.Material.Glass,.15)
  if kind=="Ambulance" or kind=="Fire" then
   local rearLen=l-cabinSection
   p("Part","Dedicated service box",Vector3.new(w-.5,r-4.7,rearLen-.5),
    0,4.7+(r-4.7)/2,front+cabinSection+rearLen*.5,cfg.paint)
   p("Part","Raised rear equipment roof",Vector3.new(w-.15,.8,rearLen-.4),
    0,r,front+cabinSection+rearLen*.5,C.snow)
  else
   for _,z in ipairs({-8,-1,6,12}) do
    p("Part","Bus continuous passenger window",Vector3.new(w+.1,2.9,4.3),
     0,8,z,C.glass,Enum.Material.Glass,.12)
   end
  end
 else
  local roofLength=(kind=="SUV" or kind=="Police") and l*.57 or l*.46
  local roofZ=(kind=="SUV" or kind=="Police") and .7 or 1.3
  p("Part","Shaped glass passenger cabin",Vector3.new(w-1.15,2.6,roofLength),
   0,7.2,roofZ,C.glass,Enum.Material.Glass,.16)
  p("Part","Painted aerodynamic roof",Vector3.new(w-1.0,.7,roofLength+.55),
   0,r,roofZ,cfg.paint)
  p("WedgePart","Sloped vehicle bonnet",Vector3.new(w-.7,1.8,5.0),
   0,5.8,front+2.6,cfg.paint,Enum.Material.Metal,0,CFrame.Angles(0,math.pi,0))
  p("WedgePart","Tapered boot",Vector3.new(w-.9,1.1,3.4),
   0,5.7,rear-1.7,cfg.paint)
  if kind=="SUV" or kind=="Police" then
   for _,sgn in ipairs({-1,1}) do
    p("Part","Elevated SUV luggage rail",Vector3.new(.5,.55,roofLength),
     sgn*(w*.5-.95),r+.57,roofZ,C.black)
   end
  end
 end
 p("Part","Two-tone side contour stripe",Vector3.new(w+.1,.46,l-.5),
  0,5.8,0,cfg.trim)
 for _,sgn in ipairs({-1,1}) do
  local wheelOffsets=kind=="Fire" and {front+5,0,rear-5} or {front+5,rear-5}
  for _,z in ipairs(wheelOffsets) do
   local tire=p("Part","Upright circular rubber wheel",
    Vector3.new(1.6,cfg.wheel,cfg.wheel),sgn*(w*.5+.14),
    1.1+cfg.wheel*.5,z,C.black,Enum.Material.Rubber)
   tire.Shape=Enum.PartType.Cylinder
   local rim=p("Part","Aluminium wheel rim",
    Vector3.new(.22,cfg.wheel*.62,cfg.wheel*.62),
    sgn*(w*.5+1.03),1.1+cfg.wheel*.5,z,C.steel)
   rim.Shape=Enum.PartType.Cylinder
  end
  p("Part","Side-view mirror",Vector3.new(1.3,.75,1.5),
   sgn*(w*.5+.35),7.0,front+5,C.black)
  p("Part","Modern white headlight",Vector3.new(2.2,.72,.3),
   sgn*(w*.5-1.5),5.1,front-.14,C.amber,Enum.Material.Neon)
  p("Part","Wrapped red tail light",Vector3.new(2.3,.68,.3),
   sgn*(w*.5-1.5),5.1,rear+.13,C.red,Enum.Material.Neon)
  local wx=sgn*(w*.5+.08)
  if tall then
   p("Part","Passenger cabin side glass",Vector3.new(.22,2.7,4.7),
    wx,8,front+5,C.glass,Enum.Material.Glass,.12)
  else
   p("Part","Main door side glass",Vector3.new(.22,2.0,l*.33),
    wx,7.25,1.2,C.glass,Enum.Material.Glass,.12)
   p("Part","Realistic dark door seam",Vector3.new(.27,2,.2),
    wx,6.7,1.2,C.black)
   p("Part","Silver door handles",Vector3.new(.3,.25,1.3),
    wx,5.85,2.8,C.steel)
  end
 end
 if kind=="Taxi" then
  p("Part","TAXI illuminated roof sign",Vector3.new(4.5,1.2,2.4),
   0,r+.9,0,C.amber,Enum.Material.Neon)
 elseif kind=="Ambulance" then
  p("Part","Ambulance dark blue side graphic",Vector3.new(w+.25,1.7,l*.65),
   0,7.0,2.4,C.blue)
  signage(new,"AMBULANCE  |  الإسعاف",
   pivot*CFrame.new(0,7.1,rear*.40),w*.78,1.7,C.blue)
 elseif kind=="Fire" then
  p("Part","Civil Defence high visibility red band",Vector3.new(w+.25,1.3,l*.75),
   0,6.4,2.7,C.red)
  signage(new,"CIVIL DEFENCE  |  الدفاع المدني",
   pivot*CFrame.new(0,7.3,rear*.40),w*.8,1.7,C.red)
 elseif kind=="Police" then
  p("Part","Dubai Police dark green doors",Vector3.new(w+.2,1.1,l*.54),
   0,5.4,.4,C.green)
  signage(new,"DUBAI POLICE  |  شرطة دبي",
   pivot*CFrame.new(0,5.45,rear*.20),w*.78,1.5,C.green)
 end
 if kind=="Police" or kind=="Ambulance" or kind=="Fire" then
  p("Part","Blue emergency lightbar",Vector3.new(2.9,.75,2),
   -2,r+1,front+7,C.blue,Enum.Material.Neon)
  p("Part","Red emergency lightbar",Vector3.new(2.9,.75,2),
   2,r+1,front+7,C.red,Enum.Material.Neon)
 end
 model:SetAttribute("UAE61ArtStyle",kind)
end
local function scan(obj)
 if not obj:IsA("VehicleSeat") or obj.Name~="DriverSeat" then return end
 local model=obj:FindFirstAncestorOfClass("Model")
 if model and model:GetAttribute("UAEVehicle")==true then
  local success,err=pcall(style,model)
  if not success then warn("[UAE61] Vehicle model error:",model.Name,err) end
 end
end
for _,object in ipairs(fleet:GetDescendants()) do scan(object) end
fleet.DescendantAdded:Connect(function(obj)
 if obj:IsA("VehicleSeat") then
  task.delay(.35,function() if obj.Parent then scan(obj) end end)
 end
end)
print("[UAE 6.1] Fleet: 7 distinct vehicle silhouettes with upright wheels and preserved driving seats.")

]========])
install("UAE61_Architecture",[========[
-- UAE City Life 6.1: architectural variety on existing E11 towers and street shops.
-- Facade palette, crowns, balconies, shade canopies and distinct commercial awnings.
-- No wholesale city destruction; performance-aware limited facade part budget.
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase61_QualityFoundation")
local gallery=Instance.new("Folder")
gallery.Name="ArchitecturalStreetRedesign"
gallery.Parent=root
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local styles={
 {name="Limestone Arabesque",wall=rgb(226,209,180),glass=rgb(78,149,157),frame=rgb(183,150,97),mat=Enum.Material.Concrete},
 {name="Black Steel Tower",wall=rgb(74,83,91),glass=rgb(64,112,154),frame=rgb(173,188,192),mat=Enum.Material.Slate},
 {name="Pearl White Residence",wall=rgb(238,233,216),glass=rgb(114,176,177),frame=rgb(213,191,146),mat=Enum.Material.Concrete},
 {name="Warm Terracotta Offices",wall=rgb(183,115,90),glass=rgb(74,127,152),frame=rgb(93,73,72),mat=Enum.Material.Brick},
 {name="Sky Blue Glass Office",wall=rgb(137,182,198),glass=rgb(60,126,179),frame=rgb(226,230,224),mat=Enum.Material.Metal},
 {name="Sandstone Heritage",wall=rgb(191,164,119),glass=rgb(91,143,142),frame=rgb(134,113,84),mat=Enum.Material.Concrete},
}
local function part(parent,name,sz,cf,color,material)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=sz;p.CFrame=cf
 p.Color=color;p.Material=material
 p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.CanTouch=false
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local modern=world:FindFirstChild("SheikhZayedArchitecture",true)
local changed=0
if modern then
 local towers={}
 for _,f in ipairs(modern:GetChildren()) do
  if f:FindFirstChild("Limestone tower frame") then
   towers[#towers+1]=f
  end
 end
 table.sort(towers,function(a,b)return a.Name<b.Name end)
 for i,tower in ipairs(towers) do
  local core=tower:FindFirstChild("Limestone tower frame")
  if core and core:IsA("BasePart") then
   changed=changed+1
   local style=styles[(i-1)%#styles+1]
   core.Color=style.wall;core.Material=style.mat
   core.CanCollide=true
   local cf=core.CFrame
   local w,h,d=core.Size.X,core.Size.Y,core.Size.Z
   tower:SetAttribute("UAE61Architecture",style.name)
   for _,obj in ipairs(tower:GetDescendants()) do
    if obj:IsA("BasePart") then
     if obj.Name:find("glass",1,true) or obj.Name:find("glazed",1,true) or
        obj.Name:find("window",1,true) then
      obj.Color=style.glass
      obj.Material=Enum.Material.Glass
      obj.Transparency=.17
     end
    end
   end
   local front=d*.5+.9
   local roof=h*.5
   -- Choose visibly different facade details, not identical repeating window strips.
   if i%4==1 then
    for _,sx in ipairs({-w*.35,w*.35}) do
     part(gallery,"Arabesque vertical sandstone ribs",
      Vector3.new(1.8,h*.82,1.1),cf*CFrame.new(sx,0,front),
      style.frame,Enum.Material.Concrete)
    end
    part(gallery,"Gold stepped skyline crown",Vector3.new(w*.74,3.2,d*.78),
     cf*CFrame.new(0,h*.5+3,0),style.frame,Enum.Material.Metal)
   elseif i%4==2 then
    for level=1,math.min(7,math.floor(h/22)) do
     local y=-h*.5+level*(h/8)
     part(gallery,"Deep shaded black steel floor",Vector3.new(w*.92,1.1,d+3),
      cf*CFrame.new(0,y,0),style.frame,Enum.Material.Metal)
    end
    part(gallery,"Glass high-rise spire",Vector3.new(5,22,5),
     cf*CFrame.new(0,h*.5+12,0),style.glass,Enum.Material.Glass)
   elseif i%4==3 then
    for level=1,math.min(9,math.floor(h/16)) do
     local y=-h*.5+level*15
     for _,sgn in ipairs({-1,1}) do
      part(gallery,"Residence projecting balcony",Vector3.new(w*.24,.6,7),
       cf*CFrame.new(sgn*w*.32,y,front+2),
       style.frame,Enum.Material.Concrete)
     end
    end
    part(gallery,"Roof terrace pergola",Vector3.new(w*.65,1.6,d*.5),
     cf*CFrame.new(0,h*.5+5,0),style.frame,Enum.Material.WoodPlanks)
   else
    for _,sx in ipairs({-w*.31,-w*.11,w*.11,w*.31}) do
     part(gallery,"Terracotta facade fin",Vector3.new(.9,h*.85,2),
      cf*CFrame.new(sx,0,front),style.frame,Enum.Material.Metal)
    end
    part(gallery,"Angular parapet",Vector3.new(w*.82,3.2,d*.68),
     cf*CFrame.new(0,h*.5+4,0),style.frame,Enum.Material.Metal)
   end
   local frontSign=part(gallery,"Building entrance sunshade",
    Vector3.new(w*.48,1,9),cf*CFrame.new(0,-h*.5+9,front+4),
    style.frame,Enum.Material.Metal)
  end
 end
end
-- Retail fronts: varied Arabic-inspired tile/warm timber/metal colors and awnings.
local storefront=world:FindFirstChild("CityBusinesses",true)
if storefront then
 local colors={rgb(201,122,75),rgb(55,110,120),rgb(144,92,116),
  rgb(193,156,74),rgb(84,130,93),rgb(54,87,124)}
 local shops=storefront:GetChildren()
 for i,shop in ipairs(shops) do
  local tint=colors[(i-1)%#colors+1]
  for _,obj in ipairs(shop:GetDescendants()) do
   if obj:IsA("BasePart") and (string.find(obj.Name,"Awning",1,true) or
      obj.Name:find("awning") or obj.Name:find("sign") or
      obj.Name:find("Sign") or obj.Name:find("facade")) then
     obj.Color=tint
    end
  end
 end
end
-- Additional clear district markers, placed on side pavements.
local markers={
 {"DOWNTOWN DUBAI",110,-355,rgb(132,99,68)},
 {"BUSINESS DISTRICT",360,-1065,rgb(46,95,110)},
 {"AIRPORT & DXB",-930,-1035,rgb(50,95,124)},
 {"DUBAI MARINA",1045,-1195,rgb(43,106,109)},
}
for _,marker in ipairs(markers) do
 local textLabel,x,z,bg=marker[1],marker[2],marker[3],marker[4]
 local sign=part(gallery,"District monument",Vector3.new(36,7,.7),
  CFrame.new(x,13,z),bg,Enum.Material.Metal)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=35
 gui.Parent=sign
 local label=Instance.new("TextLabel")
 label.Text=textLabel
 label.TextScaled=true
 label.TextWrapped=true
 label.Font=Enum.Font.GothamBold
 label.TextColor3=rgb(241,229,202)
 label.BackgroundTransparency=1
 label.Size=UDim2.fromScale(1,1)
 label.Parent=gui
end
print("[UAE 6.1] Architecture: restyled",changed,"E11 towers with varied crowns, materials, colors and balconies.")

]========])
world:SetAttribute("InstalledVersion","6.1")
print("UAE CITY LIFE v6.1 INSTALLED: collision-safe driving, six distinct traffic types, revised emergency/taxi/SUV bodies and tower facade variety.")
print("Disabled legacy conflicting scripts: "..table.concat(disabled,", "))
print("SAVE AS new v6.1 file; press PLAY to build updated cars, roadside traffic and architecture.")
