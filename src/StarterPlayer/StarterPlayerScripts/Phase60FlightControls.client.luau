-- UAE 6.0 arcade aircraft cockpit input. Uses server-validated pilot seat.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("UAE60_FlightControl",30)
if not remote then return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE60_PilotCockpit"
gui.ResetOnSpawn=false
gui.DisplayOrder=77
gui.Parent=player:WaitForChild("PlayerGui")
local info=Instance.new("TextLabel")
info.Name="FlightReadout"
info.AnchorPoint=Vector2.new(.5,1)
info.Position=UDim2.new(.5,0,1,-64)
info.Size=UDim2.fromOffset(340,67)
info.BackgroundColor3=Color3.fromRGB(19,44,61)
info.BackgroundTransparency=.13
info.BorderSizePixel=0
info.Font=Enum.Font.GothamBold
info.TextColor3=Color3.fromRGB(254,239,207)
info.TextSize=12
info.TextWrapped=true
info.Text="PILOT CONTROLS"
info.Visible=false
info.Parent=gui
local c=Instance.new("UICorner")
c.CornerRadius=UDim.new(0,11);c.Parent=info
local last=0
local wasFlying=false
Run.RenderStepped:Connect(function(dt)
 last=last+dt
 if last<.09 then return end
 last=0
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 local model=seat and seat.Parent
 local kind=seat and seat:GetAttribute("UAE60AircraftSeat")
 if not kind or not model or not model:GetAttribute("UAE60Aircraft") then
  if wasFlying then
   remote:FireServer({forward=0,yaw=0,climb=0})
  end
  wasFlying=false;info.Visible=false
  return
 end
 wasFlying=true;info.Visible=true
 local inputAllowed=UIS:GetFocusedTextBox()==nil
 local function down(key)
  return inputAllowed and UIS:IsKeyDown(key)
 end
 local forward=(down(Enum.KeyCode.W) and 1 or 0)-(down(Enum.KeyCode.S) and 1 or 0)
 local yaw=(down(Enum.KeyCode.D) and 1 or 0)-(down(Enum.KeyCode.A) and 1 or 0)
 local climb=(down(Enum.KeyCode.R) and 1 or 0)-(down(Enum.KeyCode.F) and 1 or 0)
 remote:FireServer({forward=forward,yaw=yaw,climb=climb})
 info.Text=string.format("%s   SPEED %d  |  ALT +%d studs\nW/S Throttle | A/D Turn | R Up | F Down | Space Exit\nARCADE FLIGHT • follow the city map below",
  kind:upper(),model:GetAttribute("UAE60Speed") or 0,
  model:GetAttribute("UAE60Altitude") or 0)
end)
