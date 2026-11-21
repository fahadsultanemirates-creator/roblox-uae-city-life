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
