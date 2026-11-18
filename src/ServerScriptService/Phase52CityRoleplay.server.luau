-- UAE City Life v5.2 server authority for city travel, interactive shops and personal cars.
-- Uses the original UAE_Driving and UAE_DrivingInput scripts for prototype driving.
-- Dynamic seats get their own server-checked proximity entry binding.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local roleplay=world:WaitForChild("Phase52_RoleplayDistrict")
local cars=world:WaitForChild("EmergencyVehicles")
local action=RS:FindFirstChild("UAE_V52_CityAction") or Instance.new("RemoteEvent")
action.Name="UAE_V52_CityAction"
action.Parent=RS
local feedback=RS:FindFirstChild("UAE_V52_CityFeedback") or Instance.new("RemoteEvent")
feedback.Name="UAE_V52_CityFeedback"
feedback.Parent=RS
local types={
 Taxi={body=Color3.fromRGB(236,224,195),trim=Color3.fromRGB(203,70,59),glass=Color3.fromRGB(49,105,137)},
 Family={body=Color3.fromRGB(219,221,218),trim=Color3.fromRGB(49,78,91),glass=Color3.fromRGB(49,105,137)},
 Sedan={body=Color3.fromRGB(37,105,131),trim=Color3.fromRGB(26,43,55),glass=Color3.fromRGB(49,105,137)},
}
local travel={
 Homes=Vector3.new(0,5,-747),
 E11=Vector3.new(107,5,-1200),
 Downtown=Vector3.new(115,6,-392),
 Marina=Vector3.new(1085,6,-1250),
 Airport=Vector3.new(-1055,6,-1330),
}
local carSlots={
 Vector3.new(-130,1,-689),Vector3.new(-78,1,-689),Vector3.new(-26,1,-689),
 Vector3.new(26,1,-689),Vector3.new(78,1,-689),Vector3.new(130,1,-689),
}
local owned={}
local lastAction={}
local function tell(player,msg)
 if player.Parent==Players then feedback:FireClient(player,msg) end
end
local function characterRoot(player)
 local ch=player.Character
 local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 if hum and root and hum.Health>0 then return root,hum end
 return nil,nil
end
local function allowed(player)
 if lastAction[player] and os.clock()-lastAction[player]<1.3 then return false end
 lastAction[player]=os.clock()
 return true
end
local function safeRemove(player)
 local prior=owned[player]
 if prior then
  if prior.Parent then prior:Destroy() end
  owned[player]=nil
 end
end
local function part(parent,name,size,cf,color,material)
 local p=Instance.new("Part")
 p.Name=name
 p.Anchored=true
 p.CanCollide=false
 p.CastShadow=true
 p.Size=size
 p.CFrame=cf
 p.Color=color
 p.Material=material or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function makeCar(player,typ,pos)
 local colors=types[typ]
 local model=Instance.new("Model")
 model.Name="Personal "..typ.." • "..player.UserId
 model:SetAttribute("UAEVehicle",true)
 model:SetAttribute("VehicleType",typ)
 model:SetAttribute("OwnerUserId",player.UserId)
 model.Parent=cars
 local root=part(model,"VehiclePivot",Vector3.new(.2,.2,.2),CFrame.new(),
  Color3.fromRGB(241,241,241))
 root.Transparency=1
 model.PrimaryPart=root
 local function add(name,size,x,y,z,color,mat)
  return part(model,name,size,CFrame.new(x,y,z),color,mat)
 end
 local length=(typ=="Family") and 22 or 19
 local side=(typ=="Family") and 5.2 or 4.8
 add("Dark underbody",Vector3.new(side*2,1.3,length),0,3.3,0,colors.trim,Enum.Material.Metal)
 add("Modern car side body",Vector3.new(side*2,2.7,length-2),0,4.4,0,colors.body,Enum.Material.Metal)
 add("Rounded front bonnet",Vector3.new(side*2-.25,1.2,6),0,5,-length/2+3,colors.body,Enum.Material.Metal)
 add("Cabin lower shape",Vector3.new(side*2-.9,2,10),0,6.5,1.1,colors.body,Enum.Material.Metal)
 add("Car roof",Vector3.new(side*2-1.6,.8,8),0,8,1.25,colors.body,Enum.Material.Metal)
 for _,dir in ipairs({-1,1}) do
  local x=dir*side
  for _,z in ipairs({-length*.32,length*.32}) do
   local tyre=add("Vertical rubber tyre",Vector3.new(1.8,5.1,5.1),x,2.6,z,
    Color3.fromRGB(26,29,33),Enum.Material.Rubber)
   tyre.Shape=Enum.PartType.Cylinder
   local rim=add("Alloy rim",Vector3.new(.25,2.8,2.8),x+dir*.98,2.6,z,
    Color3.fromRGB(192,197,197),Enum.Material.Metal)
   rim.Shape=Enum.PartType.Cylinder
  end
  add("Side door glazing",Vector3.new(.3,2.1,8.7),dir*(side-.27),7.3,1.4,
   colors.glass,Enum.Material.Glass)
  add("Door handle",Vector3.new(.35,.22,1.6),dir*(side+.1),5.55,1.3,
   Color3.fromRGB(222,229,223),Enum.Material.Metal)
  add("LED front light",Vector3.new(2.6,.65,.35),dir*(side-1.7),5,
   -length/2-.05,Color3.fromRGB(255,245,196),Enum.Material.Neon)
  add("Rear red light",Vector3.new(2.6,.65,.35),dir*(side-1.7),5,
   length/2+.05,Color3.fromRGB(201,45,52),Enum.Material.Neon)
 end
 add("Front windshield",Vector3.new(side*2-1.5,2.7,.4),0,6.7,-4,
  colors.glass,Enum.Material.Glass)
 add("Rear windshield",Vector3.new(side*2-1.5,2.5,.4),0,6.8,5.8,
  colors.glass,Enum.Material.Glass)
 add("Front silver grille",Vector3.new(side*1.3,1,.35),0,3.9,-length/2-.15,
  Color3.fromRGB(57,67,73),Enum.Material.Metal)
 local seat=Instance.new("VehicleSeat")
 seat.Name="DriverSeat"
 seat.Anchored=true
 seat.CanCollide=false
 seat.Transparency=1
 seat.Size=Vector3.new(3,.8,3)
 seat.CFrame=CFrame.new(0,7,-1)
 seat.MaxSpeed=0
 seat.Parent=model
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="EntryPrompt"
 prompt.ActionText="Drive"
 prompt.ObjectText="Your "..typ
 prompt.MaxActivationDistance=16
 prompt.RequiresLineOfSight=false
 prompt.Parent=seat
 if typ=="Taxi" then
  local roof=add("Dubai taxi roof sign",Vector3.new(5,1.1,2.3),
   0,8.95,1,Color3.fromRGB(236,228,199),Enum.Material.SmoothPlastic)
  local g=Instance.new("SurfaceGui")
  g.Face=Enum.NormalId.Front
  g.PixelsPerStud=40
  g.Parent=roof
  local t=Instance.new("TextLabel")
  t.BackgroundTransparency=1
  t.Size=UDim2.fromScale(1,1)
  t.Text="DUBAI TAXI"
  t.Font=Enum.Font.GothamBold
  t.TextScaled=true
  t.TextColor3=Color3.fromRGB(19,59,91)
  t.Parent=g
 end
 model:PivotTo(CFrame.new(pos))
 prompt.Triggered:Connect(function(p)
  local rootPart,hum=characterRoot(p)
  if p~=player or not rootPart or not hum then return end
  if (rootPart.Position-seat.Position).Magnitude>19 then return end
  if seat.Occupant==nil then
   seat:Sit(hum)
  end
 end)
 return model
end
local function nearestFreeSlot()
 for _,slot in ipairs(carSlots) do
  local free=true
  for _,model in pairs(owned) do
   if model and model.Parent and (model:GetPivot().Position-slot).Magnitude<23 then
    free=false
    break
   end
  end
  if free then return slot end
 end
 return nil
end
action.OnServerEvent:Connect(function(player,kind,choice)
 if typeof(kind)~="string" or typeof(choice)~="string" then return end
 if #kind>20 or #choice>24 then return end
 if not allowed(player) then return end
 local rootPart,hum=characterRoot(player)
 if not rootPart then return end
 if kind=="Travel" then
  local position=travel[choice]
  if not position then return end
  local character=player.Character
  if hum.Sit then
   hum.Sit=false
   task.wait(.15)
  end
  if character and character.Parent then
   character:PivotTo(CFrame.new(position))
   tell(player,"Welcome to "..(choice=="Homes" and "UAE Villas" or choice).."!")
  end
 elseif kind=="SpawnCar" then
  if not types[choice] then return end
  local pos=rootPart.Position
  if math.abs(pos.X)>590 or pos.Z < -920 or pos.Z > -550 then
   tell(player,"Open CITY → Homes first to visit the garage area.")
   return
  end
  local spot=nearestFreeSlot()
  if not spot then
   tell(player,"Garage spaces are occupied. Try again soon.")
   return
  end
  safeRemove(player)
  owned[player]=makeCar(player,choice,spot)
  tell(player,choice.." ready near the residential garages. Press E to drive.")
 elseif kind=="RemoveCar" then
  safeRemove(player)
  tell(player,"Your personal vehicle has been removed.")
 end
end)
-- Trim the enormous old GAME OWNER billboard without removing owner recognition.
local function tidyOwnerTag(character)
 task.delay(2,function()
  if not character.Parent then return end
  local head=character:FindFirstChild("Head")
  local label=head and head:FindFirstChild("UAEGameOwnerTag")
  if label and label:IsA("BillboardGui") then
   label.Size=UDim2.fromOffset(120,29)
   label.StudsOffset=Vector3.new(0,2.9,0)
   label.MaxDistance=75
  end
 end)
end
Players.PlayerAdded:Connect(function(player)
 player.CharacterAdded:Connect(tidyOwnerTag)
end)
for _,player in ipairs(Players:GetPlayers()) do
 player.CharacterAdded:Connect(tidyOwnerTag)
 if player.Character then tidyOwnerTag(player.Character) end
end
Players.PlayerRemoving:Connect(function(player)
 safeRemove(player)
 lastAction[player]=nil
end)
-- The retail interactions are individual roleplay activities, never an economy exploit.
local business=roleplay:WaitForChild("CityBusinesses")
local lastShopUse={}
for _,shop in ipairs(business:GetChildren()) do
 local counter=shop:FindFirstChild("ServiceCounter")
 local prompt=counter and counter:FindFirstChildOfClass("ProximityPrompt")
 local activity=shop:GetAttribute("Service")
 if prompt and activity then
  prompt.Triggered:Connect(function(player)
   local rootPart,hum=characterRoot(player)
   if not rootPart or (rootPart.Position-counter.Position).Magnitude>15 then return end
   local key=tostring(player.UserId)..":"..tostring(activity)
   if lastShopUse[key] and os.clock()-lastShopUse[key]<25 then
    tell(player,"This service is ready again shortly.")
    return
   end
   lastShopUse[key]=os.clock()
   if activity=="Hospital" then
    hum.Health=hum.MaxHealth
    tell(player,"Hospital: you've been treated. Welcome back!")
   elseif activity=="Cafe" then
    hum.Health=math.min(hum.MaxHealth,hum.Health+12)
    tell(player,"Cafe: enjoy your karak tea!")
   else
    tell(player,shop.Name.." • roleplay service completed.")
    local leader=player:FindFirstChild("leaderstats")
    local points=leader and leader:FindFirstChild("CityPoints")
    if points then points.Value=points.Value+5 end
   end
  end)
 end
end
