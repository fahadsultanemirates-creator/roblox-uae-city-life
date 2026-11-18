-- UAE City Life v5.2: lightweight neighborhood pedestrian loop.
-- Uses Roblox's own R15 rig creator; models are basic, not photorealistic.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local area=world:WaitForChild("Phase52_RoleplayDistrict")
local crowd=Instance.new("Folder")
crowd.Name="ShoppingStreetResidents"
crowd.Parent=area
local positions={
 {Vector3.new(-370,4,-682),Vector3.new(-290,4,-682),Vector3.new(-290,4,-740)},
 {Vector3.new(-225,4,-682),Vector3.new(-150,4,-682),Vector3.new(-150,4,-744)},
 {Vector3.new(-60,4,-681),Vector3.new(0,4,-681),Vector3.new(0,4,-745)},
 {Vector3.new(110,4,-682),Vector3.new(170,4,-682),Vector3.new(170,4,-741)},
 {Vector3.new(265,4,-680),Vector3.new(330,4,-680),Vector3.new(330,4,-740)},
 {Vector3.new(399,4,-683),Vector3.new(430,4,-733),Vector3.new(397,4,-733)},
}
local palette={
 Color3.fromRGB(232,188,150),Color3.fromRGB(160,118,86),
 Color3.fromRGB(111,81,65),Color3.fromRGB(207,153,122),
 Color3.fromRGB(188,130,94),Color3.fromRGB(224,195,155),
}
local shirts={
 Color3.fromRGB(81,131,168),Color3.fromRGB(236,224,201),
 Color3.fromRGB(65,113,91),Color3.fromRGB(157,85,101),
 Color3.fromRGB(210,182,120),Color3.fromRGB(77,80,102),
}
for i,waypoints in ipairs(positions) do
 task.spawn(function()
  local desc=Instance.new("HumanoidDescription")
  local skin=palette[i]
  desc.HeadColor=skin
  desc.LeftArmColor=skin
  desc.RightArmColor=skin
  desc.TorsoColor=shirts[i]
  desc.LeftLegColor=Color3.fromRGB(61,76,96)
  desc.RightLegColor=Color3.fromRGB(61,76,96)
  desc.HeightScale=1
  local ok,rig=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
  end)
  desc:Destroy()
  if not ok or not rig then warn("v5.2 shopper "..i.." not created") return end
  rig.Name="Dubai Shopper "..i
  local hum=rig:FindFirstChildOfClass("Humanoid")
  if not hum then rig:Destroy() return end
  hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  hum.WalkSpeed=7+i%3
  rig.Parent=crowd
  rig:PivotTo(CFrame.new(waypoints[1]))
  for _,p in ipairs(rig:GetDescendants()) do
   if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=false end
  end
  while crowd.Parent and hum.Health>0 do
   for n=2,#waypoints do
    if not rig.Parent or hum.Health<=0 then break end
    hum:MoveTo(waypoints[n])
    hum.MoveToFinished:Wait()
    task.wait(.2)
   end
   if rig.Parent and hum.Health>0 then
    hum:MoveTo(waypoints[1])
    hum.MoveToFinished:Wait()
   end
  end
 end)
 task.wait(.12)
end
