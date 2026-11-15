-- Phase 5 vehicle chase camera: Mouse wheel zoom, right-drag orbit, PageUp/Down pitch.
-- On foot: Roblox's standard camera, zoom and right-drag remain available.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
player.CameraMode=Enum.CameraMode.Classic
player.CameraMinZoomDistance=5
player.CameraMaxZoomDistance=85
local rightHeld=false
local distance=36
local pitch=math.rad(18)
local yaw=0
local wasDriving=false
local lastCar=nil
UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.UserInputType==Enum.UserInputType.MouseButton2 then
  rightHeld=true
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(9),math.rad(4),math.rad(65))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(9),math.rad(4),math.rad(65))
 elseif input.KeyCode==Enum.KeyCode.C then
  yaw=0
  pitch=math.rad(18)
  distance=36
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then
  rightHeld=false
 end
end)
UIS.InputChanged:Connect(function(input,processed)
 if processed then return end
 if input.UserInputType==Enum.UserInputType.MouseWheel and wasDriving then
  distance=math.clamp(distance-input.Position.Z*4,18,78)
 elseif input.UserInputType==Enum.UserInputType.MouseMovement and rightHeld and wasDriving then
  yaw=yaw-input.Delta.X*.006
  pitch=math.clamp(pitch+input.Delta.Y*.004,math.rad(4),math.rad(65))
 end
end)
local function driveSeat()
 local character=player.Character
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 local seat=humanoid and humanoid.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then
   return model,humanoid,character
  end
 end
 return nil,humanoid,character
end
RunService:BindToRenderStep("UAE_Phase5Camera",Enum.RenderPriority.Camera.Value+1,function(dt)
 local camera=workspace.CurrentCamera
 if not camera then return end
 local car,humanoid,char=driveSeat()
 if not car then
  if wasDriving then
   camera.CameraType=Enum.CameraType.Custom
   if humanoid then camera.CameraSubject=humanoid end
   camera.FieldOfView=70
  end
  wasDriving=false
  lastCar=nil
  return
 end
 if car~=lastCar then
  distance=(car:GetAttribute("VehicleType")=="Fire") and 48 or 36
  pitch=math.rad(18)
  yaw=0
  lastCar=car
 end
 local base=car:GetPivot()
 local focus=(base*CFrame.new(0,6,-7)).Position
 local polar=CFrame.Angles(0,yaw,0)
 local eye=(base*polar*CFrame.new(0,
  math.sin(pitch)*distance+5,
  math.cos(pitch)*distance)).Position
 local diff=eye-focus
 if diff.Magnitude<2 then
  eye=focus+Vector3.new(0,9,22)
  diff=eye-focus
 end
 -- Avoid camera being embedded in walls; filter driver's vehicle and character.
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={car,char}
 local ray=workspace:Raycast(focus,diff,params)
 if ray then eye=ray.Position-diff.Unit*1.2 end
 local desired=CFrame.lookAt(eye,focus)
 camera.CameraType=Enum.CameraType.Scriptable
 camera.FieldOfView=73
 if not wasDriving then camera.CFrame=desired
 else camera.CFrame=camera.CFrame:Lerp(desired,math.clamp(dt*8,0,1)) end
 wasDriving=true
end)
