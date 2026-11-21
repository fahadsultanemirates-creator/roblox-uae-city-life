-- UAE CITY LIFE 6.0: interactive service buildings and chain-based roleplay.
-- Session economy only. All actions, distance checks and rewards run server-side.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local parent=world:WaitForChild("Phase60_ProductionPass")
local root=Instance.new("Folder")
root.Name="FunctionalCityBuildings"
root.Parent=parent
local feedback=RS:FindFirstChild("UAE60_Notification")
if not feedback then
 feedback=Instance.new("RemoteEvent")
 feedback.Name="UAE60_Notification"
 feedback.Parent=RS
end
local C={
 white=Color3.fromRGB(239,238,227),ivory=Color3.fromRGB(221,211,190),
 marble=Color3.fromRGB(205,207,197),blue=Color3.fromRGB(67,143,165),
 navy=Color3.fromRGB(31,67,83),gold=Color3.fromRGB(216,179,108),
 wood=Color3.fromRGB(143,108,80),metal=Color3.fromRGB(141,151,157),
 glass=Color3.fromRGB(79,161,180),red=Color3.fromRGB(196,67,65),
 green=Color3.fromRGB(70,150,111),sand=Color3.fromRGB(203,178,139),
}
local function part(parent,name,size,cf,col,mat,solid)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true
 p.Color=col or C.white;p.Material=mat or Enum.Material.SmoothPlastic
 p.CanCollide=solid==true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function makeText(parent,caption,w,h,cf,color)
 local p=part(parent,caption,Vector3.new(w,h,.5),cf,color or C.navy,Enum.Material.Metal,false)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=35;gui.Parent=p
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1
 t.TextColor3=C.white;t.Font=Enum.Font.GothamBold;t.TextScaled=true
 t.TextWrapped=true;t.Text=caption;t.Parent=gui
 return p
end
local function notify(player,text)
 if player.Parent==Players then feedback:FireClient(player,text) end
end
local function points(player,amount)
 local leader=player:FindFirstChild("leaderstats")
 if not leader then leader=Instance.new("Folder");leader.Name="leaderstats";leader.Parent=player end
 local v=leader:FindFirstChild("CityPoints")
 if not v then v=Instance.new("IntValue");v.Name="CityPoints";v.Parent=leader end
 v.Value=v.Value+amount
end
local lastUse={}
local function register(parent,label,actionText,cf,onActivate)
 local terminal=part(parent,label,Vector3.new(6,4,3),cf,C.blue,Enum.Material.Metal,true)
 local p=Instance.new("ProximityPrompt")
 p.Name="Interact"
 p.ActionText=actionText;p.ObjectText=label
 p.HoldDuration=.45;p.MaxActivationDistance=12
 p.RequiresLineOfSight=false;p.Parent=terminal
 p.Triggered:Connect(function(player)
  local ch=player.Character
  local hum=ch and ch:FindFirstChildOfClass("Humanoid")
  local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
  if not hrp or not hum or hum.Health<=0 then return end
  if (hrp.Position-terminal.Position).Magnitude>17 then return end
  local key=player.UserId..":"..label
  if lastUse[key] and os.clock()-lastUse[key]<1.5 then return end
  lastUse[key]=os.clock()
  onActivate(player,hrp,hum)
 end)
 return terminal
end
local function interior(name,x,z,w,d,col,title)
 local m=Instance.new("Model")
 m.Name=name
 m.Parent=root
 part(m,"Accessible interior floor",Vector3.new(w,1,d),CFrame.new(x,.5,z),
  C.marble,Enum.Material.Marble,true)
 for _,side in ipairs({-1,1}) do
  part(m,"Insulated side wall",Vector3.new(1,22,d),
   CFrame.new(x+side*w/2,11,z),C.white,Enum.Material.Concrete,true)
 end
 part(m,"Rear structural wall",Vector3.new(w,22,1),
  CFrame.new(x,11,z+d/2),C.ivory,Enum.Material.Concrete,true)
 part(m,"High lobby roof",Vector3.new(w,1.6,d),
  CFrame.new(x,22.5,z),C.white,Enum.Material.Concrete,true)
 part(m,"Entrance left glazing",Vector3.new(w*.32,16,.7),
  CFrame.new(x-w*.34,10,z-d/2),C.glass,Enum.Material.Glass,false)
 part(m,"Entrance right glazing",Vector3.new(w*.32,16,.7),
  CFrame.new(x+w*.34,10,z-d/2),C.glass,Enum.Material.Glass,false)
 makeText(m,title,w*.85,6,CFrame.new(x,18,z-d/2-.55),col)
 part(m,"Reception marble counter",Vector3.new(25,4.2,6),
  CFrame.new(x,3,z+10),col,Enum.Material.Marble,true)
 for i=-1,1 do
  part(m,"Waiting seating",Vector3.new(12,2.2,4),
   CFrame.new(x+i*18,2.2,z-10),C.wood,Enum.Material.Wood,true)
 end
 for _,dx in ipairs({-w*.36,w*.36}) do
  part(m,"Lit vertical glass pillar",Vector3.new(.7,17,.7),
   CFrame.new(x+dx,10,z-d/2+3),C.blue,Enum.Material.Neon,false)
 end
 for _,dx in ipairs({-w*.27,0,w*.27}) do
  local led=part(m,"Warm ceiling lamp",Vector3.new(8,.3,5),
   CFrame.new(x+dx,21.4,z),C.gold,Enum.Material.Neon,false)
  local light=Instance.new("PointLight")
  light.Brightness=.6;light.Range=22;light.Parent=led
 end
 return m
end
local states={}
local function state(player)
 local s=states[player]
 if not s then s={hotel=0,hospital=0,airport=0,police=0,fire=0};states[player]=s end
 return s
end
-- HOTEL: actual check-in state, furnished accessible suite and checkout.
local hotel=interior("Al Wasl Hotel Lobby",-550,-922,80,66,C.gold,
 "DUBAI HOTEL | فندق دبي")
register(hotel,"Hotel Front Desk","Check in",CFrame.new(-550,4,-910),function(player)
 local s=state(player)
 if s.hotel==0 then
  s.hotel=1
  notify(player,"HOTEL: Welcome! Room 101 assigned. Use the guest lift.")
 else
  notify(player,"HOTEL: You already have Room 101.")
 end
end)
register(hotel,"Hotel Guest Lift","Go to Room 101",CFrame.new(-580,4,-923),function(player)
 if state(player).hotel==0 then notify(player,"Check in first at reception.") return end
 local ch=player.Character
 if ch then ch:PivotTo(CFrame.new(-550,5,-835)) end
 notify(player,"HOTEL: Room 101 • your key card works.")
end)
local room=interior("Guest Suite 101",-550,-831,56,53,C.wood,
 "ROOM 101 | GUEST SUITE")
part(room,"King hotel bed frame",Vector3.new(16,2.8,14),
 CFrame.new(-550,2.4,-816),C.wood,Enum.Material.Wood,true)
part(room,"White hotel duvet",Vector3.new(15,1,12),
 CFrame.new(-550,4.1,-816),C.white,Enum.Material.Fabric,true)
part(room,"Bedside nightstand",Vector3.new(4,4,4),
 CFrame.new(-564,3,-816),C.wood,Enum.Material.Wood,true)
part(room,"Suite window",Vector3.new(18,8,.7),
 CFrame.new(-550,12,-804),C.glass,Enum.Material.Glass,false)
register(room,"Room checkout desk","Check out",CFrame.new(-533,4,-835),function(player)
 local s=state(player)
 if s.hotel==0 then notify(player,"You need a hotel booking first.") return end
 s.hotel=0
 points(player,15)
 local ch=player.Character
 if ch then ch:PivotTo(CFrame.new(-550,5,-946)) end
 notify(player,"HOTEL: Checked out. +15 CityPoints.")
end)
-- HOSPITAL: a sequence, not merely a decorative Medical Centre.
local hospital=interior("Dubai Hospital Reception",-235,-1095,84,75,C.blue,
 "DUBAI HOSPITAL | مستشفى دبي")
register(hospital,"Medical Registration","Register patient",CFrame.new(-235,4,-1085),function(player)
 state(player).hospital=1
 notify(player,"HOSPITAL: Registration complete. Visit the examination room.")
end)
register(hospital,"Triage Clinic","Consult doctor",CFrame.new(-261,4,-1098),function(player,rootPart,hum)
 if state(player).hospital~=1 then notify(player,"Register at reception first.") return end
 state(player).hospital=2
 hum.Health=math.min(hum.MaxHealth,hum.Health+35)
 notify(player,"HOSPITAL: Consultation complete. Collect your medicine.")
end)
register(hospital,"Hospital Pharmacy","Collect medicine",CFrame.new(-206,4,-1098),function(player,rootPart,hum)
 if state(player).hospital~=2 then notify(player,"Complete your medical consultation first.") return end
 state(player).hospital=0
 hum.Health=hum.MaxHealth
 points(player,35)
 notify(player,"HOSPITAL: Treatment completed. +35 CityPoints.")
end)
local ward=Instance.new("Folder");ward.Name="TreatmentWard";ward.Parent=hospital
for _,x in ipairs({-255,-218}) do
 local bed=part(ward,"Adjustable hospital bed",Vector3.new(12,2,19),
  CFrame.new(x,2.6,-1075),C.white,Enum.Material.Metal,true)
 part(ward,"Medical privacy screen",Vector3.new(1,10,18),
  CFrame.new(x+9,6,-1075),C.blue,Enum.Material.Glass,false)
 part(ward,"Medical monitor",Vector3.new(5,4,2),
  CFrame.new(x+4,7,-1067),C.navy,Enum.Material.Metal,false)
end
-- AIRPORT: ticket, bag check, security, boarding; gate unlocks flight state.
local airport=interior("Dubai International Terminal",-1020,-969,107,86,C.navy,
 "DXB INTERNATIONAL | مطار دبي")
register(airport,"Flight Ticket Counter","Book flight",CFrame.new(-1054,4,-964),function(player)
 state(player).airport=1
 notify(player,"DXB: Ticket booked. Take your bag to check-in.")
end)
register(airport,"Emirates Baggage Drop","Check in luggage",CFrame.new(-1033,4,-963),function(player)
 local s=state(player)
 if s.airport~=1 then notify(player,"Book a flight ticket first.") return end
 s.airport=2
 notify(player,"DXB: Baggage checked. Continue through security.")
end)
register(airport,"Airport Security Gate","Pass security",CFrame.new(-1006,4,-963),function(player)
 local s=state(player)
 if s.airport~=2 then notify(player,"Check in your baggage first.") return end
 s.airport=3
 notify(player,"DXB: Security passed. Proceed to boarding.")
end)
register(airport,"Gate A1 Boarding","Board aircraft",CFrame.new(-985,4,-963),function(player)
 local s=state(player)
 if s.airport~=3 then notify(player,"Finish ticket, baggage and security first.") return end
 s.airport=0
 player:SetAttribute("UAE60FlightTicket",true)
 points(player,50)
 notify(player,"DXB: Boarding approved. +50 CityPoints. Pilot the aircraft from the airfield!")
end)
for i=1,6 do
 part(airport,"Airport check-in queue rail",Vector3.new(1.3,3.5,11),
  CFrame.new(-1065+i*10,2.7,-983),C.metal,Enum.Material.Metal,false)
end
-- Police/Civil Defence are accessible office wings beside the earlier stations.
local police=interior("Dubai Police Operations",-1135,-480,74,65,C.navy,
 "DUBAI POLICE | شرطة دبي")
register(police,"Police Duty Roster","Start patrol",CFrame.new(-1135,4,-469),function(player)
 state(player).police=1
 notify(player,"POLICE: Patrol shift started. Inspect the incident desk.")
end)
register(police,"Police Incident Desk","File incident report",CFrame.new(-1113,4,-486),function(player)
 if state(player).police~=1 then notify(player,"Start a police shift first.") return end
 state(player).police=2
 notify(player,"POLICE: Report filed. Return to reception to finish duty.")
end)
register(police,"Police Return Desk","End patrol",CFrame.new(-1157,4,-487),function(player)
 if state(player).police~=2 then notify(player,"File an incident report first.") return end
 state(player).police=0
 points(player,45)
 notify(player,"POLICE: Community duty completed. +45 CityPoints.")
end)
local fire=interior("Civil Defence Training Bay",-1135,-630,80,74,C.red,
 "CIVIL DEFENCE | الدفاع المدني")
register(fire,"Fire Safety Briefing","Attend briefing",CFrame.new(-1135,4,-620),function(player)
 state(player).fire=1
 notify(player,"CIVIL DEFENCE: Briefing complete. Check equipment.")
end)
register(fire,"Fire Hose Equipment","Inspect safety tools",CFrame.new(-1161,4,-630),function(player)
 if state(player).fire~=1 then notify(player,"Attend the safety briefing first.") return end
 state(player).fire=2
 notify(player,"CIVIL DEFENCE: Equipment checked. Report to dispatch.")
end)
register(fire,"Civil Defence Dispatch","Finish safety shift",CFrame.new(-1110,4,-630),function(player)
 if state(player).fire~=2 then notify(player,"Inspect the equipment first.") return end
 state(player).fire=0
 points(player,45)
 notify(player,"CIVIL DEFENCE: Safety shift finished. +45 CityPoints.")
end)
Players.PlayerRemoving:Connect(function(player)
 states[player]=nil
end)
print("[UAE6] Service buildings: hotel, suite, medical care, DXB airport, police, Civil Defence")
