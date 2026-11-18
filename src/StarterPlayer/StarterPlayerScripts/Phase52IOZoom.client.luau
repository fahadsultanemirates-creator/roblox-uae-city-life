-- UAE City Life v5.2: reliable third-person zoom with I/O on laptop.
-- Some Roblox CoreScripts consume I/O key events; poll IsKeyDown each frame.
-- O = zoom OUT, I = zoom IN. Mouse wheel and camera-orbit are extras.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V52_CameraStatus"
gui.ResetOnSpawn=false
gui.DisplayOrder=24
gui.Parent=player:WaitForChild("PlayerGui")
local hint=Instance.new("TextLabel")
hint.Name="CameraZoomStatus"
hint.AnchorPoint=Vector2.new(1,1)
hint.Position=UDim2.new(1,-12,1,-12)
hint.Size=UDim2.fromOffset(160,22)
hint.BackgroundColor3=Color3.fromRGB(22,43,55)
hint.BackgroundTransparency=.24
hint.BorderSizePixel=0
hint.TextColor3=Color3.fromRGB(244,232,209)
hint.TextSize=11
hint.Font=Enum.Font.GothamSemibold
hint.Text="I Zoom In  |  O Zoom Out"
hint.Parent=gui
local round=Instance.new("UICorner")
round.CornerRadius=UDim.new(0,7)
round.Parent=hint
local currentDistance=20
local orbit=0
local elevation=math.rad(19)
local mouseHeld=false
local lastType=nil
local lastKeyStep=0
local lastStatus=0
local initialized=false
local function vehicle()
 local character=player.Character
 local hum=character and character:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then
   return model,character,hum
  end
 end
 return nil,character,hum
end
local function maxRange()
 local car=vehicle()
 return car and 12 or 5,car and 105 or 75
end
local function zoom(ratio)
 local near,far=maxRange()
 currentDistance=math.clamp(currentDistance*ratio,near,far)
 hint.Text=string.format("I / O  ZOOM   %d studs",math.round(currentDistance))
end
local function resetCamera()
 currentDistance=20
 orbit=0
 elevation=math.rad(19)
end
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then
  mouseHeld=true
 end
 if processed or UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.C then
  resetCamera()
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  elevation=math.clamp(elevation+math.rad(9),math.rad(8),math.rad(74))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  elevation=math.clamp(elevation-math.rad(9),math.rad(8),math.rad(74))
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=false end
end)
UIS.InputChanged:Connect(function(input,processed)
 if UIS:GetFocusedTextBox() then return end
 if input.UserInputType==Enum.UserInputType.MouseWheel and not processed then
  zoom(input.Position.Z>0 and .82 or 1.21)
 elseif input.UserInputType==Enum.UserInputType.MouseMovement and mouseHeld then
  orbit=orbit-input.Delta.X*.006
  elevation=math.clamp(elevation+input.Delta.Y*.004,math.rad(8),math.rad(74))
 end
end)
RunService:BindToRenderStep("UAE_V52_KBZoomCamera",Enum.RenderPriority.Camera.Value+70,function(dt)
 local camera=workspace.CurrentCamera
 if not camera then return end
 local car,char,hum=vehicle()
 local root=char and char:FindFirstChild("HumanoidRootPart")
 if not root or not hum or hum.Health<=0 then
  initialized=false
  camera.CameraType=Enum.CameraType.Custom
  return
 end
 local mode=car and "Vehicle" or "Walk"
 if mode~=lastType then
  lastType=mode
  currentDistance=car and 35 or 20
  initialized=false
 end
 -- Roblox default camera may process I/O before InputBegan; reading key STATE works.
 local now=os.clock()
 if not UIS:GetFocusedTextBox() and now-lastKeyStep>=.11 then
  if UIS:IsKeyDown(Enum.KeyCode.I) then
   zoom(.89)
   lastKeyStep=now
  elseif UIS:IsKeyDown(Enum.KeyCode.O) then
   zoom(1.13)
   lastKeyStep=now
  end
 end
 -- Explicit CFrame placement prevents old camera settings ignoring zoom.
 local basis=car and car:GetPivot() or root.CFrame
 local height=car and 5.7 or 2.3
 local target=(basis*CFrame.new(0,height,0)).Position
 local localView=basis*CFrame.Angles(0,orbit,0)
 local intended=(localView*CFrame.new(0,height+currentDistance*math.sin(elevation),
  currentDistance*math.cos(elevation))).Position
 local vec=intended-target
 if vec.Magnitude<1 then return end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=car and {char,car} or {char}
 params.IgnoreWater=true
 local hit=workspace:Raycast(target,vec,params)
 if hit then intended=hit.Position-vec.Unit*1.3 end
 camera.CameraType=Enum.CameraType.Scriptable
 local goal=CFrame.lookAt(intended,target)
 camera.CFrame=initialized and camera.CFrame:Lerp(goal,math.clamp(dt*13,0,1)) or goal
 camera.Focus=CFrame.new(target)
 camera.FieldOfView=70
 initialized=true
end)
