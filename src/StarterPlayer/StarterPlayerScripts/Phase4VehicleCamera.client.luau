-- PHASE 4 improved chase camera for all 3 UAE emergency vehicles.
-- Exits cleanly when player leaves a seat. Does not affect walking camera.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local wasDriving=false
local function carSeat()
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then
   return model,hum
  end
 end
 return nil,hum
end
RunService:BindToRenderStep("UAE_Phase4Camera",Enum.RenderPriority.Camera.Value+1,function(dt)
 local camera=workspace.CurrentCamera
 if not camera then return end
 local car,hum=carSeat()
 if not car then
  if wasDriving then
   camera.CameraType=Enum.CameraType.Custom
   if hum then camera.CameraSubject=hum end
   camera.FieldOfView=70
   wasDriving=false
  end
  return
 end
 local typeName=car:GetAttribute("VehicleType") or "Police"
 local isFire=typeName=="Fire"
 local isAmbulance=typeName=="Ambulance"
 local height=isFire and 21 or (isAmbulance and 18 or 14)
 local distance=isFire and 43 or (isAmbulance and 38 or 34)
 local aimY=isFire and 7.5 or 5.2
 local basis=car:GetPivot()
 local eye=(basis*CFrame.new(0,height,distance)).Position
 local focus=(basis*CFrame.new(0,aimY,-14)).Position
 local desired=CFrame.lookAt(eye,focus)
 camera.CameraType=Enum.CameraType.Scriptable
 if wasDriving then
  camera.CFrame=camera.CFrame:Lerp(desired,math.clamp(dt*9,0,1))
 else
  camera.CFrame=desired
 end
 camera.FieldOfView=74
 wasDriving=true
end)
