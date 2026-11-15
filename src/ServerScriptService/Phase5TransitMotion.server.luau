-- Phase 5: cinematic transit display movement.
-- Metro, yacht, cruise ship, sightseeing helicopter and airplane: anchored scene props,
-- NOT independently driveable or flyable yet; no player collision or external assets.
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase5_DubaiModern")
local motion=root:WaitForChild("AnimatedTransit")
local registry={}
for _,m in ipairs(motion:GetChildren()) do
 if m:IsA("Model") and m.PrimaryPart then
  local kind=m:GetAttribute("TransitType")
  if kind then
   registry[#registry+1]={
    model=m,kind=kind,phase=m:GetAttribute("Phase") or 0,
    speed=m:GetAttribute("MotionSpeed") or 1,
    part=m:FindFirstChild("RotorMain",true),
   }
  end
 end
end
local elapsed=0
local stepAccum=0
RunService.Heartbeat:Connect(function(dt)
 local capped=math.min(dt,.1)
 stepAccum=stepAccum+capped
 if stepAccum<.06 then return end
 local step=math.min(stepAccum,.13)
 stepAccum=0
 elapsed=elapsed+step
 for _,v in ipairs(registry) do
  if v.model.Parent then
   local t=(elapsed*v.speed+v.phase)
   if v.kind=="Metro" then
    local z=-1428+((t%2)<1 and (t%1)*395 or (1-(t%1))*395)
    local forward=(t%2)<1 and Vector3.new(0,0,1) or Vector3.new(0,0,-1)
    v.model:PivotTo(CFrame.lookAt(Vector3.new(193,29,z),
      Vector3.new(193,29,z)+forward))
   elseif v.kind=="Yacht" then
    local phi=t*.22
    local x=1220+125*math.cos(phi)
    local z=-1280+80*math.sin(phi)
    local tang=Vector3.new(-125*math.sin(phi),0,80*math.cos(phi))
    v.model:PivotTo(CFrame.lookAt(Vector3.new(x,3.8,z),
      Vector3.new(x,3.8,z)+tang))
   elseif v.kind=="Cruise" then
    local phi=t*.08
    local z=-1390+40*math.sin(phi)
    v.model:PivotTo(CFrame.lookAt(Vector3.new(1510,8,z),
      Vector3.new(1510,8,z)+Vector3.new(0,0,1)))
   elseif v.kind=="Helicopter" then
    local phi=t*.23
    local x=-1020+180*math.cos(phi)
    local z=-1240+145*math.sin(phi)
    local tang=Vector3.new(-180*math.sin(phi),0,145*math.cos(phi))
    local cf=CFrame.lookAt(Vector3.new(x,155+math.sin(t)*8,z),
      Vector3.new(x,155+math.sin(t)*8,z)+tang)
    v.model:PivotTo(cf)
    if v.part and v.part:IsA("BasePart") then
      v.part.CFrame=cf*CFrame.new(0,6.5,0)*CFrame.Angles(0,t*23,0)
    end
   elseif v.kind=="Plane" then
    -- Scenic flyover that wraps around far beyond the playable map.
    local p=t%1
    local from=Vector3.new(-1600,235,-1370)
    local to=Vector3.new(1400,355,-1370)
    local pos=from:Lerp(to,p)
    v.model:PivotTo(CFrame.lookAt(pos,pos+(to-from).Unit))
   end
  end
 end
end)
