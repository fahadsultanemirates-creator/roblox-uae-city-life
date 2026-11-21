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
