-- UAE CITY LIFE 6: R15 pedestrians for the single-install Phase60_World build.
-- Uses Roblox-owned default R15 rig construction and humanoid walking, no copied characters.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local folder=Instance.new("Folder")
folder.Name="WalkingHumanCitizens"
folder.Parent=root
local stations={
 {"Hotel Receptionist",{-545,-910},{-550,-906},{-559,-907}},
 {"Hospital Nurse",{-225,-1081},{-222,-1077},{-233,-1074}},
 {"Airport Staff",{-1020,-957},{-1006,-954},{-1010,-971}},
 {"Airport Traveller",{-1065,-1110},{-1052,-1100},{-1037,-1110}},
 {"Dubai Police Officer",{-1120,-477},{-1135,-470},{-1146,-486}},
 {"Firefighter",{-1130,-635},{-1150,-644},{-1115,-615}},
 {"Dubai Mall Visitor",{105,-375},{137,-360},{100,-338}},
 {"Downtown Visitor",{-65,-355},{-35,-347},{-82,-377}},
 {"Sheikh Zayed Tourist",{96,-1200},{102,-1140},{92,-1170}},
 {"Museum Guest",{315,-1124},{345,-1126},{320,-1153}},
 {"City Taxi Passenger",{-30,-742},{10,-736},{-22,-700}},
 {"Cafe Customer",{-214,-595},{-206,-587},{-223,-606}},
 {"Marina Visitor",{1050,-1325},{1063,-1275},{1042,-1230}},
 {"Beach Tourist",{1000,-720},{1040,-717},{1100,-700}},
 {"Community Gardener",{-942,-880},{-905,-900},{-965,-916}},
 {"Hotel Guest",{-580,-915},{-566,-905},{-545,-940}},
}
local clothingColors={
 Color3.fromRGB(59,91,115),Color3.fromRGB(226,232,230),
 Color3.fromRGB(62,111,144),Color3.fromRGB(195,169,126),
 Color3.fromRGB(210,221,221),Color3.fromRGB(91,148,112),
 Color3.fromRGB(162,105,77),Color3.fromRGB(89,109,153),
}
local pantsColors={
 Color3.fromRGB(36,48,62),Color3.fromRGB(55,61,69),
 Color3.fromRGB(104,88,77),Color3.fromRGB(58,72,93),
}
local skinColors={
 Color3.fromRGB(210,161,121),Color3.fromRGB(175,119,80),
 Color3.fromRGB(241,197,159),Color3.fromRGB(132,88,68),
}
local function npcDescription(index)
 local d=Instance.new("HumanoidDescription")
 d.HeightScale=1.0+((index%3)-1)*.06
 d.WidthScale=.92
 d.DepthScale=.91
 d.HeadScale=.97
 d.BodyTypeScale=.55
 d.ProportionScale=.65
 return d
end
local function setClothes(npc,i)
 local shirt=clothingColors[(i-1)%#clothingColors+1]
 local pants=pantsColors[(i-1)%#pantsColors+1]
 local skin=skinColors[(i-1)%#skinColors+1]
 for _,item in ipairs(npc:GetDescendants()) do
  if item:IsA("BasePart") then
   local name=item.Name
   if name=="UpperTorso" or name=="LowerTorso" or name=="LeftUpperArm" or name=="RightUpperArm" then
    item.Color=shirt
   elseif name:find("Leg") or name:find("Foot") then
    item.Color=pants
   elseif name=="Head" or name=="LeftHand" or name=="RightHand" then
    item.Color=skin
   end
  end
 end
 local h=npc:FindFirstChildOfClass("Humanoid")
 if h then h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.Viewer end
end
local count=0
local perf=root:GetAttribute("LowPerformance")==true
local nMax=perf and 7 or math.min(#stations,12) -- Dell laptop NPC performance budget
for i,location in ipairs(stations) do
 if i<=nMax then
  task.spawn(function()
   local d=npcDescription(i)
   local ok,npc=pcall(function()
    return Players:CreateHumanoidModelFromDescriptionAsync(d,Enum.HumanoidRigType.R15)
   end)
   d:Destroy()
   if not ok or not npc then
    warn("[UAE6] Could not construct R15 citizen:",location[1])
    return
   end
   npc.Name=location[1]
   npc.Parent=folder
   npc:PivotTo(CFrame.new(location[2][1],4.2,location[2][2]))
   setClothes(npc,i)
   local hum=npc:FindFirstChildOfClass("Humanoid")
   local hrp=npc:FindFirstChild("HumanoidRootPart")
   if not hum or not hrp then npc:Destroy() return end
   hum.WalkSpeed=i%5==0 and 7 or 9
   pcall(function() hrp:SetNetworkOwner(nil) end)
   -- Roblox standard R15 walk clip: optional asset; NPC still moves if inaccessible.
   local anim=Instance.new("Animation")
   anim.AnimationId="rbxassetid://507777826"
   local animator=hum:FindFirstChildOfClass("Animator") or Instance.new("Animator",hum)
   local okAnimation,track=pcall(function()
    return animator:LoadAnimation(anim)
   end)
   if okAnimation and track then
    track.Priority=Enum.AnimationPriority.Movement
    track.Looped=true
    track:Play(.15,1,.85)
   end
   hum.JumpPower=0
   hum.AutoRotate=true
   hum.BreakJointsOnDeath=false
   hrp.Anchored=false
   count=count+1
   local routes={location[2],location[3],location[4],location[2]}
   task.spawn(function()
    while folder.Parent and npc.Parent and hum.Health>0 do
     for _,pt in ipairs(routes) do
      if not npc.Parent then return end
      hum:MoveTo(Vector3.new(pt[1],3.3,pt[2]))
      hum.MoveToFinished:Wait()
      task.wait(1.3+(i%3)*.4)
     end
    end
   end)
  end)
 end
end
print("[UAE6] R15 pedestrian spawning started:",nMax,"humanoid citizens")
