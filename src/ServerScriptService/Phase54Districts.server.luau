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
