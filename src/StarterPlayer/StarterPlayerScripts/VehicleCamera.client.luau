-- Phase 2: Third-person chase camera for UAE emergency vehicles
-- Client only. This does not replace the avatar or force camera behavior when walking.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local wasDriving = false
local function getCarAndHumanoid()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local seat = humanoid and humanoid.SeatPart
    if seat and seat:IsA("VehicleSeat") and seat.Name == "DriverSeat" then
        local model = seat.Parent
        if model and model:IsA("Model") and model:GetAttribute("UAEVehicle") == true then
            return model, humanoid
        end
    end
    return nil, humanoid
end
RunService:BindToRenderStep("UAECityVehicleChase", Enum.RenderPriority.Camera.Value + 1, function(dt)
    local car, humanoid = getCarAndHumanoid()
    local camera = workspace.CurrentCamera
    if not camera then return end
    if car then
        -- Fixed over-the-shoulder chase camera; aim ahead of driver and above roofline.
        camera.CameraType = Enum.CameraType.Scriptable
        local pivot = car:GetPivot()
        local target = (pivot * CFrame.new(0, 5, -7)).Position
        local eye = (pivot * CFrame.new(0, 17, 31)).Position
        local desired = CFrame.lookAt(eye, target)
        if not wasDriving then
            camera.CFrame = desired
        else
            camera.CFrame = camera.CFrame:Lerp(desired, math.clamp(dt * 7, 0, 1))
        end
        camera.FieldOfView = 74
        wasDriving = true
    elseif wasDriving then
        camera.CameraType = Enum.CameraType.Custom
        if humanoid then camera.CameraSubject = humanoid end
        camera.FieldOfView = 70
        wasDriving = false
    end
end)
