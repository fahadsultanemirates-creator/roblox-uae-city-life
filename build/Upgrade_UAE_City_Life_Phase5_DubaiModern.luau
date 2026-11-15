-- ROBLOX UAE CITY LIFE: V5 DUBAI MODERN CITY UPGRADE
-- Execute in Roblox Studio Command Bar, in EDIT MODE ONLY, after v4.
-- Your v4 backup remains unchanged. v5 generates its own folder and runtime scripts.
-- Set PERFORMANCE_MODE=true for an older Dell laptop.
local PERFORMANCE_MODE=false
local W=game:GetService("Workspace")
local L=game:GetService("Lighting")
local SP=game:GetService("StarterPlayer")
local SS=game:GetService("ServerScriptService")
local world=W:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("EmergencyVehicles"),
 "Please open your existing UAE City Life game (v4) in Studio Edit mode first.")
assert(world:FindFirstChild("Phase4_MegaCity"),
 "This upgrade requires your working v4 place. Keep your v4 .rbxl backup.")
local old=world:FindFirstChild("Phase5_DubaiModern")
if old then old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase5_DubaiModern"
root:SetAttribute("PerformanceMode",PERFORMANCE_MODE)
root.Parent=world

local function RGB(r,g,b) return Color3.fromRGB(r,g,b) end
local C={
 concrete=RGB(213,205,186),warm=RGB(231,219,195),
 sand=RGB(197,168,125),white=RGB(243,244,239),black=RGB(28,32,38),
 glass=RGB(66,141,167),glass2=RGB(101,175,198),
 blue=RGB(18,83,140),red=RGB(186,49,51),gold=RGB(238,190,101),
 asphalt=RGB(41,46,52),stripe=RGB(234,228,210),
 grey=RGB(150,160,158),wood=RGB(119,78,51),
 palm=RGB(35,122,64),neon=RGB(71,174,202),
}
local function folder(parent,name)
 local f=Instance.new("Folder")
 f.Name=name
 f.Parent=parent
 return f
end
local function p(parent,name,size,cf,color,mat,collidable)
 local v=Instance.new("Part")
 v.Name=name
 v.Anchored=true
 v.CanCollide=collidable==true
 v.Size=size
 v.CFrame=cf
 v.Color=color or C.white
 v.Material=mat or Enum.Material.SmoothPlastic
 v.TopSurface=Enum.SurfaceType.Smooth
 v.BottomSurface=Enum.SurfaceType.Smooth
 v.Parent=parent
 return v
end
local function decoText(part,words,face,tint,px)
 local gui=Instance.new("SurfaceGui")
 gui.Name="V5_Text"
 gui.Face=face or Enum.NormalId.Front
 gui.PixelsPerStud=px or 45
 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
 gui.LightInfluence=.05
 gui.Parent=part
 local lbl=Instance.new("TextLabel")
 lbl.Name="Sign"
 lbl.Text=words
 lbl.Font=Enum.Font.GothamBold
 lbl.TextScaled=true
 lbl.TextWrapped=true
 lbl.TextColor3=tint or C.white
 lbl.BackgroundTransparency=1
 lbl.Size=UDim2.fromScale(1,1)
 lbl.Parent=gui
end
local function billboard(parent,words,position)
 local peg=p(parent,"Guide peg",Vector3.new(.2,.2,.2),CFrame.new(position),C.white,nil,false)
 peg.Transparency=1
 local g=Instance.new("BillboardGui")
 g.Name="V5 Guide"
 g.Size=UDim2.fromOffset(175,38)
 g.MaxDistance=128
 g.Adornee=peg
 g.Parent=peg
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.fromScale(1,1)
 lbl.Font=Enum.Font.GothamBold
 lbl.TextScaled=true
 lbl.Text=words
 lbl.TextColor3=C.gold
 lbl.BackgroundColor3=RGB(27,50,59)
 lbl.BackgroundTransparency=.1
 lbl.Parent=g
 local r=Instance.new("UICorner")
 r.CornerRadius=UDim.new(0,7)
 r.Parent=lbl
end
local function makeModel(parent,name,kind)
 local m=Instance.new("Model")
 m.Name=name
 if kind then m:SetAttribute("TransitType",kind) end
 m.Parent=parent
 local a=p(m,"TransitPivot",Vector3.new(.3,.3,.3),CFrame.new(),C.white,nil,false)
 a.Transparency=1
 m.PrimaryPart=a
 return m
end
local function offset(m,name,size,x,y,z,tint,material,rotation)
 return p(m,name,size,CFrame.new(x,y,z)*(rotation or CFrame.new()),tint,material,false)
end

-- GROUND / 7 DISTRICTS: preserve existing world and all four original UAE flags.
local foundation=folder(root,"DubaiSouthExpansion")
p(foundation,"Land for Sheikh Zayed corridor",Vector3.new(2500,1.3,660),
 CFrame.new(-330,-.2,-1210),C.sand,Enum.Material.Sand,true)
local road=folder(root,"SheikhZayedRoadE11")
p(road,"E11 Sheikh Zayed Road",Vector3.new(162,.7,555),
 CFrame.new(0,.42,-1200),C.asphalt,Enum.Material.Asphalt,true)
for _,x in ipairs({-80,80}) do
 p(road,"Pedestrian boulevard pavement",Vector3.new(17,1.3,560),
  CFrame.new(x,.78,-1200),C.concrete,Enum.Material.Concrete,true)
end
p(road,"Central safety divider",Vector3.new(6,1,556),
 CFrame.new(0,.96,-1200),RGB(134,138,128),Enum.Material.Concrete,true)
for _,x in ipairs({-58,-34,-12,12,34,58}) do
 for z=-1460,-948,29 do
  p(road,"Sheikh Zayed dashed lane stripe",Vector3.new(.8,.15,13),
    CFrame.new(x,.88,z),C.stripe,Enum.Material.SmoothPlastic,false)
 end
end
for _,z in ipairs({-1460,-1070}) do
 p(road,"Crossing buffer",Vector3.new(150,.15,2),
  CFrame.new(0,.87,z),C.stripe,nil,false)
end
-- Concrete flyover and traffic signs.
for _,z in ipairs({-1350,-1050}) do
 for _,x in ipairs({-70,70}) do
  p(road,"Overhead gantry mast",Vector3.new(2,22,2),
   CFrame.new(x,11,z),C.grey,Enum.Material.Metal,false)
 end
 p(road,"Overhead motorway beam",Vector3.new(143,1.6,2),
  CFrame.new(0,22,z),C.grey,Enum.Material.Metal,false)
 local plaque=p(road,"E11 road sign",Vector3.new(44,8,1),
  CFrame.new(0,18,z),RGB(26,80,79),Enum.Material.Metal,false)
 decoText(plaque,"E11   SHEIKH ZAYED ROAD\nشارع الشيخ زايد",Enum.NormalId.Back,C.white,35)
 decoText(plaque,"E11   SHEIKH ZAYED ROAD",Enum.NormalId.Front,C.white,35)
end

-- Varied stepped architecture with lobby arcades, glass ribbons and illuminated rooflines.
local modern=folder(root,"SheikhZayedArchitecture")
local rng=Random.new(5050)
local tintChoices={
 RGB(217,218,208),RGB(214,206,191),RGB(192,207,205),
 RGB(200,202,214),RGB(226,208,180),RGB(211,218,219),
}
local function skyscraper(name,x,z,h,w,d,index)
 local g=folder(modern,name)
 local main=tintChoices[(index-1)%#tintChoices+1]
 p(g,"Limestone tower frame",Vector3.new(w,h,d),
  CFrame.new(x,h/2,z),main,Enum.Material.Concrete,true)
 local windowWidth=w-5
 for y=12,h-4,12 do
  p(g,"Blue-green glazed front",Vector3.new(windowWidth,3.3,.55),
   CFrame.new(x,y,z+d/2+.42),C.glass,Enum.Material.Glass,false)
  p(g,"Smoked-glass rear",Vector3.new(windowWidth,3.3,.55),
   CFrame.new(x,y,z-d/2-.42),C.glass2,Enum.Material.Glass,false)
  if not PERFORMANCE_MODE then
   for _,s in ipairs({-1,1}) do
    p(g,"Tinted side window",Vector3.new(.5,3,math.max(5,d-9)),
     CFrame.new(x+s*(w/2+.29),y,z),C.glass,Enum.Material.Glass,false)
   end
  end
 end
 p(g,"Modern entrance canopy",Vector3.new(w*.75,1.3,11),
  CFrame.new(x,8,z+d/2+7),C.grey,Enum.Material.Metal,false)
 p(g,"Glass lobby entrance",Vector3.new(13,8,.6),
  CFrame.new(x,4,z+d/2+.6),C.glass2,Enum.Material.Glass,false)
 p(g,"Roof parapet",Vector3.new(w+1,1.6,d+1),
  CFrame.new(x,h+.8,z),C.grey,Enum.Material.Metal,false)
 if index%3==0 then
  p(g,"Stepped sky penthouse",Vector3.new(w*.55,12,d*.55),
   CFrame.new(x,h+6,z),main,Enum.Material.Concrete,true)
 end
 if index%4==0 then
  p(g,"Rooftop architectural crown",Vector3.new(w*.6,1.2,d*.6),
   CFrame.new(x,h+12.6,z),C.neon,Enum.Material.Neon,false)
 end
 return g
end
local towers={
 {-285,-1430,132,62,48},{-470,-1410,172,64,56},{-680,-1430,118,50,53},
 {-285,-1270,213,58,49},{-510,-1280,146,52,55},{-720,-1250,97,47,50},
 {-460,-1090,189,60,50},{-665,-1070,134,63,45},
 {480,-1430,196,54,49},{660,-1390,132,65,52},{840,-1430,155,55,47},
 {490,-1270,210,60,49},{690,-1240,113,57,55},
 {520,-1070,182,62,56},{770,-1090,154,58,52},
}
for i,t in ipairs(towers) do
 if not PERFORMANCE_MODE or i%2==1 then
  skyscraper("SZR Modern Tower "..i,t[1],t[2],t[3],t[4],t[5],i)
 end
end
billboard(modern,"SHEIKH ZAYED ROAD",Vector3.new(0,44,-1135))
-- Upgrade original iconic Burj Khalifa tier materials without deleting its tower.
for _,item in ipairs(world:GetDescendants()) do
 if item:IsA("BasePart") and item.Name:find("Burj Khalifa %- tier") then
  item.Material=Enum.Material.Glass
  item.Color=RGB(90,146,172)
  item.Reflectance=.1
 end
end

-- Museum of the Future-inspired oval landmark: procedural ring. Stylized, not copied mesh.
local museum=folder(root,"MuseumOfTheFuture")
local mx,mz=315,-1180
p(museum,"Museum stone plaza",Vector3.new(150,3.5,128),
 CFrame.new(mx,1.4,mz),C.warm,Enum.Material.Concrete,true)
local ellipseA,ellipseB=48,66
local segCount=PERFORMANCE_MODE and 20 or 36
local function ellipse(i)
 local angle=2*math.pi*i/segCount
 return Vector3.new(mx+ellipseA*math.cos(angle),
  78+ellipseB*math.sin(angle),mz)
end
for i=1,segCount do
 local a,b=ellipse(i-1),ellipse(i)
 local delta=b-a
 local cf=CFrame.lookAt((a+b)*.5,b,Vector3.new(0,0,1))
 local ring=p(museum,"Museum curved stainless-steel arc",Vector3.new(13,12,delta.Magnitude+3.3),
  cf,RGB(207,218,216),Enum.Material.Metal,true)
 ring.Reflectance=.22
 if i%3==0 then
  local inner=p(museum,"Museum azure glass highlight",Vector3.new(2,11,delta.Magnitude),
   cf*CFrame.new(0,0,-1),RGB(86,168,182),Enum.Material.Glass,false)
 end
end
local museumName=p(museum,"Museum Arabic signage",Vector3.new(77,11,2),
 CFrame.new(mx,10,mz+67),RGB(32,68,77),Enum.Material.Metal,false)
decoText(museumName,"متحف المستقبل  |  MUSEUM OF THE FUTURE",
 Enum.NormalId.Front,C.gold,42)
billboard(museum,"MUSEUM OF THE FUTURE",Vector3.new(mx,160,mz))

-- Additional recognizable Dubai sights, built from stylized original parts.
local frameArea=folder(root,"DubaiFrameLandmark")
local frameX,frameZ=-770,-830
p(frameArea,"Dubai Frame landscaped square",Vector3.new(166,1.4,148),
 CFrame.new(frameX,.9,frameZ),C.warm,Enum.Material.Concrete,true)
for _,side in ipairs({-1,1}) do
 p(frameArea,"Gold Dubai Frame upright",Vector3.new(13,160,13),
 CFrame.new(frameX+side*53,80,frameZ),C.gold,Enum.Material.Metal,true)
 for y=12,155,19 do
  p(frameArea,"Architectural gold detail",Vector3.new(14,.8,13.5),
   CFrame.new(frameX+side*53,y,frameZ),RGB(231,208,141),Enum.Material.Metal,false)
 end
end
p(frameArea,"Dubai Frame roof skybridge",Vector3.new(119,15,15),
 CFrame.new(frameX,161,frameZ),C.gold,Enum.Material.Metal,true)
billboard(frameArea,"DUBAI FRAME",Vector3.new(frameX,190,frameZ))

local sailArea=folder(root,"BurjAlArabHotel")
local sailX,sailZ=1125,-940
p(sailArea,"Private Burj Al Arab island",Vector3.new(145,3,140),
 CFrame.new(sailX,1,sailZ),C.warm,Enum.Material.Concrete,true)
p(sailArea,"Burj Al Arab supporting mast",Vector3.new(7,208,7),
 CFrame.new(sailX-46,105,sailZ),C.grey,Enum.Material.Metal,true)
for i=1,12 do
 local y=i*16
 local width=math.max(22,94-i*6)
 p(sailArea,"Burj Al Arab curved white sail tier",Vector3.new(width,16,18),
  CFrame.new(sailX-35+width/2,y+6,sailZ),C.white,Enum.Material.SmoothPlastic,true)
 p(sailArea,"Sail facade blue glass",Vector3.new(width*.78,9,1),
  CFrame.new(sailX-31+width/2,y+8,sailZ+9.4),C.glass,Enum.Material.Glass,false)
end
p(sailArea,"Sky helipad circle",Vector3.new(2.5,48,48),
 CFrame.new(sailX+2,185,sailZ+15)*CFrame.Angles(0,0,math.pi/2),
 C.gold,Enum.Material.Metal,false).Shape=Enum.PartType.Cylinder
billboard(sailArea,"BURJ AL ARAB • HOTEL",Vector3.new(sailX,245,sailZ))

-- Buildings where services, hotels and shops can be recognized from the street.
local civic=folder(root,"DubaiShopsHotelsMall")
local function business(name,x,z,w,d,h,material)
 local box=folder(civic,name)
 p(box,name.." frontage",Vector3.new(w,h,d),CFrame.new(x,h/2,z),
  material or C.warm,Enum.Material.Concrete,true)
 p(box,"Mall window wall",Vector3.new(w-8,10,.7),
  CFrame.new(x,7,z+d/2+.5),C.glass2,Enum.Material.Glass,false)
 p(box,"Street awning",Vector3.new(w,1.4,9),
  CFrame.new(x,13,z+d/2+5),C.grey,Enum.Material.Metal,false)
 local sign=p(box,name.." wall sign",Vector3.new(w*.88,6,.5),
  CFrame.new(x,18,z+d/2+.9),RGB(34,69,81),Enum.Material.Metal,false)
 decoText(sign,name,Enum.NormalId.Front,C.gold,31)
end
business("DUBAI MEDICAL CENTRE",-235,-1175,92,74,33,RGB(229,236,230))
business("E11 GRAND HOTEL",-550,-980,120,70,55,RGB(231,219,197))
business("DUBAI CITY MALL",620,-996,118,85,38,RGB(226,218,204))
business("SOUK & CAFE",430,-996,78,68,25,RGB(218,195,164))
business("EMIRATES TOUR DESK",-400,-965,80,45,24,RGB(227,206,161))

-- Metro elevated line; animated passenger rail cars are generated separately.
local metro=folder(root,"DubaiElevatedMetro")
for _,x in ipairs({185,202}) do
 p(metro,"Silver metro rail",Vector3.new(1.2,.6,520),
  CFrame.new(x,23.8,-1200),C.grey,Enum.Material.Metal,false)
end
p(metro,"Metro concrete deck",Vector3.new(29,2.2,520),
 CFrame.new(194,22,-1200),C.warm,Enum.Material.Concrete,true)
for z=-1430,-985,72 do
 p(metro,"Metro pier",Vector3.new(5,23,5),
  CFrame.new(194,11.5,z),C.grey,Enum.Material.Concrete,true)
end
p(metro,"Elevated metro station platform",Vector3.new(49,2,125),
 CFrame.new(194,23,-1215),C.concrete,Enum.Material.Concrete,true)
p(metro,"Metro station glass canopy",Vector3.new(53,1.3,127),
 CFrame.new(194,39,-1215),C.glass2,Enum.Material.Glass,false)
for _,x in ipairs({174,214}) do
 p(metro,"Metro station roof pillars",Vector3.new(2.2,16,2.2),
  CFrame.new(x,31,-1260),C.grey,Enum.Material.Metal,true)
 p(metro,"Metro station roof pillars",Vector3.new(2.2,16,2.2),
  CFrame.new(x,31,-1170),C.grey,Enum.Material.Metal,true)
end
billboard(metro,"DUBAI METRO STATION",Vector3.new(194,52,-1215))

-- Natural-looking waterfront uses Roblox Terrain water, plus pier and yacht harbor.
local waterfront=folder(root,"DubaiCoastMarina")
local waterCenter=Vector3.new(1260,-2,-1285)
local waterSize=Vector3.new(670,20,490)
pcall(function()
 W.Terrain.WaterColor=RGB(31,110,149)
 W.Terrain.WaterTransparency=.2
 W.Terrain.WaterWaveSize=.25
 W.Terrain.WaterWaveSpeed=8
 W.Terrain:FillBlock(CFrame.new(waterCenter),waterSize,Enum.Material.Water)
end)
p(waterfront,"Marina coastal quay",Vector3.new(180,3,350),
 CFrame.new(980,2,-1285),C.concrete,Enum.Material.Concrete,true)
p(waterfront,"Harbor promenade",Vector3.new(22,1,385),
 CFrame.new(1090,3,-1285),C.warm,Enum.Material.Concrete,true)
for _,z in ipairs({-1450,-1330,-1200,-1090}) do
 p(waterfront,"Marina wooden pontoon",Vector3.new(160,1.4,17),
  CFrame.new(1162,3,z),C.wood,Enum.Material.Wood,true)
end
billboard(waterfront,"DUBAI MARINA • CRUISE PORT",Vector3.new(980,37,-1155))

-- Bigger airport expansion: runway, terminal, parked Emirates-inspired widebody airplane.
local airport=folder(root,"DubaiInternationalAirport")
p(airport,"Airport runway asphalt",Vector3.new(120,.8,520),
 CFrame.new(-1280,.5,-1220),C.asphalt,Enum.Material.Asphalt,true)
for z=-1450,-980,37 do
 p(airport,"Runway white centerline",Vector3.new(3,.12,19),
 CFrame.new(-1280,.98,z),C.stripe,Enum.Material.Neon,false)
end
p(airport,"Aircraft apron",Vector3.new(245,.7,330),
 CFrame.new(-1055,.4,-1280),RGB(142,144,146),Enum.Material.Concrete,true)
business("UAE INTERNATIONAL TERMINAL",-1020,-1025,124,72,36,RGB(215,220,211))
local plane=folder(airport,"EmiratesInspiredAircraft")
local planeCF=CFrame.new(-1080,10,-1310)
local body=p(plane,"White long-haul fuselage",Vector3.new(112,15,15),
 planeCF*CFrame.Angles(0,math.pi/2,0),C.white,Enum.Material.Metal,false)
body.Shape=Enum.PartType.Cylinder
for _,side in ipairs({-1,1}) do
 local wing=Instance.new("WedgePart")
 wing.Name="Swept aircraft wing"
 wing.Size=Vector3.new(58,3,25)
 wing.CFrame=planeCF*CFrame.new(side*34,-1,0)*CFrame.Angles(0,side*.18,0)
 wing.Color=C.white
 wing.Material=Enum.Material.Metal
 wing.Anchored=true
 wing.CanCollide=false
 wing.Parent=plane
 local engine=p(plane,"Passenger jet engine",Vector3.new(16,5,5),
  planeCF*CFrame.new(side*26,-7,-5)*CFrame.Angles(0,math.pi/2,0),C.grey,Enum.Material.Metal,false)
 engine.Shape=Enum.PartType.Cylinder
end
p(plane,"Emirates-style red tail fin",Vector3.new(3,19,14),
 planeCF*CFrame.new(0,14,45),C.red,Enum.Material.Metal,false)
local nameplate=p(plane,"Airport airplane name",Vector3.new(17,3,.5),
 planeCF*CFrame.new(7,7,-30),C.white,nil,false)
decoText(nameplate,"EMIRATES",Enum.NormalId.Front,C.red,38)
billboard(airport,"DXB AIRPORT",Vector3.new(-1060,60,-1085))

-- Ambient non-playable moving trains, boat, helicopter, cruise ship and plane.
local transit=folder(root,"AnimatedTransit")
local train=makeModel(transit,"Dubai Metro Driverless Train","Metro")
train:SetAttribute("MotionSpeed",.055)
for _,z in ipairs({-26,0,26}) do
 offset(train,"Metro car white shell",Vector3.new(13,11,27),0,4,z,C.white,Enum.Material.Metal)
 offset(train,"Metro gold door stripe",Vector3.new(13.2,.9,25),0,2,z,C.gold,Enum.Material.Metal)
 offset(train,"Metro windshield",Vector3.new(12.1,4,.55),0,5,z-13.65,C.glass,Enum.Material.Glass)
 for _,side in ipairs({-1,1}) do
  for _,q in ipairs({-7,7}) do
   offset(train,"Metro panoramic glass",Vector3.new(.3,4,10),
    side*6.63,5,z+q,C.glass2,Enum.Material.Glass)
  end
 end
end
train:PivotTo(CFrame.new(193,29,-1428))

local yacht=makeModel(transit,"Dubai Marina Yacht","Yacht")
yacht:SetAttribute("MotionSpeed",1)
offset(yacht,"Yacht white hull",Vector3.new(13,5,44),0,0,0,C.white,Enum.Material.Metal)
offset(yacht,"Yacht cabin",Vector3.new(10,5,19),0,4.4,-3,C.white,Enum.Material.Metal)
offset(yacht,"Panoramic yacht windows",Vector3.new(10.4,2.5,18),0,5,-3,C.glass2,Enum.Material.Glass)
offset(yacht,"Teak deck",Vector3.new(11,1.2,36),0,2,2,C.wood,Enum.Material.Wood)
yacht:PivotTo(CFrame.new(1220,4,-1280))

local cruise=makeModel(transit,"Dubai Cruise Ship","Cruise")
cruise:SetAttribute("MotionSpeed",1)
offset(cruise,"Cruise liner hull",Vector3.new(35,14,128),0,0,0,C.white,Enum.Material.Metal)
offset(cruise,"Blue ship waterline",Vector3.new(36,3,125),0,-6,0,C.blue,Enum.Material.Metal)
for i=1,4 do
 offset(cruise,"Passenger deck "..i,Vector3.new(29-i*1.5,5,96-i*4),
  0,7+i*4,0,C.white,Enum.Material.Metal)
 for _,side in ipairs({-1,1}) do
  for z=-37,38,15 do
   offset(cruise,"Liner balcony window",Vector3.new(.3,2.2,6),
    side*(15-i*.75),8+i*4,z,C.glass,Enum.Material.Glass)
  end
 end
end
cruise:PivotTo(CFrame.new(1510,8,-1380))

local helicopter=makeModel(transit,"Dubai Sightseeing Helicopter","Helicopter")
helicopter:SetAttribute("MotionSpeed",1)
local body=offset(helicopter,"Helicopter passenger body",
 Vector3.new(20,9,11),0,1,0,C.white,Enum.Material.Metal,CFrame.Angles(0,math.pi/2,0))
body.Shape=Enum.PartType.Cylinder
offset(helicopter,"Cabin tinted windscreen",Vector3.new(9,6,.5),0,1,-8,C.glass,Enum.Material.Glass)
offset(helicopter,"Tail boom",Vector3.new(2,2,18),0,2,15,C.white,Enum.Material.Metal)
offset(helicopter,"Tail fin",Vector3.new(1.2,10,3),0,6,23,C.red,Enum.Material.Metal)
offset(helicopter,"Left landing skid",Vector3.new(.8,.9,18),-5,-5,0,C.grey,Enum.Material.Metal)
offset(helicopter,"Right landing skid",Vector3.new(.8,.9,18),5,-5,0,C.grey,Enum.Material.Metal)
offset(helicopter,"Rotor blade secondary",Vector3.new(2,.5,34),0,6.5,0,C.black,Enum.Material.Metal)
local rotor=offset(helicopter,"RotorMain",Vector3.new(34,.65,2),
 0,6.5,0,C.black,Enum.Material.Metal)
helicopter:PivotTo(CFrame.new(-1020,155,-1240))

local flying=makeModel(transit,"Scenic Dubai Aircraft","Plane")
flying:SetAttribute("MotionSpeed",.012)
local fuselage=offset(flying,"Airliner white fuselage",
 Vector3.new(84,10,10),0,0,0,C.white,Enum.Material.Metal,CFrame.Angles(0,math.pi/2,0))
fuselage.Shape=Enum.PartType.Cylinder
offset(flying,"Swept wings",Vector3.new(68,2,20),0,-2,0,C.white,Enum.Material.Metal)
offset(flying,"Red airline tail",Vector3.new(3,14,12),0,10,32,C.red,Enum.Material.Metal)
flying:PivotTo(CFrame.new(-1600,235,-1370))

-- Mission boards: ProximityPrompts start server-validated mission routes.
local boards=folder(root,"MissionBoards")
local definitions={
 {kind="Explorer",title="Dubai City Explorer",x=-95,z=-332,tint=C.gold},
 {kind="Police",title="Police Community Patrol",x=-62,z=105,tint=RGB(18,93,65)},
 {kind="Ambulance",title="Ambulance Assistance",x=0,z=105,tint=C.blue},
 {kind="Fire",title="Civil Defence Safety",x=65,z=105,tint=C.red},
}
for _,d in ipairs(definitions) do
 local board=p(boards,d.kind.." Mission Board",Vector3.new(9,8,2),
  CFrame.new(d.x,4,d.z),d.tint,Enum.Material.Metal,true)
 board:SetAttribute("MissionType",d.kind)
 local sign=p(boards,d.kind.." Sign",Vector3.new(8.2,3.2,.4),
  CFrame.new(d.x,6,d.z+1.25),RGB(29,50,59),Enum.Material.SmoothPlastic,false)
 decoText(sign,d.title,Enum.NormalId.Front,C.white,30)
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="Start"..d.kind.."Mission"
 prompt.ObjectText=d.title
 prompt.ActionText="Start mission"
 prompt.HoldDuration=.25
 prompt.MaxActivationDistance=13
 prompt.RequiresLineOfSight=false
 prompt.Parent=board
end

-- Repair all 3 emergency vehicles: correct cylinder axes & wheel placement.
-- This removes the giant red fire cab rectangle shown in the screenshot.
local emergency=world.EmergencyVehicles
for _,v in ipairs({
 {name="Green Police SUV",width=11.4,wheels={-8.4,7.7}},
 {name="Blue White Ambulance",width=12.4,wheels={-10,9.7}},
 {name="Yellow Civil Defence Truck",width=13.6,wheels={-12,7.5,12.3}},
}) do
 local model=emergency:FindFirstChild(v.name)
 if model then
  local base=model:GetPivot()
  for _,item in ipairs(model:GetChildren()) do
   if item:IsA("BasePart") and (
     item.Name=="Realistic black tyre" or
     item.Name=="Wheel silver alloy" or
     item.Name=="Wheel hub dark centre" or
     item.Name=="Red diagonal stripe label panel" or
     item.Name=="Cab diagonal red emergency stripe"
    ) then
    item:Destroy()
   end
  end
  -- Cylinder axis is local X. DO NOT rotate it; former 90° Z rotation made wheels horizontal.
  for _,s in ipairs({-1,1}) do
   for _,z in ipairs(v.wheels) do
    local x=s*(v.width/2+.42)
    local tyre=p(model,"V5 Corrected Vertical Tyre",Vector3.new(1.8,5.25,5.25),
     base*CFrame.new(x,2.68,z),C.black,Enum.Material.Rubber,false)
    tyre.Shape=Enum.PartType.Cylinder
    local rim=p(model,"V5 Polished Wheel Rim",Vector3.new(.28,3.1,3.1),
     base*CFrame.new(x+s*.96,2.68,z),C.grey,Enum.Material.Metal,false)
    rim.Shape=Enum.PartType.Cylinder
    local bolt=p(model,"V5 Wheel Axle",Vector3.new(.37,.9,.9),
     base*CFrame.new(x+s*1.12,2.68,z),C.black,Enum.Material.Metal,false)
    bolt.Shape=Enum.PartType.Cylinder
   end
  end
  if v.name=="Yellow Civil Defence Truck" then
   for _,s in ipairs({-1,1}) do
    local brand=p(model,"Civil Defence Yellow Cab Repair",
     Vector3.new(.41,3.2,10),
     base*CFrame.new(s*(v.width/2+.4),7.0,-10.1),
     RGB(245,202,36),Enum.Material.Metal,false)
    decoText(brand,"DUBAI 997\nCIVIL DEFENCE",
     s>0 and Enum.NormalId.Right or Enum.NormalId.Left,C.red,40)
   end
  end
 end
end

-- Fix V4 civilian traffic tyre alignment as well (all 52 buses/taxis/sedans).
local phase4=world:FindFirstChild("Phase4_MegaCity")
local ambient=phase4 and phase4:FindFirstChild("RouteTraffic")
if ambient then
 for _,car in ipairs(ambient:GetChildren()) do
  if car:IsA("Model") and car.PrimaryPart then
   local body=car:FindFirstChild("Car lower painted body")
   if body and body:IsA("BasePart") then
    for _,wheel in ipairs(car:GetChildren()) do
     if wheel:IsA("BasePart") and (
      wheel.Name=="Black wheel" or wheel.Name=="Alloy wheel face" or
      wheel.Name=="V5 Traffic Tyre" or wheel.Name=="V5 Traffic Rim"
     ) then wheel:Destroy() end
    end
    local cf=car:GetPivot()
    local width=body.Size.X
    local length=body.Size.Z
    for _,side in ipairs({-1,1}) do
     for _,z in ipairs({-length*.28,length*.29}) do
      local x=side*(width/2+.38)
      local wheel=p(car,"V5 Traffic Tyre",Vector3.new(1.6,4.4,4.4),
       cf*CFrame.new(x,2.7,z),C.black,Enum.Material.Rubber,false)
      wheel.Shape=Enum.PartType.Cylinder
      local rim=p(car,"V5 Traffic Rim",Vector3.new(.22,2.5,2.5),
       cf*CFrame.new(x+side*.84,2.7,z),C.grey,Enum.Material.Metal,false)
      rim.Shape=Enum.PartType.Cylinder
     end
    end
   end
  end
 end
end

-- Extra palm clusters and night lamps around the boulevard.
local details=folder(root,"DubaiStreetDetails")
for z=-1450,-970,65 do
 for _,x in ipairs({-93,93}) do
  p(details,"Silver street lamp post",Vector3.new(.8,24,.8),
   CFrame.new(x,12,z),C.grey,Enum.Material.Metal,false)
  local lamp=p(details,"Amber night light",Vector3.new(4,.5,2),
   CFrame.new(x+4,24,z),C.gold,Enum.Material.Neon,false)
  local pt=Instance.new("PointLight")
  pt.Name="CityNightLamp"
  pt.Color=C.gold
  pt.Range=30
  pt.Brightness=1.15
  pt.Enabled=false
  pt.Parent=lamp
 end
end
for _,pos in ipairs({
 {-115,-1400},{-112,-1270},{-115,-1140},{110,-1390},{110,-1240},
 {-850,-1350},{-820,-1190},{930,-1420},{925,-1190}
}) do
 p(details,"Palm tree trunk",Vector3.new(2,14,2),
  CFrame.new(pos[1],7,pos[2]),C.wood,Enum.Material.Wood,false)
 for _,ang in ipairs({0,math.pi/2,math.pi,math.pi*1.5}) do
  p(details,"Palm canopy",Vector3.new(13,2,6),
   CFrame.new(pos[1]+5*math.cos(ang),15,pos[2]+5*math.sin(ang))
    *CFrame.Angles(0,ang,0),C.palm,Enum.Material.Grass,false)
 end
end

-- Correct previous labels' visibility clutter only; preserve buildings and exactly 4 flags.
for _,g in ipairs(world:GetDescendants()) do
 if g:IsA("BillboardGui") and g.Name=="LocationSign" then
  g.MaxDistance=120
  g.Size=UDim2.fromOffset(math.min(g.Size.X.Offset,140),34)
 end
end
-- Cinematic, low haze, warm gold sun and cool glass reflections.
L.GlobalShadows=true
L.Brightness=2
L.ShadowSoftness=.22
L.EnvironmentDiffuseScale=.65
L.EnvironmentSpecularScale=.7
local atm=L:FindFirstChild("UAEAtmosphere")
if atm and atm:IsA("Atmosphere") then
 atm.Density=.17
 atm.Haze=.5
 atm.Glare=.09
 atm.Color=RGB(235,209,177)
 atm.Decay=RGB(145,180,200)
end
local grade=L:FindFirstChild("UAEColorGrade")
if grade and grade:IsA("ColorCorrectionEffect") then
 grade.Contrast=.14
 grade.Saturation=.11
 grade.Brightness=.02
 grade.TintColor=RGB(255,245,232)
end

-- Remove old, competing HUD and camera. Leave original driving mechanics untouched.
for _,name in ipairs({
 "UAE_Phase4HUD","UAE_MinimapAndMission","UAE_Phase4Camera",
 "UAE_VehicleCamera","UAE_Phase5HUD","UAE_Phase5Camera"
}) do
 local oldScript=SP.StarterPlayerScripts:FindFirstChild(name)
 if oldScript then oldScript:Destroy() end
end
for _,name in ipairs({"UAE_Phase5Motion","UAE_Phase5CivicMissions","UAE_Phase5Visitors"}) do
 local oldScript=SS:FindFirstChild(name)
 if oldScript then oldScript:Destroy() end
end
SP.CameraMode=Enum.CameraMode.Classic
SP.CameraMinZoomDistance=5
SP.CameraMaxZoomDistance=85
local function install(class,parent,name,source)
 local obj=Instance.new(class)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
end
install("LocalScript",SP.StarterPlayerScripts,"UAE_Phase5HUD",[========[
-- Phase 5: compact GTA-style FUNCTIONAL radar, full Dubai city map, zoom +/-, and slim clock.
-- Design is original; no GTA artwork, code or images are copied.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local Lighting=game:GetService("Lighting")
local player=Players.LocalPlayer
player.CameraMode=Enum.CameraMode.Classic
player.CameraMinZoomDistance=5
player.CameraMaxZoomDistance=85
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V5_HUD"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=18
gui.Parent=player:WaitForChild("PlayerGui")
local function col(r,g,b) return Color3.fromRGB(r,g,b) end
local mint=col(61,161,156)
local cream=col(255,235,188)
local navy=col(18,37,44)
local function corner(parent,scale,offset)
 local c=Instance.new("UICorner")
 c.CornerRadius=UDim.new(scale or 0,offset or 0)
 c.Parent=parent
 return c
end
local function label(parent,name,caption,size,pos,fontSize,color,align)
 local text=Instance.new("TextLabel")
 text.Name=name
 text.Text=caption
 text.Font=Enum.Font.GothamBold
 text.TextSize=fontSize or 12
 text.TextColor3=color or cream
 text.BackgroundTransparency=1
 text.TextXAlignment=align or Enum.TextXAlignment.Left
 text.TextYAlignment=Enum.TextYAlignment.Center
 text.Size=size
 text.Position=pos
 text.Parent=parent
 return text
end
local function button(parent,name,caption,size,pos)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Text=caption
 b.TextSize=15
 b.Font=Enum.Font.GothamBold
 b.TextColor3=col(255,245,216)
 b.BackgroundColor3=navy
 b.BackgroundTransparency=.03
 b.Size=size
 b.Position=pos
 b.AutoButtonColor=true
 b.Parent=parent
 corner(b,0,7)
 return b
end
-- Mini-map: just 126 px. Roads are clipped mathematically to a circular radius.
local radar=Instance.new("Frame")
radar.Name="SmallRadar"
radar.Size=UDim2.fromOffset(132,132)
radar.Position=UDim2.fromOffset(12,14)
radar.BackgroundColor3=col(31,93,88)
radar.BorderSizePixel=0
radar.Parent=gui
corner(radar,.5,0)
local outline=Instance.new("UIStroke")
outline.Color=col(240,169,182)
outline.Thickness=3
outline.Parent=radar
local radarRoads=Instance.new("Folder")
radarRoads.Name="RoadLines"
radarRoads.Parent=radar
local mapCenter=Vector2.new(66,66)
local radius=58
local roads={
 {-1500,-1130,1400,-1130},
 {-1500,-1200,1400,-1200},
 {-1500,-1280,1400,-1280},
 {-900,-985,850,-985},
 {-500,-780,-500,750},{-390,-800,-390,750},
 {0,-1450,0,810},{390,-800,390,800},
 {-990,30,1000,30},{-990,-235,1000,-235},
 {-990,470,1000,470},
 {180,-1450,180,-960},
}
local lines={}
for i=1,#roads do
 local l=Instance.new("Frame")
 l.Name="Road "..i
 l.BackgroundColor3=col(224,221,189)
 l.BorderSizePixel=0
 l.AnchorPoint=Vector2.new(0,.5)
 l.Visible=false
 l.ZIndex=2
 l.Parent=radar
 lines[i]=l
end
local radarPins={}
for i=1,3 do
 local pin=Instance.new("TextLabel")
 pin.Name="Destination "..i
 pin.BackgroundColor3=col(32,50,65)
 pin.TextColor3=cream
 pin.Font=Enum.Font.GothamBold
 pin.TextSize=9
 pin.AnchorPoint=Vector2.new(.5,.5)
 pin.Size=UDim2.fromOffset(18,18)
 pin.ZIndex=5
 pin.BorderSizePixel=0
 pin.Parent=radar
 corner(pin,.5,0)
 radarPins[i]=pin
end
local me=Instance.new("Frame")
me.Name="YourPosition"
me.Size=UDim2.fromOffset(9,9)
me.AnchorPoint=Vector2.new(.5,.5)
me.Position=UDim2.fromOffset(66,66)
me.BackgroundColor3=col(246,58,69)
me.BorderSizePixel=0
me.ZIndex=7
me.Parent=radar
corner(me,.5,0)
local meStroke=Instance.new("UIStroke")
meStroke.Color=col(255,255,255)
meStroke.Thickness=1.6
meStroke.Parent=me
local radarOpen=Instance.new("TextButton")
radarOpen.Name="ClickToOpenCityMap"
radarOpen.Text=""
radarOpen.BackgroundTransparency=1
radarOpen.Size=UDim2.fromScale(1,1)
radarOpen.ZIndex=9
radarOpen.Parent=radar
local plus=button(gui,"ZoomIn","+",UDim2.fromOffset(25,25),UDim2.fromOffset(153,22))
local minus=button(gui,"ZoomOut","−",UDim2.fromOffset(25,25),UDim2.fromOffset(153,52))
local fullMapButton=button(gui,"FullMapButton","MAP",UDim2.fromOffset(54,25),UDim2.fromOffset(12,154))
fullMapButton.TextSize=12
local clock=Instance.new("Frame")
clock.Name="CompactDubaiClock"
clock.AnchorPoint=Vector2.new(1,0)
clock.Position=UDim2.new(1,-15,0,15)
clock.Size=UDim2.fromOffset(196,44)
clock.BackgroundColor3=navy
clock.BackgroundTransparency=.16
clock.Parent=gui
corner(clock,0,9)
local dubaiTime=label(clock,"DubaiTime","DUBAI --:-- GST",
 UDim2.new(1,-16,0,21),UDim2.fromOffset(10,1),14,cream)
local cycleTime=label(clock,"GameCycle","GAME --:--  •  DAY",
 UDim2.new(1,-16,0,18),UDim2.fromOffset(10,23),10,col(207,226,222))
local missionNotice=Instance.new("Frame")
missionNotice.Name="CompactMission"
missionNotice.AnchorPoint=Vector2.new(0,1)
missionNotice.Position=UDim2.new(0,12,1,-12)
missionNotice.Size=UDim2.fromOffset(250,46)
missionNotice.BackgroundColor3=navy
missionNotice.BackgroundTransparency=.12
missionNotice.BorderSizePixel=0
missionNotice.Parent=gui
corner(missionNotice,0,9)
local missionLabel=label(missionNotice,"MissionStatus","🇦🇪 Explore Dubai • Visit Burj Khalifa",
 UDim2.new(1,-16,1,-6),UDim2.fromOffset(8,3),11,cream)
missionLabel.TextWrapped=true

local fullMap=Instance.new("Frame")
fullMap.Name="ExpandedCityMap"
fullMap.AnchorPoint=Vector2.new(.5,.5)
fullMap.Position=UDim2.fromScale(.5,.5)
fullMap.Size=UDim2.new(.72,0,.74,0)
fullMap.BackgroundColor3=navy
fullMap.BorderSizePixel=0
fullMap.Visible=false
fullMap.ZIndex=20
fullMap.Parent=gui
corner(fullMap,0,13)
local maxConstraint=Instance.new("UISizeConstraint")
maxConstraint.MaxSize=Vector2.new(750,570)
maxConstraint.MinSize=Vector2.new(310,240)
maxConstraint.Parent=fullMap
local mapTitle=label(fullMap,"MapTitle","DUBAI • UAE CITY LIFE  |  CITY GUIDE",
 UDim2.new(1,-66,0,45),UDim2.fromOffset(18,0),17,cream)
mapTitle.ZIndex=21
local close=button(fullMap,"CloseMap","✕",UDim2.fromOffset(37,32),UDim2.new(1,-48,0,8))
close.ZIndex=22
local mapSurface=Instance.new("Frame")
mapSurface.Name="CityMapSurface"
mapSurface.Size=UDim2.new(1,-28,1,-84)
mapSurface.Position=UDim2.fromOffset(14,48)
mapSurface.BackgroundColor3=col(58,103,98)
mapSurface.BorderSizePixel=0
mapSurface.ZIndex=20
mapSurface.Parent=fullMap
corner(mapSurface,0,9)
local fullLines={}
for i=1,#roads do
 local l=Instance.new("Frame")
 l.Name="Highway "..i
 l.BackgroundColor3=col(231,211,178)
 l.BackgroundTransparency=.18
 l.BorderSizePixel=0
 l.AnchorPoint=Vector2.new(0,.5)
 l.ZIndex=21
 l.Parent=mapSurface
 fullLines[i]=l
end
local destinations={
 {name="Burj Khalifa",abbr="BK",x=-84,z=-392},
 {name="Museum of the Future",abbr="MF",x=315,z=-1180},
 {name="Dubai Mall",abbr="DM",x=100,z=-399},
 {name="Sheikh Zayed Road",abbr="SZ",x=0,z=-1215},
 {name="Dubai International Airport",abbr="DXB",x=-1070,z=-1260},
 {name="Dubai Marina",abbr="MAR",x=1060,z=-1285},
 {name="Metro Station",abbr="M",x=185,z=-1210},
 {name="Dubai Frame",abbr="DF",x=-770,z=-830},
 {name="Burj Al Arab",abbr="BA",x=1125,z=-940},
 {name="Sharjah Heritage",abbr="SHJ",x=390,z=-380},
 {name="Ajman Beach",abbr="AJM",x=390,z=210},
}
local mapLabels={}
for _,d in ipairs(destinations) do
 local p=Instance.new("TextLabel")
 p.Name=d.name
 p.Size=UDim2.fromOffset(118,24)
 p.AnchorPoint=Vector2.new(.5,.5)
 p.BackgroundColor3=col(22,48,57)
 p.BackgroundTransparency=.05
 p.Text=d.abbr.."  "..d.name
 p.TextColor3=cream
 p.Font=Enum.Font.GothamSemibold
 p.TextSize=9
 p.BorderSizePixel=0
 p.ZIndex=23
 p.Parent=mapSurface
 corner(p,0,6)
 mapLabels[#mapLabels+1]=p
end
local playerPin=Instance.new("Frame")
playerPin.Name="You"
playerPin.AnchorPoint=Vector2.new(.5,.5)
playerPin.Size=UDim2.fromOffset(13,13)
playerPin.BackgroundColor3=col(250,73,63)
playerPin.ZIndex=27
playerPin.Parent=mapSurface
corner(playerPin,.5,0)
local guide=label(fullMap,"Guide","Red dot = you  •  Click MAP or press M to close",
 UDim2.new(1,-24,0,25),UDim2.new(0,14,1,-30),11,col(217,229,225))
guide.ZIndex=21
local zoom=2.7 -- studs per pixel; smaller number means closer view.
local zoomMin,zoomMax=1.15,12
local function setZoom(value)
 zoom=math.clamp(value,zoomMin,zoomMax)
end
plus.MouseButton1Click:Connect(function() setZoom(zoom/1.3) end)
minus.MouseButton1Click:Connect(function() setZoom(zoom*1.3) end)
local function toggleMap()
 fullMap.Visible=not fullMap.Visible
end
radarOpen.MouseButton1Click:Connect(toggleMap)
fullMapButton.MouseButton1Click:Connect(toggleMap)
close.MouseButton1Click:Connect(toggleMap)
UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.KeyCode==Enum.KeyCode.M then toggleMap() end
end)
UIS.InputChanged:Connect(function(input,processed)
 if processed or input.UserInputType~=Enum.UserInputType.MouseWheel then return end
 -- Mousewheel over minimap zooms the minimap; elsewhere Roblox zooms the camera.
 local mouse=UIS:GetMouseLocation()
 local pos=radar.AbsolutePosition
 if mouse.X>=pos.X and mouse.X<=pos.X+132 and mouse.Y>=pos.Y and mouse.Y<=pos.Y+132 then
  setZoom(zoom*(input.Position.Z>0 and .88 or 1.13))
 end
end)

-- Intersect a finite line with radar circle. Prevents the square clipping artefact.
local function clipCircle(a,b)
 local d=b-a
 local A=d:Dot(d)
 if A<.0001 then return nil end
 local B=2*a:Dot(d)
 local C=a:Dot(a)-radius*radius
 local disc=B*B-4*A*C
 if disc<0 then return nil end
 local t1=(-B-math.sqrt(disc))/(2*A)
 local t2=(-B+math.sqrt(disc))/(2*A)
 local lo=math.max(0,math.min(t1,t2))
 local hi=math.min(1,math.max(t1,t2))
 if lo>=hi then return nil end
 return a+d*lo,b-d*(1-hi)
end
local function drawLine(guiLine,a,b,thick)
 local diff=b-a
 if diff.Magnitude<.1 then guiLine.Visible=false return end
 guiLine.Visible=true
 guiLine.Position=UDim2.fromOffset(a.X,a.Y)
 guiLine.Size=UDim2.fromOffset(diff.Magnitude,thick)
 guiLine.Rotation=math.deg(math.atan2(diff.Y,diff.X))
end
local function nearestVisible(playerPos)
 local arr={}
 for _,d in ipairs(destinations) do
  local dist=((Vector2.new(d.x,d.z))-playerPos).Magnitude
  arr[#arr+1]={data=d,distance=dist}
 end
 table.sort(arr,function(a,b) return a.distance<b.distance end)
 return arr
end
local function norm(x,z)
 return (x+1650)/3300,(z+1550)/3100
end
local function renderFullMap(playerPos)
 local width,height=mapSurface.AbsoluteSize.X,mapSurface.AbsoluteSize.Y
 if width<2 or height<2 then return end
 for i,r in ipairs(roads) do
  local x1,z1=norm(r[1],r[2])
  local x2,z2=norm(r[3],r[4])
  drawLine(fullLines[i],Vector2.new(x1*width,z1*height),
   Vector2.new(x2*width,z2*height),3)
 end
 for i,d in ipairs(destinations) do
  local x,z=norm(d.x,d.z)
  mapLabels[i].Position=UDim2.fromOffset(x*width,z*height)
 end
 local x,z=norm(playerPos.X,playerPos.Y)
 playerPin.Position=UDim2.fromOffset(x*width,z*height)
end

local remote=RS:FindFirstChild("UAE_MissionUpdate") or RS:WaitForChild("UAE_MissionUpdate",30)
if remote then
 remote.OnClientEvent:Connect(function(msg)
  if typeof(msg)=="string" and #msg<200 then
   missionLabel.Text=msg
  end
 end)
end
task.spawn(function()
 while gui.Parent do
  task.wait(.2)
  local char=player.Character
  local root=char and char:FindFirstChild("HumanoidRootPart")
  if root then
   local px,pz=root.Position.X,root.Position.Z
   local p2=Vector2.new(px,pz)
   for i,r in ipairs(roads) do
    local a=Vector2.new((r[1]-px)/zoom,(r[2]-pz)/zoom)
    local b=Vector2.new((r[3]-px)/zoom,(r[4]-pz)/zoom)
    local c,d=clipCircle(a,b)
    if c and d then
     drawLine(lines[i],c+mapCenter,d+mapCenter,2.7)
    else
     lines[i].Visible=false
    end
   end
   local near=nearestVisible(p2)
   for i=1,3 do
    local d=near[i].data
    local rel=Vector2.new((d.x-px)/zoom,(d.z-pz)/zoom)
    local pin=radarPins[i]
    pin.Visible=rel.Magnitude<radius-8
    pin.Position=UDim2.fromOffset(mapCenter.X+rel.X,mapCenter.Y+rel.Y)
    pin.Text=d.abbr
   end
   if fullMap.Visible then renderFullMap(p2) end
  end
  dubaiTime.Text="DUBAI  "..os.date("!%H:%M",os.time()+4*3600).." GST"
  local hour=RS:GetAttribute("UAECycleHour")
  if typeof(hour)=="number" then
   local period=hour>=6 and hour<18 and "DAY" or "NIGHT"
   cycleTime.Text=string.format("GAME %02d:%02d  •  %s",
    math.floor(hour)%24,math.floor((hour%1)*60),period)
  end
 end
end)

]========])
install("LocalScript",SP.StarterPlayerScripts,"UAE_Phase5Camera",[========[
-- Phase 5 vehicle chase camera: Mouse wheel zoom, right-drag orbit, PageUp/Down pitch.
-- On foot: Roblox's standard camera, zoom and right-drag remain available.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
player.CameraMode=Enum.CameraMode.Classic
player.CameraMinZoomDistance=5
player.CameraMaxZoomDistance=85
local rightHeld=false
local distance=36
local pitch=math.rad(18)
local yaw=0
local wasDriving=false
local lastCar=nil
UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.UserInputType==Enum.UserInputType.MouseButton2 then
  rightHeld=true
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(9),math.rad(4),math.rad(65))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(9),math.rad(4),math.rad(65))
 elseif input.KeyCode==Enum.KeyCode.C then
  yaw=0
  pitch=math.rad(18)
  distance=36
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then
  rightHeld=false
 end
end)
UIS.InputChanged:Connect(function(input,processed)
 if processed then return end
 if input.UserInputType==Enum.UserInputType.MouseWheel and wasDriving then
  distance=math.clamp(distance-input.Position.Z*4,18,78)
 elseif input.UserInputType==Enum.UserInputType.MouseMovement and rightHeld and wasDriving then
  yaw=yaw-input.Delta.X*.006
  pitch=math.clamp(pitch+input.Delta.Y*.004,math.rad(4),math.rad(65))
 end
end)
local function driveSeat()
 local character=player.Character
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 local seat=humanoid and humanoid.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then
   return model,humanoid,character
  end
 end
 return nil,humanoid,character
end
RunService:BindToRenderStep("UAE_Phase5Camera",Enum.RenderPriority.Camera.Value+1,function(dt)
 local camera=workspace.CurrentCamera
 if not camera then return end
 local car,humanoid,char=driveSeat()
 if not car then
  if wasDriving then
   camera.CameraType=Enum.CameraType.Custom
   if humanoid then camera.CameraSubject=humanoid end
   camera.FieldOfView=70
  end
  wasDriving=false
  lastCar=nil
  return
 end
 if car~=lastCar then
  distance=(car:GetAttribute("VehicleType")=="Fire") and 48 or 36
  pitch=math.rad(18)
  yaw=0
  lastCar=car
 end
 local base=car:GetPivot()
 local focus=(base*CFrame.new(0,6,-7)).Position
 local polar=CFrame.Angles(0,yaw,0)
 local eye=(base*polar*CFrame.new(0,
  math.sin(pitch)*distance+5,
  math.cos(pitch)*distance)).Position
 local diff=eye-focus
 if diff.Magnitude<2 then
  eye=focus+Vector3.new(0,9,22)
  diff=eye-focus
 end
 -- Avoid camera being embedded in walls; filter driver's vehicle and character.
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances={car,char}
 local ray=workspace:Raycast(focus,diff,params)
 if ray then eye=ray.Position-diff.Unit*1.2 end
 local desired=CFrame.lookAt(eye,focus)
 camera.CameraType=Enum.CameraType.Scriptable
 camera.FieldOfView=73
 if not wasDriving then camera.CFrame=desired
 else camera.CFrame=camera.CFrame:Lerp(desired,math.clamp(dt*8,0,1)) end
 wasDriving=true
end)

]========])
install("Script",SS,"UAE_Phase5Motion",[========[
-- Phase 5: cinematic transit display movement.
-- Metro, yacht, cruise ship, sightseeing helicopter and airplane: anchored scene props,
-- NOT independently driveable or flyable yet; no player collision or external assets.
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase5_DubaiModern")
local motion=root:WaitForChild("AnimatedTransit")
local RS=game:GetService("ReplicatedStorage")
-- Phase 4 drives the clock. Extend night-light behaviour to newly generated V5 streets.
task.spawn(function()
 while root.Parent do
  local h=RS:GetAttribute("UAECycleHour")
  local night=typeof(h)=="number" and (h>=18 or h<6)
  for _,item in ipairs(root:GetDescendants()) do
   if item:IsA("PointLight") and item.Name=="CityNightLamp" then
    item.Enabled=night
   end
  end
  task.wait(5)
 end
end)
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

]========])
install("Script",SS,"UAE_Phase5CivicMissions",[========[
-- Phase 5: server-validated civic missions with temporary CityPoints.
-- Mission rewards and progress are SESSION ONLY. No datastore, unsafe rewards or combat.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local content=world:WaitForChild("Phase5_DubaiModern")
local prompts=content:WaitForChild("MissionBoards")
local updates=RS:FindFirstChild("UAE_MissionUpdate")
if not updates then
 updates=Instance.new("RemoteEvent")
 updates.Name="UAE_MissionUpdate"
 updates.Parent=RS
end
local missionDefinitions={
 Explorer={
  label="UAE Explorer",
  points={
   {name="Burj Khalifa",pos=Vector3.new(-84,0,-392)},
   {name="Dubai Mall",pos=Vector3.new(100,0,-399)},
   {name="Museum of the Future",pos=Vector3.new(315,0,-1180)},
  },
  reward=70,
 },
 Police={
  label="Police Community Patrol",
  points={
   {name="Dubai Mall crosswalk",pos=Vector3.new(120,0,-360)},
   {name="Sheikh Zayed Road",pos=Vector3.new(0,0,-1200)},
   {name="Museum district",pos=Vector3.new(315,0,-1180)},
  },
  reward=120,
 },
 Ambulance={
  label="Ambulance Assistance",
  points={
   {name="UAE Family Park",pos=Vector3.new(220,0,360)},
   {name="Dubai Medical Centre",pos=Vector3.new(-235,0,-1175)},
  },
  reward=120,
 },
 Fire={
  label="Civil Defence Safety Exercise",
  points={
   {name="Sheikh Zayed Road fire drill",pos=Vector3.new(-260,0,-1190)},
   {name="Safe community assembly",pos=Vector3.new(220,0,360)},
  },
  reward=120,
 },
}
local states={}
local function send(player,msg)
 if player.Parent==Players then updates:FireClient(player,msg) end
end
local function begin(player,kind)
 local mission=missionDefinitions[kind]
 if not mission then return end
 states[player]={kind=kind,stage=1,lastTick=0}
 send(player,"📍 "..mission.label..": "..mission.points[1].name)
end
local function setup(player)
 local leaderboard=player:FindFirstChild("leaderstats")
 if not leaderboard then
  leaderboard=Instance.new("Folder")
  leaderboard.Name="leaderstats"
  leaderboard.Parent=player
 end
 local points=leaderboard:FindFirstChild("CityPoints")
 if not points then
  points=Instance.new("IntValue")
  points.Name="CityPoints"
  points.Value=0
  points.Parent=leaderboard
 end
 begin(player,"Explorer")
end
Players.PlayerAdded:Connect(setup)
for _,p in ipairs(Players:GetPlayers()) do setup(p) end
Players.PlayerRemoving:Connect(function(player) states[player]=nil end)
for _,board in ipairs(prompts:GetChildren()) do
 local prompt=board:FindFirstChildOfClass("ProximityPrompt")
 local kind=board:GetAttribute("MissionType")
 if prompt and missionDefinitions[kind] then
  prompt.Triggered:Connect(function(player)
   -- Roblox ProximityPrompt handles nearby activation; validate range server-side.
   local char=player.Character
   local rootPart=char and char:FindFirstChild("HumanoidRootPart")
   if not rootPart or (rootPart.Position-board.Position).Magnitude>22 then return end
   begin(player,kind)
  end)
 end
end
task.spawn(function()
 while content.Parent do
  task.wait(.6)
  for player,state in pairs(states) do
   if player.Parent~=Players then
    states[player]=nil
   else
    local mission=missionDefinitions[state.kind]
    local target=mission.points[state.stage]
    if target then
     local char=player.Character
     local rootPart=char and char:FindFirstChild("HumanoidRootPart")
     if rootPart then
      local a=rootPart.Position
      local delta=Vector3.new(a.X-target.pos.X,0,a.Z-target.pos.Z)
      if delta.Magnitude<55 then
       state.stage=state.stage+1
       if state.stage>#mission.points then
        local ls=player:FindFirstChild("leaderstats")
        local city=ls and ls:FindFirstChild("CityPoints")
        if city then city.Value=city.Value+mission.reward end
        send(player,"✅ "..mission.label.." complete! +"..mission.reward.." CityPoints")
        states[player]=nil
       else
        send(player,"✅ Checkpoint! Next: "..mission.points[state.stage].name)
       end
      end
     end
    end
   end
  end
 end
end)

]========])

install("Script",SS,"UAE_Phase5Visitors",[========[
-- Phase 5 Dubai Modern: up to 12 additional R15 tourists and residents
-- R15 humanoids with varied skin tones, outfits and cap accessories, animated walking if possible.
-- Roblox-generated models are used, not copied GTA characters or third-party avatar IDs.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase5_DubaiModern")
local scenes=root:WaitForChild("DubaiStreetDetails")
local group=Instance.new("Folder")
group.Name="DubaiTourists"
group.Parent=root
local routes={
 {Vector3.new(-106,2,-1430),Vector3.new(-106,2,-1120),Vector3.new(-120,2,-1030),Vector3.new(-120,2,-1430)},
 {Vector3.new(108,2,-1430),Vector3.new(108,2,-1120),Vector3.new(116,2,-1030),Vector3.new(116,2,-1430)},
 {Vector3.new(990,4,-1440),Vector3.new(990,4,-1320),Vector3.new(990,4,-1160),Vector3.new(1010,4,-1160)},
 {Vector3.new(-520,2,-1010),Vector3.new(-390,2,-1010),Vector3.new(-390,2,-1070),Vector3.new(-520,2,-1070)},
 {Vector3.new(350,2,-1040),Vector3.new(400,2,-1040),Vector3.new(400,2,-1080),Vector3.new(350,2,-1080)},
}
local colors={
 Color3.fromRGB(240,199,162),Color3.fromRGB(190,147,106),
 Color3.fromRGB(144,102,75),Color3.fromRGB(221,177,142),
 Color3.fromRGB(96,72,59),Color3.fromRGB(230,185,145),
}
local shirts={
 Color3.fromRGB(239,240,232),Color3.fromRGB(56,114,157),
 Color3.fromRGB(78,135,109),Color3.fromRGB(148,70,97),
 Color3.fromRGB(191,154,77),Color3.fromRGB(69,81,95),
}
local walkAnim="rbxassetid://507777826" -- Roblox default R15 walk, may fail in Studio.
local count=root:GetAttribute("PerformanceMode") and 5 or 12
local function capFor(rig,head,n)
 if n%3~=0 then return end
 local brim=Instance.new("Part")
 brim.Name="Casual cap"
 brim.Size=Vector3.new(2.5,.42,2.9)
 brim.Color=shirts[(n-1)%#shirts+1]
 brim.Material=Enum.Material.Fabric
 brim.CanCollide=false
 brim.Anchored=false
 brim.Massless=true
 brim.CFrame=head.CFrame*CFrame.new(0,1.1,-.2)
 brim.Parent=rig
 local w=Instance.new("WeldConstraint")
 w.Part0=head
 w.Part1=brim
 w.Parent=brim
end
for n=1,count do
 task.spawn(function()
  local description=Instance.new("HumanoidDescription")
  local skin=colors[(n-1)%#colors+1]
  local shirt=shirts[(n-1)%#shirts+1]
  description.HeadColor=skin
  description.LeftArmColor=skin
  description.RightArmColor=skin
  description.TorsoColor=shirt
  description.LeftLegColor=Color3.fromRGB(62,72,86)
  description.RightLegColor=Color3.fromRGB(62,72,86)
  description.HeightScale=.94+(n%3)*.035
  description.WidthScale=.9+(n%3)*.05
  local ok,rig=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15)
  end)
  description:Destroy()
  if not ok or not rig then
   warn("V5 Dubai tourist could not spawn: "..n)
   return
  end
  rig.Name="Dubai Resident "..n
  local hum=rig:FindFirstChildOfClass("Humanoid")
  local hrp=rig:FindFirstChild("HumanoidRootPart")
  local head=rig:FindFirstChild("Head")
  if not hum or not hrp then rig:Destroy() return end
  local route=routes[(n-1)%#routes+1]
  local index=(n-1)%#route+1
  rig.Parent=group
  rig:PivotTo(CFrame.new(route[index]))
  hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  hum.WalkSpeed=6.5+(n%5)
  for _,item in ipairs(rig:GetDescendants()) do
   if item:IsA("BasePart") then
    item.CanCollide=item.Name=="HumanoidRootPart"
   end
  end
  if head and head:IsA("BasePart") then capFor(rig,head,n) end
  local animator=hum:FindFirstChildOfClass("Animator")
  if not animator then
   animator=Instance.new("Animator")
   animator.Parent=hum
  end
  pcall(function()
   local anim=Instance.new("Animation")
   anim.AnimationId=walkAnim
   local track=animator:LoadAnimation(anim)
   track.Looped=true
   track:Play()
  end)
  while rig.Parent and root.Parent and hum.Health>0 do
   index=index%#route+1
   local target=route[index]
   hum:MoveTo(target)
   local reached=hum.MoveToFinished:Wait()
   if not reached then hum:MoveTo(target) end
   task.wait(.25)
  end
 end)
 task.wait(.1)
end

]========])
print("UAE V5 DUBAI MODERN READY: E11 corridor, skyscrapers, Museum of the Future-inspired ring, airport, metro, boats, cruise ship, helicopter, improved wheels, compact clickable radar and civic missions.")
