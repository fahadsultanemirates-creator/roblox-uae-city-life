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
