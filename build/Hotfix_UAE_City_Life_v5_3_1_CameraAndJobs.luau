-- UAE City Life v5.3.1 / focused repair: 2 client scripts only
-- Applies to v5.3 in Roblox Studio EDIT mode with Play STOPPED.
-- Does not regenerate/rebuild any city, buildings, roads or missions.
local StarterPlayer=game:GetService("StarterPlayer")
local Servers=game:GetService("ServerScriptService")
local W=game:GetService("Workspace")
local city=W:FindFirstChild("UAE_City_Life")
assert(city and city:FindFirstChild("Phase52_RoleplayDistrict"),
 "Open your saved UAE City Life v5.3 game in Edit mode before installing 5.3.1.")
local scripts=StarterPlayer:WaitForChild("StarterPlayerScripts")
local oldNames={
 "UAE_Phase4Camera","UAE_Phase5Camera","UAE_Phase51Camera",
 "UAE_V52_Camera","UAE_V53_Camera","UAE_V53_Jobs"
}
for _,name in ipairs(oldNames) do
 local old=scripts:FindFirstChild(name)
 if old then old:Destroy() end
end
local function install(name,source)
 local scriptObj=Instance.new("LocalScript")
 scriptObj.Name=name
 scriptObj.Source=source
 scriptObj.Parent=scripts
end
install("UAE_V53_Camera",[========[
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
 b.Position=UDim2.new(1,-12,.5,y) -- anchored to live viewport center, not absolute screen pixels
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
local zoomIn=control("ZoomIn_I","I +",-57)
local zoomOut=control("ZoomOut_O","O −",-17)
local reset=control("CameraReset","C",23)
local info=Instance.new("TextLabel")
info.Name="CameraHelp"
info.AnchorPoint=Vector2.new(1,0)
info.Position=UDim2.new(1,-59,.5,-57)
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
local lastKeyPressAt=-10
local lastKeyPressed=nil
print("[UAE v5.3.1] Camera client started; I / O and right-side zoom buttons loaded")
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
local function pressKey(keyCode)
 if UIS:GetFocusedTextBox() then return end
 local now=os.clock()
 if lastKeyPressed==keyCode and now-lastKeyPressAt<.14 then return end
 lastKeyPressAt=now
 lastKeyPressed=keyCode
 zoom(keyCode==Enum.KeyCode.I)
 nextRepeat=now+.28
end
local function onKeyboard(actionName,inputState)
 if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
 if inputState==Enum.UserInputState.Begin then
  pressKey(actionName=="UAE_V53_ZoomIn" and Enum.KeyCode.I or Enum.KeyCode.O)
 end
 return Enum.ContextActionResult.Sink
end
CAS:BindActionAtPriority("UAE_V53_ZoomIn",onKeyboard,false,4000,Enum.KeyCode.I)
CAS:BindActionAtPriority("UAE_V53_ZoomOut",onKeyboard,false,4000,Enum.KeyCode.O)
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=true end
 if UIS:GetFocusedTextBox() then return end
 -- Fallback for keyboard layouts / CoreScript priority differences.
 if input.KeyCode==Enum.KeyCode.I or input.KeyCode==Enum.KeyCode.O then
  pressKey(input.KeyCode)
 end
 if processed then return end
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
pcall(function() RS:UnbindFromRenderStep("UAE_V52_KBZoomCamera") end)
pcall(function() RS:UnbindFromRenderStep("UAE_V53_OrbitCamera") end)
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

]========])
install("UAE_V53_Jobs",[========[
-- UAE City Life v5.3 compact JOBS menu + GPS shift progress.
-- All progress and points are determined by the server, not this client UI.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local action=RS:WaitForChild("UAE_V53_JobRequest",30)
local update=RS:WaitForChild("UAE_V53_JobUpdate",30)
if not action or not update then warn("v5.3 jobs: server events unavailable") return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V53_RoleplayJobs"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=41
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(20,44,57)
local gold=Color3.fromRGB(235,191,117)
local white=Color3.fromRGB(244,234,218)
local aqua=Color3.fromRGB(68,145,152)
local function rounded(part,pixels)
 local c=Instance.new("UICorner")
 c.CornerRadius=UDim.new(0,pixels or 8)
 c.Parent=part
end
local function button(parent,name,txt,pos,size,color)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Text=txt
 b.Size=size
 b.Position=pos
 b.Font=Enum.Font.GothamBold
 b.TextSize=13
 b.TextColor3=white
 b.BackgroundColor3=color or aqua
 b.BorderSizePixel=0
 b.Parent=parent
 rounded(b)
 return b
end
local function text(parent,name,txt,pos,size,sz)
 local label=Instance.new("TextLabel")
 label.Name=name
 label.Text=txt
 label.Position=pos
 label.Size=size
 label.BackgroundTransparency=1
 label.Font=Enum.Font.GothamSemibold
 label.TextSize=sz or 12
 label.TextColor3=white
 label.TextWrapped=true
 label.TextXAlignment=Enum.TextXAlignment.Left
 label.Parent=parent
 return label
end
local launch=button(gui,"JobsButton","JOBS",
 UDim2.new(1,-85,1,-144),UDim2.fromOffset(71,37),bg)
local panel=Instance.new("Frame")
panel.Name="JobChoices"
panel.Size=UDim2.fromOffset(302,255)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.52)
panel.BackgroundColor3=bg
panel.BorderSizePixel=0
panel.Visible=false
panel.Parent=gui
rounded(panel,13)
local border=Instance.new("UIStroke")
border.Color=gold
border.Thickness=1.2
border.Parent=panel
text(panel,"Title","DUBAI COMMUNITY JOBS",
 UDim2.fromOffset(16,11),UDim2.fromOffset(246,27),16)
text(panel,"Subtitle","Choose a shift. Follow the destination marker.",
 UDim2.fromOffset(16,45),UDim2.fromOffset(272,27),11)
local close=button(panel,"Close","X",UDim2.fromOffset(263,10),
 UDim2.fromOffset(27,27),Color3.fromRGB(115,73,74))
close.Activated:Connect(function() panel.Visible=false end)
local options={
 {"Taxi Driver  •  55 pts","Taxi"},
 {"Clinic Helper  •  55 pts","Medic"},
 {"Dubai Tour Guide  •  70 pts","Tour"},
}
for n,entry in ipairs(options) do
 local b=button(panel,"Role"..entry[2],entry[1],UDim2.fromOffset(16,81+(n-1)*44),
  UDim2.fromOffset(270,37),aqua)
 b.Activated:Connect(function()
  action:FireServer("Start",entry[2])
  panel.Visible=false
 end)
end
local cancel=button(panel,"EndShift","End current shift",
 UDim2.fromOffset(16,217),UDim2.fromOffset(270,27),Color3.fromRGB(110,78,73))
cancel.Activated:Connect(function()
 action:FireServer("Cancel","None")
 panel.Visible=false
end)
launch.Activated:Connect(function() panel.Visible=not panel.Visible end)
UIS.InputBegan:Connect(function(input,processed)
 if not processed and not UIS:GetFocusedTextBox() and input.KeyCode==Enum.KeyCode.J then
  panel.Visible=not panel.Visible
 end
end)
local banner=Instance.new("TextLabel")
banner.Name="CurrentShift"
banner.AnchorPoint=Vector2.new(.5,1)
banner.Position=UDim2.new(.5,0,1,-13)
banner.Size=UDim2.fromOffset(348,38)
banner.BackgroundColor3=bg
banner.BackgroundTransparency=.08
banner.BorderSizePixel=0
banner.Font=Enum.Font.GothamSemibold
banner.TextSize=12
banner.TextColor3=white
banner.TextWrapped=true
banner.Text="JOBS  •  Choose your first Dubai shift"
banner.Visible=false
banner.Parent=gui
rounded(banner,10)
local waypoint=Instance.new("Part")
waypoint.Name="UAE_LocalJobMarker"
waypoint.Size=Vector3.new(.2,.2,.2)
waypoint.Anchored=true
waypoint.CanCollide=false
waypoint.CanTouch=false
waypoint.CanQuery=false
waypoint.Transparency=1
waypoint.Parent=workspace
local beacon=Instance.new("BillboardGui")
beacon.Name="NextJobDestination"
beacon.Adornee=waypoint
beacon.Size=UDim2.fromOffset(140,42)
beacon.AlwaysOnTop=true
beacon.MaxDistance=300
beacon.StudsOffsetWorldSpace=Vector3.new(0,8,0)
beacon.Enabled=false
beacon.Parent=waypoint
local markerText=Instance.new("TextLabel")
markerText.Size=UDim2.fromScale(1,1)
markerText.BackgroundColor3=bg
markerText.BackgroundTransparency=.12
markerText.TextColor3=gold
markerText.Font=Enum.Font.GothamBold
markerText.TextScaled=true
markerText.TextWrapped=true
markerText.Text="NEXT STOP"
markerText.Parent=beacon
rounded(markerText,8)
local active=nil
local noticeExpires=0
update.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" or typeof(data.kind)~="string" then return end
 if data.kind=="progress" and typeof(data.position)=="Vector3" then
  active={title=tostring(data.name),step=data.step,total=data.total,
   label=tostring(data.label),position=data.position}
  waypoint.CFrame=CFrame.new(data.position)
  beacon.Enabled=true
  markerText.Text="JOB DESTINATION"
  banner.Visible=true
 elseif data.kind=="completed" or data.kind=="cancelled" then
  active=nil
  beacon.Enabled=false
  banner.Text=tostring(data.message or "Shift complete")
  banner.Visible=true
  noticeExpires=os.clock()+5
 end
end)
local counter=0
RunService.RenderStepped:Connect(function(dt)
 counter=counter+dt
 if counter<.3 then return end
 counter=0
 if active then
  local ch=player.Character
  local root=ch and ch:FindFirstChild("HumanoidRootPart")
  local meters=root and math.floor((root.Position-active.position).Magnitude) or 0
  banner.Text=string.format("%s  %d/%d | %s | %d studs",
   active.title,active.step,active.total,active.label,meters)
 elseif noticeExpires>0 and os.clock()>noticeExpires then
  banner.Visible=false
  noticeExpires=0
 end
end)
task.delay(2.5,function()
 if action.Parent then action:FireServer("Status","Current") end
end)

]========])
local missing=not Servers:FindFirstChild("UAE_V53_JobsServer")
if missing then
 warn("UAE 5.3.1: Jobs server is missing, install the main 5.3 patch first for roleplay missions.")
end
print("UAE CITY LIFE v5.3.1 INSTALLED: repaired JOBS TextColor3 and camera I/O with viewport-centered zoom buttons. Stop then Play to load changes.")
