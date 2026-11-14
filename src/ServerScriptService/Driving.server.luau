-- Roblox UAE – City Life | experimental arcade vehicle controller
-- Vehicles are anchored prototypes, not physically simulated cars.
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vehicles = workspace:WaitForChild("UAE_City_Life"):WaitForChild("EmergencyVehicles")
local remote = ReplicatedStorage:FindFirstChild("UAE_DriveInput")
if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "UAE_DriveInput"
    remote.Parent = ReplicatedStorage
end
local controls = {}
local speeds = { Police = 40, Ambulance = 35, Fire = 28 }
local function carFromSeat(seat)
    if typeof(seat) ~= "Instance" or not seat:IsA("VehicleSeat") then return nil end
    local model = seat.Parent
    if not model or not model:IsA("Model") then return nil end
    if model.Parent ~= vehicles or model:GetAttribute("UAEVehicle") ~= true then return nil end
    if model:FindFirstChild("DriverSeat") ~= seat then return nil end
    return model
end
remote.OnServerEvent:Connect(function(player, seat, throttle, steer)
    local car = carFromSeat(seat)
    if not car then return end
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or seat.Occupant ~= humanoid then return end
    if typeof(throttle) ~= "number" or typeof(steer) ~= "number" then return end
    if throttle ~= throttle or steer ~= steer then return end
    controls[car] = {
        throttle = math.clamp(throttle, -1, 1),
        steer = math.clamp(steer, -1, 1),
        updated = os.clock(),
    }
end)
for _,obj in ipairs(vehicles:GetDescendants()) do
    if obj:IsA("VehicleSeat") then
        local car = carFromSeat(obj)
        if car then
            local prompt = obj:FindFirstChild("EntryPrompt")
            if prompt then
                prompt.Triggered:Connect(function(player)
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 and obj.Occupant == nil then
                        obj:Sit(humanoid)
                    end
                end)
            end
            obj:GetPropertyChangedSignal("Occupant"):Connect(function()
                if not obj.Occupant then controls[car] = nil end
            end)
        end
    end
end
RunService.Heartbeat:Connect(function(dt)
    dt = math.min(dt, .1)
    for car, ctrl in pairs(controls) do
        if not car.Parent then
            controls[car] = nil
        else
            local seat = car:FindFirstChild("DriverSeat")
            if not seat or not seat.Occupant or os.clock() - ctrl.updated > .55 then
                controls[car] = nil
            else
                local speed = ctrl.throttle * (speeds[car:GetAttribute("VehicleType")] or 30) * dt
                local turn = math.rad(54) * ctrl.steer * dt
                car:PivotTo(car:GetPivot() * CFrame.Angles(0, -turn, 0) * CFrame.new(0, 0, -speed))
            end
        end
    end
end)
