-- UAE CITY LIFE v5.3: keyboard/buttons zoom ONLY; mouse right-drag rotates camera.
-- I = zoom in, O = zoom out. Mousewheel is intentionally NOT used for zoom.
-- ContextActionService has higher input priority than default Roblox camera keys.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local RS=game:GetService("RunService")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V53_CameraControls"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=42
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(19,45,56)
local fg=Color3.fromRGB(250,238,216)
local function control(name,caption,y)
 local b=Instance.new("TextButton")
 b.Name=name
 b.AnchorPoint=Vector2.new(1,0)
 b.Position=UDim2.new(1,-12,0,y)
 b.Size=UDim2.fromOffset(40,34)
 b.BackgroundColor3=bg
 b.BackgroundTransparency=.1
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.Text=caption
 b.TextSize=17
 b.Font=Enum.Font.GothamBold
 b.TextColor3=fg
 b.Parent=gui
 local rounded=Instance.new("UICorner")
 rounded.CornerRadius=UDim.new(0,8)
 rounded.Parent=b
 return b
end
local zoomIn=control("ZoomIn_I","I +",185)
local zoomOut=control("ZoomOut_O","O −",225)
local reset=control("CameraReset","C",265)
local info=Instance.new("TextLabel")
info.Name="CameraHelp"
info.AnchorPoint=Vector2.new(1,0)
info.Position=UDim2.new(1,-59,0,185)
info.Size=UDim2.fromOffset(130,74)
info.BackgroundColor3=bg
info.BackgroundTransparency=.15
info.BorderSizePixel=0
info.TextColor3=fg
info.Font=Enum.Font.GothamMedium
info.TextSize=12
info.TextWrapped=true
info.Text="I / O  •  ZOOM\nRight-drag • LOOK\nCAM 20 studs"
info.Parent=gui
local c=Instance.new("UICorner")
c.CornerRadius=UDim.new(0,8)
c.Parent=info

local dist=20
local yaw=0
local pitch=math.rad(16)
local mouseHeld=false
local modeWas=""
local initialized=false
local nextRepeat=0
local function state()
 local ch=player.Character
 local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 local seat=hum and hum.SeatPart
 local car=nil
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then car=model end
 end
 return ch,hum,root,car
end
local function zoom(inward)
 local _,_,_,car=state()
 dist=math.clamp(dist*(inward and .84 or 1.2),car and 12 or 5,car and 100 or 75)
 info.Text=string.format("I / O  •  ZOOM\nRight-drag • LOOK\nCAM %d studs",math.round(dist))
end
local function defaultView()
 dist=20
 yaw=0
 pitch=math.rad(16)
 info.Text="I / O  •  ZOOM\nRight-drag • LOOK\nCAM 20 studs"
end
zoomIn.Activated:Connect(function() zoom(true) end)
zoomOut.Activated:Connect(function() zoom(false) end)
reset.Activated:Connect(defaultView)
-- Keyboard action handlers take priority over Roblox's default I/O camera bindings.
local function onKeyboard(actionName,inputState)
 if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
 if inputState==Enum.UserInputState.Begin then
  zoom(actionName=="UAE_V53_ZoomIn")
  nextRepeat=os.clock()+.28
 end
 return Enum.ContextActionResult.Sink
end
CAS:BindActionAtPriority("UAE_V53_ZoomIn",onKeyboard,false,4000,Enum.KeyCode.I)
CAS:BindActionAtPriority("UAE_V53_ZoomOut",onKeyboard,false,4000,Enum.KeyCode.O)
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=true end
 if UIS:GetFocusedTextBox() or processed then return end
 if input.KeyCode==Enum.KeyCode.C then defaultView()
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(9),math.rad(5),math.rad(77))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(9),math.rad(5),math.rad(77))
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=false end
end)
UIS.WindowFocusReleased:Connect(function() mouseHeld=false end)
UIS.InputChanged:Connect(function(input)
 -- Mouse movement rotates the camera while the right button is held.
 -- The scroll wheel is NOT bound to zoom, as requested.
 if mouseHeld and input.UserInputType==Enum.UserInputType.MouseMovement then
  yaw=yaw-input.Delta.X*.008
  pitch=math.clamp(pitch+input.Delta.Y*.005,math.rad(5),math.rad(77))
 end
end)
RS:BindToRenderStep("UAE_V53_OrbitCamera",Enum.RenderPriority.Camera.Value+90,function(dt)
 local camera=workspace.CurrentCamera
 local ch,hum,root,car=state()
 if not camera or not root or not hum or hum.Health<=0 then
  if camera then camera.CameraType=Enum.CameraType.Custom end
  initialized=false
  return
 end
 local mode=car and "Car" or "Walk"
 if mode~=modeWas then
  modeWas=mode
  initialized=false
  dist=car and 37 or 20
  info.Text=string.format("I / O  •  ZOOM\nRight-drag • LOOK\nCAM %d studs",dist)
 end
 if not UIS:GetFocusedTextBox() and os.clock()>nextRepeat then
  if UIS:IsKeyDown(Enum.KeyCode.I) then zoom(true);nextRepeat=os.clock()+.12
  elseif UIS:IsKeyDown(Enum.KeyCode.O) then zoom(false);nextRepeat=os.clock()+.12 end
 end
 local basis=car and car:GetPivot() or root.CFrame
 local height=car and 5.8 or 2.6
 local focus=(basis*CFrame.new(0,height,0)).Position
 local behind=basis*CFrame.Angles(0,yaw,0)
 local desired=(behind*CFrame.new(0,height+dist*math.sin(pitch),
  dist*math.cos(pitch))).Position
 local ray=desired-focus
 if ray.Magnitude<.2 then return end
 local param=RaycastParams.new()
 param.FilterType=Enum.RaycastFilterType.Exclude
 param.FilterDescendantsInstances=car and {ch,car} or {ch}
 param.IgnoreWater=true
 local hit=workspace:Raycast(focus,ray,param)
 if hit then desired=hit.Position-ray.Unit*1.3 end
 camera.CameraType=Enum.CameraType.Scriptable
 local goal=CFrame.lookAt(desired,focus)
 camera.CFrame=initialized and camera.CFrame:Lerp(goal,math.clamp(dt*12,0,1)) or goal
 camera.Focus=CFrame.new(focus)
 camera.FieldOfView=70
 initialized=true
end)
