-- UAE CITY LIFE | VERSION 5.4 DUBAI ATLAS + MAJOR ROLEPLAY EXPANSION
-- Use Roblox Studio's COMMAND BAR in EDIT mode. STOP Play first. Backup v5.3.
-- IMPORTANT: does NOT recreate v4/v5/v5.2 city or delete other districts.
-- The GPS map matches our fictional ROBLOX layout, not actual Dubai street geography.
local W=game:GetService("Workspace")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer")
local RS=game:GetService("ReplicatedStorage")
local world=W:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase52_RoleplayDistrict"),
 "Open your saved v5.3 place (with the V5.2 roleplay district) in EDIT mode.")
assert(world:FindFirstChild("Phase53CommunityPark"),
 "Version 5.3 Community Park not detected. Open the saved v5.3 game first.")
-- v5.4 is safe to reapply if needed; only v5.4-owned instances are replaced.
local old=world:FindFirstChild("Phase54_CityExpansion")
if old then old:Destroy() end
local expansion=Instance.new("Folder")
expansion.Name="Phase54_CityExpansion"
expansion.Parent=world
local function replace(class,parent,name,source)
 local previous=parent:FindFirstChild(name)
 if previous then previous:Destroy() end
 local obj=Instance.new(class)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
 return obj
end
local client=SP:WaitForChild("StarterPlayerScripts")
-- Only remove redundant OLD camera and HUD clients.
for _,name in ipairs({
 "UAE_Phase4Camera","UAE_Phase5Camera","UAE_Phase51Camera",
 "UAE_V52_Camera","UAE_V53_Camera","UAE_V54_Camera",
 "UAE_Phase5HUD","UAE_Phase51HUD","UAE_V52_HUD","UAE_V54_MapHUD",
}) do
 local previous=client:FindFirstChild(name)
 if previous then previous:Destroy() end
end
replace("ModuleScript",RS,"UAE_V54_Locations",[========[
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
 {id="MED",name="Dubai Medical Centre",category="Services",position=Vector3.new(-235,5,-1175),description="Medical facility on E11"},
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
replace("Script",SS,"UAE_V54_DistrictBuilder",[========[
-- UAE City Life v5.4: improved public-service and tourism districts.
-- The game is a Dubai-inspired schematic city, NOT a geographically exact Dubai twin.
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase54_CityExpansion")
local Lighting=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local P={
 sand=rgb(201,183,150),white=rgb(237,239,229),dark=rgb(31,48,57),
 stone=rgb(172,183,177),silver=rgb(158,169,175),glass=rgb(90,160,180),
 light=rgb(242,220,177),green=rgb(57,135,99),blue=rgb(55,123,159),
 navy=rgb(29,78,104),amber=rgb(220,177,79),red=rgb(176,53,57),
 road=rgb(48,57,64),wood=rgb(139,107,75),palm=rgb(35,124,67),
 grey=rgb(117,134,141),gold=rgb(224,181,94),
}
local function group(name)
 local f=Instance.new("Folder")
 f.Name=name
 f.Parent=root
 return f
end
local function part(parent,name,size,x,y,z,col,mat,collision)
 local v=Instance.new("Part")
 v.Name=name
 v.Size=size
 v.Position=Vector3.new(x,y,z)
 v.Anchored=true
 v.Color=col or P.white
 v.Material=mat or Enum.Material.SmoothPlastic
 v.CanCollide=collision==true
 v.TopSurface=Enum.SurfaceType.Smooth
 v.BottomSurface=Enum.SurfaceType.Smooth
 v.Parent=parent
 return v
end
local function plaque(parent,name,x,y,z,w,h,text,bg,front)
 local p=part(parent,name,Vector3.new(w,h,.5),x,y,z,bg or P.dark,Enum.Material.Metal,false)
 local g=Instance.new("SurfaceGui")
 g.Name="EnglishArabicSign"
 g.PixelsPerStud=35
 g.Face=front and Enum.NormalId.Front or Enum.NormalId.Back
 g.Parent=p
 local l=Instance.new("TextLabel")
 l.Name="Text"
 l.Text=text
 l.Size=UDim2.fromScale(1,1)
 l.Font=Enum.Font.GothamBold
 l.TextColor3=P.white
 l.TextScaled=true
 l.TextWrapped=true
 l.BackgroundTransparency=1
 l.Parent=g
 return p
end
local function lamp(parent,x,z)
 part(parent,"Streetlamp steel post",Vector3.new(.7,18,.7),x,9,z,P.silver,Enum.Material.Metal,false)
 local head=part(parent,"Streetlamp gold LED",Vector3.new(3,.5,2),x+1,18,z,P.light,Enum.Material.Neon,false)
 local point=Instance.new("PointLight")
 point.Name="UAE54NightLight"
 point.Brightness=1.1
 point.Range=28
 point.Enabled=false
 point.Color=P.light
 point.Parent=head
end
local function palm(parent,x,z,h)
 part(parent,"Palm bark",Vector3.new(2.6,h,2.6),x,h/2+.8,z,P.wood,Enum.Material.Wood,false)
 for leaf=1,5 do
  local a=(leaf-1)*math.pi*2/5
  local l=part(parent,"Palm crown frond",Vector3.new(15,1.2,4),
   x+5*math.cos(a),h+.8,z+5*math.sin(a),P.palm,Enum.Material.Grass,false)
  l.CFrame=CFrame.new(l.Position)*CFrame.Angles(0,-a,math.rad(leaf%2==0 and 7 or -7))
 end
end
local function building(parent,name,x,z,wide,deep,height,col,accent,signText,front)
 local m=Instance.new("Model")
 m.Name=name
 m.Parent=parent
 part(m,"Main reinforced building",Vector3.new(wide,height,deep),
  x,height/2+.7,z,col,Enum.Material.Concrete,true)
 part(m,"Metal roof cap",Vector3.new(wide+4,1.3,deep+3),
  x,height+1,z,P.stone,Enum.Material.Metal,false)
 -- side/glass facade ribbons emphasize the architecture without hundreds of bricks.
 local signZ=front and z-deep/2-.6 or z+deep/2+.6
 for floor=1,math.max(1,math.floor(height/12)-1) do
  local yy=5+floor*10
  for _,dx in ipairs({-wide*.25,wide*.25}) do
   local gl=part(m,"Blue double glazing",Vector3.new(wide*.34,5,.35),
    x+dx,yy,signZ,P.glass,Enum.Material.Glass,false)
   gl.Transparency=.14
  end
 end
 plaque(m,"Bilingual front sign",x,height*.52,signZ+(front and -.5 or .5),
  wide*.78,6.4,signText,accent,front)
 part(m,"Entrance awning",Vector3.new(wide*.5,1.1,6),
  x,6,signZ+(front and -4 or 4),accent,Enum.Material.Metal,false)
 for _,dx in ipairs({-wide*.25,wide*.25}) do
  part(m,"Architectural metal column",Vector3.new(1.2,height*.65,1),
   x+dx,height*.36,signZ,P.silver,Enum.Material.Metal,false)
 end
 return m
end
local function vehicle(parent,name,x,z,tint,roofText)
 local m=Instance.new("Model")
 m.Name=name
 m.Parent=parent
 part(m,"Chassis undercarriage",Vector3.new(9.8,1.1,19),x,3,z,P.dark,Enum.Material.Metal,false)
 part(m,"Painted vehicle body",Vector3.new(10,3,19),x,4.5,z,tint,Enum.Material.Metal,false)
 part(m,"Sloped front bonnet",Vector3.new(9.5,1.1,6),x,6,z-6,tint,Enum.Material.Metal,false)
 part(m,"Passenger cabin",Vector3.new(8.8,2.7,9),x,7,z+1,P.glass,Enum.Material.Glass,false)
 part(m,"Car roof",Vector3.new(9.2,.75,9.4),x,8.6,z+1,tint,Enum.Material.Metal,false)
 for _,side in ipairs({-1,1}) do
  for _,dz in ipairs({-6.5,6.5}) do
   local wheel=part(m,"VERTICAL rubber wheel",Vector3.new(1.7,4.3,4.3),
    x+side*5.1,2.5,z+dz,rgb(25,28,32),Enum.Material.Rubber,false)
   wheel.Shape=Enum.PartType.Cylinder
   local rim=part(m,"Silver wheel hub",Vector3.new(.25,2.6,2.6),
    x+side*6.04,2.5,z+dz,P.silver,Enum.Material.Metal,false)
   rim.Shape=Enum.PartType.Cylinder
  end
  part(m,"White LED headlights",Vector3.new(2.5,.6,.4),
   x+side*3,5,z-9.65,P.light,Enum.Material.Neon,false)
  part(m,"Red rear lights",Vector3.new(2,.6,.4),
   x+side*3,5,z+9.65,P.red,Enum.Material.Neon,false)
 end
 if roofText then
  local roof=plaque(m,"Vehicle fleet identification",x,9.9,z+.5,7,2,roofText,P.white,true)
 end
 return m
end
-- Public Safety Avenue, newly developed on the far western side of the city.
local civic=group("WestDubaiPublicServiceDistrict")
part(civic,"Public Safety Avenue",Vector3.new(42,1,490),-940,.5,-680,P.road,Enum.Material.Asphalt,true)
for z=-905,-440,30 do
 part(civic,"Centre line lane marking",Vector3.new(1,.1,13),-940,1.1,z,P.white,nil,false)
end
for _,x in ipairs({-974,-905}) do
 part(civic,"Polished footpath",Vector3.new(13,1,490),x,.8,-680,P.stone,Enum.Material.Concrete,true)
end
building(civic,"Dubai Community Police",-1015,-480,100,78,39,P.white,P.navy,
 "DUBAI POLICE  |  شرطة دبي",false)
building(civic,"Dubai Civil Defence",-1015,-630,100,75,36,P.sand,P.red,
 "CIVIL DEFENCE  |  الدفاع المدني",false)
local parkPad=part(civic,"West Dubai community gardens ground",Vector3.new(125,1.7,110),
 -940,1.4,-890,P.green,Enum.Material.Grass,true)
part(civic,"Community gardens walkway",Vector3.new(100,.25,11),-940,2.5,-890,P.white,Enum.Material.Concrete,false)
for _,x in ipairs({-980,-940,-900}) do
 palm(civic,x,-865,14)
 palm(civic,x,-924,17)
end
plaque(civic,"Public Services Wayfinder",-940,12,-708,65,8,
 "POLICE  •  CIVIL DEFENCE  •  PARK",P.dark,false)
local fleet=group("CommunityServiceFleet")
vehicle(fleet,"Dubai white and green police sedan",-995,-418,P.white,"POLICE")
vehicle(fleet,"Dubai Police patrol SUV",-1018,-420,P.navy,"شرطة")
vehicle(fleet,"Civil Defence yellow response car",-1000,-694,P.amber,"FIRE")
vehicle(fleet,"Civil Defence support vehicle",-1020,-693,P.red,"الدفاع")
for z=-865,-445,75 do lamp(civic,-906,z) end
-- Airport arrivals area, with taxi stands, airport signage, passenger shelter.
local terminal=group("DubaiInternationalArrivals")
part(terminal,"Arrival forecourt pavement",Vector3.new(170,1.2,78),
 -975,1,-1128,P.stone,Enum.Material.Concrete,true)
part(terminal,"Taxi stand asphalt",Vector3.new(155,.75,25),
 -975,1.3,-1174,P.road,Enum.Material.Asphalt,true)
building(terminal,"Airport Visitor Services",-960,-1100,120,45,23,P.white,P.navy,
 "DXB ARRIVALS  •  الوصول",false)
plaque(terminal,"Airport taxi wayfinding",-1000,14,-1166,55,7,
 "AIRPORT TAXI  |  تاكسي المطار",P.navy,true)
for _,x in ipairs({-1025,-990,-955,-920}) do
 part(terminal,"Airport taxi bay marker",Vector3.new(1,.12,17),
  x,1.78,-1174,P.white,nil,false)
end
vehicle(terminal,"Airport taxi display",-1015,-1175,P.sand,"TAXI")
vehicle(terminal,"Airport visitor taxi",-970,-1175,P.white,"TAXI")
for _,x in ipairs({-1045,-980,-915}) do
 palm(terminal,x,-1086,15)
 lamp(terminal,x,-1160)
end
-- Dubai Marina and Jumeirah outdoor tourism improvements.
local coast=group("MarinaAndJumeirahPublicSpaces")
part(coast,"Marina tourist promenade",Vector3.new(38,1,240),
 1074,4,-1370,P.stone,Enum.Material.Concrete,true)
part(coast,"Cruise arrival garden",Vector3.new(84,.8,92),
 1000,4.4,-1470,P.green,Enum.Material.Grass,true)
building(coast,"Dubai Cruise Visitor Centre",990,-1490,92,54,20,P.white,P.navy,
 "CRUISE TERMINAL  |  ميناء الرحلات",false)
plaque(coast,"Marina tourist information",1054,16,-1260,57,7,
 "DUBAI MARINA  •  YACHT HARBOUR",P.navy,false)
for _,z in ipairs({-1470,-1400,-1330,-1260,-1190}) do
 palm(coast,1062,z,13)
 lamp(coast,1090,z)
end
-- Jumeirah Beach walk in a separate beachfront zone, away from earlier Burj Al Arab island.
part(coast,"Jumeirah landscaped sand",Vector3.new(190,1,130),
 1050,1,-720,P.sand,Enum.Material.Sand,true)
part(coast,"Jumeirah coastal footpath",Vector3.new(190,.45,18),
 1050,2.1,-720,P.white,Enum.Material.Concrete,true)
plaque(coast,"Beach walk sign",1050,13,-760,87,7,
 "JUMEIRAH BEACH WALK  |  شاطئ جميرا",P.navy,true)
for _,x in ipairs({990,1035,1080,1125}) do
 palm(coast,x,-690,12)
end
-- Sightseeing helipad is static scenery; no misleading claim of pilotable aircraft.
local heli=group("WestDubaiHelicopterLookout")
part(heli,"Aviation sightseeing observation pad",Vector3.new(105,1.6,95),
 -1060,2,-790,P.stone,Enum.Material.Concrete,true)
local circle=part(heli,"Helipad H landing circle",Vector3.new(.8,52,52),
 -1050,2.9,-790,P.dark,Enum.Material.Metal,false)
circle.Shape=Enum.PartType.Cylinder
circle.CFrame=circle.CFrame*CFrame.Angles(0,0,math.pi/2)
part(heli,"Helipad central H mark",Vector3.new(27,.1,5),
 -1050,3.45,-790,P.white,Enum.Material.Neon,false)
plaque(heli,"Scenic helipad sign",-1090,13,-841,82,8,
 "HELICOPTER SIGHTSEEING  •  VIEWING AREA",P.dark,false)
for _,x in ipairs({-1095,-1025}) do lamp(heli,x,-831) end
-- Tourist wayfinding on already-existing E11; decorative and noncollidable.
local street=group("E11StreetFurnitureAndLighting")
for _,z in ipairs({-1430,-1360,-1280,-1160,-1080,-1000}) do
 for _,x in ipairs({-92,92}) do
  lamp(street,x,z)
 end
end
plaque(street,"Hospital direction board",-145,13,-1165,66,7,
 "HOSPITAL  •  المستشفى",P.navy,false)
plaque(street,"Metro direction board",130,13,-1245,66,7,
 "METRO  •  مترو دبي",P.navy,false)
plaque(street,"Museum direction board",220,13,-1120,70,7,
 "MUSEUM OF THE FUTURE",P.navy,false)
-- Small skyline accent lighting and paved public plazas around existing icons.
local landmark=group("LandmarkPublicPlazas")
part(landmark,"Museum blue entrance path",Vector3.new(22,.4,106),
 315,3,-1115,P.stone,Enum.Material.Marble,false)
part(landmark,"Frame visitor queue path",Vector3.new(19,.4,70),
 -770,1.8,-739,P.stone,Enum.Material.Concrete,false)
part(landmark,"Downtown entrance plaza",Vector3.new(112,.5,36),
 24,1,-342,P.stone,Enum.Material.Concrete,false)
for _,x in ipairs({-65,-20,25,70}) do
 lamp(landmark,x,-342)
end
-- Tie in night light state without modifying v4/5 day-night logic.
task.spawn(function()
 while root.Parent do
  local hour=RS:GetAttribute("UAECycleHour")
  local night=typeof(hour)=="number" and (hour>=18 or hour<6)
  for _,obj in ipairs(root:GetDescendants()) do
   if obj:IsA("PointLight") and obj.Name=="UAE54NightLight" then
    obj.Enabled=night
   end
  end
  task.wait(7)
 end
end)
print("UAE v5.4 world: public services, airport arrivals, coastline, parkland, streetlights and signposts built")

]========])
replace("Script",SS,"UAE_V54_MissionService",[========[
-- UAE City Life v5.4: SERVER-controlled missions and temporary rewards.
-- 10 non-combat routes, all targets chosen from the in-game landmark catalogue.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local function remote(name)
 local found=RS:FindFirstChild(name)
 if found then return found end
 local new=Instance.new("RemoteEvent")
 new.Name=name
 new.Parent=RS
 return new
end
local request=remote("UAE_V54_MissionRequest")
local updates=remote("UAE_V54_MissionUpdate")
local missions={
 {id="MEDIC",title="Ambulance Assistance",reward=110,
  description="Community clinic checks and medical assistance.",
  stops={"CLINIC","MED","PARK"}},
 {id="POLICE",title="Dubai Police Community Patrol",reward=120,
  description="Visit the precinct, market and Dubai Frame.",
  stops={"POLICE","MARKET","FRAME"}},
 {id="FIRE",title="Civil Defence Safety Inspection",reward=120,
  description="Inspect the fire station and major shopping areas.",
  stops={"FIRE","SOUK","SHOP"}},
 {id="AIRPORT",title="Dubai Airport Shuttle",reward=120,
  description="Carry a simulated passenger from homes to DXB.",
  stops={"HOMES","DXB","ARRIVE"}},
 {id="SIGHTS",title="Dubai Landmark Photo Trail",reward=160,
  description="Visit iconic landmarks around the city.",
  stops={"BURJ","MUSEUM","FRAME","ARAB"}},
 {id="MARINA",title="Marina Safety Volunteer",reward=110,
  description="Visit the marina, cruise port and beach walk.",
  stops={"MARINA","CRUISE","BEACH"}},
 {id="DELIVERY",title="Karak & Grocery Delivery",reward=90,
  description="Deliver a simulated order through neighbourhood stops.",
  stops={"KARAK","MARKET","HOMES"}},
 {id="METRO",title="Public Transport Explorer",reward=140,
  description="Ride the city on foot between metro, E11 and airport.",
  stops={"METRO","E11","MUSEUM","DXB"}},
 {id="HEALTH",title="Dubai Healthcare Checkup",reward=100,
  description="Visit the hospital, clinic and community park.",
  stops={"MED","CLINIC","PARK"}},
 {id="CLEANUP",title="Community Park Volunteer",reward=90,
  description="Help with simulated city park and beach checks.",
  stops={"PARK","GARDEN","BEACH"}},
}
local byId={}
for _,mission in ipairs(missions) do
 byId[mission.id]=mission
 for _,id in ipairs(mission.stops) do
  assert(locations.ById[id],"Unknown mission target: "..id)
 end
end
local sessions={}
local lastRequest={}
local function tell(player,message)
 if player.Parent==Players then updates:FireClient(player,message) end
end
local function currentStep(player,prefix)
 local state=sessions[player]
 if not state then return end
 local mission=byId[state.id]
 local loc=locations.ById[mission.stops[state.stage]]
 tell(player,{
  state="active",
  id=mission.id,title=mission.title,
  stage=state.stage,total=#mission.stops,
  destinationId=loc.id,destinationName=loc.name,
  destinationPosition=loc.position,
  reward=mission.reward,
  message=prefix or ("Visit "..loc.name),
 })
end
local function start(player,id)
 local mission=byId[id]
 if not mission then return end
 sessions[player]={id=mission.id,stage=1,activated=os.clock()}
 currentStep(player,"New mission: "..mission.title)
end
local function canRequest(player)
 local now=os.clock()
 if lastRequest[player] and now-lastRequest[player]<.7 then return false end
 lastRequest[player]=now
 return true
end
request.OnServerEvent:Connect(function(player,kind,id)
 if typeof(kind)~="string" or #kind>20 then return end
 if typeof(id)~="string" or #id>20 then return end
 if not canRequest(player) then return end
 if kind=="Start" then
  start(player,id)
 elseif kind=="Cancel" then
  sessions[player]=nil
  tell(player,{state="cancelled",message="Mission cancelled."})
 elseif kind=="Status" then
  currentStep(player,"Current mission in progress")
 end
end)
local function addPoints(player,points)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then
  stats=Instance.new("Folder")
  stats.Name="leaderstats"
  stats.Parent=player
 end
 local score=stats:FindFirstChild("CityPoints")
 if not score then
  score=Instance.new("IntValue")
  score.Name="CityPoints"
  score.Parent=stats
 end
 score.Value=score.Value+points
end
task.spawn(function()
 while true do
  for player,state in pairs(sessions) do
   local def=byId[state.id]
   local loc=def and locations.ById[def.stops[state.stage]]
   local character=player.Character
   local hum=character and character:FindFirstChildOfClass("Humanoid")
   local root=character and character:FindFirstChild("HumanoidRootPart")
   if not player.Parent or not def or not loc then
    sessions[player]=nil
   elseif root and hum and hum.Health>0 and os.clock()-state.activated>2.25 then
    -- horizontal radius allows destinations underneath elevated stations.
    local delta=Vector2.new(root.Position.X-loc.position.X,
     root.Position.Z-loc.position.Z)
    if delta.Magnitude<=36 then
     state.stage=state.stage+1
     state.activated=os.clock()
     if state.stage>#def.stops then
      sessions[player]=nil
      addPoints(player,def.reward)
      tell(player,{state="complete",id=def.id,
       message=def.title.." completed! +"..def.reward.." CityPoints."})
     else
      currentStep(player,"Checkpoint reached. Travel to the next destination.")
     end
    end
   end
  end
  task.wait(1)
 end
end)
Players.PlayerRemoving:Connect(function(player)
 sessions[player]=nil
 lastRequest[player]=nil
end)
print("UAE v5.4 mission service: "..#missions.." routes ready")

]========])
replace("LocalScript",client,"UAE_V54_MapHUD",[========[
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
gui.DisplayOrder=27
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
local mapFooter=text(panel,"Footer","Red = your location • Gold = selected • Map shows in-game distances",
 UDim2.new(0,13,1,-43),UDim2.new(1,-24,0,22),11,C.sand,54)
local confirm=button(panel,"KeepWaypoint","KEEP GPS",UDim2.new(1,-100,1,-41),
 UDim2.fromOffset(85,26),C.teal,55)
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
print("[UAE v5.4] City Atlas started; 32 destinations, GPS guide and 10 missions")

]========])
replace("LocalScript",client,"UAE_V54_Camera",[========[
-- UAE CITY LIFE v5.4: I/O zoom best effort plus reliable =/- keyboard fallback and screen buttons.
-- I = zoom in, O = zoom out. Mousewheel is intentionally NOT used for zoom.
-- ContextActionService has higher input priority than default Roblox camera keys.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local RS=game:GetService("RunService")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V54_CameraControls"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=42
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(19,45,56)
local fg=Color3.fromRGB(250,238,216)
local function control(name,caption,y)
 local b=Instance.new("TextButton")
 b.Name=name
 b.AnchorPoint=Vector2.new(1,0)
 b.Position=UDim2.new(1,-12,.5,y) -- anchored to live viewport center, not absolute screen pixels
 b.Size=UDim2.fromOffset(40,34)
 b.BackgroundColor3=bg
 b.BackgroundTransparency=.1
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.Text=caption
 b.TextSize=17
 b.Font=Enum.Font.GothamBold
 b.TextColor3=fg
 b.Parent=gui
 local rounded=Instance.new("UICorner")
 rounded.CornerRadius=UDim.new(0,8)
 rounded.Parent=b
 return b
end
local zoomIn=control("ZoomIn_I","I +",-57)
local zoomOut=control("ZoomOut_O","O −",-17)
local reset=control("CameraReset","C",23)
local info=Instance.new("TextLabel")
info.Name="CameraHelp"
info.AnchorPoint=Vector2.new(1,0)
info.Position=UDim2.new(1,-59,.5,-57)
info.Size=UDim2.fromOffset(130,74)
info.BackgroundColor3=bg
info.BackgroundTransparency=.15
info.BorderSizePixel=0
info.TextColor3=fg
info.Font=Enum.Font.GothamMedium
info.TextSize=12
info.TextWrapped=true
info.Text="I / O  (or = / -)\nRight-drag LOOK\nCAM 20 studs"
info.Parent=gui
local c=Instance.new("UICorner")
c.CornerRadius=UDim.new(0,8)
c.Parent=info

local dist=20
local yaw=0
local pitch=math.rad(16)
local mouseHeld=false
local modeWas=""
local initialized=false
local nextRepeat=0
local lastKeyPressAt=-10
local lastKeyPressed=nil
local sentKeyDiagnostic=false
print("[UAE v5.4] Camera started: I/O best effort, =/- fallback, touch buttons and right-drag look")
local function state()
 local ch=player.Character
 local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 local seat=hum and hum.SeatPart
 local car=nil
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then car=model end
 end
 return ch,hum,root,car
end
local function zoom(inward)
 local _,_,_,car=state()
 dist=math.clamp(dist*(inward and .84 or 1.2),car and 12 or 5,car and 100 or 75)
 info.Text=string.format("I / O  or = / -\nRight-drag LOOK\nCAM %d studs",math.round(dist))
end
local function defaultView()
 dist=20
 yaw=0
 pitch=math.rad(16)
 info.Text="I / O  •  ZOOM\nRight-drag • LOOK\nCAM 20 studs"
end
zoomIn.Activated:Connect(function() zoom(true) end)
zoomOut.Activated:Connect(function() zoom(false) end)
reset.Activated:Connect(defaultView)
-- Keyboard action handlers take priority over Roblox's default I/O camera bindings.
local function pressKey(keyCode)
 if UIS:GetFocusedTextBox() then return end
 if not sentKeyDiagnostic then
  sentKeyDiagnostic=true
  print("[UAE v5.4] Keyboard camera input received:",keyCode.Name)
 end
 local now=os.clock()
 if lastKeyPressed==keyCode and now-lastKeyPressAt<.14 then return end
 lastKeyPressAt=now
 lastKeyPressed=keyCode
 zoom(keyCode==Enum.KeyCode.I or keyCode==Enum.KeyCode.Equals)
 nextRepeat=now+.28
end
local function onKeyboard(actionName,inputState)
 if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
 if inputState==Enum.UserInputState.Begin then
  pressKey(actionName=="UAE_V54_ZoomIn" and Enum.KeyCode.I or Enum.KeyCode.O)
 end
 return Enum.ContextActionResult.Sink
end
pcall(function() CAS:UnbindAction("UAE_V53_ZoomIn") end)
pcall(function() CAS:UnbindAction("UAE_V53_ZoomOut") end)
CAS:BindActionAtPriority("UAE_V54_ZoomIn",onKeyboard,false,8000,Enum.KeyCode.I,Enum.KeyCode.Equals)
CAS:BindActionAtPriority("UAE_V54_ZoomOut",onKeyboard,false,8000,Enum.KeyCode.O,Enum.KeyCode.Minus)
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=true end
 if UIS:GetFocusedTextBox() then return end
 -- Fallback for keyboard layouts / CoreScript priority differences.
 if input.KeyCode==Enum.KeyCode.I or input.KeyCode==Enum.KeyCode.O or
 input.KeyCode==Enum.KeyCode.Equals or input.KeyCode==Enum.KeyCode.Minus then
  pressKey(input.KeyCode)
 end
 if processed then return end
 if input.KeyCode==Enum.KeyCode.C then defaultView()
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(9),math.rad(5),math.rad(77))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(9),math.rad(5),math.rad(77))
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=false end
end)
UIS.WindowFocusReleased:Connect(function() mouseHeld=false end)
UIS.InputChanged:Connect(function(input)
 -- Mouse movement rotates the camera while the right button is held.
 -- The scroll wheel is NOT bound to zoom, as requested.
 if mouseHeld and input.UserInputType==Enum.UserInputType.MouseMovement then
  yaw=yaw-input.Delta.X*.008
  pitch=math.clamp(pitch+input.Delta.Y*.005,math.rad(5),math.rad(77))
 end
end)
pcall(function() RS:UnbindFromRenderStep("UAE_V52_KBZoomCamera") end)
pcall(function() RS:UnbindFromRenderStep("UAE_V53_OrbitCamera") end)
pcall(function() RS:UnbindFromRenderStep("UAE_V54_OrbitCamera") end)
RS:BindToRenderStep("UAE_V54_OrbitCamera",Enum.RenderPriority.Camera.Value+90,function(dt)
 local camera=workspace.CurrentCamera
 local ch,hum,root,car=state()
 if not camera or not root or not hum or hum.Health<=0 then
  if camera then camera.CameraType=Enum.CameraType.Custom end
  initialized=false
  return
 end
 local mode=car and "Car" or "Walk"
 if mode~=modeWas then
  modeWas=mode
  initialized=false
  dist=car and 37 or 20
  info.Text=string.format("I / O  •  ZOOM\nRight-drag • LOOK\nCAM %d studs",dist)
 end
 if not UIS:GetFocusedTextBox() and os.clock()>nextRepeat then
  if UIS:IsKeyDown(Enum.KeyCode.I) or UIS:IsKeyDown(Enum.KeyCode.Equals) then
   zoom(true);nextRepeat=os.clock()+.12
  elseif UIS:IsKeyDown(Enum.KeyCode.O) or UIS:IsKeyDown(Enum.KeyCode.Minus) then
   zoom(false);nextRepeat=os.clock()+.12
  end
 end
 local basis=car and car:GetPivot() or root.CFrame
 local height=car and 5.8 or 2.6
 local focus=(basis*CFrame.new(0,height,0)).Position
 local behind=basis*CFrame.Angles(0,yaw,0)
 local desired=(behind*CFrame.new(0,height+dist*math.sin(pitch),
  dist*math.cos(pitch))).Position
 local ray=desired-focus
 if ray.Magnitude<.2 then return end
 local param=RaycastParams.new()
 param.FilterType=Enum.RaycastFilterType.Exclude
 param.FilterDescendantsInstances=car and {ch,car} or {ch}
 param.IgnoreWater=true
 local hit=workspace:Raycast(focus,ray,param)
 if hit then desired=hit.Position-ray.Unit*1.3 end
 camera.CameraType=Enum.CameraType.Scriptable
 local goal=CFrame.lookAt(desired,focus)
 camera.CFrame=initialized and camera.CFrame:Lerp(goal,math.clamp(dt*12,0,1)) or goal
 camera.Focus=CFrame.new(focus)
 camera.FieldOfView=70
 initialized=true
end)

]========])
world:SetAttribute("InstalledVersion","5.4")
print("UAE CITY LIFE v5.4 INSTALLED: 32-place city atlas, mission browser, GPS navigation, expanded city services and camera keys.")
print("Save a NEW v5.4 .rbxl in Edit mode, then press Play. New World districts generate on the server in Play mode.")
