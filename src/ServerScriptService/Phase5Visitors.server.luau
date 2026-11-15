-- Phase 5 Dubai Modern: up to 12 additional R15 tourists and residents
-- R15 humanoids with varied skin tones, outfits and cap accessories, animated walking if possible.
-- Roblox-generated models are used, not copied GTA characters or third-party avatar IDs.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase5_DubaiModern")
local scenes=root:WaitForChild("DubaiStreetDetails")
local group=Instance.new("Folder")
group.Name="DubaiTourists"
group.Parent=root
local routes={
 {Vector3.new(-106,2,-1430),Vector3.new(-106,2,-1120),Vector3.new(-120,2,-1030),Vector3.new(-120,2,-1430)},
 {Vector3.new(108,2,-1430),Vector3.new(108,2,-1120),Vector3.new(116,2,-1030),Vector3.new(116,2,-1430)},
 {Vector3.new(990,4,-1440),Vector3.new(990,4,-1320),Vector3.new(990,4,-1160),Vector3.new(1010,4,-1160)},
 {Vector3.new(-520,2,-1010),Vector3.new(-390,2,-1010),Vector3.new(-390,2,-1070),Vector3.new(-520,2,-1070)},
 {Vector3.new(350,2,-1040),Vector3.new(400,2,-1040),Vector3.new(400,2,-1080),Vector3.new(350,2,-1080)},
}
local colors={
 Color3.fromRGB(240,199,162),Color3.fromRGB(190,147,106),
 Color3.fromRGB(144,102,75),Color3.fromRGB(221,177,142),
 Color3.fromRGB(96,72,59),Color3.fromRGB(230,185,145),
}
local shirts={
 Color3.fromRGB(239,240,232),Color3.fromRGB(56,114,157),
 Color3.fromRGB(78,135,109),Color3.fromRGB(148,70,97),
 Color3.fromRGB(191,154,77),Color3.fromRGB(69,81,95),
}
local walkAnim="rbxassetid://507777826" -- Roblox default R15 walk, may fail in Studio.
local count=root:GetAttribute("PerformanceMode") and 5 or 12
local function capFor(rig,head,n)
 if n%3~=0 then return end
 local brim=Instance.new("Part")
 brim.Name="Casual cap"
 brim.Size=Vector3.new(2.5,.42,2.9)
 brim.Color=shirts[(n-1)%#shirts+1]
 brim.Material=Enum.Material.Fabric
 brim.CanCollide=false
 brim.Anchored=false
 brim.Massless=true
 brim.CFrame=head.CFrame*CFrame.new(0,1.1,-.2)
 brim.Parent=rig
 local w=Instance.new("WeldConstraint")
 w.Part0=head
 w.Part1=brim
 w.Parent=brim
end
for n=1,count do
 task.spawn(function()
  local description=Instance.new("HumanoidDescription")
  local skin=colors[(n-1)%#colors+1]
  local shirt=shirts[(n-1)%#shirts+1]
  description.HeadColor=skin
  description.LeftArmColor=skin
  description.RightArmColor=skin
  description.TorsoColor=shirt
  description.LeftLegColor=Color3.fromRGB(62,72,86)
  description.RightLegColor=Color3.fromRGB(62,72,86)
  description.HeightScale=.94+(n%3)*.035
  description.WidthScale=.9+(n%3)*.05
  local ok,rig=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15)
  end)
  description:Destroy()
  if not ok or not rig then
   warn("V5 Dubai tourist could not spawn: "..n)
   return
  end
  rig.Name="Dubai Resident "..n
  local hum=rig:FindFirstChildOfClass("Humanoid")
  local hrp=rig:FindFirstChild("HumanoidRootPart")
  local head=rig:FindFirstChild("Head")
  if not hum or not hrp then rig:Destroy() return end
  local route=routes[(n-1)%#routes+1]
  local index=(n-1)%#route+1
  rig.Parent=group
  rig:PivotTo(CFrame.new(route[index]))
  hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  hum.WalkSpeed=6.5+(n%5)
  for _,item in ipairs(rig:GetDescendants()) do
   if item:IsA("BasePart") then
    item.CanCollide=item.Name=="HumanoidRootPart"
   end
  end
  if head and head:IsA("BasePart") then capFor(rig,head,n) end
  local animator=hum:FindFirstChildOfClass("Animator")
  if not animator then
   animator=Instance.new("Animator")
   animator.Parent=hum
  end
  pcall(function()
   local anim=Instance.new("Animation")
   anim.AnimationId=walkAnim
   local track=animator:LoadAnimation(anim)
   track.Looped=true
   track:Play()
  end)
  while rig.Parent and root.Parent and hum.Health>0 do
   index=index%#route+1
   local target=route[index]
   hum:MoveTo(target)
   local reached=hum.MoveToFinished:Wait()
   if not reached then hum:MoveTo(target) end
   task.wait(.25)
  end
 end)
 task.wait(.1)
end
