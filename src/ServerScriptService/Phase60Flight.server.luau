-- UAE CITY LIFE v6.0: playable lightweight arcade airplane and helicopter.
-- Not a physical aerodynamics simulation. Validated controls; server moves craft.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local phase=world:WaitForChild("Phase60_ProductionPass")
local aircraft=Instance.new("Folder")
aircraft.Name="PilotableAircraft"
aircraft.Parent=phase
local control=RS:FindFirstChild("UAE60_FlightControl")
if not control then
 control=Instance.new("RemoteEvent")
 control.Name="UAE60_FlightControl"
 control.Parent=RS
end
local notification=RS:WaitForChild("UAE60_Notification",30)
local white=Color3.fromRGB(234,236,233)
local navy=Color3.fromRGB(27,60,80)
local blue=Color3.fromRGB(66,145,177)
local red=Color3.fromRGB(198,54,55)
local silver=Color3.fromRGB(152,166,174)
local glass=Color3.fromRGB(64,132,158)
local black=Color3.fromRGB(26,30,34)
local function part(m,name,size,cf,color,material,shape)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.Material=material or Enum.Material.Metal;p.Color=color
 if shape then p.Shape=shape end
 p.Parent=m;return p
end
local function wedge(m,name,sz,cf,color)
 local p=Instance.new("WedgePart")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Color=color
 p.Material=Enum.Material.Metal;p.CanCollide=false
 p.CanTouch=false;p.Anchored=true;p.Parent=m;return p
end
local function sign(m,label,sz,cf)
 local obj=part(m,label,sz,cf,navy)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=40;gui.Parent=obj
 local txt=Instance.new("TextLabel")
 txt.Text=label;txt.TextScaled=true;txt.TextWrapped=true
 txt.TextColor3=white;txt.Font=Enum.Font.GothamBold
 txt.BackgroundTransparency=1;txt.Size=UDim2.fromScale(1,1)
 txt.Parent=gui
end
local states={}
local function create(name,kind,pos)
 local m=Instance.new("Model")
 m.Name=name
 m:SetAttribute("UAE60Aircraft",kind)
 m:SetAttribute("UAE60Speed",0)
 m:SetAttribute("UAE60Altitude",0)
 m.Parent=aircraft
 local pivot=part(m,"AircraftPivot",Vector3.new(.2,.2,.2),
  CFrame.new(),white,nil,nil)
 pivot.Transparency=1
 m.PrimaryPart=pivot
 if kind=="Plane" then
  local body=part(m,"Airliner round fuselage",Vector3.new(58,7.5,7.5),
   CFrame.new(0,7,0)*CFrame.Angles(0,math.pi/2,0),white,
   Enum.Material.Metal,Enum.PartType.Cylinder)
  part(m,"Lower red fuselage belt",Vector3.new(7.6,1,48),
   CFrame.new(0,3.6,0),red)
  for _,s in ipairs({-1,1}) do
   wedge(m,"Swept passenger wing",Vector3.new(34,1.4,23),
    CFrame.new(s*23,6,-6)*CFrame.Angles(0,s*.28,0),white)
   part(m,"Airline wing engine",Vector3.new(11,3.6,3.6),
    CFrame.new(s*22,3,-9)*CFrame.Angles(0,math.pi/2,0),
    silver,Enum.Material.Metal,Enum.PartType.Cylinder)
   part(m,"Landing gear wheel",Vector3.new(1,4.2,4.2),
    CFrame.new(s*4,2,10),black,Enum.Material.Rubber,Enum.PartType.Cylinder)
  end
  wedge(m,"Passenger tail fin",Vector3.new(2.5,17,11),
   CFrame.new(0,13,24),red)
  part(m,"Horizontal stabilizer",Vector3.new(22,1.2,7),
   CFrame.new(0,9,23),white)
  part(m,"Cockpit windshield",Vector3.new(6.7,2.5,.3),
   CFrame.new(0,9,-27),glass,Enum.Material.Glass)
  for _,z in ipairs({-18,-10,-2,6,14,20}) do
   for _,s in ipairs({-1,1}) do
    part(m,"Passenger window",Vector3.new(.3,1.2,2.7),
     CFrame.new(s*3.8,8.2,z),glass,Enum.Material.Glass)
   end
  end
  sign(m,"UAE CITY AIR  |  الإمارات",Vector3.new(6.8,2,.35),
   CFrame.new(0,7.1,16))
 else
  part(m,"Helicopter round passenger cabin",Vector3.new(19,6.6,7.8),
   CFrame.new(0,7,-3)*CFrame.Angles(0,math.pi/2,0),
   white,Enum.Material.Metal,Enum.PartType.Cylinder)
  part(m,"Blue helicopter cockpit windows",Vector3.new(6.6,4,6.4),
   CFrame.new(0,8,-9),glass,Enum.Material.Glass)
  part(m,"Helicopter tailboom",Vector3.new(2,2,20),
   CFrame.new(0,8,12),navy)
  wedge(m,"Aviation tail fin",Vector3.new(1.4,8,7),
   CFrame.new(0,10,22),red)
  for _,s in ipairs({-1,1}) do
   part(m,"Landing skid",Vector3.new(.75,.65,24),
    CFrame.new(s*5.5,2,0),black)
   for _,z in ipairs({-6,8}) do
    part(m,"Skid brace",Vector3.new(.6,4,.6),
     CFrame.new(s*5.5,4,z),silver)
   end
  end
  part(m,"Rotor mast",Vector3.new(.9,4,.9),
   CFrame.new(0,13,0),silver)
  local rotor=part(m,"Main spinning rotor",Vector3.new(44,.4,1.3),
   CFrame.new(0,15,0),black)
  m:SetAttribute("RotorName",rotor.Name)
  part(m,"Tail rotor",Vector3.new(.3,6,1),
   CFrame.new(1,9,22),black)
  sign(m,"DUBAI CITY RESCUE",Vector3.new(6,1.8,.35),CFrame.new(0,6,8))
 end
 local seat=Instance.new("VehicleSeat")
 seat.Name="PilotSeat"
 seat.Size=Vector3.new(3,1,3)
 seat.CFrame=kind=="Plane" and CFrame.new(0,9,-22) or CFrame.new(0,7,-9)
 seat.Anchored=true
 seat.Transparency=1
 seat.CanCollide=false
 seat.MaxSpeed=0
 seat:SetAttribute("UAE60AircraftSeat",kind)
 seat.Parent=m
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="PilotAircraft"
 prompt.ActionText=kind=="Plane" and "Pilot airplane" or "Pilot helicopter"
 prompt.ObjectText=name
 prompt.MaxActivationDistance=15
 prompt.RequiresLineOfSight=false
 prompt.HoldDuration=.5
 prompt.Parent=seat
 m:PivotTo(CFrame.new(pos))
 local state={model=m,seat=seat,kind=kind,speed=0,heading=0,
  altitude=pos.Y,pos=pos,lastControls=0,
  controls={forward=0,yaw=0,climb=0},
  ground=pos.Y,elapsed=0}
 states[m]=state
 prompt.Triggered:Connect(function(player)
  local char=player.Character
  local hum=char and char:FindFirstChildOfClass("Humanoid")
  local hrp=char and char:FindFirstChild("HumanoidRootPart")
  if not hum or not hrp or hum.Health<=0 or seat.Occupant then return end
  if (hrp.Position-seat.Position).Magnitude>18 then return end
  seat:Sit(hum)
  if notification then notification:FireClient(player,
    kind=="Plane" and "AIRLINER: W accelerate, S slow down, A/D turn, R climb, F descend. Space exits." or
    "HELICOPTER: W/S forward/back, A/D turn, R up, F down. Space exits.") end
 end)
 return m
end
local plane=create("UAE City Air Passenger Jet","Plane",Vector3.new(-1280,1.1,-1350))
local heli=create("Dubai City Rescue Helicopter","Helicopter",Vector3.new(-1050,3,-790))
-- Validate piloting on every input packet, never trust a client craft reference.
control.OnServerEvent:Connect(function(player,input)
 if typeof(input)~="table" then return end
 local character=player.Character
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 local seat=humanoid and humanoid.SeatPart
 if not seat or not seat:IsA("VehicleSeat") or not seat:GetAttribute("UAE60AircraftSeat") then return end
 if seat.Occupant~=humanoid then return end
 local state=states[seat.Parent]
 if not state or state.seat~=seat then return end
 local f,y,c=input.forward,input.yaw,input.climb
 if typeof(f)~="number" or typeof(y)~="number" or typeof(c)~="number" then return end
 if f~=f or y~=y or c~=c then return end
 if math.abs(f)>1 or math.abs(y)>1 or math.abs(c)>1 then return end
 state.controls={forward=f,yaw=y,climb=c}
 state.lastControls=os.clock()
end)
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
 accumulator=accumulator+math.min(dt,.12)
 if accumulator<.05 then return end
 local elapsed=math.min(accumulator,.1)
 accumulator=0
 for _,state in pairs(states) do
  if not state.model.Parent then continue end
  local occupant=state.seat.Occupant
  local active=occupant~=nil and Players:GetPlayerFromCharacter(occupant.Parent)~=nil
  local controls=active and os.clock()-state.lastControls<.4
   and state.controls or {forward=0,yaw=0,climb=0}
  local isHeli=state.kind=="Helicopter"
  local maxSpeed=isHeli and 82 or 154
  local acceleration=isHeli and 56 or 24
  local decel=isHeli and 65 or 20
  if isHeli then
   local target=controls.forward*maxSpeed
   state.speed=state.speed+math.clamp(target-state.speed,-decel*elapsed,acceleration*elapsed)
  else
   state.speed=math.clamp(state.speed+(
    controls.forward>0 and acceleration or
    controls.forward<0 and -decel or -4)*elapsed,0,maxSpeed)
  end
  if not active then
   state.speed=math.max(0,state.speed-38*elapsed)
  end
  state.heading=state.heading+controls.yaw*elapsed*(isHeli and 1.25 or .52)
  local cf=CFrame.Angles(0,state.heading,0)
  local delta=cf.LookVector*state.speed*elapsed
  local pos=state.pos
  local nextY=pos.Y
  if isHeli then
   nextY=math.clamp(pos.Y+controls.climb*27*elapsed,3,275)
  else
   local lift=state.speed>78 and 5 or state.speed<50 and -5 or 0
   nextY=math.clamp(pos.Y+(lift+controls.climb*24)*elapsed,state.ground,315)
  end
  local nextPos=Vector3.new(math.clamp(pos.X+delta.X,-1730,1730),
   nextY,math.clamp(pos.Z+delta.Z,-1740,900))
  -- Prevent forward movement directly through solid buildings and terrain.
  local travel=nextPos-pos
  local filter=RaycastParams.new()
  filter.FilterType=Enum.RaycastFilterType.Exclude
  local excludes={state.model}
  if occupant then table.insert(excludes,occupant.Parent) end
  filter.FilterDescendantsInstances=excludes
  filter.IgnoreWater=true
  if travel.Magnitude>.1 then
   local hit=workspace:Raycast(pos+Vector3.new(0,7,0),travel.Unit*(travel.Magnitude+12),filter)
   if hit and hit.Instance.CanCollide then
    state.speed=0
    nextPos=pos
   end
  end
  state.pos=nextPos
  local bank=isHeli and -controls.yaw*.075 or -controls.yaw*.14
  local nose=state.kind=="Plane" and -controls.climb*.04 or .03
  state.model:PivotTo(CFrame.new(nextPos)*CFrame.Angles(0,state.heading,0)*
   CFrame.Angles(nose,0,bank))
  state.model:SetAttribute("UAE60Speed",math.round(math.abs(state.speed)))
  state.model:SetAttribute("UAE60Altitude",math.round(nextPos.Y-state.ground))
  if isHeli then
   local rotor=state.model:FindFirstChild("Main spinning rotor")
   if rotor then
    state.elapsed=state.elapsed+elapsed*25
    rotor.CFrame=state.model:GetPivot()*CFrame.new(0,15,0)*
     CFrame.Angles(0,state.elapsed,0)
   end
  end
 end
end)
print("[UAE6] Pilotable aircraft: airliner and rescue helicopter with server-authoritative flight")
