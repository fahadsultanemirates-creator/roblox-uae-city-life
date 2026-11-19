-- UAE City Life 5.5: lightweight R15 NPC pedestrians and service staff.
-- Uses Roblox's standard avatar rig; no third-party avatar / copyrighted outfit IDs.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_LivingCity")
local performance=root:GetAttribute("PerformanceMode")==true
local folder=Instance.new("Folder")
folder.Name="UAE55_R15Pedestrians"
folder.Parent=root
local c=Color3.fromRGB
local archetypes={
 {name="Hospital Nurse",x=-225,z=-1086,walk=false,shirt=c(59,137,163),pants=c(36,76,94),skin=c(196,156,119)},
 {name="Hotel Receptionist",x=-548,z=-861,walk=false,shirt=c(169,112,92),pants=c(64,60,63),skin=c(199,151,123)},
 {name="Airport Check In Staff",x=-1137,z=-1000,walk=false,shirt=c(57,105,154),pants=c(48,58,72),skin=c(190,151,111)},
 {name="Police Community Officer",x=-1109,z=-479,walk=false,shirt=c(53,91,111),pants=c(28,42,59),skin=c(171,122,87)},
 {name="Civil Defence Volunteer",x=-1121,z=-650,walk=false,shirt=c(166,109,61),pants=c(74,62,57),skin=c(166,114,86)},
 {name="Downtown Resident",x=-360,z=-710,walk=true,shirt=c(90,123,107),pants=c(67,77,85),skin=c(220,183,152)},
 {name="Dubai Tourist",x=-400,z=-811,walk=true,shirt=c(189,160,104),pants=c(68,79,92),skin=c(167,114,81)},
 {name="Marina Walker",x=1050,z=-1300,walk=true,shirt=c(85,123,169),pants=c(76,74,79),skin=c(215,169,131)},
 {name="Park Visitor",x=-902,z=-878,walk=true,shirt=c(144,107,153),pants=c(53,73,75),skin=c(172,120,95)},
 {name="Airport Traveller",x=-1210,z=-965,walk=true,shirt=c(193,139,109),pants=c(51,62,75),skin=c(210,169,139)},
}
local spawnCount=performance and 7 or #archetypes
local created=0
for i=1,spawnCount do
 local entry=archetypes[i]
 local desc=Instance.new("HumanoidDescription")
 desc.HeightScale=1
 desc.WidthScale=.92
 desc.DepthScale=.92
 desc.HeadScale=.98
 desc.BodyTypeScale=.34
 desc.ProportionScale=.18
 local ok,model=pcall(function()
  return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
 end)
 desc:Destroy()
 if not ok or not model then
  warn("[UAE v5.5] Unable to create R15 NPC "..entry.name..": "..tostring(model))
 else
  model.Name=entry.name
  local hum=model:FindFirstChildOfClass("Humanoid")
  local rootPart=model:FindFirstChild("HumanoidRootPart")
  if hum and rootPart then
   hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.Subject
   hum.HealthDisplayType=Enum.HumanoidHealthDisplayType.AlwaysOff
   hum.WalkSpeed=entry.walk and 7 or 0
   hum.JumpPower=0
   for _,part in ipairs(model:GetDescendants()) do
    if part:IsA("BasePart") then
     local n=part.Name
     if n=="UpperTorso" or n=="LowerTorso" or n:find("UpperArm") then
      part.Color=entry.shirt
     elseif n:find("UpperLeg") or n:find("LowerLeg") or n:find("Foot") then
      part.Color=entry.pants
     elseif n=="Head" or n:find("Hand") or n:find("LowerArm") then
      part.Color=entry.skin
     end
     if n~="HumanoidRootPart" then part.CanCollide=false end
    end
   end
   model.Parent=folder
   model:PivotTo(CFrame.new(entry.x,4,entry.z))
   created=created+1
   if entry.walk then
    task.spawn(function()
     local rng=Random.new(690+i*13)
     while model.Parent and hum.Health>0 do
      local dx=rng:NextNumber(-12,12)
      local dz=rng:NextNumber(-15,15)
      local target=Vector3.new(entry.x+dx,4,entry.z+dz)
      hum:MoveTo(target)
      task.wait(rng:NextNumber(4,6.5))
     end
    end)
   end
  else
   model:Destroy()
   warn("[UAE v5.5] Missing Humanoid rig nodes for "..entry.name)
  end
 end
 task.wait(.08)
end
print("[UAE v5.5] "..created.." animated-capable R15 pedestrian and service rigs created")
