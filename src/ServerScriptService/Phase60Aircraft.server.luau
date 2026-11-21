-- UAE City Life Phase 6: flyable arcade aircraft, server-authoritative controls.
-- This is arcade flight, not flight physics; both aircraft use original Part geometry.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local folder=Instance.new("Folder");folder.Name="PilotableAircraft";folder.Parent=root
local input=RS:WaitForChild("UAE60_FlightInput")
local notice=RS:WaitForChild("UAE60_Notice")
local function rgb(r,g,b)return Color3.fromRGB(r,g,b)end
local C={white=rgb(239,240,235),red=rgb(196,53,58),dark=rgb(35,44,56),
 glass=rgb(82,162,190),steel=rgb(142,153,164),blade=rgb(37,51,60)}
local function part(parent,class,name,size,cf,color,mat,solid)
 local p=Instance.new(class)
 p.Name=name;p.Size=size;p.CFrame=cf
 p.Color=color;p.Material=mat or Enum.Material.Metal
 p.Anchored=true;p.CanCollide=solid==true
 p.CanTouch=solid==true
 p.Parent=parent
 return p
end
local function build(kind,at)
 local model=Instance.new("Model")
 model.Name=kind=="Plane" and "UAE City Air Passenger Jet" or "Dubai Scenic Helicopter"
 model:SetAttribute("UAE60Aircraft",kind)
 model.Parent=folder
 local pivot=part(model,"Part","AirframePivot",Vector3.new(.3,.3,.3),
  at,C.white,nil,false)
 pivot.Transparency=1;model.PrimaryPart=pivot
 local function p(cl,name,size,x,y,z,c,mat)
  return part(model,cl,name,size,at*CFrame.new(x,y,z),c,mat,false)
 end
 local seat=Instance.new("Seat")
 seat.Name="UAE60PilotSeat";seat.Size=Vector3.new(2.5,1.1,2.7)
 seat.CFrame=at*CFrame.new(0,3,-2)
 seat.Anchored=true;seat.Transparency=1;seat.CanCollide=false
 seat.Parent=model
 local prompt=Instance.new("ProximityPrompt")
 prompt.ObjectText=model.Name
 prompt.ActionText="Pilot aircraft"
 prompt.HoldDuration=.5
 prompt.MaxActivationDistance=17
 prompt.RequiresLineOfSight=false
 prompt.Parent=seat
 if kind=="Plane" then
  local fus=p("Part","Rounded fuselage",Vector3.new(14,13,76),
   0,5,0,C.white,Enum.Material.Metal)
  -- Cylinder axis is local X; rotate 90 degrees about Y for lengthwise fuselage.
  fus.Shape=Enum.PartType.Cylinder
  fus.CFrame=fus.CFrame*CFrame.Angles(0,math.pi/2,0)
  for _,side in ipairs({-1,1}) do
   local wing=p("WedgePart","Swept passenger wing",Vector3.new(54,1.7,21),
    side*24,4,3,C.white,Enum.Material.Metal)
   wing.CFrame=wing.CFrame*CFrame.Angles(0,side*.22,0)
   local engine=p("Part","Jet engine",Vector3.new(5,5,14),
    side*19,1,-5,C.steel,Enum.Material.Metal)
   engine.Shape=Enum.PartType.Cylinder
   engine.CFrame=engine.CFrame*CFrame.Angles(0,math.pi/2,0)
   p("Part","Wing tip navigation light",Vector3.new(1,1,3),
    side*51,4,9,side==1 and C.red or C.glass,Enum.Material.Neon)
  end
  p("WedgePart","Tail fin",Vector3.new(3,21,15),0,17,28,C.red,Enum.Material.Metal)
  p("Part","Aircraft horizontal tail",Vector3.new(33,1.8,8),0,10,30,C.white,Enum.Material.Metal)
  p("Part","Cockpit dark glass",Vector3.new(10,3,5),0,8,-30,C.glass,Enum.Material.Glass)
  for _,side in ipairs({-1,1}) do
   for _,z in ipairs({-21,-15,-9,-3,3,9,15,21}) do
    p("Part","Round passenger window",Vector3.new(.2,1.1,2),side*6.88,7,z,
     C.glass,Enum.Material.Glass)
   end
  end
  p("Part","Red airline accent",Vector3.new(11,.8,48),0,10,1,C.red,Enum.Material.Metal)
  -- runway landing gear only decorative; no full wheel suspension.
  for _,x in ipairs({-7,7}) do
   local w=p("Part","Landing wheel",Vector3.new(1.4,4,4),x,-3,13,C.dark,Enum.Material.Rubber)
   w.Shape=Enum.PartType.Cylinder
  end
 else
  local main=p("Part","Rounded rotorcraft body",Vector3.new(11,8,23),
   0,5,0,C.white,Enum.Material.Metal)
  main.Shape=Enum.PartType.Ball
  p("Part","Panoramic dark windscreen",Vector3.new(10.2,5,.5),
   0,6,-8,C.glass,Enum.Material.Glass)
  p("Part","Tail boom",Vector3.new(3,3,26),0,6,20,C.white,Enum.Material.Metal)
  p("Part","Vertical tail stabilizer",Vector3.new(2,10,7),0,10,32,C.red,Enum.Material.Metal)
  p("Part","Landing skids left",Vector3.new(1.4,1.4,20),-6,0,2,C.dark,Enum.Material.Metal)
  p("Part","Landing skids right",Vector3.new(1.4,1.4,20),6,0,2,C.dark,Enum.Material.Metal)
  for _,x in ipairs({-6,6}) do
   for _,z in ipairs({-5,9}) do
    p("Part","Skid support strut",Vector3.new(.65,5,.65),x,2.5,z,C.steel,Enum.Material.Metal)
   end
  end
  p("Part","Main rotor mast",Vector3.new(1.1,4,1.1),0,11,0,C.dark,Enum.Material.Metal)
  local rotor=p("Part","Main rotor blur",Vector3.new(44,.4,3),0,13.2,0,C.dark,Enum.Material.Metal)
  rotor:SetAttribute("SpinRotor",true)
  local tail=p("Part","Tail rotor",Vector3.new(.3,8,1.2),0,9,34,C.dark,Enum.Material.Metal)
  tail:SetAttribute("SpinTail",true)
 end
 -- safe interaction; server checks nearby avatar before seating
 prompt.Triggered:Connect(function(player)
  local ch=player.Character
  local hum=ch and ch:FindFirstChildOfClass("Humanoid")
  local charRoot=ch and ch:FindFirstChild("HumanoidRootPart")
  if hum and charRoot and hum.Health>0 and (charRoot.Position-seat.Position).Magnitude<20 then
   if not seat.Occupant then seat:Sit(hum) end
  end
 end)
 return {model=model,seat=seat,kind=kind,
  pilot=nil,buttons={},lastPos=at.Position,lastInput=0,speed=0,bank=0}
end
local aircraft={
 build("Plane",CFrame.new(-1160,10,-1370)),
 build("Helicopter",CFrame.new(-1070,12,-790)),
}
local function findPilot(player)
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if not seat or seat.Name~="UAE60PilotSeat" then return nil end
 local model=seat:FindFirstAncestorOfClass("Model")
 for _,a in ipairs(aircraft) do
  if a.model==model and a.seat==seat and seat.Occupant==hum then return a end
 end
 return nil
end
local accepted={W=true,A=true,S=true,D=true,R=true,F=true}
input.OnServerEvent:Connect(function(player,key,pressed)
 if typeof(key)~="string" or not accepted[key] or typeof(pressed)~="boolean" then return end
 local a=findPilot(player)
 if not a then return end
 a.buttons[key]=pressed
 a.pilot=player
 a.lastInput=os.clock()
end)
local stepAccum=0
RunService.Heartbeat:Connect(function(dt)
 stepAccum=stepAccum+dt
 if stepAccum<.06 then return end
 local step=math.min(stepAccum,.12)
 stepAccum=0
 for _,a in ipairs(aircraft) do
  local seat=a.seat
  local seated=seat.Occupant
  local player=seated and Players:GetPlayerFromCharacter(seated.Parent)
  if not player or player~=a.pilot or os.clock()-a.lastInput>1.4 then
   a.buttons={}
   a.speed=math.max(0,a.speed-step*28)
  end
  if player and a.pilot~=player then
   a.pilot=player
   a.buttons={}
  end
  local b=a.buttons
  local cf=a.model:GetPivot()
  local topSpeed=a.kind=="Plane" and 125 or 66
  local floorSpeed=a.kind=="Plane" and 0 or 0
  local targetSpeed=b.W and topSpeed or (b.S and -27 or 0)
  a.speed=a.speed+(targetSpeed-a.speed)*math.clamp(step*1.7,0,1)
  local turn=(b.D and 1 or 0)-(b.A and 1 or 0)
  local rise=(b.R and 1 or 0)-(b.F and 1 or 0)
  local turnRate=a.kind=="Plane" and .52 or 1.1
  local movement=CFrame.Angles(0,turn*turnRate*step,0)*
   CFrame.new(0,rise*(a.kind=="Plane" and 36 or 31)*step,-a.speed*step)
  local goal=cf*movement
  local pos=goal.Position
  local minY=a.kind=="Plane" and 10 or 12
  local clamped=Vector3.new(math.clamp(pos.X,-1550,1550),
   math.clamp(pos.Y,minY,350),math.clamp(pos.Z,-1540,650))
  local rotational=goal-goal.Position
  a.model:PivotTo(CFrame.new(clamped)*rotational)
  if a.kind=="Helicopter" then
   for _,desc in ipairs(a.model:GetDescendants()) do
    if desc:IsA("BasePart") and desc:GetAttribute("SpinRotor")==true then
     desc.CFrame=a.model:GetPivot()*CFrame.new(0,13.2,0)*CFrame.Angles(0,os.clock()*18,0)
    elseif desc:IsA("BasePart") and desc:GetAttribute("SpinTail")==true then
     desc.CFrame=a.model:GetPivot()*CFrame.new(0,9,34)*CFrame.Angles(os.clock()*21,0,0)
    end
   end
  end
 end
end)
Players.PlayerRemoving:Connect(function(pl)
 for _,a in ipairs(aircraft) do
  if a.pilot==pl then a.pilot=nil;a.buttons={} end
 end
end)
print("[UAE60] Pilotable plane and helicopter built (arcade controls, no aerodynamics)")
