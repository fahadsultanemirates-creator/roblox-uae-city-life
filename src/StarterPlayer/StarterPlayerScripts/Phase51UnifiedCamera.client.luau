-- UAE CITY LIFE v5.1: unified on-foot AND in-vehicle camera.
-- Mouse wheel or the +/- buttons zoom. Right-drag rotates. PageUp/Down change elevation.
-- Camera controls are on the RIGHT; minimap zoom buttons are on the LEFT.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local currentDistance=22
local yaw=0
local pitch=math.rad(18)
local rightHeld=false
local lastMode="OnFoot"
local cameraGui=Instance.new("ScreenGui")
cameraGui.Name="UAE_V51_CameraControls"
cameraGui.ResetOnSpawn=false
cameraGui.IgnoreGuiInset=false
cameraGui.DisplayOrder=35
cameraGui.Parent=player:WaitForChild("PlayerGui")
local function makeButton(name,text,y)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Size=UDim2.fromOffset(44,37)
 b.AnchorPoint=Vector2.new(1,0)
 b.Position=UDim2.new(1,-16,0,y)
 b.Text=text
 b.Font=Enum.Font.GothamBold
 b.TextSize=19
 b.TextColor3=Color3.fromRGB(248,240,213)
 b.BackgroundColor3=Color3.fromRGB(21,47,56)
 b.BackgroundTransparency=.08
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.ZIndex=4
 b.Parent=cameraGui
 local r=Instance.new("UICorner")
 r.CornerRadius=UDim.new(0,9)
 r.Parent=b
 return b
end
local plus=makeButton("CameraZoomIn","+ ",113)
local minus=makeButton("CameraZoomOut","−",157)
local up=makeButton("CameraUp","↑",209)
local down=makeButton("CameraDown","↓",253)
local indicator=Instance.new("TextLabel")
indicator.Name="CameraDistance"
indicator.Size=UDim2.fromOffset(87,25)
indicator.AnchorPoint=Vector2.new(1,0)
indicator.Position=UDim2.new(1,-10,0,298)
indicator.Font=Enum.Font.GothamBold
indicator.TextSize=11
indicator.TextColor3=Color3.fromRGB(252,243,218)
indicator.BackgroundColor3=Color3.fromRGB(23,48,58)
indicator.BackgroundTransparency=.17
indicator.Text="CAMERA 22"
indicator.Parent=cameraGui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,7)
corner.Parent=indicator
local function isDriving()
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local car=seat.Parent
  if car and car:IsA("Model") and car:GetAttribute("UAEVehicle")==true then
   return car,char,hum
  end
 end
 return nil,char,hum
end
local function limits()
 local car=isDriving()
 return car and 14 or 6,car and 100 or 80
end
local function zoomBy(factor)
 local near,far=limits()
 currentDistance=math.clamp(currentDistance*factor,near,far)
 indicator.Text=string.format("CAMERA %d",math.round(currentDistance))
end
plus.Activated:Connect(function() zoomBy(.77) end)
minus.Activated:Connect(function() zoomBy(1.30) end)
up.Activated:Connect(function() pitch=math.clamp(pitch+math.rad(10),math.rad(7),math.rad(73)) end)
down.Activated:Connect(function() pitch=math.clamp(pitch-math.rad(10),math.rad(7),math.rad(73)) end)
local function overMap()
 local gui=player.PlayerGui:FindFirstChild("UAE_V51_HUD") or player.PlayerGui:FindFirstChild("UAE_V5_HUD")
 if not gui then return false end
 local full=gui:FindFirstChild("ExpandedCityMap")
 if full and full.Visible then return true end
 local radar=gui:FindFirstChild("SmallRadar")
 if not radar then return false end
 local mouse=UIS:GetMouseLocation()
 local a=radar.AbsolutePosition
 local b=radar.AbsoluteSize
 return mouse.X>=a.X and mouse.X<=a.X+b.X and mouse.Y>=a.Y and mouse.Y<=a.Y+b.Y
end
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 and not overMap() then
  rightHeld=true
 end
 if processed then return end
 if input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(10),math.rad(7),math.rad(73))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(10),math.rad(7),math.rad(73))
 elseif input.KeyCode==Enum.KeyCode.C then
  currentDistance=22
  pitch=math.rad(18)
  yaw=0
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then rightHeld=false end
end)
UIS.InputChanged:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseWheel then
  if not overMap() then
   zoomBy(input.Position.Z>0 and .83 or 1.2)
  end
 elseif input.UserInputType==Enum.UserInputType.MouseMovement and rightHeld then
  yaw=yaw-input.Delta.X*.006
  pitch=math.clamp(pitch+input.Delta.Y*.004,math.rad(7),math.rad(73))
 end
end)
local wasActive=false
RunService:BindToRenderStep("UAE_Phase51UnifiedCamera",Enum.RenderPriority.Camera.Value+2,function(dt)
 local cam=workspace.CurrentCamera
 local car,char,hum=isDriving()
 local root=char and char:FindFirstChild("HumanoidRootPart")
 if not cam or not root then
  if wasActive and cam then
   cam.CameraType=Enum.CameraType.Custom
  end
  wasActive=false
  return
 end
 local mode=car and "Driving" or "OnFoot"
 if mode~=lastMode then
  currentDistance=car and 39 or 22
  pitch=math.rad(18)
  yaw=0
  lastMode=mode
 end
 local basis=car and car:GetPivot() or root.CFrame
 local vertical=car and 6.6 or 2.5
 local lookAt=(basis*CFrame.new(0,vertical,0)).Position
 local outward=basis*CFrame.Angles(0,yaw,0)
 local dist=math.max(currentDistance,6)
 local height=math.sin(pitch)*dist
 local behind=math.cos(pitch)*dist
 local wanted=(outward*CFrame.new(0,vertical+height,behind)).Position
 local direction=wanted-lookAt
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=car and {char,car} or {char}
 params.IgnoreWater=true
 local hit=workspace:Raycast(lookAt,direction,params)
 if hit then wanted=hit.Position-direction.Unit*1.1 end
 local desired=CFrame.lookAt(wanted,lookAt)
 cam.CameraType=Enum.CameraType.Scriptable
 cam.CFrame=cam.CFrame:Lerp(desired,wasActive and math.clamp(dt*9,0,1) or 1)
 cam.Focus=CFrame.new(lookAt)
 cam.FieldOfView=70
 wasActive=true
end)
