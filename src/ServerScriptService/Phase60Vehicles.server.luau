-- UAE City Life 6.0 | improved visual vehicle shapes + collision proxy.
-- Vehicle driving is still handled by the previous UAE_Driving system.
-- Rebuilds cosmetic appearance ONLY; leaves seats, prompts and movement scripts intact.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local notices=RS:WaitForChild("UAE60_Notice")
local clock=RS
local active={}
local originals={}
local lastImpact={}
local function rgb(r,g,b)return Color3.fromRGB(r,g,b) end
local C={
 white=rgb(242,242,233),glass=rgb(76,141,169),shadow=rgb(26,36,43),
 steel=rgb(152,165,176),black=rgb(23,27,30),wheel=rgb(25,27,30),
 green=rgb(17,104,76),gold=rgb(237,190,78),blue=rgb(24,81,142),
 red=rgb(192,50,55),cream=rgb(231,217,185),orange=rgb(214,104,48),
}
local function subtype(model)
 local name=string.lower(model.Name)
 local ty=string.lower(tostring(model:GetAttribute("VehicleType") or ""))
 local function has(word)return string.find(name,word,1,true) or string.find(ty,word,1,true)end
 if has("aircraft") or has("helicopter") or has("plane") then return nil end
 if has("ambulance") then return "Ambulance" end
 if has("civil") or has("fire") or has("rescue") then return "Fire" end
 if has("police") or has("patrol") then return "Police" end
 if has("taxi") then return "Taxi" end
 if has("bus") then return "Bus" end
 if has("family") or has("suv") then return "SUV" end
 if has("sedan") then return "Sedan" end
 if model:GetAttribute("UAEVehicle")==true then return "Sedan" end
 if model:IsDescendantOf(world:FindFirstChild("EmergencyVehicles") or world) then return "Ambulance" end
 return nil
end
local function sizeFor(kind)
 if kind=="Fire" then return 12.8,32,12.0 end
 if kind=="Ambulance" then return 11.7,25,10.6 end
 if kind=="Bus" then return 12.3,34,12 end
 if kind=="SUV" or kind=="Police" then return 10.5,22.5,8.4 end
 return 9.8,20.5,7.9
end
local function part(parent,class,name,sz,cf,col,mat,alpha)
 local o=Instance.new(class or "Part")
 o.Name=name
 o.Size=sz;o.CFrame=cf;o.Anchored=true;o.CanCollide=false
 o.CanTouch=false;o.CanQuery=false
 o.Material=mat or Enum.Material.SmoothPlastic
 o.Color=col or C.white
 o.Transparency=alpha or 0
 o.TopSurface=Enum.SurfaceType.Smooth
 o.BottomSurface=Enum.SurfaceType.Smooth
 o.Parent=parent
 return o
end
local function sign(parent,title,cf,w,h,face,tint)
 local p=part(parent,"Part","Bilingual designation",Vector3.new(w,h,.18),cf,tint or C.blue,Enum.Material.Metal)
 local s=Instance.new("SurfaceGui")
 s.Name="VehicleText";s.Face=face or Enum.NormalId.Front
 s.PixelsPerStud=42;s.Parent=p
 local t=Instance.new("TextLabel")
 t.BackgroundTransparency=1;t.Size=UDim2.fromScale(1,1)
 t.Font=Enum.Font.GothamBold;t.TextScaled=true
 t.TextWrapped=true;t.TextColor3=C.white;t.Text=title;t.Parent=s
 return p
end
local function make(model,kind,allowStatic)
 if active[model] or model:FindFirstChild("UAE60_HighDetailSkin") then return end
 local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
 if not seat and not allowStatic then return end
 -- Some legacy emergency vehicles have no PrimaryPart. Preserve their original pivot.
 if not model.PrimaryPart then
  local originalPivot=model:GetPivot()
  local stub=Instance.new("Part")
  stub.Name="UAE60PreservedVehiclePivot"
  stub.Size=Vector3.new(.2,.2,.2)
  stub.CFrame=originalPivot
  stub.Anchored=true;stub.CanCollide=false
  stub.Transparency=1;stub.Parent=model
  model.PrimaryPart=stub
 end
 local w,len,h=sizeFor(kind)
 local pivot=model:GetPivot()
 local outer=Instance.new("Model");outer.Name="UAE60_HighDetailSkin";outer.Parent=model
 local function place(class,name,sz,x,y,z,col,mat,alpha,rotation)
  return part(outer,class,name,sz,pivot*CFrame.new(x,y,z)*(rotation or CFrame.new()),col,mat,alpha)
 end
 local body=C.white
 local stripe=C.shadow
 if kind=="Police" then body=C.white;stripe=C.green
 elseif kind=="Ambulance" then body=C.white;stripe=C.blue
 elseif kind=="Fire" then body=C.gold;stripe=C.red
 elseif kind=="Taxi" then body=C.cream;stripe=C.orange
 elseif kind=="Bus" then body=C.cream;stripe=C.green
 elseif kind=="Sedan" then body=C.blue;stripe=C.shadow
 elseif kind=="SUV" then body=C.white;stripe=C.shadow end
 local roofY=(kind=="Fire" or kind=="Bus") and 10.9 or (kind=="Ambulance" and 10.25 or 8.15)
 local front=-len/2
 local rear=len/2
 -- sculpted multi-layer vehicle silhouette with bevelled bumpers and recessed windows.
 place("Part","Undertray",Vector3.new(w-.35,1.05,len-.35),0,3.55,0,C.shadow,Enum.Material.Metal)
 place("Part","Finished metallic side panel",Vector3.new(w,3.2,len-.8),0,5,0,body,Enum.Material.Metal)
 place("Part","Side belt stripe",Vector3.new(w+.12,1.0,len-.3),0,5.6,0,stripe,Enum.Material.Metal)
 place("Part","Floor sill",Vector3.new(w+1,.6,len-.8),0,3.15,0,C.shadow,Enum.Material.Metal)
 local tall=(kind=="Fire" or kind=="Ambulance" or kind=="Bus")
 local noseLen=tall and 6.8 or 7
 local cabinZ=tall and (front+noseLen/2+1.5) or 1.0
 if tall then
  place("Part","Raised service compartment",Vector3.new(w-.5,roofY-5.8,len-noseLen-.6),
   0,(roofY+5.65)/2,2.7,body,Enum.Material.Metal)
  place("Part","Front driver cabin",Vector3.new(w-.7,3.4,noseLen),0,7,front+noseLen/2+1,body,Enum.Material.Metal)
 else
  place("Part","Roof contour",Vector3.new(w-1,1,len*.41),0,roofY,1,body,Enum.Material.Metal)
  place("WedgePart","Sloped hood",Vector3.new(w-.45,1.8,5.3),
   0,6.1,front+2.6,body,Enum.Material.Metal)
 end
 for _,side in ipairs({-1,1}) do
  local sx=side*w/2
  local axlefront=front+5.3
  local axlerear=rear-5.1
  for _,z in ipairs({axlefront,axlerear}) do
   -- Cylinder default axis is X, which is horizontal axle orientation.
   local wheel=place("Part","UAE60 Tire",Vector3.new(1.5,4.55,4.55),
    sx+side*.2,2.36,z,C.wheel,Enum.Material.Rubber)
   wheel.Shape=Enum.PartType.Cylinder
   local rim=place("Part","UAE60 Alloy wheel",Vector3.new(.22,2.8,2.8),
    sx+side*1.04,2.36,z,C.steel,Enum.Material.Metal)
   rim.Shape=Enum.PartType.Cylinder
   local hub=place("Part","Centre wheel hub",Vector3.new(.24,.85,.85),
    sx+side*1.19,2.36,z,C.shadow,Enum.Material.Metal)
   hub.Shape=Enum.PartType.Cylinder
  end
  local cabY=tall and 7.9 or 7.25
  local windowLen=tall and 4.7 or 6.8
  local wx=side*(w/2+.075)
  local windowZ=tall and front+3.8 or 1.0
  place("Part","Tinted side window",Vector3.new(.22,2.15,windowLen),
   wx,cabY,windowZ,C.glass,Enum.Material.Glass,.15)
  place("Part","Door separator",Vector3.new(.23,2.2,.22),
   wx+side*.08,cabY,windowZ,C.shadow,Enum.Material.Metal)
  place("Part","Painted mirror",Vector3.new(1.3,1.1,1.8),
   sx+side*.68,6.7,front+5,body,Enum.Material.Metal)
  place("Part","Door pull handle",Vector3.new(.3,.32,1.4),
   sx+side*.1,5.85,windowZ+2.6,C.steel,Enum.Material.Metal)
  place("Part","Side step",Vector3.new(1.0,.35,5),
   sx+side*.55,3.3,windowZ,C.steel,Enum.Material.Metal)
  place("Part","Rear red lamp",Vector3.new(1.75,1,.45),
   side*(w/2-1.3),5.0,rear+.11,C.red,Enum.Material.Neon)
  place("Part","Front LED lamp",Vector3.new(1.9,.75,.45),
   side*(w/2-1.3),5.1,front-.11,C.cream,Enum.Material.Neon)
 end
 place("Part","Front grille",Vector3.new(w*.48,1.1,.25),0,4.6,front-.25,C.shadow,Enum.Material.Metal)
 place("Part","Front bumper",Vector3.new(w+.6,.75,1.1),0,3.9,front-.25,C.steel,Enum.Material.Metal)
 place("Part","Rear bumper",Vector3.new(w+.5,.65,1.05),0,3.9,rear+.2,C.steel,Enum.Material.Metal)
 -- front and back glazing
 local winFront=tall and (front+.7) or (front+6.1)
 place("Part","Front windshield",Vector3.new(w-1.1,2.4,.22),
  0,tall and 7.9 or 7.4,winFront,C.glass,Enum.Material.Glass,.12)
 if tall then
  place("Part","Cargo roof panel",Vector3.new(w+.1,.7,len-noseLen-1),0,roofY,3.1,body,Enum.Material.Metal)
  for _,z in ipairs({1.0,4.1,7.2}) do
   place("Part","Service compartment seam",Vector3.new(w+.15,.14,.2),0,7,z,stripe,Enum.Material.Metal)
  end
 end
 if kind=="Police" then
  sign(outer,"شرطة دبي  |  DUBAI POLICE",pivot*CFrame.new(0,6.05,rear*.12),w*.85,1.0,Enum.NormalId.Front,C.green)
 elseif kind=="Ambulance" then
  sign(outer,"الإسعاف  |  AMBULANCE",pivot*CFrame.new(0,7.1,rear*.27),w*.86,1.25,Enum.NormalId.Front,C.blue)
 elseif kind=="Fire" then
  sign(outer,"الدفاع المدني  |  CIVIL DEFENCE",pivot*CFrame.new(0,7.2,rear*.23),w*.82,1.2,Enum.NormalId.Front,C.red)
 elseif kind=="Taxi" then
  place("Part","Taxi illuminated rooftop",Vector3.new(5.0,1.1,2.5),0,roofY+.9,0,C.cream,Enum.Material.Neon)
 end
 if kind=="Police" or kind=="Fire" or kind=="Ambulance" then
  local left=place("Part","Lightbar blue",Vector3.new(2.6,.9,2.7),
   -2.4,roofY+1.2,front+6,C.blue,Enum.Material.Neon)
  local right=place("Part","Lightbar red",Vector3.new(2.6,.9,2.7),
   2.4,roofY+1.2,front+6,C.red,Enum.Material.Neon)
  for _,p in ipairs({left,right}) do
   local g=Instance.new("PointLight");g.Name="UAE60EmergencyLight"
   g.Brightness=0;g.Range=30;g.Parent=p
  end
 end
 -- Only hide old decorative parts after successfully making the new skin.
 for _,p in ipairs(model:GetDescendants()) do
  if p:IsA("BasePart") and not p:IsDescendantOf(outer) and p~=seat then
   if not originals[p] then originals[p]=p.Transparency end
   p.Transparency=1
  end
 end
 active[model]={skin=outer,kind=kind,last=model:GetPivot().Position,lastTime=os.clock()}
 model:SetAttribute("UAE60Skin",kind)
 model:SetAttribute("UAE60Damage",0)
end
local function tryModel(obj)
 if not obj:IsA("VehicleSeat") then return end
 local model=obj:FindFirstAncestorOfClass("Model")
 if model and not model:GetAttribute("UAE60Aircraft") then
  local kind=subtype(model)
  if kind then
   local ok,err=pcall(make,model,kind)
   if not ok then warn("[UAE60] skin failed:",model.Name,err) end
  end
 end
end
for _,obj in ipairs(world:GetDescendants()) do tryModel(obj) end
-- Several v5.4 police / fire display cars have no seats; repaint them too.
for _,folderName in ipairs({"CommunityServiceFleet"}) do
 local fleet=world:FindFirstChild(folderName,true)
 if fleet then
  for _,model in ipairs(fleet:GetChildren()) do
   if model:IsA("Model") then
    local kind=subtype(model)
    if kind then
     local ok,err=pcall(make,model,kind,true)
     if not ok then warn("[UAE60] display vehicle skin failed:",err) end
    end
   end
  end
 end
end
-- Upgrade the old stationary buses when they are Models and not already styled.
local upgradedBuses=0
for _,model in ipairs(world:GetDescendants()) do
 if model:IsA("Model") and upgradedBuses<8 and
   string.find(string.lower(model.Name),"bus",1,true) and not active[model] then
  local ok=pcall(make,model,"Bus",true)
  if ok then upgradedBuses=upgradedBuses+1 end
 end
end
world.DescendantAdded:Connect(function(obj)
 if obj:IsA("VehicleSeat") then task.delay(.22,tryModel,obj) end
end)
-- Anchored legacy cars use PivotTo, so measure actual displacement instead of physics velocity.
local elapsed=0
RunService.Heartbeat:Connect(function(dt)
 elapsed=elapsed+dt
 if elapsed<.22 then return end
 local now=os.clock()
 local step=elapsed;elapsed=0
 for model,state in pairs(active) do
  if not model.Parent then active[model]=nil
  elseif state.skin.Parent then
   local pos=model:GetPivot().Position
   local speed=(pos-state.last).Magnitude/math.max(step,.07)
   state.last=pos
   local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
   local player=seat and seat.Occupant and Players:GetPlayerFromCharacter(seat.Occupant.Parent)
   if player and speed>22 and (not lastImpact[model] or now-lastImpact[model]>4) then
    local forward=model:GetPivot().LookVector
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={model}
    local hit=workspace:Raycast(pos+forward*4+Vector3.new(0,3,0),forward*12,params)
    if hit and hit.Instance and hit.Instance.CanCollide and math.abs(hit.Normal.Y)<.7 then
     lastImpact[model]=now
     local damage=math.clamp(math.floor(speed*.27),5,24)
     model:SetAttribute("UAE60Damage",math.clamp((model:GetAttribute("UAE60Damage") or 0)+damage,0,100))
     local bumper=state.skin:FindFirstChild("Front bumper")
     if bumper then bumper.Color=C.red:Lerp(C.black,math.min(1,(model:GetAttribute("UAE60Damage") or 0)/100)) end
     notices:FireClient(player,"Vehicle impact detected. Damage +"..damage.." | Visit the repair garage.")
    end
   end
  end
 end
end)
-- Collision damage service garage: the older v5.5 crash script is disabled.
local garage=Instance.new("Folder")
garage.Name="VehicleRepairWorkshop";garage.Parent=root
local pad=part(garage,"Part","Garage repair service bay",Vector3.new(39,1,35),
 CFrame.new(-320,1.6,-1030),C.steel,Enum.Material.Concrete,0)
pad.CanCollide=true
local desk=part(garage,"Part","Workshop service terminal",Vector3.new(5,7,2),
 CFrame.new(-325,5,-1042),C.green,Enum.Material.Metal,0)
desk.CanCollide=true
local prompt=Instance.new("ProximityPrompt")
prompt.ActionText="Repair vehicle"
prompt.ObjectText="UAE City Auto Service"
prompt.HoldDuration=1;prompt.MaxActivationDistance=17
prompt.RequiresLineOfSight=false;prompt.Parent=desk
prompt.Triggered:Connect(function(pl)
 local char=pl.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local rootPart=char and char:FindFirstChild("HumanoidRootPart")
 if not hum or hum.Health<=0 or not rootPart or (rootPart.Position-desk.Position).Magnitude>20 then return end
 local nearest,best=nil,48
 for model,state in pairs(active) do
  if model.Parent and state.skin.Parent then
   local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
   local owner=model:GetAttribute("OwnerUserId")
   local authorized=not owner or owner==pl.UserId
   if seat and authorized then
    local distance=(seat.Position-pad.Position).Magnitude
    if distance<best then nearest=model;best=distance end
   end
  end
 end
 if not nearest then notices:FireClient(pl,"Park your vehicle at the repair workshop.") return end
 nearest:SetAttribute("UAE60Damage",0)
 local skin=active[nearest] and active[nearest].skin
 local bumper=skin and skin:FindFirstChild("Front bumper")
 if bumper then bumper.Color=C.steel end
 notices:FireClient(pl,"Repair completed. Vehicle damage restored to zero.")
end)
print("[UAE60] Vehicle cosmetics, crash sensor and repair workshop installed.")
