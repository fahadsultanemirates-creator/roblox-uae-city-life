-- UAE CITY LIFE 6.0: low-cost road-following background traffic on E11.
-- Server follows authored lanes, slows near players and never drives across malls.
-- Noncolliding traffic scenery, not full physical AI driving.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local traffic=Instance.new("Folder")
traffic.Name="E11MovingTraffic"
traffic.Parent=root
local palettes={
 {Color3.fromRGB(236,231,219),Color3.fromRGB(58,90,118)},
 {Color3.fromRGB(189,204,212),Color3.fromRGB(48,79,98)},
 {Color3.fromRGB(48,103,122),Color3.fromRGB(34,47,56)},
 {Color3.fromRGB(231,221,195),Color3.fromRGB(180,69,56)},
}
local function part(m,name,sz,cf,col,mat,cylinder)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Anchored=true
 p.Color=col;p.Material=mat or Enum.Material.Metal
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 if cylinder then p.Shape=Enum.PartType.Cylinder end
 p.Parent=m;return p
end
local function mkCar(i)
 local model=Instance.new("Model")
 model.Name="E11 Civilian Traffic Vehicle "..i
 model:SetAttribute("UAE60NoArt",true)
 model.Parent=traffic
 local colors=palettes[(i-1)%#palettes+1]
 local rootPart=part(model,"CarPivot",Vector3.new(.3,.3,.3),
  CFrame.new(),colors[1])
 rootPart.Transparency=1
 model.PrimaryPart=rootPart
 part(model,"Vehicle chassis",Vector3.new(9.8,2.2,18),
  CFrame.new(0,4,0),colors[1])
 part(model,"Car rear cabin",Vector3.new(8.5,2.9,9),
  CFrame.new(0,6.3,1.3),colors[2],Enum.Material.Glass)
 part(model,"Car roof",Vector3.new(8.7,.65,9.3),
  CFrame.new(0,8.1,1.3),colors[1])
 local front=Instance.new("WedgePart")
 front.Name="Aerodynamic bonnet"
 front.Size=Vector3.new(9.2,2,5)
 front.CFrame=CFrame.new(0,5.3,-6.3)*CFrame.Angles(0,math.pi,0)
 front.Color=colors[1];front.Anchored=true;front.CanCollide=false
 front.CanTouch=false;front.CanQuery=false;front.Parent=model
 for _,s in ipairs({-1,1}) do
  for _,z in ipairs({-5.9,5.9}) do
   part(model,"Round black tyre",Vector3.new(1.6,4.8,4.8),
    CFrame.new(s*4.8,2.6,z),Color3.fromRGB(20,24,27),Enum.Material.Rubber,true)
   part(model,"Silver rim",Vector3.new(.2,2.8,2.8),
    CFrame.new(s*5.66,2.6,z),Color3.fromRGB(174,180,180),Enum.Material.Metal,true)
  end
  part(model,"Front LED lamps",Vector3.new(2.2,.6,.3),
   CFrame.new(s*2.6,4.7,-9.2),Color3.fromRGB(254,238,176),Enum.Material.Neon)
  part(model,"Rear red lamp",Vector3.new(2.1,.5,.3),
   CFrame.new(s*2.6,4.6,9.2),Color3.fromRGB(210,52,62),Enum.Material.Neon)
 end
 return model
end
local laneInfo={
 {-56,-1420,-1020,1}, {-36,-1370,-985,1},
 {38,-985,-1420,-1}, {57,-1000,-1390,-1},
 {-56,-1290,-1020,1}, {38,-1100,-1420,-1},
}
local cars={}
local low=root:GetAttribute("LowPerformance")==true
for i,lane in ipairs(laneInfo) do
 if low and i>4 then break end
 local x,zStart,zEnd=lane[1],lane[2],lane[3]
 local model=mkCar(i)
 local pos=Vector3.new(x,1.4,zStart)
 local target=Vector3.new(x,1.4,zEnd)
 local forward=(target-pos).Unit
 model:PivotTo(CFrame.lookAt(pos,pos+forward))
 cars[i]={model=model,from=pos,to=target,pos=pos,speed=0,
  cruise=23+(i%3)*3,waiting=0}
end
local throttle=0
RunService.Heartbeat:Connect(function(dt)
 throttle=throttle+math.min(dt,.12)
 if throttle<.12 then return end
 local delta=math.min(throttle,.2)
 throttle=0
 for _,car in ipairs(cars) do
  if not car.model.Parent then continue end
  local diff=car.to-car.pos
  if diff.Magnitude<12 then
   car.to,car.from=car.from,car.to
   diff=car.to-car.pos
   car.waiting=.9
  end
  local blocked=false
  for _,player in ipairs(Players:GetPlayers()) do
   local char=player.Character
   local rootPart=char and char:FindFirstChild("HumanoidRootPart")
   if rootPart and (rootPart.Position-car.pos).Magnitude<24 then
    local toward=rootPart.Position-car.pos
    if toward.Magnitude>1 and toward.Unit:Dot(diff.Unit)>.45 then
     blocked=true;break
    end
   end
  end
  for _,other in ipairs(cars) do
   if other~=car and (other.pos-car.pos).Magnitude<22 then
    local toward=other.pos-car.pos
    if toward.Magnitude>1 and toward.Unit:Dot(diff.Unit)>.55 then
     blocked=true;break
    end
   end
  end
  local desired=blocked and 0 or car.cruise
  if car.waiting>0 then car.waiting=math.max(0,car.waiting-delta);desired=0 end
  local rate=desired<car.speed and 45 or 17
  car.speed=car.speed+math.clamp(desired-car.speed,-rate*delta,rate*delta)
  local step=math.min(car.speed*delta,diff.Magnitude)
  local forward=diff.Unit
  car.pos=car.pos+forward*step
  car.model:PivotTo(CFrame.lookAt(car.pos,car.pos+forward))
 end
end)
print("[UAE6] E11 traffic: 6 lane-following civilian cars, slows for players")
