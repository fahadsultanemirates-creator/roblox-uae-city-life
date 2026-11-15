-- Roblox UAE City Life | Phase 3A ambient traffic & walkers
-- Simple animated visual population, not physics/NPC AI. Kept low-cost for laptops.
local RunService=game:GetService("RunService")
local root=workspace:WaitForChild("UAE_City_Life"):WaitForChild("Phase3_LivingCity")
local traffic=root:WaitForChild("AmbientTraffic")
local walkers=root:WaitForChild("AmbientPedestrians")
local routes={
 -- Roads match current prototype, with simple turn-around loops.
 HighwaySouth={
  Vector3.new(-640,0,30),Vector3.new(640,0,30),
  Vector3.new(640,0,70),Vector3.new(-640,0,70)
 },
 Downtown={
  Vector3.new(-490,0,-235),Vector3.new(480,0,-235),
  Vector3.new(480,0,-207),Vector3.new(-490,0,-207)
 },
 East={
  Vector3.new(390,0,-540),Vector3.new(390,0,530),
  Vector3.new(418,0,530),Vector3.new(418,0,-540)
 },
 West={
  Vector3.new(-390,0,-540),Vector3.new(-390,0,530),
  Vector3.new(-363,0,530),Vector3.new(-363,0,-540)
 },
}
local walkersWaypoints={
 Vector3.new(-75,0,132),Vector3.new(76,0,132),
 Vector3.new(76,0,166),Vector3.new(-75,0,166),
}
local movers={}
for _,model in ipairs(traffic:GetChildren()) do
 if model:IsA("Model") and model.PrimaryPart then
  local route=routes[model:GetAttribute("RouteName") or "HighwaySouth"]
  local idx=tonumber(model:GetAttribute("Waypoint")) or 1
  local p=route[idx]
  movers[#movers+1]={model=model,route=route,index=idx,position=p,
   speed=tonumber(model:GetAttribute("Speed")) or 13}
 end
end
for _,model in ipairs(walkers:GetChildren()) do
 if model:IsA("Model") and model.PrimaryPart then
  local idx=tonumber(model:GetAttribute("Waypoint")) or 1
  local p=walkersWaypoints[idx]
  movers[#movers+1]={model=model,route=walkersWaypoints,index=idx,
   position=p,speed=tonumber(model:GetAttribute("Speed")) or 3}
 end
end
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
 accumulator=accumulator+math.min(dt,.08)
 if accumulator<.12 then return end
 local step=math.min(accumulator,.18)
 accumulator=0
 for _,obj in ipairs(movers) do
  if obj.model.Parent then
   local nextIndex=obj.index%#obj.route+1
   local dest=obj.route[nextIndex]
   local diff=dest-obj.position
   if diff.Magnitude<obj.speed*step+1 then
    obj.position=dest
    obj.index=nextIndex
   else
    obj.position=obj.position+diff.Unit*obj.speed*step
   end
   local dir=obj.route[obj.index%#obj.route+1]-obj.position
   if dir.Magnitude>.02 then
    obj.model:PivotTo(CFrame.lookAt(obj.position,obj.position+dir.Unit))
   end
  end
 end
end)
