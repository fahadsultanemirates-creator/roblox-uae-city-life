-- ROBLOX UAE CITY LIFE | PHASE 5.5 LIVING CITY + VISUAL UPGRADE
-- Paste all code into Roblox Studio COMMAND BAR in EDIT mode, with PLAY STOPPED.
-- Open your saved v5.4/5.4.1 place, make a .rbxl BACKUP before installing.
-- This adds features, leaves your existing v4/v5/v5.2/v5.3/v5.4 districts in place.
-- PERFORMANCE_MODE=true is recommended for the older Dell laptop. Set false for more NPCs and traffic.
local PERFORMANCE_MODE=true
local W=game:GetService("Workspace")
local SP=game:GetService("StarterPlayer")
local SS=game:GetService("ServerScriptService")
local RS=game:GetService("ReplicatedStorage")
local world=W:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase54_CityExpansion"),
 "Open your saved working UAE City Life v5.4 game (not a blank Baseplate).")
assert(world:FindFirstChild("Phase52_RoleplayDistrict"),
 "This upgrade requires the existing v5.2+ base city and services.")
local old=world:FindFirstChild("Phase55_LivingCity")
if old then old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase55_LivingCity"
root:SetAttribute("PerformanceMode",PERFORMANCE_MODE)
root.Parent=world
local function install(kind,parent,name,source)
 local old=parent:FindFirstChild(name)
 if old then old:Destroy() end
 local obj=Instance.new(kind)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
 return obj
end
local client=SP:WaitForChild("StarterPlayerScripts")
-- Existing HUD/camera from v5.4, city jobs/claims, driving and other gameplay scripts remain.
install("ModuleScript",RS,"UAE_V54_Locations",[========[
-- UAE City Life v5.4: central catalogue of IN-GAME destinations.
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
}
-- v5.5 actual ENTERABLE service doors and incident staging area.
table.insert(destinations,{id="HOSP55",name="Dubai Hospital Reception",category="Services",
 position=Vector3.new(-235,5,-1090),description="Enter hospital lobby, receive treatment and check in"})
table.insert(destinations,{id="HOTEL55",name="Al Wasl Hotel Reception",category="Services",
 position=Vector3.new(-550,5,-870),description="Enter hotel lobby, book a room and rest"})
table.insert(destinations,{id="AIR55",name="DXB Airport Passenger Check-in",category="Transport",
 position=Vector3.new(-1150,5,-996),description="Airport boarding pass and sightseeing transfer"})
table.insert(destinations,{id="POL55",name="Dubai Police Reception",category="Services",
 position=Vector3.new(-1120,5,-475),description="Report an incident or request accident response duty"})
table.insert(destinations,{id="FIRE55",name="Dubai Civil Defence Reception",category="Services",
 position=Vector3.new(-1120,5,-650),description="Join road rescue and emergency drills"})
table.insert(destinations,{id="ACC55",name="Traffic Accident Training Scene",category="Services",
 position=Vector3.new(-830,5,-740),description="Inspect collision and assist emergency services"})
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

]========])
install("Script",SS,"UAE55_WorldAndInteriors",[========[
-- UAE City Life v5.5: interior-focused interactive city phase (server; run in Play)
-- World objects stay under Phase55_LivingCity so reinstall in EDIT mode is reversible.
local W=game:GetService("Workspace")
local L=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local world=W:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_LivingCity")
local C={
 cream=Color3.fromRGB(237,231,215),stone=Color3.fromRGB(189,195,183),
 navy=Color3.fromRGB(26,54,72),teal=Color3.fromRGB(53,139,143),
 glass=Color3.fromRGB(104,171,187),red=Color3.fromRGB(174,62,59),
 amber=Color3.fromRGB(243,183,85),green=Color3.fromRGB(74,145,111),
 wood=Color3.fromRGB(146,104,65),metal=Color3.fromRGB(137,159,161),
 asphalt=Color3.fromRGB(49,53,59),black=Color3.fromRGB(36,42,48),
 white=Color3.fromRGB(248,248,244),blue=Color3.fromRGB(61,120,171)
}
local function folder(n,parent)
 local f=Instance.new("Folder");f.Name=n;f.Parent=parent or root;return f
end
local function p(parent,name,size,cf,color,material,collision)
 local v=Instance.new("Part")
 v.Name=name;v.Size=size;v.CFrame=cf;v.Anchored=true
 v.Color=color or C.cream;v.Material=material or Enum.Material.SmoothPlastic
 v.CanCollide=collision==true;v.CanTouch=false;v.CastShadow=true
 v.TopSurface=Enum.SurfaceType.Smooth;v.BottomSurface=Enum.SurfaceType.Smooth
 v.Parent=parent
 return v
end
local function textFace(part,caption,face,tint)
 local gui=Instance.new("SurfaceGui")
 gui.Face=face or Enum.NormalId.Front;gui.PixelsPerStud=42;gui.LightInfluence=.1;gui.Parent=part
 local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1)
 label.BackgroundTransparency=1;label.Text=caption;label.TextScaled=true
 label.TextWrapped=true;label.Font=Enum.Font.GothamBold
 label.TextColor3=tint or C.white;label.Parent=gui
end
local function node(parent,name,x,y,z,action)
 local n=p(parent,name,Vector3.new(3,3,3),CFrame.new(x,y,z),C.teal,Enum.Material.Metal,false)
 n:SetAttribute("UAE55Action",action)
 local glow=Instance.new("PointLight")
 glow.Range=10;glow.Brightness=.25;glow.Color=C.amber;glow.Parent=n
 local pr=Instance.new("ProximityPrompt")
 pr.Name="CityLifeServicePrompt";pr.ActionText=name
 pr.ObjectText="UAE City Life";pr.MaxActivationDistance=12
 pr.HoldDuration=.3;pr.RequiresLineOfSight=false
 pr.KeyboardKeyCode=Enum.KeyCode.E;pr.Parent=n
 return n
end
local function interior(parent,key,title,x,z,w,d,accent,sign)
 local m=Instance.new("Model");m.Name=key;m.Parent=parent
 local ground=1.5
 p(m,"Walkable tiled floor",Vector3.new(w,1.2,d),CFrame.new(x,ground,z),
  C.stone,Enum.Material.Marble,true)
 p(m,"Back wall",Vector3.new(w,16,1),CFrame.new(x,9,z-d/2),C.cream,Enum.Material.Concrete,true)
 for _,side in ipairs({-1,1}) do
  p(m,"Glass front-side panel",Vector3.new(1,15,d),CFrame.new(x+side*w/2,8.5,z),
   C.glass,Enum.Material.Glass,true).Transparency=.25
  p(m,"Silver vertical facade",Vector3.new(1.2,17,1.3),CFrame.new(x+side*w/2,8.5,z+d/2),
   C.metal,Enum.Material.Metal,false)
 end
 p(m,"Lobby canopy",Vector3.new(w+3,1.1,d+3),CFrame.new(x,17,z),C.cream,Enum.Material.Concrete,false)
 local signPart=p(m,"Public lobby sign",Vector3.new(w*.88,5,1),CFrame.new(x,18.5,z+d/2),
  accent,Enum.Material.Metal,false)
 textFace(signPart,sign,Enum.NormalId.Front,C.white)
 local entrance=p(m,"Welcome mat",Vector3.new(14,.15,7),CFrame.new(x,2.2,z+d/2+1.5),
  accent,Enum.Material.Fabric,false)
 local desk=p(m,"Reception wood desk",Vector3.new(w*.5,3,4),
  CFrame.new(x,3.9,z-d*.15),C.wood,Enum.Material.Wood,true)
 local trim=p(m,"Reception counter trim",Vector3.new(w*.5+.6,.35,4.6),
  CFrame.new(x,5.5,z-d*.15),C.cream,Enum.Material.Marble,false)
 for _,side in ipairs({-1,1}) do
  p(m,"Lobby waiting bench",Vector3.new(9,1.4,3.8),
   CFrame.new(x+side*(w*.35),3.2,z+d*.16),C.navy,Enum.Material.Fabric,true)
  p(m,"Window seating glass",Vector3.new(4,4,.35),
   CFrame.new(x+side*(w*.3),12,z-d/2+.8),C.glass,Enum.Material.Glass,false)
 end
 local ceiling=p(m,"Recessed ceiling lights",Vector3.new(w*.3,.2,2),
  CFrame.new(x,16.3,z),C.white,Enum.Material.Neon,false)
 local light=Instance.new("PointLight");light.Range=34;light.Brightness=.65;light.Parent=ceiling
 return m
end
local services=folder("FunctionalCityInteriors")
-- Interiors are annexes near previously solid model exteriors; open front means players can enter.
local hospital=interior(services,"DubaiHospitalLobby","Hospital",-235,-1090,62,38,C.red,
 "DUBAI HOSPITAL  |  مستشفى دبي")
node(hospital,"Get medical check-in ticket",-251,5,-1086,"HospitalCheckIn")
node(hospital,"Receive treatment",-221,5,-1086,"HospitalTreat")
local clinic=p(hospital,"Examination bed",Vector3.new(12,1.2,5),
 CFrame.new(-244,3,-1104),C.white,Enum.Material.Fabric,true)
p(hospital,"Examination pillow",Vector3.new(4,.5,3.5),
 CFrame.new(-247,3.8,-1104),C.teal,Enum.Material.Fabric,false)
local hotel=interior(services,"AlWaslHotelLobby","Hotel",-550,-870,62,41,C.amber,
 "AL WASL HOTEL  |  فندق الوصل")
node(hotel,"Check in to hotel",-565,5,-863,"HotelCheckIn")
node(hotel,"Rest in guest room",-532,5,-863,"HotelRest")
local bed=p(hotel,"Guest bed",Vector3.new(11,1.6,6),
 CFrame.new(-533,3,-884),C.cream,Enum.Material.Fabric,true)
p(hotel,"Guest pillow",Vector3.new(2.8,.65,5),CFrame.new(-537,4,-884),C.white,Enum.Material.Fabric,false)
local airport=interior(services,"DXBPassengerTerminal","Airport",-1150,-996,71,48,C.blue,
 "DXB DEPARTURES  |  مطار دبي")
node(airport,"Airport check-in",-1168,5,-984,"AirportCheckIn")
node(airport,"Board Dubai flight",-1127,5,-984,"AirportBoard")
for i=1,3 do
 p(airport,"Self-service terminal",Vector3.new(3,6,3),CFrame.new(-1173+(i-1)*6,5,-1008),
  C.navy,Enum.Material.Metal,true)
 p(airport,"Digital boarding kiosk screen",Vector3.new(2.5,2,.2),
  CFrame.new(-1173+(i-1)*6,6,-1006.35),C.glass,Enum.Material.Neon,false)
end
local police=interior(services,"DubaiPoliceReception","Police",-1120,-475,60,36,C.navy,
 "DUBAI POLICE  |  شرطة دبي")
node(police,"Report a city incident",-1134,5,-466,"PoliceReport")
node(police,"Request accident-response shift",-1106,5,-466,"AccidentAccept")
local fire=interior(services,"DubaiCivilDefenceReception","Civil Defence",-1120,-650,60,36,C.red,
 "CIVIL DEFENCE  |  الدفاع المدني")
node(fire,"Join road-rescue response",-1120,5,-638,"AccidentAccept")
-- Roadside crash scene is a controlled, non-violent roleplay exercise with prompts.
local incident=folder("RoadIncidentRoleplayScene")
p(incident,"Incident safety turnout",Vector3.new(70,.6,67),CFrame.new(-830,1,-740),
 C.asphalt,Enum.Material.Asphalt,true)
local car=Instance.new("Model");car.Name="Damaged sedan (stationary exercise)";car.Parent=incident
p(car,"Damaged car body",Vector3.new(11,3,22),CFrame.new(-834,4.2,-746)*CFrame.Angles(0,.2,0),
 C.blue,Enum.Material.Metal,false)
p(car,"Cabin glass",Vector3.new(9,3,10),CFrame.new(-833.3,6.8,-743.8)*CFrame.Angles(0,.2,0),
 C.glass,Enum.Material.Glass,false)
p(car,"Bent bonnet",Vector3.new(10,.9,5),CFrame.new(-836,5,-755)*CFrame.Angles(.11,.2,.15),
 C.navy,Enum.Material.Metal,false)
for _,dx in ipairs({-5.5,5.5}) do
 for _,dz in ipairs({-8,8}) do
  local wh=p(car,"Safety wheel",Vector3.new(4.7,1.5,4.7),
   CFrame.new(-834+dx,2.9,-746+dz)*CFrame.Angles(0,0,math.pi/2),
   C.black,Enum.Material.Rubber,false)
  wh.Shape=Enum.PartType.Cylinder
 end
end
for _,pos in ipairs({{-852,-754},{-852,-729},{-812,-754},{-812,-729}}) do
 local cone=p(incident,"Reflective safety cone",Vector3.new(2.4,3,2.4),
  CFrame.new(pos[1],2.6,pos[2]),C.amber,Enum.Material.Neon,false)
 cone.Shape=Enum.PartType.Cylinder
end
local smoke=p(car,"Engine smoke source",Vector3.new(.3,.3,.3),
 CFrame.new(-840,6,-755),C.white,nil,false)
smoke.Transparency=1
local mist=Instance.new("ParticleEmitter")
mist.Name="Light accident training smoke"
mist.Rate=2;mist.Lifetime=NumberRange.new(1.5,2.5)
mist.Speed=NumberRange.new(2,3);mist.Size=NumberSequence.new(.6,2)
mist.Color=ColorSequence.new(Color3.fromRGB(150,159,162))
mist.Transparency=NumberSequence.new(.45,.95)
mist.Parent=smoke
node(incident,"Assess accident scene",-826,5,-725,"AccidentInspect")
node(incident,"Help and clear roadway",-846,5,-724,"AccidentClear")
node(incident,"Repair damaged vehicle",-844,5,-760,"AccidentRepair")
-- Crosswalk and sidewalk improvements on already open E11; decoration only.
local street=folder("RealStreetDetails")
for _,z in ipairs({-1290,-1140,-1020}) do
 for x=-68,68,13 do
  p(street,"E11 pedestrian crossing stripe",Vector3.new(7,.09,3.5),
   CFrame.new(x,1.5,z),C.white,Enum.Material.SmoothPlastic,false)
 end
end
for _,item in ipairs({
 {-760,-807,"DUBAI FRAME",C.amber},
 {-315,-1120,"DUBAI HOSPITAL",C.red},
 {-1190,-1120,"DXB AIRPORT",C.blue},
 {-570,-818,"HOTEL",C.amber},
}) do
 local peg=p(street,"Route information post",Vector3.new(1.3,13,1.3),
  CFrame.new(item[1],7,item[2]),C.metal,Enum.Material.Metal,false)
 local plate=p(street,"Bilingual visitor guide",Vector3.new(34,5,.8),
  CFrame.new(item[1],14,item[2]),item[4],Enum.Material.Metal,false)
 textFace(plate,item[3],Enum.NormalId.Front,C.white)
end
-- Moderate atmospheric polish without breaking existing game clock/day-night scripts.
local atmo=L:FindFirstChild("UAE55_CityAtmosphere")
if not atmo then
 atmo=Instance.new("Atmosphere");atmo.Name="UAE55_CityAtmosphere"
 atmo.Density=.18;atmo.Haze=.6;atmo.Glare=.1
 atmo.Color=Color3.fromRGB(223,231,244)
 atmo.Decay=Color3.fromRGB(153,178,196)
 atmo.Parent=L
end
local cc=L:FindFirstChild("UAE55_ColorBalance")
if not cc then
 cc=Instance.new("ColorCorrectionEffect");cc.Name="UAE55_ColorBalance"
 cc.Brightness=.02;cc.Contrast=.065;cc.Saturation=.06
 cc.TintColor=Color3.fromRGB(255,249,242)
 cc.Parent=L
end
print("[UAE v5.5] 5 enterable service annexes, accident response scene, new surfaces and atmosphere ready")

]========])
install("Script",SS,"UAE55_InteractiveCity",[========[
-- UAE City Life v5.5: server-authoritative usable hotel/hospital/airport and accident roleplay.
-- Prompt actions are checked for real player distance (client can forge ProximityPrompt).
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_LivingCity")
local services=root:WaitForChild("FunctionalCityInteriors")
local crash=root:WaitForChild("RoadIncidentRoleplayScene")
local status=RS:FindFirstChild("UAE55_ServiceStatus")
if not status then
 status=Instance.new("RemoteEvent");status.Name="UAE55_ServiceStatus";status.Parent=RS
end
local state={}
local lastUsed={}
local lastCompleted={}
local waypoints={
 Hospital=Vector3.new(-235,5,-1090),
 Hotel=Vector3.new(-550,5,-870),
 Airport=Vector3.new(-1150,5,-996),
 Accident=Vector3.new(-830,5,-740),
 CivilDefence=Vector3.new(-1120,5,-650),
 Police=Vector3.new(-1120,5,-475)
}
local function send(player,title,message,target)
 if player.Parent~=Players then return end
 status:FireClient(player,{
  title=title,message=message,
  destination=target and waypoints[target] or nil,
  destinationName=target,
 })
end
local function getState(player)
 if not state[player] then
  state[player]={checkedHospital=false,checkedHotel=false,checkedAirport=false,
   caseStage=0}
 end
 return state[player]
end
local function getRoot(player)
 local char=player.Character
 local h=char and char:FindFirstChildOfClass("Humanoid")
 local rootPart=char and char:FindFirstChild("HumanoidRootPart")
 if h and h.Health>0 and rootPart then return rootPart,h end
end
local function points(player,amount)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player end
 local score=stats:FindFirstChild("CityPoints")
 if not score then score=Instance.new("IntValue");score.Name="CityPoints";score.Parent=stats end
 score.Value=math.clamp(score.Value+amount,0,2000000000)
end
local function valid(player,node)
 local char,h=getRoot(player)
 if not char or not h then return nil end
 if (char.Position-node.Position).Magnitude>17 then return nil end
 local last=lastUsed[player] or {}
 local action=node:GetAttribute("UAE55Action")
 local now=os.clock()
 if last[action] and now-last[action]<1.2 then return nil end
 last[action]=now
 lastUsed[player]=last
 return h
end
local function handle(player,node)
 local hum=valid(player,node)
 if not hum then return end
 local s=getState(player)
 local action=node:GetAttribute("UAE55Action")
 if action=="HospitalCheckIn" then
  s.checkedHospital=true
  send(player,"DUBAI HOSPITAL","Your appointment is registered. Visit the treatment desk.","Hospital")
 elseif action=="HospitalTreat" then
  if not s.checkedHospital then
   send(player,"HOSPITAL","Check in at the reception counter first.","Hospital")
   return
  end
  hum.Health=hum.MaxHealth
  s.checkedHospital=false
  points(player,8)
  send(player,"HOSPITAL","Treatment complete; health restored. +8 CityPoints.")
 elseif action=="HotelCheckIn" then
  s.checkedHotel=true
  send(player,"AL WASL HOTEL","Guest room assigned. Use the guest-room rest point.","Hotel")
 elseif action=="HotelRest" then
  if not s.checkedHotel then
   send(player,"HOTEL","Please check in before resting.","Hotel")
   return
  end
  s.checkedHotel=false
  hum.Health=hum.MaxHealth
  points(player,6)
  send(player,"HOTEL","You rested in your room. Health restored; +6 CityPoints.")
 elseif action=="AirportCheckIn" then
  s.checkedAirport=true
  send(player,"DXB AIRPORT","Boarding pass issued for a simulated sightseeing transfer. Visit the gate.","Airport")
 elseif action=="AirportBoard" then
  if not s.checkedAirport then
   send(player,"AIRPORT","Check in at the terminal first.","Airport")
   return
  end
  s.checkedAirport=false
  local character=player.Character
  if character and character.Parent then
   if hum.Sit then hum.Sit=false end
   character:PivotTo(CFrame.new(1085,8,-1250))
  end
  points(player,15)
  send(player,"SIGHTSEEING TRANSFER","Arrived at Dubai Marina! This is a fast-travel simulation, not a flyable aircraft. +15 CityPoints.")
 elseif action=="PoliceReport" then
  send(player,"CITY POLICE","Incident noted. For road rescue, join a response shift at this reception.","Police")
 elseif action=="AccidentAccept" then
  local now=os.clock()
  if lastCompleted[player] and now-lastCompleted[player]<35 then
   send(player,"ROAD RESCUE","You have completed a case recently. Another case opens shortly.")
   return
  end
  s.caseStage=1
  send(player,"ROAD RESCUE","Dispatch received: staged traffic collision. Visit the crash scene and inspect.","Accident")
 elseif action=="AccidentInspect" then
  if s.caseStage~=1 then
   send(player,"ACCIDENT SCENE","Start a response shift at Police or Civil Defence first.","Police")
   return
  end
  s.caseStage=2
  send(player,"ROAD RESCUE","Scene assessed. Approach the rescue equipment beside the vehicle.","Accident")
 elseif action=="AccidentClear" then
  if s.caseStage~=2 then
   send(player,"ACCIDENT SCENE","Inspect the incident scene before clearing the road.","Accident")
   return
  end
  s.caseStage=3
  send(player,"ROAD RESCUE","The road is safe. Repair the demonstration vehicle to close the case.","Accident")
 elseif action=="AccidentRepair" then
  if s.caseStage~=3 then
   send(player,"ACCIDENT SCENE","You must complete the inspection and clearance steps first.","Accident")
   return
  end
  s.caseStage=0
  lastCompleted[player]=os.clock()
  points(player,140)
  local damaged=crash:FindFirstChild("Damaged sedan (stationary exercise)")
  local bonnet=damaged and damaged:FindFirstChild("Bent bonnet")
  local exhaust=damaged and damaged:FindFirstChild("Engine smoke source")
  local smoke=exhaust and exhaust:FindFirstChildOfClass("ParticleEmitter")
  if smoke then smoke.Enabled=false end
  if bonnet then bonnet.Color=Color3.fromRGB(65,135,179) end
  -- Reset the training scene after a short respite for the next player.
  task.delay(25,function()
   if smoke and smoke.Parent then smoke.Enabled=true end
   if bonnet and bonnet.Parent then bonnet.Color=Color3.fromRGB(26,54,72) end
  end)
  send(player,"RESCUE COMPLETED","Incident closed: hazard smoke cleared and vehicle repaired. +140 CityPoints.")
 end
end
local count=0
for _,collection in ipairs({services,crash}) do
 for _,node in ipairs(collection:GetDescendants()) do
  if node:IsA("BasePart") and node:GetAttribute("UAE55Action") then
   local prompt=node:FindFirstChild("CityLifeServicePrompt")
   if prompt and prompt:IsA("ProximityPrompt") then
    prompt.Triggered:Connect(function(player) handle(player,node) end)
    count=count+1
   end
  end
 end
end
Players.PlayerRemoving:Connect(function(player)
 state[player]=nil;lastUsed[player]=nil;lastCompleted[player]=nil
end)
print("[UAE v5.5] Interactive city services started: "..count.." check-in, treatment, hotel, airport and road-rescue prompts")

]========])
install("Script",SS,"UAE55_TrafficAndVehicles",[========[
-- UAE City Life 5.5: higher-detail lane-following cars + repaired procedural wheel orientation.
-- This traffic is visual, anchored and noncolliding; do not mistake it for a physics traffic engine.
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_LivingCity")
local lightMode=root:GetAttribute("PerformanceMode")==true
local vehicles=Instance.new("Folder")
vehicles.Name="V55LaneTraffic"
vehicles.Parent=root
local RGB=Color3.fromRGB
local palette={
 RGB(211,219,216),RGB(34,78,116),RGB(159,48,47),
 RGB(231,223,191),RGB(58,67,75),RGB(195,196,202),
 RGB(150,107,64),RGB(41,101,94),
}
local asphalt=RGB(40,44,52)
local window=RGB(49,94,116)
local chrome=RGB(202,213,212)
local function part(model,name,sz,relative,color,material,shape)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=relative
 p.Color=color;p.Material=material or Enum.Material.SmoothPlastic
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CastShadow=true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 if shape then p.Shape=shape end
 p.Parent=model
 return p
end
local function makeCar(idx)
 local kind=({"Sedan","Sedan","SUV","Taxi","Sedan","SUV","Van","Taxi"})[(idx-1)%8+1]
 local tint=palette[(idx-1)%#palette+1]
 local m=Instance.new("Model");m.Name="V55_Traffic_"..kind.."_"..idx;m.Parent=vehicles
 local pivot=part(m,"Pivot",Vector3.new(.15,.15,.15),CFrame.new(),tint)
 pivot.Transparency=1
 m.PrimaryPart=pivot
 local length=kind=="Van" and 24 or (kind=="SUV" and 21 or 19)
 local bodyWidth=kind=="Van" and 11.5 or 10.3
 part(m,"Low dark undercarriage",Vector3.new(bodyWidth,1,length),
 CFrame.new(0,3.1,0),asphalt,Enum.Material.Metal)
 part(m,"Rounded panel body",Vector3.new(bodyWidth,2.3,length),
 CFrame.new(0,4.6,0),tint,Enum.Material.Metal)
 part(m,"Front bumper",Vector3.new(bodyWidth+.4,.9,1.15),
 CFrame.new(0,3.55,-length/2-.2),chrome,Enum.Material.Metal)
 part(m,"Rear bumper",Vector3.new(bodyWidth+.2,.7,1),
 CFrame.new(0,3.6,length/2+.2),asphalt,Enum.Material.Metal)
 local cabinLength=(kind=="Van" and 12 or 10)
 part(m,"Passenger window glass",Vector3.new(bodyWidth-.7,2.8,cabinLength),
 CFrame.new(0,6.7,1),window,Enum.Material.Glass)
 part(m,"Vehicle roof",Vector3.new(bodyWidth-.75,.7,cabinLength+.6),
 CFrame.new(0,8.3,1),tint,Enum.Material.Metal)
 part(m,"Bonnet paint",Vector3.new(bodyWidth-.5,.8,5),
 CFrame.new(0,5.4,-length/2+2.7),tint,Enum.Material.Metal)
 local wheels={}
 for _,side in ipairs({-1,1}) do
  for _,z in ipairs({-length*.32,length*.32}) do
   local wheel=part(m,"Wheel Rubber",Vector3.new(4.4,1.5,4.4),
    CFrame.new(side*(bodyWidth/2+.3),2.4,z)*CFrame.Angles(0,0,math.pi/2),
    RGB(25,27,30),Enum.Material.Rubber,Enum.PartType.Cylinder)
   local hub=part(m,"Wheel Alloy Rim",Vector3.new(2.5,1.55,2.5),
    CFrame.new(side*(bodyWidth/2+.45),2.4,z)*CFrame.Angles(0,0,math.pi/2),
    chrome,Enum.Material.Metal,Enum.PartType.Cylinder)
   wheels[#wheels+1]=wheel
   wheels[#wheels+1]=hub
  end
  part(m,"Door seam",Vector3.new(.12,2.7,.16),
   CFrame.new(side*(bodyWidth/2+.06),4.9,1.6),asphalt,Enum.Material.Metal)
  part(m,"Silver door handle",Vector3.new(.15,.24,1.8),
   CFrame.new(side*(bodyWidth/2+.1),5.4,2),chrome,Enum.Material.Metal)
  part(m,"LED front lamp",Vector3.new(2.1,.65,.3),
   CFrame.new(side*(bodyWidth/2-1.6),4.8,-length/2-.28),
   RGB(255,244,200),Enum.Material.Neon)
  part(m,"Red rear lamp",Vector3.new(2.1,.65,.3),
   CFrame.new(side*(bodyWidth/2-1.6),4.8,length/2+.28),
   RGB(194,54,63),Enum.Material.Neon)
 end
 part(m,"Black front grille",Vector3.new(bodyWidth*.45,.9,.25),
 CFrame.new(0,3.95,-length/2-.42),asphalt,Enum.Material.Metal)
 if kind=="Taxi" then
  local roof=part(m,"Dubai taxi roof sign",Vector3.new(4.3,1.1,2),
   CFrame.new(0,9,1),RGB(244,227,176),Enum.Material.SmoothPlastic)
  local gui=Instance.new("SurfaceGui");gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=25;gui.Parent=roof
  local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1)
  label.Text="TAXI";label.BackgroundTransparency=1
  label.TextColor3=RGB(22,76,98);label.TextScaled=true
  label.Font=Enum.Font.GothamBold;label.Parent=gui
 end
 local localWheels={}
 for _,wheel in ipairs(wheels) do
  localWheels[#localWheels+1]={p=wheel,rel=m:GetPivot():ToObjectSpace(wheel.CFrame)}
 end
 return m,localWheels
end
-- E11 lane traffic uses consistent one-direction lane paths, so new cars don't cross each other.
local routes={
 {x=-55,dir=-1},{x=-32,dir=-1},{x=32,dir=1},{x=55,dir=1},
}
local fleet={}
local perLane=lightMode and 2 or 3
for lane,route in ipairs(routes) do
 for number=1,perLane do
  local idx=(lane-1)*perLane+number
  local model,parts=makeCar(idx)
  fleet[#fleet+1]={model=model,wheels=parts,route=route,
   alpha=(number-1)/perLane,rotation=0,speed=lightMode and 18 or 21}
 end
end
local elapsed=0
RunService.Heartbeat:Connect(function(dt)
 elapsed=elapsed+math.min(dt,.1)
 if elapsed<.09 then return end
 local step=math.min(elapsed,.16)
 elapsed=0
 for _,obj in ipairs(fleet) do
  obj.alpha=(obj.alpha+step*obj.speed/480)%1
  obj.rotation=obj.rotation+step*obj.speed/2.1
  local z=obj.route.dir==1 and (-1455+obj.alpha*480) or (-975-obj.alpha*480)
  local cf=CFrame.new(obj.route.x,0,z)*CFrame.Angles(0,obj.route.dir==1 and math.pi or 0,0)
  obj.model:PivotTo(cf)
  -- Rotate visual wheel cylinders around their axle; no physical car dynamics.
  for _,data in ipairs(obj.wheels) do
   data.p.CFrame=cf*data.rel*CFrame.Angles(0,obj.rotation,0)
  end
 end
end)
-- Older procedural models incorrectly put the cylinder axle vertically. Fix wheels once.
local function fixLegacy(model)
 if not model:IsA("Model") or model:GetAttribute("UAE55TyresFixed") then return end
 if model:IsDescendantOf(vehicles) then return end
 local count=0
 for _,part in ipairs(model:GetDescendants()) do
  if part:IsA("Part") and part.Shape==Enum.PartType.Cylinder then
   local n=string.lower(part.Name)
   if n:find("wheel") or n:find("tyre") or n:find("tire") or n:find("rim") then
    local dim=part.Size
    local diameter=math.max(dim.X,dim.Y,dim.Z)
    local axle=math.min(dim.X,dim.Y,dim.Z)
    if diameter>=2.2 and axle<=3 then
     part.Size=Vector3.new(diameter,axle,diameter)
     part.CFrame=part.CFrame*CFrame.Angles(0,0,math.pi/2)
     count=count+1
    end
   end
  end
 end
 if count>0 then model:SetAttribute("UAE55TyresFixed",true) end
end
-- Existing car models may be spawned after server start.
task.spawn(function()
 while root.Parent do
  local cars=world:FindFirstChild("EmergencyVehicles")
  if cars then for _,m in ipairs(cars:GetChildren()) do fixLegacy(m) end end
  local phase=world:FindFirstChild("Phase54_CityExpansion")
  local static=phase and phase:FindFirstChild("CommunityServiceFleet",true)
  if static then for _,m in ipairs(static:GetChildren()) do fixLegacy(m) end end
  task.wait(6)
 end
end)
print("[UAE v5.5] "..#fleet.." higher-detail E11 lane traffic cars; legacy procedural tyres corrected")

]========])
install("Script",SS,"UAE55_R15Pedestrians",[========[
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

]========])
install("LocalScript",client,"UAE55_CityLifeHUD",[========[
-- UAE City Life v5.5: compact feedback/UI for city services and traffic incident response.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("UAE55_ServiceStatus",30)
if not remote then warn("[UAE v5.5] Services server event missing");return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE55_ServiceHUD";gui.ResetOnSpawn=false;gui.DisplayOrder=39
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(22,47,61)
local tint=Color3.fromRGB(248,223,174)
local fg=Color3.fromRGB(236,246,243)
local function corner(obj,r)
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=obj
end
local function label(par,s,size,pos,bounds,color)
 local t=Instance.new("TextLabel")
 t.Text=s;t.TextSize=size;t.Font=Enum.Font.GothamSemibold
 t.TextColor3=color or tint;t.BackgroundTransparency=1
 t.TextWrapped=true;t.TextXAlignment=Enum.TextXAlignment.Left
 t.Position=pos;t.Size=bounds;t.Parent=par;return t
end
local btn=Instance.new("TextButton")
btn.Name="CityLifeInfoButton";btn.Text="LIFE  •  L"
btn.Font=Enum.Font.GothamBold;btn.TextSize=12;btn.TextColor3=fg
btn.Size=UDim2.fromOffset(90,30);btn.Position=UDim2.new(1,-183,0,54)
btn.BackgroundColor3=bg;btn.Parent=gui;corner(btn,8)
local pop=Instance.new("Frame")
pop.Name="ServiceInstructions";pop.BackgroundColor3=bg
pop.Size=UDim2.fromOffset(274,186);pop.Position=UDim2.new(1,-286,0,89)
pop.BorderSizePixel=0;pop.Visible=false;pop.Parent=gui;corner(pop,12)
label(pop,"LIVING CITY  •  SERVICES",14,UDim2.fromOffset(11,7),
 UDim2.fromOffset(255,23),tint)
label(pop,"HOSPITAL: check in → treatment\nHOTEL: book room → rest\nAIRPORT: check in → boarding transfer\nPOLICE / CIVIL DEFENCE: accept road rescue\nACCIDENT: inspect → clear → repair\nUse E when near a service desk.\nSearch for these places in MAP / M.",11,
 UDim2.fromOffset(11,33),UDim2.new(1,-18,1,-39),fg)
btn.Activated:Connect(function() pop.Visible=not pop.Visible end)
UIS.InputBegan:Connect(function(input,processed)
 if processed or UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.L then pop.Visible=not pop.Visible end
end)
local news=Instance.new("Frame")
news.Name="CityServiceFeedback";news.Size=UDim2.fromOffset(310,65)
news.AnchorPoint=Vector2.new(.5,0);news.Position=UDim2.new(.5,0,0,67)
news.BackgroundColor3=bg;news.BackgroundTransparency=.06
news.BorderSizePixel=0;news.Parent=gui;news.Visible=false
corner(news,11)
local h=label(news,"CITY SERVICES",13,UDim2.fromOffset(10,4),
 UDim2.new(1,-20,0,22),tint)
local body=label(news,"",11,UDim2.fromOffset(10,24),
 UDim2.new(1,-20,1,-27),fg)
local route=Instance.new("Frame")
route.Name="ServiceRoute";route.AnchorPoint=Vector2.new(1,1)
route.Position=UDim2.new(1,-11,1,-58);route.Size=UDim2.fromOffset(205,39)
route.BackgroundColor3=bg;route.Parent=gui;route.Visible=false;corner(route,9)
local routeText=label(route,"",10,UDim2.fromOffset(8,4),
 UDim2.new(1,-15,1,-8),tint)
local destination=nil
local destinationName=nil
local revision=0
remote.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" then return end
 if typeof(data.title)~="string" or typeof(data.message)~="string" then return end
 if #data.message>280 then return end
 h.Text=data.title;body.Text=data.message
 news.Visible=true
 revision=revision+1
 local token=revision
 task.delay(7,function()
  if news.Parent and revision==token then news.Visible=false end
 end)
 if typeof(data.destination)=="Vector3" then
  destination=data.destination
  destinationName=data.destinationName or "Your destination"
 else
  destination=nil
  destinationName=nil
  route.Visible=false
 end
end)
task.spawn(function()
 while gui.Parent do
  task.wait(.35)
  local character=player.Character
  local playerRoot=character and character:FindFirstChild("HumanoidRootPart")
  if destination and playerRoot then
   local diff=destination-playerRoot.Position
   local dist=Vector2.new(diff.X,diff.Z).Magnitude
   route.Visible=true
   routeText.Text=string.format("SERVICE GPS • %s\n%d studs away",
    destinationName or "City destination",math.floor(dist))
   if dist<22 then routeText.Text="You've reached: "..(destinationName or "Destination") end
  else
   route.Visible=false
  end
 end
end)
print("[UAE v5.5] Compact City Life HUD running; press L for service instructions")

]========])
world:SetAttribute("InstalledVersion","5.5")
print("UAE CITY LIFE v5.5 INSTALLED: 38 map places, five enterable service areas, functional check-in, 4-step road rescue, upgraded traffic and R15 people.")
print("Remember: buildings/NPCs/traffic are generated by server scripts when PLAY starts; do not expect them all to appear in Edit mode.")
