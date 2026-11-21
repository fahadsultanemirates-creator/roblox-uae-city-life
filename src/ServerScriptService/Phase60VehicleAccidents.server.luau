-- UAE CITY LIFE 6.0: visual crash incidents + repair for legacy moving anchored cars.
-- IMPORTANT: v4/v5 cars are manually CFrame moved, so Roblox Touched/velocity
-- cannot reliably detect collisions. Detect ray obstruction along the traveled path.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local phase=world:WaitForChild("Phase60_ProductionPass")
local cars=world:WaitForChild("EmergencyVehicles")
local notice=RS:WaitForChild("UAE60_Notification",30)
local known=setmetatable({},{__mode="k"})
local lastHit=setmetatable({},{__mode="k"})
local originalColors=setmetatable({},{__mode="k"})
local function pilot(car)
 local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
 if seat and seat.Occupant then
  return Players:GetPlayerFromCharacter(seat.Occupant.Parent)
 end
 return nil
end
local function register(car)
 if not car:IsA("Model") or known[car] then return end
 local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
 if not seat then return end
 known[car]={last=car:GetPivot().Position}
 car:SetAttribute("UAE60Damage",0)
 car:SetAttribute("UAE60NeedsRepair",false)
end
for _,car in ipairs(cars:GetChildren()) do register(car) end
cars.ChildAdded:Connect(function(car)
 task.delay(.2,function() if car.Parent then register(car) end end)
end)
local function cosmeticDamage(car,damage)
 local score=math.clamp((car:GetAttribute("UAE60Damage") or 0)+damage,0,100)
 car:SetAttribute("UAE60Damage",score)
 car:SetAttribute("UAE60NeedsRepair",score>=50)
 local body=car:FindFirstChild("UAE60_RefinedBody")
 local primary=body and body:FindFirstChild("Refined painted flank",true)
 if primary and primary:IsA("BasePart") then
  if not originalColors[primary] then originalColors[primary]=primary.Color end
  primary.Color=originalColors[primary]:Lerp(Color3.fromRGB(90,86,80),score/130)
 end
end
local runTime=0
RunService.Heartbeat:Connect(function(dt)
 runTime=runTime+math.min(dt,.2)
 if runTime<.12 then return end
 local interval=math.min(runTime,.25)
 runTime=0
 for car,data in pairs(known) do
  if car.Parent then
   local now=car:GetPivot().Position
   local travel=now-data.last
   data.last=now
   local driver=pilot(car)
   local speed=travel.Magnitude/math.max(interval,.05)
   if driver and speed>28 and travel.Magnitude>1 and travel.Magnitude<22 then
    local key=lastHit[car] or 0
    if os.clock()-key>3.5 then
     local params=RaycastParams.new()
     params.FilterType=Enum.RaycastFilterType.Exclude
     local excludes={car}
     if driver.Character then table.insert(excludes,driver.Character) end
     params.FilterDescendantsInstances=excludes
     params.IgnoreWater=true
     local cast=workspace:Raycast(data.last-travel+Vector3.new(0,4,0),
      travel+travel.Unit*5,params)
     if cast and cast.Instance and cast.Instance.CanCollide and
      cast.Instance.Size.Y>2 then
      lastHit[car]=os.clock()
      local impact=math.clamp(math.floor(speed*.18),6,24)
      cosmeticDamage(car,impact)
      if notice then
       notice:FireClient(driver,string.format(
        "COLLISION WARNING • +%d vehicle damage • garage repairs available",impact))
      end
     end
    end
   end
  else
   known[car]=nil
  end
 end
end)
local garage=Instance.new("Model")
garage.Name="Vehicle Repair and Inspection Centre"
garage.Parent=phase
local foundation=Instance.new("Part")
foundation.Name="Accessible repair ramp"
foundation.Size=Vector3.new(48,1.2,44)
foundation.CFrame=CFrame.new(-340,.6,-1010)
foundation.Anchored=true
foundation.Material=Enum.Material.Concrete
foundation.Color=Color3.fromRGB(170,177,175)
foundation.Parent=garage
local kiosk=Instance.new("Part")
kiosk.Name="Repair services terminal"
kiosk.Size=Vector3.new(6,6,4)
kiosk.CFrame=CFrame.new(-355,4,-1007)
kiosk.Anchored=true
kiosk.Material=Enum.Material.Metal
kiosk.Color=Color3.fromRGB(43,104,119)
kiosk.Parent=garage
local prompt=Instance.new("ProximityPrompt")
prompt.ActionText="Repair nearby vehicle"
prompt.ObjectText="Dubai Motor Workshop"
prompt.MaxActivationDistance=14
prompt.HoldDuration=.75
prompt.RequiresLineOfSight=false
prompt.Parent=kiosk
prompt.Triggered:Connect(function(player)
 local char=player.Character
 local hrp=char and char:FindFirstChild("HumanoidRootPart")
 if not hrp or (hrp.Position-kiosk.Position).Magnitude>17 then return end
 local closest,distance=nil,90
 for car in pairs(known) do
  if car.Parent then
   local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
   if seat then
    local delta=(seat.Position-foundation.Position).Magnitude
    if delta<distance then
     distance=delta;closest=car
    end
   end
  end
 end
 if not closest then
  notice:FireClient(player,"Bring a vehicle onto the repair ramp.")
  return
 end
 closest:SetAttribute("UAE60Damage",0)
 closest:SetAttribute("UAE60NeedsRepair",false)
 local body=closest:FindFirstChild("UAE60_RefinedBody")
 local primary=body and body:FindFirstChild("Refined painted flank",true)
 if primary and originalColors[primary] then
  primary.Color=originalColors[primary]
 end
 notice:FireClient(player,"Vehicle repaired and inspected successfully.")
end)
print("[UAE6] Visual collision monitor and repair workshop enabled")
