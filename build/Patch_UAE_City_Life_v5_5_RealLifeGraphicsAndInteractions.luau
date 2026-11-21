-- UAE CITY LIFE VERSION 5.5: VISUALS + REAL-LIFE ACTIVITIES + COLLISIONS
-- Install on saved v5.4 in Roblox Studio EDIT MODE, not Play mode.
-- Save a new v5.5 .rbxl backup. This preserves your v4-v5.4 city.
local world=workspace:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase54_CityExpansion"),
 "Open your working v5.4 city in Studio EDIT mode before installing v5.5.")
local root=world:FindFirstChild("Phase55_RealLife")
if root then root:Destroy() end
root=Instance.new("Folder")
root.Name="Phase55_RealLife"
root.Parent=world
local function replace(class,parent,name,source)
 local old=parent:FindFirstChild(name)
 if old then old:Destroy() end
 local new=Instance.new(class)
 new.Name=name;new.Source=source;new.Parent=parent
end
replace("Script",game:GetService("ServerScriptService"),"UAE55_Graphics",[========[
-- v5.5 visual pass: tuned PBR-like Roblox materials, atmosphere and detail.
-- No external meshes or copyrighted assets. Keep geometry budget bounded.
local Lighting=game:GetService("Lighting")
local W=game:GetService("Workspace")
local world=W:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local visuals=Instance.new("Folder")
visuals.Name="GraphicsAndStreets"
visuals.Parent=root
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
-- Lighting.Technology may be protected in some Roblox runtimes.
pcall(function() Lighting.Technology=Enum.Technology.Future end)
Lighting.GlobalShadows=true
Lighting.ShadowSoftness=.42
Lighting.EnvironmentDiffuseScale=.65
Lighting.EnvironmentSpecularScale=.75
Lighting.ExposureCompensation=-.08
Lighting.Brightness=2.3
local function effect(class,name)
 local e=Lighting:FindFirstChild(name)
 if not e then e=Instance.new(class);e.Name=name;e.Parent=Lighting end
 return e
end
local atmosphere=effect("Atmosphere","UAE55_DesertAir")
atmosphere.Density=.22
atmosphere.Offset=.14
atmosphere.Color=rgb(220,218,207)
atmosphere.Decay=rgb(164,180,194)
atmosphere.Glare=.19
atmosphere.Haze=1.1
local color=effect("ColorCorrectionEffect","UAE55_CinemaGrade")
color.Brightness=.012
color.Contrast=.10
color.Saturation=.08
color.TintColor=rgb(255,245,231)
local bloom=effect("BloomEffect","UAE55_NightBloom")
bloom.Intensity=.16
bloom.Size=18
bloom.Threshold=1.8
local rays=effect("SunRaysEffect","UAE55_SunRays")
rays.Intensity=.035
rays.Spread=.65
local function part(parent,name,size,cf,color,material,solid)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true
 p.Color=color;p.Material=material;p.CanCollide=solid==true
 p.CastShadow=solid==true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function light(x,z)
 local pole=part(visuals,"Realistic boulevard lamp",Vector3.new(.65,17,.65),
  CFrame.new(x,9,z),rgb(116,123,128),Enum.Material.Metal,false)
 local arm=part(visuals,"LED streetlight arm",Vector3.new(7,.55,.8),
  CFrame.new(x+3,17.5,z),rgb(120,130,138),Enum.Material.Metal,false)
 local led=part(visuals,"Warm LED lamp",Vector3.new(3,.22,1.2),
  CFrame.new(x+5,17.15,z),rgb(255,224,163),Enum.Material.Neon,false)
 local point=Instance.new("PointLight")
 point.Name="UAE55NightLamp";point.Brightness=1.3;point.Range=36
 point.Color=rgb(255,229,181);point.Enabled=false;point.Parent=led
end
-- Build a handful of recognizable urban details rather than a heavy city-wide clone.
for _,z in ipairs({-1450,-1370,-1290,-1210,-1130,-1050,-970}) do
 for _,x in ipairs({-100,100}) do light(x,z) end
end
for _,z in ipairs({-1420,-1280,-1140,-1000}) do
 for _,x in ipairs({-120,120}) do
  part(visuals,"Roadside concrete planter",Vector3.new(15,2.1,7),
   CFrame.new(x,1.5,z),rgb(190,184,170),Enum.Material.Concrete,true)
  part(visuals,"Planter greenery",Vector3.new(13,1.2,5),
   CFrame.new(x,3.1,z),rgb(48,112,72),Enum.Material.Grass,false)
 end
end
-- Existing towers: subtle material improvement, without overwriting all building colors.
local count=0
for _,item in ipairs(world:GetDescendants()) do
 if item:IsA("BasePart") and item.Parent~=visuals then
  if item.Material==Enum.Material.Glass then
   item.Reflectance=math.min(item.Reflectance,.12)
   if item.Transparency<.1 then item.Transparency=.08 end
   count=count+1
  elseif item.Material==Enum.Material.Asphalt then
   item.Reflectance=0
  end
 end
end
local RS=game:GetService("ReplicatedStorage")
task.spawn(function()
 while root.Parent do
  local hour=RS:GetAttribute("UAECycleHour")
  local night=typeof(hour)=="number" and (hour>=18 or hour<6)
  for _,obj in ipairs(visuals:GetDescendants()) do
   if obj:IsA("PointLight") and obj.Name=="UAE55NightLamp" then
    obj.Enabled=night
   end
  end
  task.wait(8)
 end
end)
print("[v5.5] Visual pass: Future lighting, atmospheric grade, street detail; glass panels updated:",count)

]========])
replace("Script",game:GetService("ServerScriptService"),"UAE55_Activities",[========[
-- v5.5 playable interiors and activities. Original schematic Dubai layout.
-- Lobby, hospital and airport activities are functional server-side roleplay loops.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local spaces=Instance.new("Folder")
spaces.Name="PlayableInteriors"
spaces.Parent=root
local function rgb(r,g,b)return Color3.fromRGB(r,g,b)end
local white=rgb(237,235,225)
local stone=rgb(194,189,177)
local navy=rgb(33,66,82)
local teal=rgb(43,128,144)
local gold=rgb(221,174,85)
local function part(parent,name,size,x,y,z,color,mat,solid)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.Position=Vector3.new(x,y,z)
 p.Color=color or white;p.Material=mat or Enum.Material.SmoothPlastic
 p.Anchored=true;p.CanCollide=solid==true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent;return p
end
local function sign(parent,name,words,x,y,z,w,h)
 local p=part(parent,name,Vector3.new(w,h,.4),x,y,z,navy,Enum.Material.Metal,false)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=30;gui.Parent=p
 local label=Instance.new("TextLabel")
 label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
 label.Font=Enum.Font.GothamBold;label.TextScaled=true;label.TextWrapped=true
 label.TextColor3=white;label.Text=words;label.Parent=gui
 return p
end
local cooldown={}
local notify=RS:FindFirstChild("UAE55_Notice") or Instance.new("RemoteEvent")
notify.Name="UAE55_Notice";notify.Parent=RS
local function tell(player,msg)
 if player.Parent==Players then notify:FireClient(player,msg) end
end
local function reward(player,points)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player end
 local v=stats:FindFirstChild("CityPoints")
 if not v then v=Instance.new("IntValue");v.Name="CityPoints";v.Parent=stats end
 v.Value=v.Value+points
end
local function action(parent,base,actionText,x,y,z,callback)
 local terminal=part(parent,base,Vector3.new(5,5,2),x,y,z,teal,Enum.Material.Metal,true)
 local prompt=Instance.new("ProximityPrompt")
 prompt.ActionText=actionText;prompt.ObjectText=base
 prompt.HoldDuration=.6;prompt.MaxActivationDistance=13
 prompt.RequiresLineOfSight=false;prompt.Parent=terminal
 prompt.Triggered:Connect(function(player)
  local char=player.Character
  local rootPart=char and char:FindFirstChild("HumanoidRootPart")
  if not rootPart or (rootPart.Position-terminal.Position).Magnitude>17 then return end
  local key=tostring(player.UserId)..":"..base
  if cooldown[key] and os.clock()-cooldown[key]<2 then return end
  cooldown[key]=os.clock()
  callback(player)
 end)
 return terminal
end
local function room(name,x,z,w,d,theme,title)
 local m=Instance.new("Model");m.Name=name;m.Parent=spaces
 part(m,"Polished lobby floor",Vector3.new(w,1,d),x,1,z,stone,Enum.Material.Marble,true)
 part(m,"Back wall",Vector3.new(w,19,1),x,10,z+d/2,white,Enum.Material.Concrete,true)
 part(m,"Left wall",Vector3.new(1,19,d),x-w/2,10,z,white,Enum.Material.Concrete,true)
 part(m,"Right wall",Vector3.new(1,19,d),x+w/2,10,z,white,Enum.Material.Concrete,true)
 part(m,"Roof with lighting",Vector3.new(w,1,d),x,20,z,white,Enum.Material.Concrete,true)
 part(m,"Reception desk",Vector3.new(22,4,5),x,3.5,z+10,theme,Enum.Material.Marble,true)
 part(m,"Reception glass panel",Vector3.new(21,3,.5),x,7,z+12,teal,Enum.Material.Glass,false)
 for _,dx in ipairs({-w*.35,w*.35}) do
  part(m,"Sofa seating",Vector3.new(13,2.5,7),x+dx,2.8,z-6,navy,Enum.Material.Fabric,true)
 end
 sign(m,"Entrance signage",title,x,13,z+d/2-.8,w*.7,5)
 -- open front is deliberate, so players can walk inside
 return m
end
local hotel=room("Dubai Hotel Playable Lobby",-550,-920,80,65,gold,
 "DUBAI HOTEL  |  HOTEL RECEPTION")
local hotelStatus={}
action(hotel,"Hotel Check-in","Check in",-550,4,-915,function(player)
 hotelStatus[player.UserId]=true
 tell(player,"Hotel check-in complete. Your guest room is ready.")
 reward(player,20)
end)
action(hotel,"Hotel Room Access","Enter guest room",-575,4,-920,function(player)
 if not hotelStatus[player.UserId] then tell(player,"Check in at reception first.") return end
 local char=player.Character
 if char then char:PivotTo(CFrame.new(-550,5,-878)) end
 tell(player,"Welcome to your guest room.")
end)
local guest=Instance.new("Model");guest.Name="Hotel Guest Room";guest.Parent=spaces
part(guest,"Guest suite floor",Vector3.new(43,1,39),-550,1,-868,stone,Enum.Material.Marble,true)
part(guest,"Guest room bed frame",Vector3.new(18,2,12),-550,2.5,-856,navy,Enum.Material.Wood,true)
part(guest,"White duvet",Vector3.new(17,1,11),-550,4,-856,white,Enum.Material.Fabric,true)
action(guest,"Guest Check-out","Check out",-534,4,-878,function(player)
 hotelStatus[player.UserId]=nil
 tell(player,"Checked out. Thank you for visiting!")
end)
local hospital=room("Dubai Medical Centre Playable Reception",-235,-1095,86,68,teal,
 "HOSPITAL  |  MEDICAL RECEPTION")
local patientState={}
action(hospital,"Patient Registration","Register as patient",-235,4,-1095,function(player)
 patientState[player.UserId]="waiting"
 tell(player,"Patient registered. Proceed to the examination desk.")
end)
action(hospital,"Medical Examination","Complete checkup",-265,4,-1100,function(player)
 if patientState[player.UserId]~="waiting" then
  tell(player,"Please register at reception first.") return end
 patientState[player.UserId]="checked"
 tell(player,"Examination complete. Proceed to pharmacy.")
end)
action(hospital,"Hospital Pharmacy","Collect prescription",-205,4,-1100,function(player)
 if patientState[player.UserId]~="checked" then
  tell(player,"Complete registration and examination first.") return end
 patientState[player.UserId]=nil
 reward(player,30)
 tell(player,"Hospital visit completed. +30 CityPoints.")
end)
local airport=room("DXB Playable Airport Terminal",-1020,-980,110,75,navy,
 "DXB  |  INTERNATIONAL TERMINAL")
local flightState={}
action(airport,"Airport Check-in Desk","Check in for flight",-1050,4,-980,function(player)
 flightState[player.UserId]="checkin"
 tell(player,"Flight check-in complete. Proceed to security.")
end)
action(airport,"Airport Security","Clear security",-1020,4,-980,function(player)
 if flightState[player.UserId]~="checkin" then
  tell(player,"Please check in first.") return end
 flightState[player.UserId]="security"
 tell(player,"Security cleared. Proceed to boarding gate.")
end)
action(airport,"Airport Boarding Gate","Board flight",-990,4,-980,function(player)
 if flightState[player.UserId]~="security" then
  tell(player,"Complete check-in and security first.") return end
 flightState[player.UserId]=nil
 reward(player,40)
 tell(player,"Boarding complete! +40 CityPoints. Flight simulation ends here.")
end)
-- Functional cafe transaction, for a small everyday activity.
local cafe=room("Karak Cafe Interactive Counter",-225,-595,54,48,gold,
 "KARAK CAFE  |  ORDER COUNTER")
action(cafe,"Karak Order Counter","Order karak tea",-225,4,-595,function(player)
 tell(player,"Fresh karak tea served! Enjoy your visit.")
end)
Players.PlayerRemoving:Connect(function(p)
 hotelStatus[p.UserId]=nil;patientState[p.UserId]=nil;flightState[p.UserId]=nil
end)
print("[v5.5] Interactive hotel, guest room, hospital, airport and cafe ready")

]========])
replace("Script",game:GetService("ServerScriptService"),"UAE55_VehicleIncidents",[========[
-- v5.5 vehicle crash feedback: server-side cosmetic damage, repair stations.
-- Does not destroy vehicles or injure avatars; safe first iteration.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local notify=RS:WaitForChild("UAE55_Notice")
local registered={}
local crashTimes={}
local original={}
local function findCar(part)
 local node=part
 for _=1,7 do
  if not node or node==workspace then break end
  if node:IsA("Model") and node:FindFirstChildWhichIsA("VehicleSeat",true) then
   return node
  end
  node=node.Parent
 end
 return nil
end
local function seatedDriver(car)
 local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
 if not seat or not seat.Occupant then return nil end
 return Players:GetPlayerFromCharacter(seat.Occupant.Parent)
end
local function setDamage(car,amount)
 local current=car:GetAttribute("UAE55Damage") or 0
 local nextValue=math.clamp(current+amount,0,100)
 car:SetAttribute("UAE55Damage",nextValue)
 if nextValue>=70 then car:SetAttribute("UAE55NeedsRepair",true) end
 local body=car:FindFirstChildWhichIsA("BasePart",true)
 if body and body:IsA("BasePart") then
  if not original[body] then original[body]=body.Color end
  body.Color=original[body]:Lerp(Color3.fromRGB(88,82,78),nextValue/170)
 end
end
local function onImpact(car,part,other)
 if not other or not other:IsA("BasePart") then return end
 if other:IsDescendantOf(car) then return end
 local driver=seatedDriver(car)
 if not driver then return end
 local now=os.clock()
 if crashTimes[car] and now-crashTimes[car]<3 then return end
 local speed=part.AssemblyLinearVelocity.Magnitude
 local otherVelocity=other.Anchored and Vector3.zero or other.AssemblyLinearVelocity
 local relative=(part.AssemblyLinearVelocity-otherVelocity).Magnitude
 if speed<32 or relative<35 then return end
 crashTimes[car]=now
 local impact=math.clamp(math.floor((relative-30)*.7),5,35)
 setDamage(car,impact)
 notify:FireClient(driver,string.format("Vehicle collision! +%d damage. Repair at the garage.",impact))
end
local function attachCar(car)
 if registered[car] then return end
 registered[car]=true
 car:SetAttribute("UAE55Damage",0)
 car:SetAttribute("UAE55NeedsRepair",false)
 -- Touched on a few substantial parts, avoiding every wheel and cosmetic piece.
 local connected=0
 for _,p in ipairs(car:GetDescendants()) do
  if p:IsA("BasePart") and p.CanCollide and p.Size.Magnitude>=5 then
   p.Touched:Connect(function(other)onImpact(car,p,other)end)
   connected=connected+1
   if connected>=8 then break end
  end
 end
end
local function check(desc)
 if desc:IsA("VehicleSeat") then
  local car=findCar(desc)
  if car then attachCar(car) end
 end
end
for _,desc in ipairs(world:GetDescendants()) do check(desc) end
world.DescendantAdded:Connect(check)
local garage=Instance.new("Folder")
garage.Name="RepairGarage"
garage.Parent=root
local pad=Instance.new("Part")
pad.Name="Vehicle Repair Pad"
pad.Size=Vector3.new(42,1,35)
pad.Position=Vector3.new(-320,1,-1030)
pad.Anchored=true;pad.CanCollide=true
pad.Material=Enum.Material.Concrete
pad.Color=Color3.fromRGB(110,134,144)
pad.Parent=garage
local sign=Instance.new("Part")
sign.Name="REPAIR GARAGE"
sign.Size=Vector3.new(35,7,1)
sign.Position=Vector3.new(-320,12,-1049)
sign.Anchored=true;sign.CanCollide=false
sign.Color=Color3.fromRGB(35,81,96);sign.Parent=garage
local gui=Instance.new("SurfaceGui")
gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=35;gui.Parent=sign
local label=Instance.new("TextLabel")
label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
label.Font=Enum.Font.GothamBold;label.TextScaled=true
label.Text="VEHICLE REPAIR  |  إصلاح السيارات"
label.TextColor3=Color3.new(1,1,1);label.Parent=gui
local prompt=Instance.new("ProximityPrompt")
prompt.ActionText="Repair vehicle";prompt.ObjectText="City Garage"
prompt.MaxActivationDistance=22;prompt.HoldDuration=1
prompt.RequiresLineOfSight=false;prompt.Parent=pad
prompt.Triggered:Connect(function(player)
 local char=player.Character
 local rootPart=char and char:FindFirstChild("HumanoidRootPart")
 if not rootPart or (rootPart.Position-pad.Position).Magnitude>28 then return end
 local best,bestDist=nil,65
 for car in pairs(registered) do
  if car.Parent then
   local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
   if seat then
    local dist=(seat.Position-pad.Position).Magnitude
    if dist<bestDist then best=car;bestDist=dist end
   end
  end
 end
 if not best then notify:FireClient(player,"Park a vehicle near the garage to repair it.") return end
 best:SetAttribute("UAE55Damage",0)
 best:SetAttribute("UAE55NeedsRepair",false)
 for part,color in pairs(original) do
  if part:IsDescendantOf(best) then part.Color=color end
 end
 notify:FireClient(player,"Vehicle repaired. Damage reset to 0.")
end)
print("[v5.5] Collision damage and repair garage active for vehicles with VehicleSeat")

]========])
replace("Script",game:GetService("ServerScriptService"),"UAE55_Citizens",[========[
-- v5.5 R15 human NPC pedestrians: recognizable humanoids, no block statues.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local folder=Instance.new("Folder")
folder.Name="R15Citizens"
folder.Parent=root
local places={
 {name="Hotel Receptionist",x=-550,z=-911,shirt=Color3.fromRGB(47,79,109)},
 {name="Hospital Receptionist",x=-235,z=-1091,shirt=Color3.fromRGB(229,236,231)},
 {name="Airport Ground Staff",x=-1020,z=-975,shirt=Color3.fromRGB(59,93,143)},
 {name="Cafe Worker",x=-225,z=-590,shirt=Color3.fromRGB(154,110,69)},
 {name="Tourist Downtown",x=24,z=-340,shirt=Color3.fromRGB(216,199,173)},
 {name="Marina Visitor",x=1040,z=-1300,shirt=Color3.fromRGB(210,215,230)},
}
for i,loc in ipairs(places) do
 local success,model=pcall(function()
  local desc=Instance.new("HumanoidDescription")
  desc.HeightScale=1
  desc.WidthScale=.94
  desc.DepthScale=.94
  desc.HeadScale=1
  desc.BodyTypeScale=.35
  desc.ProportionScale=.5
  local m=Players:CreateHumanoidModelFromDescription(desc,Enum.HumanoidRigType.R15)
  desc:Destroy()
  return m
 end)
 if success and model then
  model.Name=loc.name
  model.Parent=folder
  model:PivotTo(CFrame.new(loc.x,4,loc.z))
  local hum=model:FindFirstChildOfClass("Humanoid")
  if hum then
   hum.DisplayName=loc.name
   hum.WalkSpeed=0
   hum.AutoRotate=false
  end
  local rootPart=model:FindFirstChild("HumanoidRootPart")
  if rootPart then rootPart.Anchored=true end
  for _,part in ipairs(model:GetDescendants()) do
   if part:IsA("BasePart") and part.Name=="UpperTorso" then
    part.Color=loc.shirt
   end
  end
 else
  warn("[v5.5] R15 NPC could not spawn:",loc.name)
 end
end
print("[v5.5] R15 human NPCs attempted:",#places)

]========])
replace("LocalScript",game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts"),"UAE55_Notifications",[========[
-- v5.5 compact notifications for activities, collisions and repair.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("UAE55_Notice",30)
if not remote then return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE55_Notifications"
gui.ResetOnSpawn=false
gui.DisplayOrder=85
gui.Parent=player:WaitForChild("PlayerGui")
local box=Instance.new("TextLabel")
box.Name="ActivityNotice"
box.AnchorPoint=Vector2.new(.5,0)
box.Position=UDim2.new(.5,0,0,55)
box.Size=UDim2.new(.68,0,0,53)
box.BackgroundColor3=Color3.fromRGB(22,50,64)
box.BackgroundTransparency=.07
box.TextColor3=Color3.fromRGB(247,229,188)
box.Font=Enum.Font.GothamBold
box.TextSize=15
box.TextWrapped=true
box.Visible=false
box.Parent=gui
local constraint=Instance.new("UISizeConstraint")
constraint.MaxSize=Vector2.new(520,53)
constraint.Parent=box
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,9)
corner.Parent=box
local counter=0
remote.OnClientEvent:Connect(function(msg)
 if typeof(msg)~="string" or #msg>240 then return end
 counter=counter+1
 local n=counter
 box.Text=msg
 box.Visible=true
 task.delay(4,function()
  if counter==n and gui.Parent then box.Visible=false end
 end)
end)

]========])
world:SetAttribute("InstalledVersion","5.5")
print("UAE CITY LIFE v5.5 INSTALLED: enhanced graphics, interactive hotel/hospital/airport, car crash feedback, R15 citizens.")
print("Save as a NEW .rbxl and press Play. Activities and city visuals generate on the server during Play.")
