-- v5.5 R15 human NPC pedestrians: recognizable humanoids, no block statues.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local folder=Instance.new("Folder")
folder.Name="R15Citizens"
folder.Parent=root
local places={
 {name="Hotel Receptionist",x=-550,z=-911,shirt=Color3.fromRGB(47,79,109)},
 {name="Hospital Receptionist",x=-235,z=-1091,shirt=Color3.fromRGB(229,236,231)},
 {name="Airport Ground Staff",x=-1020,z=-975,shirt=Color3.fromRGB(59,93,143)},
 {name="Cafe Worker",x=-225,z=-590,shirt=Color3.fromRGB(154,110,69)},
 {name="Tourist Downtown",x=24,z=-340,shirt=Color3.fromRGB(216,199,173)},
 {name="Marina Visitor",x=1040,z=-1300,shirt=Color3.fromRGB(210,215,230)},
}
for i,loc in ipairs(places) do
 local success,model=pcall(function()
  local desc=Instance.new("HumanoidDescription")
  desc.HeightScale=1
  desc.WidthScale=.94
  desc.DepthScale=.94
  desc.HeadScale=1
  desc.BodyTypeScale=.35
  desc.ProportionScale=.5
  local m=Players:CreateHumanoidModelFromDescription(desc,Enum.HumanoidRigType.R15)
  desc:Destroy()
  return m
 end)
 if success and model then
  model.Name=loc.name
  model.Parent=folder
  model:PivotTo(CFrame.new(loc.x,4,loc.z))
  local hum=model:FindFirstChildOfClass("Humanoid")
  if hum then
   hum.DisplayName=loc.name
   hum.WalkSpeed=0
   hum.AutoRotate=false
  end
  local rootPart=model:FindFirstChild("HumanoidRootPart")
  if rootPart then rootPart.Anchored=true end
  for _,part in ipairs(model:GetDescendants()) do
   if part:IsA("BasePart") and part.Name=="UpperTorso" then
    part.Color=loc.shirt
   end
  end
 else
  warn("[v5.5] R15 NPC could not spawn:",loc.name)
 end
end
print("[v5.5] R15 human NPCs attempted:",#places)
