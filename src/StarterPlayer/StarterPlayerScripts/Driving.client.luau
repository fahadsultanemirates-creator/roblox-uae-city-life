-- Local controls: E near vehicle to enter; W/S to accelerate; A/D to steer.
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("UAE_DriveInput")
local player = Players.LocalPlayer
local function pressed(key)
    return UserInputService:IsKeyDown(key) and 1 or 0
end
while true do
    task.wait(.12)
    if not UserInputService:GetFocusedTextBox() then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local seat = humanoid and humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") and seat.Name == "DriverSeat" then
            local car = seat.Parent
            if car and car:GetAttribute("UAEVehicle") == true then
                remote:FireServer(seat,
                    pressed(Enum.KeyCode.W) - pressed(Enum.KeyCode.S),
                    pressed(Enum.KeyCode.D) - pressed(Enum.KeyCode.A))
            end
        end
    end
end
