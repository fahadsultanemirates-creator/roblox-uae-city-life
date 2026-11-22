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
