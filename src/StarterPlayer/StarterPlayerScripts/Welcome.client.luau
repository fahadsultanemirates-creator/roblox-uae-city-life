-- Friendly temporary message shown at join.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UAECityWelcome"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local label = Instance.new("TextLabel")
label.Name = "WelcomeMessage"
label.AnchorPoint = Vector2.new(.5,0)
label.Position = UDim2.fromScale(.5,.035)
label.Size = UDim2.new(.8,0,0,80)
label.BackgroundColor3 = Color3.fromRGB(13,67,67)
label.BackgroundTransparency = .12
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextWrapped = true
label.Text = "🇦🇪 Welcome to Roblox UAE – City Life! Explore seven emirates. Press E by a vehicle to drive, W/A/S/D to steer."
label.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = label
task.delay(13,function()
    if gui.Parent then gui:Destroy() end
end)
