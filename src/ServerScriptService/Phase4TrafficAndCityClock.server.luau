-- PHASE 4: route-locked city traffic, R15 ambient people, live day-night cycle.
-- Studio server script. All traffic vehicles non-collidable: deliberate for this v4 beta.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase4_MegaCity")
local vehicles=root:WaitForChild("RouteTraffic")
local humans=root:WaitForChild("CitizenWaypoints")
-- One-way nested ring lanes. They never cross, merge or intersect each other.
-- Cars in the same ring/lane have identical speed and are equally spaced.
local function route(hw,hh,cz)
 local coords={}
 local r=45
 local corners={
  {hw-r,-hh+r,-math.pi/2,0},
  {hw-r, hh-r,0,math.pi/2},
  {-hw+r,hh-r,math.pi/2,math.pi},
  {-hw+r,-hh+r,math.pi,math.pi*1.5}
 }
 for _,c in ipairs(corners) do
  for i=0,7 do
   local a=c[3]+(c[4]-c[3])*i/7
   coords[#coords+1]=Vector3.new(c[1]+r*math.cos(a),0,cz+c[2]+r*math.sin(a))
  end
 end
 local lengths={}
 local total=0
 for i=1,#coords do
  local len=(coords[i%#coords+1]-coords[i]).Magnitude
  lengths[i]=len
  total=total+len
 end
 return {pts=coords,lengths=lengths,length=total}
end
local routes={
 D1=route(302,232,-325), D2=route(317,247,-325),
 C1=route(322,242,215), C2=route(337,257,215),
 O1=route(1032,942,0),O2=route(1047,957,0),
}
local function positionAt(route,d)
 d=d%route.length
 for i,len in ipairs(route.lengths) do
  if d<=len then
   local a=route.pts[i]
   local b=route.pts[i%#route.pts+1]
   local pos=a:Lerp(b,math.clamp(d/len,0,1))
   local ahead=route.pts[(i+1)%#route.pts+1]
   local smooth=b:Lerp(ahead,math.min(.12,1))
   local look=(b-pos)
   if look.Magnitude<1 then look=smooth-b end
   if look.Magnitude<.01 then look=Vector3.new(0,0,-1) end
   return pos,look.Unit
  end
  d=d-len
 end
 return route.pts[1],Vector3.new(0,0,-1)
end
local cars={}
for _,model in ipairs(vehicles:GetChildren()) do
 if model:IsA("Model") and model.PrimaryPart then
  local lane=model:GetAttribute("Lane") or "D1"
  local path=routes[lane]
  if path then
   cars[#cars+1]={
    model=model,route=path,
    s=tonumber(model:GetAttribute("Progress")) or 0,
    speed=tonumber(model:GetAttribute("Speed")) or 17
   }
  end
 end
end
local clockStart=os.clock()
local function updateClock()
 local cycle=(14+(os.clock()-clockStart)*24/(40*60))%24
 ReplicatedStorage:SetAttribute("UAECycleHour",cycle)
 Lighting.ClockTime=cycle
 local night=cycle<6 or cycle>=18.2
 for _,lamp in ipairs(root:GetDescendants()) do
  if lamp:IsA("PointLight") and lamp.Name=="CityNightLamp" then
   lamp.Enabled=night
  end
 end
end
updateClock()
task.spawn(function()
 while root.Parent do
  updateClock()
  task.wait(6)
 end
end)
local accumulated=0
RunService.Heartbeat:Connect(function(dt)
 accumulated=accumulated+math.min(dt,.12)
 if accumulated<.065 then return end
 local step=math.min(accumulated,.16)
 accumulated=0
 for _,car in ipairs(cars) do
  if car.model.Parent then
   car.s=(car.s+car.speed*step)%car.route.length
   local pos,forward=positionAt(car.route,car.s)
   car.model:PivotTo(CFrame.lookAt(pos,pos+forward))
  end
 end
end)

-- Actual R15 Roblox Humanoid models. No downloaded/copy-protected avatars or accessories.
-- Rendering defaults are simple but better than floating rectangular mannequins.
local torsoColors={
 Color3.fromRGB(244,242,232),Color3.fromRGB(61,111,166),
 Color3.fromRGB(139,49,64),Color3.fromRGB(223,180,62),
 Color3.fromRGB(65,128,88),Color3.fromRGB(176,179,182),
}
local skinColors={
 Color3.fromRGB(231,188,147),Color3.fromRGB(191,142,103),
 Color3.fromRGB(145,104,80),Color3.fromRGB(247,210,166),
}
local locations={
 {Vector3.new(180,2,370),Vector3.new(279,2,370),Vector3.new(279,2,415),Vector3.new(180,2,415)},
 {Vector3.new(-165,2,200),Vector3.new(-90,2,200),Vector3.new(-90,2,228),Vector3.new(-165,2,228)},
 {Vector3.new(82,2,175),Vector3.new(148,2,175),Vector3.new(148,2,202),Vector3.new(82,2,202)},
}
local npcFolder=Instance.new("Folder")
npcFolder.Name="R15WalkingCitizens"
npcFolder.Parent=root
for i=1,15 do
 task.spawn(function()
  local description=Instance.new("HumanoidDescription")
  local skin=skinColors[(i-1)%#skinColors+1]
  local outfit=torsoColors[(i-1)%#torsoColors+1]
  description.HeadColor=skin
  description.LeftArmColor=skin
  description.RightArmColor=skin
  description.TorsoColor=outfit
  description.LeftLegColor=Color3.fromRGB(55,68,78)
  description.RightLegColor=Color3.fromRGB(55,68,78)
  description.HeightScale=.92+(i%4)*.04
  description.WidthScale=.95
  local ok,rig=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15)
  end)
  description:Destroy()
  if not ok or not rig then
   warn("UAE City Life: unable to create NPC "..i)
   return
  end
  rig.Name="UAE Resident "..i
  local hum=rig:FindFirstChildOfClass("Humanoid")
  local hrp=rig:FindFirstChild("HumanoidRootPart")
  if not hum or not hrp then rig:Destroy() return end
  local route=locations[(i-1)%#locations+1]
  local start=(i-1)%4+1
  rig.Parent=npcFolder
  rig:PivotTo(CFrame.new(route[start]))
  hum.WalkSpeed=7+(i%3)
  hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  -- Citizens don't push players or interfere with emergency vehicles.
  for _,p in ipairs(rig:GetDescendants()) do
   if p:IsA("BasePart") then p.CanCollide=false end
  end
  -- A hidden non-colliding root still moves through MoveTo; no teleporting across roads.
  while rig.Parent and root.Parent and hum.Health>0 do
   local nextIndex=start%#route+1
   local target=route[nextIndex]
   hum:MoveTo(target)
   local reached=hum.MoveToFinished:Wait()
   if not reached then hum:MoveTo(target) end
   start=nextIndex
   task.wait(.25+(i%3)*.12)
  end
 end)
 task.wait(.12)
end
