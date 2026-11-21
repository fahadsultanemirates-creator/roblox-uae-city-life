-- UAE CITY LIFE VERSION 6.0 | ONE LARGE BUILD | VISUALS + WORKING CITY
-- For Roblox Studio Command Bar in EDIT MODE only; STOP Play first.
-- Requires saved v5.4 or later city with Phase54_CityExpansion.
-- Save File -> Save to File As: VERSION 5.5 BACKUP BEFORE RUNNING.
-- ORIGINAL self-contained PROCEDURAL geometry; cannot equal high-poly mesh assets.
local W=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer")
local clients=SP:WaitForChild("StarterPlayerScripts")
local world=W:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase54_CityExpansion"),
 "Open the SAVED UAE City Life v5.4/v5.5 game in EDIT mode before installing v6.")
-- For Dell laptop start with low mode: only 8 walking R15 citizens (instead of 16).
-- Change true -> false here after you test performance on your machine.
local LOW_PERFORMANCE_MODE=true
local old=world:FindFirstChild("Phase60_ProductionPass")
if old then old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase60_ProductionPass"
root:SetAttribute("LowPerformance",LOW_PERFORMANCE_MODE)
root.Parent=world
-- Old v5.5 service/character/crash scripts produce duplicate world geometry and
-- unreliable collisions. Replace their behaviors with the v6 systems.
for _,name in ipairs({
 "UAE55_Activities","UAE55_Citizens","UAE55_VehicleIncidents"
}) do
 local previous=SS:FindFirstChild(name)
 if previous then previous:Destroy() end
end
for _,name in ipairs({"UAE55_Notifications"}) do
 local previous=clients:FindFirstChild(name)
 if previous then previous:Destroy() end
end
local function replace(class,parent,name,source)
 local previous=parent:FindFirstChild(name)
 if previous then previous:Destroy() end
 local obj=Instance.new(class)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
 return obj
end
replace("ModuleScript",RS,"UAE_V54_Locations",[==========[
-- UAE City Life v6.0: extended 40-destination catalogue of IN-GAME destinations.
-- Coordinates refer to this fictional Roblox layout, NOT real-world GPS.
local destinations={
 {id="BURJ",name="Burj Khalifa",category="Landmarks",position=Vector3.new(-84,6,-392),description="Downtown skyline tower"},
 {id="MALL",name="Dubai Mall",category="Shopping",position=Vector3.new(100,6,-399),description="Downtown retail and attractions"},
 {id="MUSEUM",name="Museum of the Future",category="Landmarks",position=Vector3.new(315,6,-1180),description="Iconic museum-inspired landmark"},
 {id="FRAME",name="Dubai Frame",category="Landmarks",position=Vector3.new(-770,5,-830),description="Gold architectural frame"},
 {id="ARAB",name="Burj Al Arab",category="Landmarks",position=Vector3.new(1125,6,-940),description="Sail-shaped coastal hotel"},
 {id="E11",name="Sheikh Zayed Road",category="Transport",position=Vector3.new(0,5,-1200),description="Main expressway corridor"},
 {id="DXB",name="Dubai International Airport",category="Transport",position=Vector3.new(-1070,5,-1260),description="Airport terminal and apron"},
 {id="METRO",name="Dubai Metro Station",category="Transport",position=Vector3.new(194,25,-1215),description="Elevated metro station"},
 {id="MARINA",name="Dubai Marina",category="Leisure",position=Vector3.new(1060,5,-1285),description="Harbour, yachts and promenade"},
 {id="CRUISE",name="Cruise Port",category="Transport",position=Vector3.new(1110,5,-1450),description="Cruise terminal waterfront"},
 {id="MED",name="Dubai Medical Centre",category="Services",position=Vector3.new(-235,5,-1175),description="Hospital and medical centre on E11"},
 {id="POLICE",name="Dubai Police Station",category="Services",position=Vector3.new(-960,5,-480),description="Community police office"},
 {id="FIRE",name="Civil Defence Station",category="Services",position=Vector3.new(-930,5,-630),description="Civil defence service station"},
 {id="SHOP",name="Dubai City Mall",category="Shopping",position=Vector3.new(620,5,-996),description="West-end retail plaza"},
 {id="SOUK",name="Souk & Cafe",category="Shopping",position=Vector3.new(430,5,-996),description="Souk shops and cafes"},
 {id="HOTEL",name="E11 Grand Hotel",category="Services",position=Vector3.new(-550,5,-980),description="Sheikh Zayed Road hotel"},
 {id="DESK",name="Emirates Tour Desk",category="Services",position=Vector3.new(-400,5,-965),description="Tourism and city information"},
 {id="HOMES",name="Dubai Villas",category="Living",position=Vector3.new(0,5,-790),description="Claimable homes and gardens"},
 {id="PARK",name="Al Wasl Community Park",category="Leisure",position=Vector3.new(0,5,-850),description="Fountain, trees and family activities"},
 {id="CLINIC",name="Dubai Clinic",category="Services",position=Vector3.new(-370,5,-665),description="Neighbourhood clinic and help"},
 {id="KARAK",name="Karak Cafe",category="Shopping",position=Vector3.new(-225,5,-665),description="Local cafe and refreshments"},
 {id="MARKET",name="City Market",category="Shopping",position=Vector3.new(-80,5,-665),description="Everyday grocery shop"},
 {id="WASL",name="Hotel Al Wasl",category="Services",position=Vector3.new(80,5,-665),description="City hotel and lobby"},
 {id="BANK",name="Dubai Bank",category="Services",position=Vector3.new(225,5,-665),description="Bank reception"},
 {id="FASHION",name="Fashion Souq",category="Shopping",position=Vector3.new(370,5,-665),description="Clothing shops"},
 {id="SHJ",name="Sharjah Heritage",category="Landmarks",position=Vector3.new(390,5,-380),description="Emirate heritage district"},
 {id="AJMAN",name="Ajman Beach",category="Leisure",position=Vector3.new(390,5,210),description="Beach destination"},
 {id="BEACH",name="Jumeirah Beach Walk",category="Leisure",position=Vector3.new(1050,5,-720),description="Beach promenade"},
 {id="ARRIVE",name="Airport Arrivals Plaza",category="Transport",position=Vector3.new(-970,5,-1120),description="Terminal pickup and taxi zone"},
 {id="GARDEN",name="Dubai Community Gardens",category="Leisure",position=Vector3.new(-940,5,-890),description="Green public space"},
 {id="TAXI",name="Residential Taxi Stand",category="Transport",position=Vector3.new(0,5,-746),description="Personal vehicle garage area"},
 {id="HELIPAD",name="Helicopter Viewing Deck",category="Leisure",position=Vector3.new(-1010,5,-780),description="Helicopter sightseeing viewpoint"},

 {id="HOTEL6",name="Dubai Hotel Check-in Lobby",category="Services",position=Vector3.new(-550,5,-890),description="Working hotel reception, guest room booking and checkout"},
 {id="HOSP6",name="Dubai Hospital Patient Entrance",category="Services",position=Vector3.new(-235,5,-1095),description="Interactive hospital registration examination and pharmacy"},
 {id="DXB6",name="DXB Airport Check-in Terminal",category="Transport",position=Vector3.new(-1020,5,-925),description="Working airport ticket baggage security and boarding"},
 {id="POLICE6",name="Dubai Police Operations Office",category="Services",position=Vector3.new(-1135,5,-480),description="Interactive police duty and incident reporting"},
 {id="FIRE6",name="Civil Defence Training Centre",category="Services",position=Vector3.new(-1135,5,-630),description="Safety briefing equipment check and dispatch"},
 {id="REPAIR6",name="City Vehicle Repair Workshop",category="Services",position=Vector3.new(-340,5,-1010),description="Repair car collision damage"},
 {id="FLIGHT6",name="Pilotable Passenger Jet",category="Transport",position=Vector3.new(-1280,5,-1060),description="Airliner flight training plane W S A D R F"},
 {id="HELI6",name="Pilotable Rescue Helicopter",category="Transport",position=Vector3.new(-1050,5,-790),description="Helicopter flight experience W S A D R F"},
}
local byId={}
local categories={"All","Landmarks","Transport","Services","Shopping","Living","Leisure"}
for _,place in ipairs(destinations) do byId[place.id]=place end
return {
 List=destinations,
 ById=byId,
 Categories=categories,
 -- Drawing extents in game-world studs, not geographical longitude/latitude
 Bounds={xmin=-1600,xmax=1650,zmin=-1530,zmax=750},
}

]==========])
replace("Script",SS,"UAE60_CityServices",[==========[
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
local hotel=interior("Al Wasl Hotel Lobby",-550,-890,80,66,C.gold,
 "DUBAI HOTEL | فندق دبي")
register(hotel,"Hotel Front Desk","Check in",CFrame.new(-550,4,-878),function(player)
 local s=state(player)
 if s.hotel==0 then
  s.hotel=1
  notify(player,"HOTEL: Welcome! Room 101 assigned. Use the guest lift.")
 else
  notify(player,"HOTEL: You already have Room 101.")
 end
end)
register(hotel,"Hotel Guest Lift","Go to Room 101",CFrame.new(-580,4,-891),function(player)
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
 if ch then ch:PivotTo(CFrame.new(-550,5,-916)) end
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
local airport=interior("Dubai International Terminal",-1020,-925,107,86,C.navy,
 "DXB INTERNATIONAL | مطار دبي")
register(airport,"Flight Ticket Counter","Book flight",CFrame.new(-1054,4,-920),function(player)
 state(player).airport=1
 notify(player,"DXB: Ticket booked. Take your bag to check-in.")
end)
register(airport,"Emirates Baggage Drop","Check in luggage",CFrame.new(-1033,4,-919),function(player)
 local s=state(player)
 if s.airport~=1 then notify(player,"Book a flight ticket first.") return end
 s.airport=2
 notify(player,"DXB: Baggage checked. Continue through security.")
end)
register(airport,"Airport Security Gate","Pass security",CFrame.new(-1006,4,-919),function(player)
 local s=state(player)
 if s.airport~=2 then notify(player,"Check in your baggage first.") return end
 s.airport=3
 notify(player,"DXB: Security passed. Proceed to boarding.")
end)
register(airport,"Gate A1 Boarding","Board aircraft",CFrame.new(-985,4,-919),function(player)
 local s=state(player)
 if s.airport~=3 then notify(player,"Finish ticket, baggage and security first.") return end
 s.airport=0
 player:SetAttribute("UAE60FlightTicket",true)
 points(player,50)
 notify(player,"DXB: Boarding approved. +50 CityPoints. Pilot the aircraft from the airfield!")
end)
for i=1,6 do
 part(airport,"Airport check-in queue rail",Vector3.new(1.3,3.5,11),
  CFrame.new(-1065+i*10,2.7,-939),C.metal,Enum.Material.Metal,false)
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

]==========])
replace("Script",SS,"UAE60_VehicleArt",[==========[
-- UAE CITY LIFE 6.0: visual fleet overhaul on existing V4/V5 anchored driving rigs.
-- Cars retain the old scripted driver system. These are higher-detail procedural
-- models, NOT fully sprung mesh chassis. Old "tyre legs" are hidden, wheel
-- cylinders re-positioned at physically sensible local x/z spots.
local world=workspace:WaitForChild("UAE_City_Life")
local cars=world:WaitForChild("EmergencyVehicles")
local expansion=world:WaitForChild("Phase60_ProductionPass")
local fleet=Instance.new("Folder")
fleet.Name="VehicleArtAndGarages"
fleet.Parent=expansion
local Colors={
 white=Color3.fromRGB(240,242,239),black=Color3.fromRGB(24,28,33),
 dark=Color3.fromRGB(32,58,68),blue=Color3.fromRGB(38,93,151),
 green=Color3.fromRGB(19,91,73),red=Color3.fromRGB(196,42,45),
 gold=Color3.fromRGB(235,178,79),silver=Color3.fromRGB(169,179,183),
 glass=Color3.fromRGB(73,136,169),light=Color3.fromRGB(255,239,193),
 tyre=Color3.fromRGB(20,23,27),metal=Color3.fromRGB(115,122,127),
}
local processed=setmetatable({},{__mode="k"})
local function part(parent,name,sz,cf,col,mat)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Anchored=true
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.Color=col;p.Material=mat or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function wedge(parent,name,sz,cf,col)
 local p=Instance.new("WedgePart")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Anchored=true
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.Color=col;p.Material=Enum.Material.Metal;p.Parent=parent;return p
end
local function label(parent,text,sz,cf,bg)
 local p=part(parent,"Service bilingual lettering",sz,cf,bg,Enum.Material.Metal)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=55
 gui.Parent=p
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1
 t.TextColor3=Colors.white;t.Font=Enum.Font.GothamBold
 t.TextScaled=true;t.TextWrapped=true;t.Text=text;t.Parent=gui
 return p
end
local function inferClass(model)
 local title=string.lower(model.Name)
 local kind=tostring(model:GetAttribute("VehicleType") or "")
 local all=title.." "..string.lower(kind)
 if all:find("ambul",1,true) or all:find("medical",1,true) then return "Ambulance" end
 if all:find("fire",1,true) or all:find("defence",1,true) or
  all:find("rescue",1,true) then return "Fire" end
 if all:find("police",1,true) or all:find("patrol",1,true) then return "Police" end
 if all:find("bus",1,true) then return "Bus" end
 if all:find("taxi",1,true) then return "Taxi" end
 if all:find("suv",1,true) or all:find("family",1,true) then return "SUV" end
 if all:find("car",1,true) or all:find("sedan",1,true) then return "Sedan" end
 return nil
end
local function classifyDimensions(model,class)
 local bmin,bmax=Vector3.new(100,100,100),Vector3.new(-100,-100,-100)
 local pivot=model:GetPivot()
 local pieces=0
 -- Only large body panels and seats, not billboards, wheels or light bars.
 for _,obj in ipairs(model:GetDescendants()) do
  if obj:IsA("BasePart") and not string.find(string.lower(obj.Name),"wheel") and
   not string.find(string.lower(obj.Name),"tyre") and
   not string.find(string.lower(obj.Name),"rim") and
   obj.Size.X>=2 and obj.Size.Z>=3 and
   obj.Size.Y>=.8 and obj.Size.Y<=18 then
   local rel=pivot:PointToObjectSpace(obj.Position)
   bmin=Vector3.new(math.min(bmin.X,rel.X-obj.Size.X*.5),
    math.min(bmin.Y,rel.Y-obj.Size.Y*.5),math.min(bmin.Z,rel.Z-obj.Size.Z*.5))
   bmax=Vector3.new(math.max(bmax.X,rel.X+obj.Size.X*.5),
    math.max(bmax.Y,rel.Y+obj.Size.Y*.5),math.max(bmax.Z,rel.Z+obj.Size.Z*.5))
   pieces=pieces+1
  end
 end
 local length=class=="Fire" and 34 or class=="Ambulance" and 25 or
  class=="Bus" and 37 or class=="SUV" and 23 or 19
 local width=class=="Fire" and 12.5 or class=="Ambulance" and 11.5 or
  class=="Bus" and 12 or 9.7
 if pieces>=2 then
  -- Ignore massive stray bounds from parked scenery and long ropes.
  local detectedX=math.abs(bmax.X-bmin.X)
  local detectedZ=math.abs(bmax.Z-bmin.Z)
  if detectedX>=6 and detectedX<=20 then width=detectedX end
  if detectedZ>=13 and detectedZ<=49 then length=detectedZ end
 end
 return math.clamp(width,8,14),math.clamp(length,17,44)
end
local function style(model,class)
 if processed[model] then return end
 processed[model]=true
 if not model:IsA("Model") or model:GetAttribute("UAE60NoArt") then return end
 local pivot=model:GetPivot()
 local width,length=classifyDimensions(model,class)
 -- Old wheels are often flat Cuboid parts standing like legs; hide, not destroy.
 for _,item in ipairs(model:GetDescendants()) do
  if item:IsA("BasePart") and (
   string.find(string.lower(item.Name),"tyre") or
   string.find(string.lower(item.Name),"tire") or
   string.find(string.lower(item.Name),"wheel") or
   string.find(string.lower(item.Name),"rim") ) then
   item.Transparency=1
   item.CanCollide=false
  end
 end
 local art=Instance.new("Model")
 art.Name="UAE60_RefinedBody"
 art.Parent=model
 local cf=function(x,y,z) return pivot*CFrame.new(x,y,z) end
 local carBody=class=="Police" and Colors.white or
  class=="Ambulance" and Colors.white or
  class=="Fire" and Colors.gold or
  class=="Taxi" and Color3.fromRGB(235,224,195) or
  class=="SUV" and Color3.fromRGB(200,210,214) or
  class=="Bus" and Color3.fromRGB(242,235,218) or Color3.fromRGB(65,132,156)
 -- Thin shaped body overlays, not a giant visible box that hides wheels.
 part(art,"Lower body sill",Vector3.new(width-.4,1.1,length-.4),
  cf(0,3.2,0),Colors.black,Enum.Material.Metal)
 part(art,"Refined painted flank",Vector3.new(width-.3,1.8,length-.9),
  cf(0,4.35,0),carBody,Enum.Material.Metal)
 local short=class=="Sedan" or class=="Taxi" or class=="Police" or class=="SUV"
 if short then
  part(art,"Upper cabin front",Vector3.new(width-1.8,2.8,length*.46),
   cf(0,7.0,1.4),Colors.glass,Enum.Material.Glass)
  part(art,"Body color roof",Vector3.new(width-1.4,.65,length*.46),
   cf(0,8.7,1.4),carBody,Enum.Material.Metal)
  wedge(art,"Sloped front bonnet",Vector3.new(width-.8,2.0,length*.24),
   cf(0,6,-length*.38)*CFrame.Angles(0,math.pi,0),carBody)
  wedge(art,"Tapered rear deck",Vector3.new(width-.8,2.1,length*.18),
   cf(0,6,length*.41),carBody)
 else
  part(art,"Cabin silhouette",Vector3.new(width-.9,4.5,length*.26),
   cf(0,7.6,-length*.28),Colors.glass,Enum.Material.Glass)
  part(art,"Rear fitted cargo compartment",Vector3.new(width-.6,5.2,length*.53),
   cf(0,7.0,length*.20),carBody,Enum.Material.Metal)
  wedge(art,"Front aerodynamic nose",Vector3.new(width-.9,3.0,length*.17),
   cf(0,6,-length*.43)*CFrame.Angles(0,math.pi,0),carBody)
 end
 for _,dir in ipairs({-1,1}) do
  local posX=dir*(width*.48)
  for _,z in ipairs({-length*.31,length*.31}) do
   -- Cylinder's axle is local X. Diameter is Y/Z. Wheel visual sits on ground.
   local tire=part(art,"Correct vertical rubber wheel",
    Vector3.new(1.8,4.7,4.7),cf(posX,2.7,z),Colors.tyre,Enum.Material.Rubber)
   tire.Shape=Enum.PartType.Cylinder
   local hub=part(art,"Five-spoke wheel center",
    Vector3.new(.26,2.7,2.7),cf(posX+dir*1,2.7,z),Colors.silver,Enum.Material.Metal)
   hub.Shape=Enum.PartType.Cylinder
   for spoke=1,5 do
    local angle=spoke*math.pi*2/5
    part(art,"Rim spoke",Vector3.new(.29,.38,1.15),
     cf(posX+dir*1.18,2.7+math.sin(angle)*.78,z+math.cos(angle)*.78)*
      CFrame.Angles(angle,0,0),Colors.metal,Enum.Material.Metal)
   end
  end
  part(art,"Wing mirror",Vector3.new(1.1,.65,1.25),
   cf(dir*(width*.56),7.0,-length*.24),Colors.black,Enum.Material.Metal)
  part(art,"Front LED lamp",Vector3.new(width*.20,.6,.3),
   cf(dir*width*.25,4.8,-length*.5-.08),Colors.light,Enum.Material.Neon)
  part(art,"Rear red brake lamp",Vector3.new(width*.22,.5,.3),
   cf(dir*width*.26,4.8,length*.5+.08),Colors.red,Enum.Material.Neon)
 end
 if class=="Ambulance" then
  part(art,"Paramedic blue belt",Vector3.new(width+.18,1.7,length*.65),
   cf(0,6.15,length*.15),Colors.blue,Enum.Material.Metal)
  label(art,"AMBULANCE  |  إسعاف",Vector3.new(width*.72,1.6,.3),
   cf(0,6.3,length*.47+.2),Colors.blue)
 elseif class=="Police" then
  part(art,"Green police door stripe",Vector3.new(width+.3,1.2,length*.52),
   cf(0,5.3,0),Colors.green,Enum.Material.Metal)
  label(art,"POLICE  |  الشرطة",Vector3.new(width*.85,1.8,.3),
   cf(0,5.4,length*.33),Colors.green)
 elseif class=="Fire" then
  part(art,"Civil defence red band",Vector3.new(width+.2,1.4,length*.72),
   cf(0,5.5,0),Colors.red,Enum.Material.Metal)
  label(art,"CIVIL DEFENCE  |  الدفاع المدني",Vector3.new(width*.85,2,.3),
   cf(0,6.4,length*.41),Colors.red)
 elseif class=="Taxi" then
  part(art,"Taxi roof sign",Vector3.new(4,1.3,2),
   cf(0,9.45,0),Colors.gold,Enum.Material.SmoothPlastic)
 end
 if class=="Police" or class=="Ambulance" or class=="Fire" then
  part(art,"Roof emergency red bar",Vector3.new(width*.36,.55,1.7),
   cf(-width*.2,10.2,-1),Colors.red,Enum.Material.Neon)
  part(art,"Roof emergency blue bar",Vector3.new(width*.36,.55,1.7),
   cf(width*.2,10.2,-1),Colors.blue,Enum.Material.Neon)
 end
 model:SetAttribute("UAE60Visuals","Body+Wheels")
 model:SetAttribute("UAE60Class",class)
end
local function process(model)
 if not model or not model:IsA("Model") or processed[model] then return end
 local class=inferClass(model)
 if class then style(model,class) end
end
for _,model in ipairs(cars:GetChildren()) do process(model) end
local v4=world:FindFirstChild("Phase4_MegaCity")
if v4 then
 for _,m in ipairs(v4:GetDescendants()) do
  if m:IsA("Model") and m:FindFirstChildWhichIsA("VehicleSeat",true) then
   process(m)
  end
 end
end
cars.ChildAdded:Connect(function(model)
 task.defer(function()
  if model.Parent then process(model) end
 end)
end)
print("[UAE6] Fleet art: corrected wheel cylinders and vehicle class silhouettes")

]==========])
replace("Script",SS,"UAE60_VehicleIncidents",[==========[
-- UAE CITY LIFE 6.0: visual crash incidents + repair for legacy moving anchored cars.
-- IMPORTANT: v4/v5 cars are manually CFrame moved, so Roblox Touched/velocity
-- cannot reliably detect collisions. Detect ray obstruction along the traveled path.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local phase=world:WaitForChild("Phase60_ProductionPass")
local cars=world:WaitForChild("EmergencyVehicles")
local notice=RS:WaitForChild("UAE60_Notification",30)
local known=setmetatable({},{__mode="k"})
local lastHit=setmetatable({},{__mode="k"})
local originalColors=setmetatable({},{__mode="k"})
local function pilot(car)
 local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
 if seat and seat.Occupant then
  return Players:GetPlayerFromCharacter(seat.Occupant.Parent)
 end
 return nil
end
local function register(car)
 if not car:IsA("Model") or known[car] then return end
 local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
 if not seat then return end
 known[car]={last=car:GetPivot().Position}
 car:SetAttribute("UAE60Damage",0)
 car:SetAttribute("UAE60NeedsRepair",false)
end
for _,car in ipairs(cars:GetChildren()) do register(car) end
cars.ChildAdded:Connect(function(car)
 task.delay(.2,function() if car.Parent then register(car) end end)
end)
local function cosmeticDamage(car,damage)
 local score=math.clamp((car:GetAttribute("UAE60Damage") or 0)+damage,0,100)
 car:SetAttribute("UAE60Damage",score)
 car:SetAttribute("UAE60NeedsRepair",score>=50)
 local body=car:FindFirstChild("UAE60_RefinedBody")
 local primary=body and body:FindFirstChild("Refined painted flank",true)
 if primary and primary:IsA("BasePart") then
  if not originalColors[primary] then originalColors[primary]=primary.Color end
  primary.Color=originalColors[primary]:Lerp(Color3.fromRGB(90,86,80),score/130)
 end
end
local runTime=0
RunService.Heartbeat:Connect(function(dt)
 runTime=runTime+math.min(dt,.2)
 if runTime<.12 then return end
 local interval=math.min(runTime,.25)
 runTime=0
 for car,data in pairs(known) do
  if car.Parent then
   local now=car:GetPivot().Position
   local travel=now-data.last
   data.last=now
   local driver=pilot(car)
   local speed=travel.Magnitude/math.max(interval,.05)
   if driver and speed>28 and travel.Magnitude>1 and travel.Magnitude<22 then
    local key=lastHit[car] or 0
    if os.clock()-key>3.5 then
     local params=RaycastParams.new()
     params.FilterType=Enum.RaycastFilterType.Exclude
     local excludes={car}
     if driver.Character then table.insert(excludes,driver.Character) end
     params.FilterDescendantsInstances=excludes
     params.IgnoreWater=true
     local cast=workspace:Raycast(data.last-travel+Vector3.new(0,4,0),
      travel+travel.Unit*5,params)
     if cast and cast.Instance and cast.Instance.CanCollide and
      cast.Instance.Size.Y>2 then
      lastHit[car]=os.clock()
      local impact=math.clamp(math.floor(speed*.18),6,24)
      cosmeticDamage(car,impact)
      if notice then
       notice:FireClient(driver,string.format(
        "COLLISION WARNING • +%d vehicle damage • garage repairs available",impact))
      end
     end
    end
   end
  else
   known[car]=nil
  end
 end
end)
local garage=Instance.new("Model")
garage.Name="Vehicle Repair and Inspection Centre"
garage.Parent=phase
local foundation=Instance.new("Part")
foundation.Name="Accessible repair ramp"
foundation.Size=Vector3.new(48,1.2,44)
foundation.CFrame=CFrame.new(-340,.6,-1010)
foundation.Anchored=true
foundation.Material=Enum.Material.Concrete
foundation.Color=Color3.fromRGB(170,177,175)
foundation.Parent=garage
local kiosk=Instance.new("Part")
kiosk.Name="Repair services terminal"
kiosk.Size=Vector3.new(6,6,4)
kiosk.CFrame=CFrame.new(-355,4,-1007)
kiosk.Anchored=true
kiosk.Material=Enum.Material.Metal
kiosk.Color=Color3.fromRGB(43,104,119)
kiosk.Parent=garage
local prompt=Instance.new("ProximityPrompt")
prompt.ActionText="Repair nearby vehicle"
prompt.ObjectText="Dubai Motor Workshop"
prompt.MaxActivationDistance=14
prompt.HoldDuration=.75
prompt.RequiresLineOfSight=false
prompt.Parent=kiosk
prompt.Triggered:Connect(function(player)
 local char=player.Character
 local hrp=char and char:FindFirstChild("HumanoidRootPart")
 if not hrp or (hrp.Position-kiosk.Position).Magnitude>17 then return end
 local closest,distance=nil,90
 for car in pairs(known) do
  if car.Parent then
   local seat=car:FindFirstChildWhichIsA("VehicleSeat",true)
   if seat then
    local delta=(seat.Position-foundation.Position).Magnitude
    if delta<distance then
     distance=delta;closest=car
    end
   end
  end
 end
 if not closest then
  notice:FireClient(player,"Bring a vehicle onto the repair ramp.")
  return
 end
 closest:SetAttribute("UAE60Damage",0)
 closest:SetAttribute("UAE60NeedsRepair",false)
 local body=closest:FindFirstChild("UAE60_RefinedBody")
 local primary=body and body:FindFirstChild("Refined painted flank",true)
 if primary and originalColors[primary] then
  primary.Color=originalColors[primary]
 end
 notice:FireClient(player,"Vehicle repaired and inspected successfully.")
end)
print("[UAE6] Visual collision monitor and repair workshop enabled")

]==========])
replace("Script",SS,"UAE60_Flight",[==========[
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
local plane=create("UAE City Air Passenger Jet","Plane",Vector3.new(-1280,1.1,-1060))
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

]==========])
replace("Script",SS,"UAE60_Citizens",[==========[
-- UAE CITY LIFE 6: R15 pedestrian crowds around service districts.
-- Uses Roblox-owned default R15 rig construction and humanoid walking, no copied characters.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_ProductionPass")
local folder=Instance.new("Folder")
folder.Name="WalkingHumanCitizens"
folder.Parent=root
local stations={
 {"Hotel Receptionist",{-545,-880},{-550,-877},{-559,-875}},
 {"Hospital Nurse",{-225,-1081},{-222,-1077},{-233,-1074}},
 {"Airport Staff",{-1020,-910},{-1006,-907},{-1010,-922}},
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
 {"Hotel Guest",{-580,-889},{-566,-876},{-545,-910}},
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
local nMax=perf and 8 or #stations
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

]==========])
replace("Script",SS,"UAE60_Traffic",[==========[
-- UAE CITY LIFE 6.0: low-cost road-following background traffic on E11.
-- Server follows authored lanes, slows near players and never drives across malls.
-- Noncolliding traffic scenery, not full physical AI driving.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_ProductionPass")
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
for i,lane in ipairs(laneInfo) do
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

]==========])
replace("Script",SS,"UAE60_Architecture",[==========[
-- UAE CITY LIFE 6: focused architectural overhaul (budgeted procedural details).
-- Detailed material silhouettes, glazing, awnings, signs, crosswalks.
-- Quality upgrade within Roblox Parts; international-level game art still needs meshes.
local Lighting=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local phase=world:WaitForChild("Phase60_ProductionPass")
local root=Instance.new("Folder")
root.Name="ModernStreetsAndArchitecture"
root.Parent=phase
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local C={
 glass=rgb(72,151,177),silver=rgb(185,193,195),
 blue=rgb(39,91,120),cream=rgb(232,228,217),
 gold=rgb(231,186,100),dark=rgb(33,52,64),
 sand=rgb(190,172,143),white=rgb(246,244,228),
 green=rgb(43,124,79),brown=rgb(145,105,73)
}
local function part(name,sz,cf,color,mat,collide)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Color=color
 p.Material=mat or Enum.Material.SmoothPlastic;p.Anchored=true
 p.CanCollide=collide==true
 p.CastShadow=collide==true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=root;return p
end
local function sign(text,x,y,z,width)
 local board=part("Legible road destination board",Vector3.new(width,6,.65),
  CFrame.new(x,y,z),C.blue,Enum.Material.Metal,false)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=34;gui.Parent=board
 local l=Instance.new("TextLabel")
 l.Text=text;l.TextScaled=true;l.TextWrapped=true
 l.Font=Enum.Font.GothamBold;l.TextColor3=C.white
 l.BackgroundTransparency=1;l.Size=UDim2.fromScale(1,1)
 l.Parent=gui
 return board
end
-- Towers with glazed vertical ribs and readable multiple window bands,
-- placed around existing x/z coordinates, not into villa/playable interiors.
local buildings={
 {-285,-1430,132,62,48}, {-470,-1410,172,64,56},
 {-285,-1270,213,58,49}, {-510,-1280,146,52,55},
 {480,-1430,196,54,49},{660,-1390,132,65,52},
 {490,-1270,210,60,49},{690,-1240,113,57,55},
}
for i,entry in ipairs(buildings) do
 local x,z,height,w,d=unpack(entry)
 local frontZ=z-d*.5-.65
 part("Architectural glass facade "..i,Vector3.new(w*.84,height*.82,.8),
  CFrame.new(x,height*.44+3,frontZ),C.glass,Enum.Material.Glass,false).Transparency=.25
 for floor=1,math.floor(height/18) do
  local y=4+floor*16
  part("Brushed steel horizontal mullion",Vector3.new(w*.88,.38,1),
   CFrame.new(x,y,frontZ-.5),C.silver,Enum.Material.Metal,false)
 end
 for _,side in ipairs({-.32,0,.32}) do
  part("Tower vertical aluminium fin",Vector3.new(.7,height*.81,1.1),
   CFrame.new(x+side*w,height*.44+3,frontZ-.6),C.silver,Enum.Material.Metal,false)
 end
 part("Rooftop LED facade",Vector3.new(w*.8,1.0,1.2),
  CFrame.new(x,height+4,frontZ),i%2==0 and C.gold or C.blue,Enum.Material.Neon,false)
 part("Tower lobby glass canopy",Vector3.new(w*.47,.8,11),
  CFrame.new(x,7,frontZ-4.5),C.silver,Enum.Material.Metal,false)
end
-- Wayfinding signs put main services on the street.
for _,s in ipairs({
 {"DXB AIRPORT  |  مطار دبي",-1070,-1180,62},
 {"HOSPITAL  |  المستشفى",-235,-1195,60},
 {"HOTEL & RECEPTION",-550,-1005,62},
 {"DUBAI POLICE  |  شرطة دبي",-935,-480,66},
 {"CIVIL DEFENCE  |  الدفاع المدني",-935,-630,72},
 {"MARINA & COAST  |  دبي مارينا",1080,-1250,72},
 {"CITY ATLAS  |  CITY MISSIONS",30,-1180,74}
}) do
 local txt,x,z,w=s[1],s[2],s[3],s[4]
 part("Road sign support column",Vector3.new(1.2,17,1.2),
  CFrame.new(x-22,9,z),C.silver,Enum.Material.Metal,false)
 sign(txt,x,18,z,w)
end
-- Modern painted road pedestrian crossings at business junctions.
local crossings={
 {0,-1010,105},{0,-1430,105},{-940,-705,34},
 {-235,-1155,44},{-550,-985,44},{-1020,-1110,54}
}
for _,e in ipairs(crossings) do
 local x,z,length=e[1],e[2],e[3]
 for j=1,8 do
  local px=x-length/2+j*length/9
  part("Reflective crosswalk zebra paint",Vector3.new(3,.13,7),
   CFrame.new(px,1.15,z),C.white,Enum.Material.SmoothPlastic,false)
 end
end
-- Faceted traffic lights, functional night-time illumination, road benches.
for _,e in ipairs({
 {-100,-1010},{100,-1010},{-100,-1430},{100,-1430},
 {-960,-705},{-950,-480},{-950,-630}
}) do
 local x,z=e[1],e[2]
 part("Traffic signal mast",Vector3.new(.9,16,.9),
  CFrame.new(x,8,z),C.dark,Enum.Material.Metal,false)
 local box=part("Vertical traffic signal",Vector3.new(2.2,5.5,2),
  CFrame.new(x,15,z),C.dark,Enum.Material.Metal,false)
 for idx,color in ipairs({rgb(198,58,55),rgb(245,172,59),rgb(58,194,131)}) do
  local bulb=part("Signal illuminated disc",Vector3.new(1,1,.32),
   CFrame.new(x,17.5-idx*1.5,z-1.05),color,Enum.Material.Neon,false)
  bulb.Shape=Enum.PartType.Ball
 end
end
for _,e in ipairs({{-235,-1145},{-550,-970},{-1020,-1105},
 {1050,-1260},{-940,-865}}) do
 local x,z=e[1],e[2]
 part("City waiting bench",Vector3.new(13,.7,4),
  CFrame.new(x,2.5,z),C.brown,Enum.Material.WoodPlanks,true)
 part("Bench backrest",Vector3.new(13,4,.5),
  CFrame.new(x,4.5,z+1.5),C.brown,Enum.Material.WoodPlanks,false)
end
-- Directional, low intensity scene grading. No overriding old game's day/night.
pcall(function()
 Lighting.EnvironmentDiffuseScale=.8
 Lighting.EnvironmentSpecularScale=.85
 Lighting.ShadowSoftness=.33
 Lighting.ExposureCompensation=0
end)
local grade=Lighting:FindFirstChild("UAE60_ArchitectureGrade")
if not grade then
 grade=Instance.new("ColorCorrectionEffect")
 grade.Name="UAE60_ArchitectureGrade";grade.Parent=Lighting
end
grade.Contrast=.055
grade.Saturation=.045
grade.TintColor=rgb(255,248,239)
print("[UAE6] Exterior art: glass facade ribs, lobby canopies, signage, crossings, traffic signals")

]==========])
replace("Script",SS,"UAE60_LongMissions",[==========[
-- UAE6: six longer server-authoritative roleplay journeys (session-only).
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local quests={
 {id="RESCUE",title="Emergency Response Dispatch",reward=180,
  stops={{"Hospital Emergency Reception",-235,-1095},
   {"Airport Arrivals",-970,-1120},{"Hospital Return",-235,-1095}}},
 {id="POLICE",title="City Safety Patrol",reward=150,
  stops={{"Police Operations Office",-1135,-480},
   {"Downtown Mall Area",100,-399},{"Police Duty Return",-1135,-480}}},
 {id="FIRE",title="Civil Defence Rescue Drill",reward=180,
  stops={{"Civil Defence Training",-1135,-630},
   {"E11 Road Safety Incident",0,-1200},{"Civil Defence Return",-1135,-630}}},
 {id="AIR",title="Pilot Training & City Flyover",reward=230,
  stops={{"DXB Airport Terminal",-1020,-925},
   {"Aircraft Runway",-1280,-1060},{"Museum Flyover",315,-1180},
   {"Dubai Marina",1060,-1285}}},
 {id="HOTEL",title="International Tourist Transfer",reward=170,
  stops={{"DXB Arrivals",-970,-1120},
   {"Hotel Guest Check-in",-550,-890},
   {"Burj Khalifa Downtown",-84,-392}}},
 {id="COAST",title="Marina Search & Safety",reward=170,
  stops={{"Dubai Marina",1060,-1285},
   {"Cruise Port",1110,-1450},{"Jumeirah Beach Walk",1050,-720}}},
}
local lookup={}
for _,q in ipairs(quests) do lookup[q.id]=q end
local start=RS:FindFirstChild("UAE60_QuestRequest")
if not start then start=Instance.new("RemoteEvent");start.Name="UAE60_QuestRequest";start.Parent=RS end
local update=RS:FindFirstChild("UAE60_QuestUpdate")
if not update then update=Instance.new("RemoteEvent");update.Name="UAE60_QuestUpdate";update.Parent=RS end
local active={}
local last={}
local function send(player,state,phrase)
 local quest=lookup[state.id]
 local stop=quest.stops[state.step]
 update:FireClient(player,{status="active",id=quest.id,title=quest.title,
  stage=state.step,total=#quest.stops,name=stop[1],
  position=Vector3.new(stop[2],5,stop[3]),reward=quest.reward,message=phrase})
end
start.OnServerEvent:Connect(function(player,action,id)
 if typeof(action)~="string" or typeof(id)~="string" or #action>16 or #id>22 then return end
 local now=os.clock()
 if last[player] and now-last[player]<.7 then return end
 last[player]=now
 if action=="Start" and lookup[id] then
  active[player]={id=id,step=1,since=now}
  send(player,active[player],"Mission started! Follow the golden GPS destination.")
 elseif action=="Cancel" then
  active[player]=nil
  update:FireClient(player,{status="cancelled",message="Mission cancelled."})
 elseif action=="Status" and active[player] then
  send(player,active[player],"Continue to the next checkpoint.")
 end
end)
local function award(player,reward)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player end
 local points=stats:FindFirstChild("CityPoints")
 if not points then points=Instance.new("IntValue");points.Name="CityPoints";points.Parent=stats end
 points.Value=points.Value+reward
end
task.spawn(function()
 while true do
  for player,state in pairs(active) do
   local q=lookup[state.id]
   local stop=q and q.stops[state.step]
   local ch=player.Character
   local root=ch and ch:FindFirstChild("HumanoidRootPart")
   local hum=ch and ch:FindFirstChildOfClass("Humanoid")
   if not player.Parent or not stop then active[player]=nil
   elseif root and hum and hum.Health>0 and os.clock()-state.since>=2 then
    local distance=(Vector2.new(root.Position.X,root.Position.Z)-
     Vector2.new(stop[2],stop[3])).Magnitude
    local maxDist=q.id=="AIR" and 75 or 34
    if distance<=maxDist then
     state.step=state.step+1
     state.since=os.clock()
     if state.step>#q.stops then
      active[player]=nil
      award(player,q.reward)
      update:FireClient(player,{status="complete",
       message=q.title.." complete! +"..q.reward.." CityPoints."})
     else
      send(player,state,"Checkpoint reached. Follow the next GPS marker.")
     end
    end
   end
  end
  task.wait(1.2)
 end
end)
Players.PlayerRemoving:Connect(function(player) active[player]=nil;last[player]=nil end)
print("[UAE6] Six longer route missions online")

]==========])
replace("Script",SS,"UAE60_Transit",[==========[
-- UAE6: optional fast travel for PLAYTESTING large map services.
-- Uses a limited whitelist and server-checked cooldown. Not a simulated taxi.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local allowed={
 HOTEL6=true,HOSP6=true,DXB6=true,POLICE6=true,FIRE6=true,
 REPAIR6=true,FLIGHT6=true,HELI6=true,
 HOMES=true,PARK=true,DOWNTOWN=false,BURJ=true,MARINA=true,
}
local remote=RS:FindFirstChild("UAE60_FastTravel")
if not remote then
 remote=Instance.new("RemoteEvent")
 remote.Name="UAE60_FastTravel"
 remote.Parent=RS
end
local feedback=RS:WaitForChild("UAE60_Notification",30)
local last={}
remote.OnServerEvent:Connect(function(player,id)
 if typeof(id)~="string" or #id>24 or not allowed[id] then return end
 local target=locations.ById[id]
 if not target then return end
 local now=os.clock()
 if last[player] and now-last[player]<16 then
  if feedback then feedback:FireClient(player,"City transit is ready again shortly.") end
  return
 end
 local ch=player.Character
 local humanoid=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 if not ch or not humanoid or humanoid.Health<=0 or not root then return end
 if humanoid.SeatPart then
  if feedback then feedback:FireClient(player,"Exit your vehicle before using transit.") end
  return
 end
 last[player]=now
 local arrival=target.position+Vector3.new(0,4,0)
 ch:PivotTo(CFrame.new(arrival))
 if feedback then feedback:FireClient(player,"CITY TRANSIT: Arrived at "..target.name) end
end)
Players.PlayerRemoving:Connect(function(player) last[player]=nil end)
print("[UAE6] City transit fast-travel available to mapped service entrances")

]==========])
replace("LocalScript",clients,"UAE_V54_MapHUD",[==========[
-- UAE CITY LIFE 5.4: integrated map, mission browser and objective guidance.
-- "Map" is a schematic of this ROBLOX GAME, not real Dubai GPS geography.
-- Replaces UAE_V52_HUD (not the camera or CITY / JOBS menus).
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local all=locations.List
local byId=locations.ById
local missions={
 {id="MEDIC",name="Ambulance Assistance",reward=110},
 {id="POLICE",name="Dubai Police Community Patrol",reward=120},
 {id="FIRE",name="Civil Defence Safety Inspection",reward=120},
 {id="AIRPORT",name="Dubai Airport Shuttle",reward=120},
 {id="SIGHTS",name="Dubai Landmark Photo Trail",reward=160},
 {id="MARINA",name="Marina Safety Volunteer",reward=110},
 {id="DELIVERY",name="Karak & Grocery Delivery",reward=90},
 {id="METRO",name="Public Transport Explorer",reward=140},
 {id="HEALTH",name="Dubai Healthcare Checkup",reward=100},
 {id="CLEANUP",name="Community Park Volunteer",reward=90},
}
local request=RS:WaitForChild("UAE_V54_MissionRequest",25)
local updates=RS:WaitForChild("UAE_V54_MissionUpdate",25)
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V54_CityGuide"
gui.ResetOnSpawn=false
gui.DisplayOrder=60 -- ensure the opened atlas is above CITY/JOBS/camera buttons
gui.IgnoreGuiInset=false
gui.Parent=player:WaitForChild("PlayerGui")
local C={
 navy=Color3.fromRGB(17,41,53),
 dark=Color3.fromRGB(30,66,77),
 sand=Color3.fromRGB(245,225,188),
 white=Color3.fromRGB(240,245,242),
 teal=Color3.fromRGB(62,151,163),
 gold=Color3.fromRGB(240,192,103),
 grass=Color3.fromRGB(65,111,93),
 sea=Color3.fromRGB(34,106,142),
 road=Color3.fromRGB(217,207,170),
 red=Color3.fromRGB(232,81,75),
}
local function round(obj,pixels)
 local u=Instance.new("UICorner")
 u.CornerRadius=UDim.new(0,pixels or 8)
 u.Parent=obj
end
local function stroke(obj,tint,w)
 local s=Instance.new("UIStroke")
 s.Color=tint
 s.Thickness=w or 1.1
 s.Parent=obj
end
local function frame(parent,name,pos,size,color,z)
 local f=Instance.new("Frame")
 f.Name=name
 f.Position=pos
 f.Size=size
 f.BackgroundColor3=color or C.navy
 f.BorderSizePixel=0
 f.ZIndex=z or 20
 f.Parent=parent
 return f
end
local function text(parent,name,caption,pos,size,fontSize,color,z)
 local l=Instance.new("TextLabel")
 l.Name=name
 l.Text=caption
 l.Position=pos
 l.Size=size
 l.BackgroundTransparency=1
 l.TextColor3=color or C.sand
 l.TextSize=fontSize or 12
 l.Font=Enum.Font.GothamSemibold
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.TextWrapped=true
 l.ZIndex=z or 22
 l.Parent=parent
 return l
end
local function button(parent,name,caption,pos,size,color,z)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Text=caption
 b.Position=pos
 b.Size=size
 b.BackgroundColor3=color or C.dark
 b.TextColor3=C.white
 b.TextSize=12
 b.Font=Enum.Font.GothamBold
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.ZIndex=z or 22
 b.Parent=parent
 round(b,7)
 return b
end
local function mapColor(cat)
 if cat=="Landmarks" then return C.gold end
 if cat=="Transport" then return C.teal end
 if cat=="Services" then return Color3.fromRGB(240,116,108) end
 if cat=="Shopping" then return Color3.fromRGB(179,160,229) end
 if cat=="Living" then return Color3.fromRGB(200,228,175) end
 return C.sand
end
-- Compact radar stays in top-left and never covers the game world.
local radar=frame(gui,"CircularRadar",UDim2.fromOffset(12,48),
 UDim2.fromOffset(100,100),C.dark,20)
round(radar,50)
stroke(radar,C.gold,2)
local miniMe=frame(radar,"You",UDim2.fromOffset(46,46),UDim2.fromOffset(8,8),C.red,24)
round(miniMe,6)
local miniNorth=text(radar,"North","N",UDim2.fromOffset(45,4),UDim2.fromOffset(12,15),11,C.sand,23)
local miniTarget=frame(radar,"DestinationPin",UDim2.fromOffset(45,5),
 UDim2.fromOffset(9,9),C.gold,24)
round(miniTarget,5)
miniTarget.Visible=false
local radarOpen=button(gui,"OpenCityMap","MAP / M",UDim2.fromOffset(12,152),
 UDim2.fromOffset(100,25),C.navy,24)
local clickRadar=button(radar,"OpenByClickingRadar","",
 UDim2.fromScale(0,0),UDim2.fromScale(1,1),C.dark,26)
clickRadar.BackgroundTransparency=1
local clock=frame(gui,"DubaiClock",UDim2.new(1,-183,0,13),
 UDim2.fromOffset(171,37),C.navy,24)
round(clock,8)
local liveClock=text(clock,"DubaiTime","DUBAI --:-- GST",UDim2.fromOffset(7,3),
 UDim2.fromOffset(155,16),11,C.gold,25)
local dayNight=text(clock,"DayNight","GAME --:--  •  DAY",UDim2.fromOffset(7,20),
 UDim2.fromOffset(155,14),10,C.white,25)
local guideStatus=frame(gui,"RouteStatus",UDim2.new(0,12,1,-53),
 UDim2.fromOffset(265,41),C.navy,24)
round(guideStatus,9)
local guideText=text(guideStatus,"DestinationStatus","MAP: Select a destination to navigate",
 UDim2.fromOffset(8,4),UDim2.new(1,-16,1,-8),11,C.sand,25)
local missionQuick=button(gui,"MissionQuick","MISSIONS",UDim2.new(1,-85,1,-190),
 UDim2.fromOffset(72,36),C.dark,26)
-- Major map panel. It is used on demand, never permanently overlays the game.
local panel=frame(gui,"CityAtlas",UDim2.fromScale(.5,.5),
 UDim2.new(.91,0,.84,0),C.navy,50)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Visible=false
round(panel,12)
stroke(panel,C.gold,1.5)
local limit=Instance.new("UISizeConstraint")
limit.MaxSize=Vector2.new(1010,660)
limit.MinSize=Vector2.new(340,290)
limit.Parent=panel
local header=text(panel,"Title","DUBAI CITY ATLAS",
 UDim2.fromOffset(13,7),UDim2.new(.43,0,0,27),17,C.gold,51)
local close=button(panel,"Close","✕",UDim2.new(1,-43,0,8),
 UDim2.fromOffset(31,27),Color3.fromRGB(118,71,76),53)
local search=Instance.new("TextBox")
search.Name="SearchDestinations"
search.PlaceholderText="Find a place..."
search.Text=""
search.ClearTextOnFocus=false
search.Position=UDim2.new(.47,0,0,8)
search.Size=UDim2.new(.47,-43,0,27)
search.Font=Enum.Font.GothamMedium
search.TextSize=12
search.TextColor3=C.navy
search.BackgroundColor3=C.white
search.ZIndex=53
search.Parent=panel
round(search,7)
local tabRow=frame(panel,"CategoryBar",UDim2.fromOffset(11,44),
 UDim2.new(1,-22,0,36),C.navy,51)
tabRow.BackgroundTransparency=1
local listArea=frame(panel,"Sidebar",UDim2.fromOffset(11,85),
 UDim2.new(.35,-13,1,-134),C.dark,52)
round(listArea,7)
local infoHeader=text(listArea,"ListHeading","DESTINATIONS",UDim2.fromOffset(9,4),
 UDim2.new(1,-18,0,23),12,C.gold,54)
local listing=Instance.new("ScrollingFrame")
listing.Name="DestinationsAndMissions"
listing.Position=UDim2.fromOffset(5,29)
listing.Size=UDim2.new(1,-10,1,-34)
listing.BackgroundTransparency=1
listing.ScrollBarThickness=4
listing.ScrollBarImageColor3=C.gold
listing.BorderSizePixel=0
listing.ZIndex=55
listing.CanvasSize=UDim2.fromOffset(0,1000)
listing.Parent=listArea
local map=frame(panel,"SchematicMap",UDim2.new(.35,7,0,85),
 UDim2.new(.65,-20,1,-134),C.grass,52)
round(map,7)
map.ClipsDescendants=true
local water=frame(map,"GulfCoast",UDim2.new(.79,0,0,0),
 UDim2.new(.21,0,1,0),C.sea,53)
water.BackgroundTransparency=.05
local mapNote=text(map,"MapLegend","IN-GAME MAP  •  SELECT A DOT",UDim2.fromOffset(9,5),
 UDim2.new(1,-18,0,17),10,C.white,61)
local mapFooter=text(panel,"Footer","Red = your location • Gold = selected • Selected entrances support CITY TRANSIT • gold = GPS",
 UDim2.new(0,13,1,-43),UDim2.new(1,-24,0,22),11,C.sand,54)
local confirm=button(panel,"KeepWaypoint","KEEP GPS",UDim2.new(1,-100,1,-41),
 UDim2.fromOffset(85,26),C.teal,55)
local transitBtn=button(panel,"TransitToDestination","CITY TRANSIT",UDim2.new(1,-225,1,-41),
 UDim2.fromOffset(117,26),C.gold,55)
transitBtn.TextColor3=C.navy
local transit=RS:WaitForChild("UAE60_FastTravel",30)
local transitIds={HOTEL6=true,HOSP6=true,DXB6=true,POLICE6=true,FIRE6=true,
 REPAIR6=true,FLIGHT6=true,HELI6=true,HOMES=true,PARK=true,
 BURJ=true,MARINA=true}
local roads={
 {-1500,-1130,1400,-1130}, {-1500,-1200,1400,-1200},
 {-1500,-1280,1400,-1280}, {-900,-985,850,-985},
 {-500,-780,-500,750},{-390,-800,-390,750},
 {0,-1450,0,810},{390,-800,390,800},{-990,30,1000,30},
 {-990,-235,1000,-235},{-990,470,1000,470},
 {-940,-920,-940,-440},{-975,-710,-905,-710},
 {-460,-715,460,-715},{-460,-665,460,-665},
}
local roadFrames={}
for i=1,#roads do
 roadFrames[i]=frame(map,"Road"..i,UDim2.fromOffset(0,0),
  UDim2.fromOffset(10,2),C.road,54)
 roadFrames[i].AnchorPoint=Vector2.new(0,.5)
end
-- Radar road fragments are clipped to a circular 45 px radius.
local localRoads={}
for i=1,#roads do
 local segment=frame(radar,"NearbyRoad"..i,UDim2.fromOffset(0,0),
  UDim2.fromOffset(2,2),C.road,21)
 segment.BackgroundTransparency=.15
 segment.AnchorPoint=Vector2.new(0,.5)
 segment.Visible=false
 localRoads[i]=segment
end
local function clipCircle(a,b)
 local delta=b-a
 local A=delta:Dot(delta)
 if A<.001 then return nil end
 local B=2*a:Dot(delta)
 local Cc=a:Dot(a)-45*45
 local discr=B*B-4*A*Cc
 if discr<0 then return nil end
 local t1=(-B-math.sqrt(discr))/(2*A)
 local t2=(-B+math.sqrt(discr))/(2*A)
 local low=math.max(0,math.min(t1,t2))
 local high=math.min(1,math.max(t1,t2))
 if low>=high then return nil end
 return a+delta*low,a+delta*high
end
local pinWidgets={}
for _,loc in ipairs(all) do
 local pin=button(map,"Pin_"..loc.id,"●",UDim2.fromOffset(0,0),
  UDim2.fromOffset(14,14),mapColor(loc.category),57)
 pin.TextColor3=C.navy
 pin.TextSize=15
 pin.AnchorPoint=Vector2.new(.5,.5)
 round(pin,7)
 pinWidgets[loc.id]=pin
end
local you=frame(map,"YouAreHere",UDim2.fromOffset(0,0),
 UDim2.fromOffset(12,12),C.red,59)
you.AnchorPoint=Vector2.new(.5,.5)
round(you,7)
stroke(you,C.white,1)
local route=frame(map,"StraightLineGuide",UDim2.fromOffset(0,0),
 UDim2.fromOffset(10,3),C.gold,56)
route.AnchorPoint=Vector2.new(0,.5)
route.Visible=false
local selectedLabel=text(map,"SelectedPinLabel","",UDim2.fromOffset(0,0),
 UDim2.fromOffset(180,22),10,C.gold,59)
selectedLabel.TextXAlignment=Enum.TextXAlignment.Center
selectedLabel.BackgroundColor3=C.navy
selectedLabel.BackgroundTransparency=.05
round(selectedLabel,6)
selectedLabel.Visible=false
local bounds=locations.Bounds
local function normalized(x,z)
 return (x-bounds.xmin)/(bounds.xmax-bounds.xmin),
  (z-bounds.zmin)/(bounds.zmax-bounds.zmin)
end
local function mapPoint(x,z)
 local nx,nz=normalized(x,z)
 return Vector2.new(nx*map.AbsoluteSize.X,nz*map.AbsoluteSize.Y)
end
local function paintLine(obj,a,b,thick)
 local dir=b-a
 local length=dir.Magnitude
 if length<1 then obj.Visible=false return end
 obj.Visible=true
 obj.Position=UDim2.fromOffset(a.X,a.Y)
 obj.Size=UDim2.fromOffset(length,thick)
 obj.Rotation=math.deg(math.atan2(dir.Y,dir.X))
end
local currentPage="Places"
local currentCategory="All"
local manualId=nil
local missionId=nil
local missionTitle=nil
local missionStep=0
local jobWaypoint=nil
local lastStatus=""
local selectionStatus=""
local function activeDestination()
 if missionId and byId[missionId] then return byId[missionId] end
 if jobWaypoint then return jobWaypoint end
 return manualId and byId[manualId] or nil
end
local function selectId(id)
 if not byId[id] then return end
 manualId=id
 selectionStatus=byId[id].name
 if not missionId and not jobWaypoint then lastStatus="GPS: "..selectionStatus end
end
local missionButtons={}
local navButtons={}
local function clearRows()
 for _,widget in ipairs(navButtons) do widget:Destroy() end
 navButtons={}
end
local function listButton(txt,extra,y,callback)
 local b=button(listing,"Entry","",UDim2.fromOffset(4,y),
  UDim2.new(1,-12,0,43),C.navy,56)
 b.Text=""
 local name=text(b,"Name",txt,UDim2.fromOffset(8,3),
  UDim2.new(1,-16,0,19),12,C.sand,57)
 local sub=text(b,"Sub",extra,UDim2.fromOffset(8,22),
  UDim2.new(1,-16,0,16),10,C.white,57)
 b.Activated:Connect(callback)
 navButtons[#navButtons+1]=b
end
local function updateList()
 clearRows()
 local searchWord=string.lower(search.Text)
 local y=0
 if currentPage=="Missions" then
  infoHeader.Text="CITY MISSIONS"
  for _,m in ipairs(missions) do
   if searchWord=="" or string.find(string.lower(m.name),searchWord,1,true) then
    listButton(m.name,"+"..m.reward.." CityPoints  •  Start shift",y,function()
     if request then request:FireServer("Start",m.id) end
     panel.Visible=false
    end)
    y=y+47
   end
  end
 else
  infoHeader.Text=currentCategory=="All" and "ALL DESTINATIONS" or string.upper(currentCategory)
  for _,loc in ipairs(all) do
   local visible=currentCategory=="All" or loc.category==currentCategory
   local textMatch=searchWord=="" or
    string.find(string.lower(loc.name),searchWord,1,true) or
    string.find(string.lower(loc.description),searchWord,1,true)
   if visible and textMatch then
    listButton(loc.name,loc.category.." • "..loc.description,y,function()
     selectId(loc.id)
     panel.Visible=false
    end)
    y=y+47
   end
  end
 end
 if y==0 then
  listButton("No results","Try another search or category.",0,function() end)
  y=49
 end
 listing.CanvasSize=UDim2.fromOffset(0,y+6)
end
local function setCategory(cat)
 currentCategory=cat
 currentPage="Places"
 search.Text=""
 updateList()
end
for i,name in ipairs({"All","Landmarks","Services","Transport","Shopping","Living","Leisure","Missions"}) do
 local b=button(tabRow,"Tab_"..name,name,
  UDim2.new((i-1)/8,1,0,2),UDim2.new(1/8,-3,0,29),
  name=="Missions" and C.teal or C.dark,53)
 b.TextSize=9
 b.Activated:Connect(function()
  if name=="Missions" then
   currentPage="Missions"
   search.Text=""
   updateList()
  else
   setCategory(name)
  end
 end)
end
search:GetPropertyChangedSignal("Text"):Connect(updateList)
for _,loc in ipairs(all) do
 pinWidgets[loc.id].Activated:Connect(function()
  selectId(loc.id)
 end)
end
local function showPage(page)
 currentPage=page or "Places"
 search.Text=""
 panel.Visible=true
 updateList()
end
local function toggleMap()
 if panel.Visible then
  panel.Visible=false
 else
  showPage("Places")
 end
end
radarOpen.Activated:Connect(toggleMap)
clickRadar.Activated:Connect(toggleMap)
missionQuick.Activated:Connect(function()
 if panel.Visible and currentPage=="Missions" then panel.Visible=false
 else showPage("Missions") end
end)
close.Activated:Connect(function() panel.Visible=false end)
confirm.Activated:Connect(function() panel.Visible=false end)
transitBtn.Activated:Connect(function()
 if transit and manualId and transitIds[manualId] then
  transit:FireServer(manualId)
  panel.Visible=false
 else
  mapFooter.Text="Select a mapped service entrance or use KEEP GPS for other locations."
 end
end)
UIS.InputBegan:Connect(function(input,processed)
 if processed or UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.M then toggleMap()
 elseif input.KeyCode==Enum.KeyCode.K then
  if panel.Visible and currentPage=="Missions" then panel.Visible=false
  else showPage("Missions") end
 end
end)
if updates then
 updates.OnClientEvent:Connect(function(data)
  if typeof(data)~="table" then return end
  if data.state=="active" and typeof(data.destinationId)=="string" and byId[data.destinationId] then
   missionId=data.destinationId
   missionTitle=data.title
   missionStep=data.stage
   selectionStatus=data.destinationName
   lastStatus=data.message or "Next mission destination"
  elseif data.state=="complete" or data.state=="cancelled" then
   missionId=nil
   missionTitle=nil
   lastStatus=data.message or "Mission ended"
  end
 end)
end
local olderJobs=RS:FindFirstChild("UAE_V53_JobUpdate")
if olderJobs then
 olderJobs.OnClientEvent:Connect(function(msg)
  if typeof(msg)~="table" then return end
  if msg.kind=="progress" and typeof(msg.position)=="Vector3" then
   jobWaypoint={name=msg.label or "Job destination",position=msg.position}
  elseif msg.kind=="cancelled" or msg.kind=="completed" then
   jobWaypoint=nil
  end
 end)
end
local legacy=RS:FindFirstChild("UAE_MissionUpdate")
if legacy then
 legacy.OnClientEvent:Connect(function(message)
  if typeof(message)=="string" and #message<200 and not missionId then
   lastStatus=message
  end
 end)
end
local function drawMap(playerPos)
 local w,h=map.AbsoluteSize.X,map.AbsoluteSize.Y
 if w<80 or h<80 then return end
 for i,r in ipairs(roads) do
  paintLine(roadFrames[i],mapPoint(r[1],r[2]),mapPoint(r[3],r[4]),2.7)
 end
 for _,loc in ipairs(all) do
  pinWidgets[loc.id].Position=UDim2.fromOffset(
   mapPoint(loc.position.X,loc.position.Z).X,
   mapPoint(loc.position.X,loc.position.Z).Y)
 end
 you.Position=UDim2.fromOffset(mapPoint(playerPos.X,playerPos.Z).X,
  mapPoint(playerPos.X,playerPos.Z).Y)
 local target=activeDestination()
 if target then
  local from=mapPoint(playerPos.X,playerPos.Z)
  local to=mapPoint(target.position.X,target.position.Z)
  paintLine(route,from,to,3)
  local x=math.clamp(to.X-90,2,w-185)
  local y=math.clamp(to.Y-26,19,h-25)
  selectedLabel.Position=UDim2.fromOffset(x,y)
  selectedLabel.Text=target.name
  selectedLabel.Visible=true
 else
  route.Visible=false
  selectedLabel.Visible=false
 end
end
-- One client-only GPS beacon makes the selected destination visible in 3D.
local gpsAnchor=Instance.new("Part")
gpsAnchor.Name="UAE_V54_LocalGPSDestination"
gpsAnchor.Anchored=true
gpsAnchor.CanCollide=false
gpsAnchor.CanTouch=false
gpsAnchor.CanQuery=false
gpsAnchor.Size=Vector3.new(.2,.2,.2)
gpsAnchor.Transparency=1
gpsAnchor.Parent=workspace
local gpsBillboard=Instance.new("BillboardGui")
gpsBillboard.Name="WaypointBeacon"
gpsBillboard.Adornee=gpsAnchor
gpsBillboard.AlwaysOnTop=true
gpsBillboard.Size=UDim2.fromOffset(154,42)
gpsBillboard.MaxDistance=450
gpsBillboard.StudsOffsetWorldSpace=Vector3.new(0,6,0)
gpsBillboard.Enabled=false
gpsBillboard.Parent=gpsAnchor
local worldLabel=text(gpsBillboard,"DestinationLabel","GPS DESTINATION",
 UDim2.fromScale(0,0),UDim2.fromScale(1,1),13,C.gold,1)
worldLabel.TextXAlignment=Enum.TextXAlignment.Center
worldLabel.BackgroundColor3=C.navy
worldLabel.BackgroundTransparency=.08
round(worldLabel,8)
local function updateRadarAndText(root)
 local target=activeDestination()
 if target then
  gpsAnchor.CFrame=CFrame.new(target.position+Vector3.new(0,7,0))
  worldLabel.Text=target.name
  gpsBillboard.Enabled=true
 else
  gpsBillboard.Enabled=false
 end
 if not root then
  miniTarget.Visible=false
  return
 end
 local pt=root.Position
 -- Roads scroll past the player as the avatar/vehicle travels.
 local radarScale=9.5 -- studs per map pixel
 for i,r in ipairs(roads) do
  local a=Vector2.new((r[1]-pt.X)/radarScale,(r[2]-pt.Z)/radarScale)
  local b=Vector2.new((r[3]-pt.X)/radarScale,(r[4]-pt.Z)/radarScale)
  local nearA,nearB=clipCircle(a,b)
  if nearA and nearB then
   paintLine(localRoads[i],nearA+Vector2.new(50,50),nearB+Vector2.new(50,50),2)
  else
   localRoads[i].Visible=false
  end
 end
 if target then
  local dv=Vector2.new(target.position.X-pt.X,target.position.Z-pt.Z)
  local d=dv.Magnitude
  local capped=d>1 and dv.Unit*math.min(d/15,37) or Vector2.zero
  miniTarget.Position=UDim2.fromOffset(50+capped.X-4,50+capped.Y-4)
  miniTarget.Visible=true
  local look=Vector2.new(root.CFrame.LookVector.X,root.CFrame.LookVector.Z)
  local message="Ahead"
  if look.Magnitude>.1 and d>2 then
   local dir=dv.Unit
   local theta=math.deg(math.atan2(look.X*dir.Y-look.Y*dir.X,look:Dot(dir)))
   if math.abs(theta)>40 then
    message=theta>0 and "Turn right" or "Turn left"
   end
  end
  guideText.Text=string.format("GPS • %s\n%d studs • %s",target.name,math.floor(d),message)
 else
  miniTarget.Visible=false
  guideText.Text=(lastStatus~="" and lastStatus or "MAP: choose a destination")
 end
end
task.spawn(function()
 local ticked=0
 while gui.Parent do
  task.wait(.3)
  local char=player.Character
  local root=char and char:FindFirstChild("HumanoidRootPart")
  updateRadarAndText(root)
  if panel.Visible and root then drawMap(root.Position) end
  liveClock.Text="DUBAI  "..os.date("!%H:%M",os.time()+4*3600).." GST"
  local hour=RS:GetAttribute("UAECycleHour")
  if typeof(hour)=="number" then
   dayNight.Text=string.format("GAME %02d:%02d  •  %s",math.floor(hour)%24,
    math.floor((hour%1)*60),(hour>=6 and hour<18) and "DAY" or "NIGHT")
  end
 end
end)
updateList()
task.delay(4,function()
 if request then request:FireServer("Status","CURRENT") end
end)
print("[UAE6] City Atlas started:",#all,"destinations, GPS guide and 10 existing missions")

]==========])
replace("LocalScript",clients,"UAE60_Notifications",[==========[
-- v6.0 compact notifications for activities, collisions and repair.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("UAE60_Notification",30)
if not remote then return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE60_Notifications"
gui.ResetOnSpawn=false
gui.DisplayOrder=85
gui.Parent=player:WaitForChild("PlayerGui")
local box=Instance.new("TextLabel")
box.Name="ActivityNotice"
box.AnchorPoint=Vector2.new(.5,0)
box.Position=UDim2.new(.5,0,0,55)
box.Size=UDim2.new(.68,0,0,53)
box.BackgroundColor3=Color3.fromRGB(22,50,64)
box.BackgroundTransparency=.07
box.TextColor3=Color3.fromRGB(247,229,188)
box.Font=Enum.Font.GothamBold
box.TextSize=15
box.TextWrapped=true
box.Visible=false
box.Parent=gui
local constraint=Instance.new("UISizeConstraint")
constraint.MaxSize=Vector2.new(520,53)
constraint.Parent=box
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,9)
corner.Parent=box
local counter=0
remote.OnClientEvent:Connect(function(msg)
 if typeof(msg)~="string" or #msg>240 then return end
 counter=counter+1
 local n=counter
 box.Text=msg
 box.Visible=true
 task.delay(4,function()
  if counter==n and gui.Parent then box.Visible=false end
 end)
end)

]==========])
replace("LocalScript",clients,"UAE60_FlightControls",[==========[
-- UAE 6.0 arcade aircraft cockpit input. Uses server-validated pilot seat.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("UAE60_FlightControl",30)
if not remote then return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE60_PilotCockpit"
gui.ResetOnSpawn=false
gui.DisplayOrder=77
gui.Parent=player:WaitForChild("PlayerGui")
local info=Instance.new("TextLabel")
info.Name="FlightReadout"
info.AnchorPoint=Vector2.new(.5,1)
info.Position=UDim2.new(.5,0,1,-64)
info.Size=UDim2.fromOffset(340,67)
info.BackgroundColor3=Color3.fromRGB(19,44,61)
info.BackgroundTransparency=.13
info.BorderSizePixel=0
info.Font=Enum.Font.GothamBold
info.TextColor3=Color3.fromRGB(254,239,207)
info.TextSize=12
info.TextWrapped=true
info.Text="PILOT CONTROLS"
info.Visible=false
info.Parent=gui
local c=Instance.new("UICorner")
c.CornerRadius=UDim.new(0,11);c.Parent=info
local last=0
local wasFlying=false
Run.RenderStepped:Connect(function(dt)
 last=last+dt
 if last<.09 then return end
 last=0
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 local model=seat and seat.Parent
 local kind=seat and seat:GetAttribute("UAE60AircraftSeat")
 if not kind or not model or not model:GetAttribute("UAE60Aircraft") then
  if wasFlying then
   remote:FireServer({forward=0,yaw=0,climb=0})
  end
  wasFlying=false;info.Visible=false
  return
 end
 wasFlying=true;info.Visible=true
 local inputAllowed=UIS:GetFocusedTextBox()==nil
 local function down(key)
  return inputAllowed and UIS:IsKeyDown(key)
 end
 local forward=(down(Enum.KeyCode.W) and 1 or 0)-(down(Enum.KeyCode.S) and 1 or 0)
 local yaw=(down(Enum.KeyCode.D) and 1 or 0)-(down(Enum.KeyCode.A) and 1 or 0)
 local climb=(down(Enum.KeyCode.R) and 1 or 0)-(down(Enum.KeyCode.F) and 1 or 0)
 remote:FireServer({forward=forward,yaw=yaw,climb=climb})
 info.Text=string.format("%s   SPEED %d  |  ALT +%d studs\nW/S Throttle | A/D Turn | R Up | F Down | Space Exit\nARCADE FLIGHT • follow the city map below",
  kind:upper(),model:GetAttribute("UAE60Speed") or 0,
  model:GetAttribute("UAE60Altitude") or 0)
end)

]==========])
replace("LocalScript",clients,"UAE60_LongMissionUI",[==========[
-- UAE6: simple extra missions panel and navigation for the long journeys.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local req=RS:WaitForChild("UAE60_QuestRequest",30)
local updates=RS:WaitForChild("UAE60_QuestUpdate",30)
if not req or not updates then return end
local options={
 {"RESCUE","Ambulance Emergency Dispatch",180},
 {"POLICE","City Safety Patrol",150},
 {"FIRE","Civil Defence Rescue Drill",180},
 {"AIR","Pilot Training & City Flyover",230},
 {"HOTEL","International Tourist Transfer",170},
 {"COAST","Marina Search & Safety",170},
}
local gui=Instance.new("ScreenGui")
gui.Name="UAE60_MissionBrowser";gui.ResetOnSpawn=false
gui.DisplayOrder=78;gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(20,43,56)
local ink=Color3.fromRGB(244,227,191)
local function round(p)
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,8);c.Parent=p
end
local function button(parent,txt,x,y,w,h)
 local b=Instance.new("TextButton")
 b.Text=txt;b.Size=UDim2.fromOffset(w,h)
 b.Position=UDim2.fromOffset(x,y)
 b.BackgroundColor3=bg;b.TextColor3=ink
 b.Font=Enum.Font.GothamBold;b.TextSize=12
 b.Parent=parent;round(b);return b
end
local launch=button(gui,"BIG MISSIONS",0,0,103,33)
launch.Position=UDim2.new(1,-115,1,-236)
local panel=Instance.new("Frame")
panel.Name="MissionPanel"
panel.Size=UDim2.fromOffset(348,400)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.5)
panel.BackgroundColor3=bg
panel.Visible=false
panel.Parent=gui;round(panel)
local head=Instance.new("TextLabel")
head.Text="CITY LIFE • LONG MISSIONS"
head.Size=UDim2.new(1,-50,0,37)
head.Position=UDim2.fromOffset(12,5)
head.BackgroundTransparency=1;head.TextColor3=ink
head.Font=Enum.Font.GothamBold;head.TextSize=16
head.Parent=panel
local close=button(panel,"X",310,8,29,29)
close.Activated:Connect(function()panel.Visible=false end)
for i,q in ipairs(options) do
 local b=button(panel,q[2].."   +"..q[3].." pts",12,45+(i-1)*49,325,42)
 b.Activated:Connect(function()
  req:FireServer("Start",q[1]);panel.Visible=false
 end)
end
local cancel=button(panel,"CANCEL CURRENT LONG MISSION",12,345,325,37)
cancel.Activated:Connect(function()
 req:FireServer("Cancel","");panel.Visible=false
end)
local function toggle()
 panel.Visible=not panel.Visible
end
launch.Activated:Connect(toggle)
UIS.InputBegan:Connect(function(input,processed)
 if not processed and not UIS:GetFocusedTextBox() and input.KeyCode==Enum.KeyCode.L then
  toggle()
 end
end)
local status=Instance.new("TextLabel")
status.Name="MissionProgress"
status.AnchorPoint=Vector2.new(.5,1)
status.Position=UDim2.new(.5,0,1,-15)
status.Size=UDim2.fromOffset(380,43)
status.BackgroundColor3=bg;status.BackgroundTransparency=.13
status.TextColor3=ink;status.Font=Enum.Font.GothamBold
status.TextSize=12;status.TextWrapped=true
status.Parent=gui;status.Visible=false;round(status)
local marker=Instance.new("Part")
marker.Name="UAE60_ClientMissionBeacon"
marker.Size=Vector3.new(.2,.2,.2)
marker.Transparency=1;marker.CanCollide=false
marker.CanTouch=false;marker.CanQuery=false
marker.Anchored=true;marker.Parent=workspace
local board=Instance.new("BillboardGui")
board.Name="MissionGoldWaypoint"
board.Adornee=marker;board.Size=UDim2.fromOffset(150,38)
board.AlwaysOnTop=true;board.MaxDistance=550
board.StudsOffsetWorldSpace=Vector3.new(0,9,0)
board.Enabled=false;board.Parent=marker
local title=Instance.new("TextLabel")
title.Size=UDim2.fromScale(1,1);title.Text="NEXT STOP"
title.TextWrapped=true;title.TextScaled=true
title.Font=Enum.Font.GothamBold;title.TextColor3=ink
title.BackgroundColor3=bg;title.Parent=board;round(title)
local dest=nil
local ending=0
updates.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" then return end
 if data.status=="active" and typeof(data.position)=="Vector3" then
  dest=data
  marker.CFrame=CFrame.new(data.position)
  board.Enabled=true
  title.Text=tostring(data.name)
  status.Visible=true
 elseif data.status=="complete" or data.status=="cancelled" then
  dest=nil
  board.Enabled=false
  status.Text=tostring(data.message or "Mission ended")
  status.Visible=true
  ending=os.clock()+5
 end
end)
local ticked=0
Run.RenderStepped:Connect(function(dt)
 ticked=ticked+dt
 if ticked<.25 then return end
 ticked=0
 if dest then
  local char=player.Character
  local root=char and char:FindFirstChild("HumanoidRootPart")
  local distance=root and (root.Position-dest.position).Magnitude or 0
  status.Text=string.format("%s  %d/%d\n%s • %d studs",
   tostring(dest.title),dest.stage,dest.total,tostring(dest.name),math.floor(distance))
 elseif status.Visible and ending>0 and os.clock()>ending then
  status.Visible=false;ending=0
 end
end)
task.delay(2.5,function()
 if req.Parent then req:FireServer("Status","") end
end)

]==========])
world:SetAttribute("InstalledVersion","6.0")
print("UAE CITY LIFE v6.0 BIG BUILD INSTALLED: corrected wheels, upgraded vehicle body silhouettes, 6 functional service missions, airport/hospital/hotel/police/fire, aircraft flight, R15 pedestrians, road traffic, 40-place city atlas.")
print("Save as a NEW UAE_City_Life_v6_0.rbxl then press Play. Buildings, NPCs, traffic and aircraft generate during Play. Check Output for [UAE6] logs.")
