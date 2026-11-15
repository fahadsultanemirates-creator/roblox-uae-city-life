-- ROBLOX UAE CITY LIFE: MAJOR PHASE 4 PATCH | Gulf-inspired living city.
-- Run IN ROBLOX STUDIO COMMAND BAR while NOT playing. Requires Phase 1 map.
-- Works after v2 or v3A. Creates a NEW Phase4_MegaCity folder; keeps 4 UAE flags.
-- 40+ route-locked civilian cars, R15 citizens, Dubai clock, 40-minute day/night.
-- Yellow Dubai Civil Defence truck and blue/white Dubai ambulance approximate supplied photos.
local W=game:GetService("Workspace")
local L=game:GetService("Lighting")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer")
local world=W:FindFirstChild("UAE_City_Life")
assert(world,"Open your saved UAE City Life v2/v3A place. Phase 1 map is missing.")
local emergency=world:FindFirstChild("EmergencyVehicles")
assert(emergency,"EmergencyVehicles missing. Open your existing working v2/v3A place.")
-- Replacing v3A avoids old crossing traffic and duplicate rectangular map.
local old=world:FindFirstChild("Phase3_LivingCity")
if old then old:Destroy() end
local oldRuntime=SS:FindFirstChild("UAE_Phase3_Animation")
if oldRuntime then oldRuntime:Destroy() end
local oldUI=SP.StarterPlayerScripts:FindFirstChild("UAE_MinimapAndMission")
if oldUI then oldUI:Destroy() end
local v4old=world:FindFirstChild("Phase4_MegaCity")
if v4old then v4old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase4_MegaCity"
root.Parent=world
local function color(r,g,b) return Color3.fromRGB(r,g,b) end
local C={
 white=color(249,247,238),black=color(34,38,43),silver=color(142,155,160),
 yellow=color(244,205,34),red=color(193,39,49),blue=color(31,106,165),
 navy=color(29,60,103),green=color(19,99,73),glass=color(67,138,174),
 sand=color(219,199,162),road=color(48,55,62),stripe=color(244,238,209),
 gold=color(249,212,137),palm=color(46,125,79),copper=color(151,108,74),
 beige=color(214,197,170),
}
local function group(parent,name)
 local f=Instance.new("Folder")
 f.Name=name
 f.Parent=parent
 return f
end
local function part(parent,name,size,cf,tint,mat,collision)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=size
 p.CFrame=cf
 p.Anchored=true
 p.CanCollide=(collision==true)
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Color=tint or C.white
 p.Material=mat or Enum.Material.SmoothPlastic
 p.Parent=parent
 return p
end
local function label(parent,words,face,col)
 local g=Instance.new("SurfaceGui")
 g.Name="Phase4 Vehicle Lettering"
 g.Face=face
 g.PixelsPerStud=58
 g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
 g.LightInfluence=.02
 g.Parent=parent
 local l=Instance.new("TextLabel")
 l.Size=UDim2.fromScale(1,1)
 l.Text=words
 l.Font=Enum.Font.GothamBold
 l.TextColor3=col or C.white
 l.TextScaled=true
 l.TextWrapped=true
 l.BackgroundTransparency=1
 l.Parent=g
 return l
end
local function billboard(parent,words,position)
 local mount=part(parent,"Visitor guide marker",Vector3.new(.4,.4,.4),CFrame.new(position),C.white,nil,false)
 mount.Transparency=1
 local gui=Instance.new("BillboardGui")
 gui.Size=UDim2.fromOffset(180,40)
 gui.AlwaysOnTop=false
 gui.MaxDistance=125
 gui.Adornee=mount
 gui.Parent=mount
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1)
 t.Text=words
 t.TextColor3=C.gold
 t.BackgroundColor3=color(26,52,56)
 t.BackgroundTransparency=.12
 t.TextScaled=true
 t.Font=Enum.Font.GothamBold
 t.Parent=gui
 local u=Instance.new("UICorner")
 u.CornerRadius=UDim.new(0,10)
 u.Parent=t
end

-- Expand original base ground, preserving all seven emirate landmarks.
local terrain=world:FindFirstChild("TerrainAndRoads")
local ground=terrain and terrain:FindFirstChild("UAE Desert Ground")
if ground and ground:IsA("BasePart") then
 ground.Size=Vector3.new(3300,2,3100)
end

-- Road rings: two separated lanes per route, no route crossings or merges.
local routes=group(root,"RingRoadNetwork")
local function loop(hw,hh,cz)
 local pts={}
 local radius=45
 local corners={
  {hw-radius,-hh+radius,-math.pi/2,0},
  {hw-radius,hh-radius,0,math.pi/2},
  {-hw+radius,hh-radius,math.pi/2,math.pi},
  {-hw+radius,-hh+radius,math.pi,math.pi*1.5},
 }
 for _,c in ipairs(corners) do
  for i=0,7 do
   local a=c[3]+(c[4]-c[3])*i/7
   pts[#pts+1]=Vector3.new(c[1]+radius*math.cos(a),0,cz+c[2]+radius*math.sin(a))
  end
 end
 return pts
end
local function roadBetween(parent,a,b,width,tint)
 local flat=Vector3.new(b.X-a.X,0,b.Z-a.Z)
 local len=flat.Magnitude
 local mid=(a+b)*.5+Vector3.new(0,.38,0)
 local cf=CFrame.lookAt(mid,mid+flat)
 part(parent,"Smooth asphalt road",Vector3.new(width,.4,len+1.8),cf,tint or C.road,Enum.Material.Asphalt,true)
end
local specs={
 {name="Downtown Dubai Ring",hw=310,hh=240,cz=-325},
 {name="Central UAE Ring",hw=330,hh=250,cz=215},
 {name="Outer Emirates Expressway",hw=1040,hh=950,cz=0},
}
for _,spec in ipairs(specs) do
 local folder=group(routes,spec.name)
 local p=loop(spec.hw,spec.hh,spec.cz)
 for i=1,#p do
  local a,b=p[i],p[i%#p+1]
  roadBetween(folder,a,b,34,C.road)
  local dir=(b-a)
  local center=(a+b)*.5+Vector3.new(0,.66,0)
  local cf=CFrame.lookAt(center,center+dir)
  part(folder,"Twin-lane divider",Vector3.new(.6,.10,dir.Magnitude+.5),
   cf,C.stripe,Enum.Material.SmoothPlastic,false)
 end
end
-- Connector roads and community boulevards.
local streets=group(root,"CityBoulevards")
for _,v in ipairs({
 {-725,-530,-725,470}, {720,-530,720,580},
 {-860,-110,860,-110}, {-850,480,850,480},
 {-710,625,740,625}, {-820,-670,710,-670},
}) do
 roadBetween(streets,Vector3.new(v[1],0,v[2]),Vector3.new(v[3],0,v[4]),24,C.road)
end

-- Richer, denser street fronts and varied midrise/highrise blocks.
local districts=group(root,"ExpandedUrbanDistricts")
local rng=Random.new(20261115)
local zones={
 {"Dubai Business", -640,-445, 5,4},
 {"Sharjah Community", 500,-510,5,4},
 {"Marina Residences", 520,-720,4,3},
 {"Abu Dhabi North", -740,-120,5,4},
 {"Central Offices", 470,180,5,4},
 {"Western Homes", -760,415,4,3},
 {"Northeast Tower Mile", 600,465,5,4},
 {"Fujairah Road", -730,770,4,3},
}
local tintSet={color(221,218,200),color(216,197,165),color(201,208,213),color(213,199,184),color(183,199,194)}
local function highrise(parent,x,z,w,h,depth,index)
 local face=tintSet[(index-1)%#tintSet+1]
 part(parent,"Architectural stone facade",Vector3.new(w,h,depth),CFrame.new(x,h/2,z),face,Enum.Material.Concrete,true)
 part(parent,"Recessed rooftop edge",Vector3.new(w+1.5,1.3,depth+1.5),CFrame.new(x,h+.65,z),C.silver,Enum.Material.Metal,false)
 for y=10,h-5,12 do
  part(parent,"Blue glass ribbon",Vector3.new(w-5,2.7,.35),CFrame.new(x,y,z+depth/2+.3),C.glass,Enum.Material.Glass,false)
  part(parent,"Rear glass ribbon",Vector3.new(w-5,2.7,.35),CFrame.new(x,y,z-depth/2-.3),C.glass,Enum.Material.Glass,false)
 end
 for _,side in ipairs({-1,1}) do
  part(parent,"Side window strip",Vector3.new(.4,math.max(8,h-13),4),
   CFrame.new(x+side*(w/2+.24),h/2,z),C.glass,Enum.Material.Glass,false)
 end
 part(parent,"Glass entrance",Vector3.new(9,7,.6),CFrame.new(x,3.5,z+depth/2+.4),C.glass,Enum.Material.Glass,false)
 if index%5==0 then
  part(parent,"Rooftop HVAC",Vector3.new(w*.42,4,depth*.3),CFrame.new(x,h+3,z),C.silver,Enum.Material.Metal,false)
 end
end
for _,area in ipairs(zones) do
 local f=group(districts,area[1])
 for i=1,area[4] do
  for j=1,area[5] do
   local n=(i-1)*area[5]+j
   local x=area[2]+(j-1)*63+rng:NextInteger(-7,7)
   local z=area[3]+(i-1)*64+rng:NextInteger(-8,8)
   local h=rng:NextInteger(4,16)*8
   if n%7==0 then h=math.floor(h*1.38) end
   local w=rng:NextInteger(32,44)
   local d=rng:NextInteger(28,44)
   highrise(f,x,z,w,h,d,n)
  end
 end
end

-- Decorative roadside plazas: planted trees, lamp posts, seats.
local landscape=group(root,"StreetFurnishings")
local function lamp(x,z)
 local pole=part(landscape,"Streetlight pole",Vector3.new(.8,25,.8),
  CFrame.new(x,12.5,z),C.silver,Enum.Material.Metal,false)
 local arm=part(landscape,"Streetlight arm",Vector3.new(8,.65,.65),
  CFrame.new(x+4,24,z),C.silver,Enum.Material.Metal,false)
 local bulb=part(landscape,"Streetlight LED",Vector3.new(3,.55,2),
  CFrame.new(x+7,23.7,z),C.gold,Enum.Material.Neon,false)
 local light=Instance.new("PointLight")
 light.Name="CityNightLamp"
 light.Color=C.gold
 light.Brightness=1.4
 light.Range=26
 light.Enabled=false
 light.Parent=bulb
end
for x=-850,850,125 do
 if math.abs(x)>50 then
  lamp(x,-84)
  lamp(x,493)
 end
end
for _,x in ipairs({-750,752}) do
 for z=-580,570,110 do lamp(x,z) end
end
local function palm(x,z)
 part(landscape,"Palm trunk",Vector3.new(2.2,17,2.2),CFrame.new(x,8.5,z),C.copper,Enum.Material.Wood,false)
 for _,ang in ipairs({0,math.pi/2,math.pi,math.pi*1.5}) do
  local px=x+7*math.cos(ang)
  local pz=z+7*math.sin(ang)
  part(landscape,"Palm leaf",Vector3.new(17,1.8,5),
   CFrame.new(px,19,pz)*CFrame.Angles(0,-ang,0),C.palm,Enum.Material.Grass,false)
 end
end
for _,p in ipairs({
 {-650,-225},{-555,-225},{500,-220},{607,-219},
 {-603,250},{-480,250},{525,360},{645,360},
 {-670,670},{-540,670},{530,650},{635,650},
}) do palm(p[1],p[2]) end
for _,p in ipairs({{-195,180},{-140,180},{100,188},{155,188},{-540,390},{510,-77}}) do
 part(landscape,"Public bench",Vector3.new(13,1.5,4),CFrame.new(p[1],1.8,p[2]),C.copper,Enum.Material.Wood,false)
end

-- Detailed emergency vehicle shell rebuild, preserving seat models and existing driver controls.
local garage=group(root,"EmergencyVehicleWorkshop")
local function rebuild(modelName,kind)
 local m=emergency:FindFirstChild(modelName)
 if not m then warn("Cannot find "..modelName) return end
 local seat=m:FindFirstChild("DriverSeat")
 if not seat then warn(modelName.." has no driver seat") return end
 local base=m:GetPivot()
 -- Repeated builds use prior root; avoid compounding rotation or position.
 local pos=base.Position
 -- Phase 1 used a chassis at Y=3.4 as PrimaryPart; reset our new root to road height.
 base=CFrame.new(pos.X,0,pos.Z)
 m.PrimaryPart=nil
 for _,child in ipairs(m:GetChildren()) do
  if child:IsA("BasePart") and child~=seat then child:Destroy() end
 end
 local length=kind=="Fire" and 36 or (kind=="Ambulance" and 29 or 24)
 local width=kind=="Fire" and 13.6 or (kind=="Ambulance" and 12.4 or 11.4)
 local rootPart=part(m,"Phase4Root",Vector3.new(.5,.5,.5),base,C.white,nil,false)
 rootPart.Transparency=1
 m.PrimaryPart=rootPart
 local function P(name,size,offset,tint,mat,collide,rotation)
  return part(m,name,size,base*CFrame.new(offset)*(rotation or CFrame.new()),tint,mat,collide)
 end
 local wheelZs=kind=="Fire" and {-12,7.5,12.3} or (kind=="Ambulance" and {-10,9.7} or {-8.4,7.7})
 for _,side in ipairs({-1,1}) do
  for _,z in ipairs(wheelZs) do
   local wheel=P("Realistic black tyre",Vector3.new(3.1,5.5,5.5),
    Vector3.new(side*(width/2+.5),3,z),C.black,Enum.Material.Rubber,false,CFrame.Angles(0,0,math.pi/2))
   wheel.Shape=Enum.PartType.Cylinder
   local hub=P("Wheel silver alloy",Vector3.new(3.2,2.6,2.6),
    Vector3.new(side*(width/2+.58),3,z),C.silver,Enum.Material.Metal,false,CFrame.Angles(0,0,math.pi/2))
   hub.Shape=Enum.PartType.Cylinder
   local axle=P("Wheel hub dark centre",Vector3.new(3.35,.75,.75),
    Vector3.new(side*(width/2+.6),3,z),C.black,Enum.Material.Metal,false,CFrame.Angles(0,0,math.pi/2))
   axle.Shape=Enum.PartType.Cylinder
  end
 end
 P("Undercarriage",Vector3.new(width,1.2,length),Vector3.new(0,3.5,0),C.black,Enum.Material.Metal,true)
 if kind=="Police" then
  P("White police SUV body",Vector3.new(width,3.6,length-1.4),Vector3.new(0,5.2,0),C.white,Enum.Material.Metal,true)
  P("SUV high passenger cabin",Vector3.new(width-1.2,2.8,length*.66),Vector3.new(0,8.2,.3),C.white,Enum.Material.Metal,true)
  P("SUV glass windshield",Vector3.new(width-2,2.65,.4),Vector3.new(0,8,-length/2+3.2),C.glass,Enum.Material.Glass,false)
  P("SUV rear window",Vector3.new(width-2,2.3,.4),Vector3.new(0,8,length/2-2.7),C.glass,Enum.Material.Glass,false)
  for _,side in ipairs({-1,1}) do
   P("Side window front",Vector3.new(.3,2.2,4.4),Vector3.new(side*(width/2+.11),8,-5.7),C.glass,Enum.Material.Glass,false)
   P("Side window rear",Vector3.new(.3,2.2,4.7),Vector3.new(side*(width/2+.11),8,2),C.glass,Enum.Material.Glass,false)
   local green=P("Dark green police door",Vector3.new(.32,2.6,8.8),
    Vector3.new(side*(width/2+.19),5.9,-.7),C.green,Enum.Material.SmoothPlastic,false)
   label(green,"الشرطة\nPOLICE",side>0 and Enum.NormalId.Right or Enum.NormalId.Left,C.white)
   P("Green running stripe",Vector3.new(.35,.6,17),Vector3.new(side*(width/2+.20),4.5,0),C.green,nil,false)
   P("SUV door mirror",Vector3.new(1.7,.7,1.4),Vector3.new(side*(width/2+1),8,-7),C.black,Enum.Material.Metal,false)
  end
  P("Police roof lightbar blue",Vector3.new(4,.9,1.4),Vector3.new(-2.4,10.3,-3),C.blue,Enum.Material.Neon,false)
  P("Police roof lightbar red",Vector3.new(4,.9,1.4),Vector3.new(2.4,10.3,-3),C.red,Enum.Material.Neon,false)
 elseif kind=="Ambulance" then
  -- Supplied reference: white front/side cabin, deep-navy high rear, red accents.
  P("Van lower white shell",Vector3.new(width,4,length-1),Vector3.new(0,5.1,0),C.white,Enum.Material.Metal,true)
  P("Rear blue medical box",Vector3.new(width+.12,6,15.2),Vector3.new(0,8.4,6.1),C.navy,Enum.Material.Metal,true)
  P("White raised medical roof",Vector3.new(width+.2,1,15.5),Vector3.new(0,11.7,6.1),C.white,Enum.Material.Metal,false)
  P("High white front cabin",Vector3.new(width-1.1,3.1,11.7),Vector3.new(0,8.5,-8.0),C.white,Enum.Material.Metal,true)
  P("Front windscreen",Vector3.new(width-2,2.9,.45),Vector3.new(0,8.5,-length/2+1.6),C.glass,Enum.Material.Glass,false)
  for _,side in ipairs({-1,1}) do
   P("Front glass passenger door",Vector3.new(.3,2.5,5.4),
    Vector3.new(side*(width/2+.08),9.2,-7.8),C.glass,Enum.Material.Glass,false)
   local panel=P("Rear navy blue panel",Vector3.new(.3,4.8,13.3),
    Vector3.new(side*(width/2+.20),8.1,6.1),C.navy,Enum.Material.Metal,false)
   label(panel,"الإسعاف\nAMBULANCE",side>0 and Enum.NormalId.Right or Enum.NormalId.Left,C.white)
   P("White front ambulance door",Vector3.new(.29,2.1,6.3),
    Vector3.new(side*(width/2+.22),5.8,-7),C.white,nil,false)
   P("Red rear medical signal",Vector3.new(.37,.8,11.5),
    Vector3.new(side*(width/2+.26),6.25,6.1),C.red,Enum.Material.Neon,false)
   P("Van door handle",Vector3.new(.38,.4,1.3),
    Vector3.new(side*(width/2+.28),6.6,-8),C.black,Enum.Material.Metal,false)
  end
  P("Ambulance front roof",Vector3.new(width,1.5,10),Vector3.new(0,10.9,-8.4),C.white,Enum.Material.Metal,false)
  for _,x in ipairs({-4.5,0,4.5}) do
   P("Emergency front roof beacon",Vector3.new(2,1.2,1.1),Vector3.new(x,12.3,-11),x==0 and C.white or C.red,Enum.Material.Neon,false)
  end
  P("Medical heartbeat line",Vector3.new(.4,.9,5),Vector3.new(width/2+.35,9.4,5.5),C.red,Enum.Material.Neon,false)
 else
  -- Supplied photo: yellow Dubai Civil Defence engine, white front, silver shutters,
  -- red/white diagonals, blue roof emergency lights, large 997 number.
  P("Yellow fire chassis body",Vector3.new(width,4.2,length-1),Vector3.new(0,5.5,0),C.yellow,Enum.Material.Metal,true)
  P("Raised yellow cab",Vector3.new(width-.7,6.7,12.7),Vector3.new(0,8,-11),C.yellow,Enum.Material.Metal,true)
  P("White cab roof",Vector3.new(width+.1,1,13.3),Vector3.new(0,11.9,-11),C.white,Enum.Material.Metal,false)
  P("Fire front windscreen",Vector3.new(width-2,4.0,.5),
    Vector3.new(0,9,-length/2+1.3),C.glass,Enum.Material.Glass,false)
  P("Silver water equipment compartment",Vector3.new(width-.1,7.0,20),
    Vector3.new(0,9,7.8),C.yellow,Enum.Material.Metal,true)
  P("Cab white front bumper",Vector3.new(width+1.0,1.45,1.2),
    Vector3.new(0,3.8,-length/2-.35),C.white,Enum.Material.Metal,false)
  for _,side in ipairs({-1,1}) do
   local face=side>0 and Enum.NormalId.Right or Enum.NormalId.Left
   P("Black cab window",Vector3.new(.32,3.1,5.2),Vector3.new(side*(width/2+.12),9.2,-10.0),C.glass,Enum.Material.Glass,false)
   local cabLogo=P("Red diagonal stripe label panel",Vector3.new(.28,3.0,9.7),
    Vector3.new(side*(width/2+.22),6.5,-10.1),C.red,Enum.Material.Metal,false)
   label(cabLogo,"DUBAI\nCIVIL DEFENCE",face,C.gold)
   for band=1,5 do
    P("Cab diagonal red emergency stripe",Vector3.new(.32,.65,7.6),
     Vector3.new(side*(width/2+.34),8+band*.28,-12.2+(band-2)*.82),
     C.red,Enum.Material.Neon,false,CFrame.Angles(math.rad(32),0,0))
   end
   for index=1,3 do
    local z=.2+(index-1)*6.6
    local door=P("Brushed steel equipment shutter",Vector3.new(.36,5.3,6.1),
     Vector3.new(side*(width/2+.14),9.0,z),color(170,174,172),Enum.Material.Metal,false)
    for j=1,6 do
     P("Shutter horizontal groove",Vector3.new(.42,.1,5.9),
      Vector3.new(side*(width/2+.22),6.65+j*.73,z),C.silver,Enum.Material.Metal,false)
    end
   end
   P("Upper red/white livery stripe",Vector3.new(.4,1.1,20.4),
    Vector3.new(side*(width/2+.30),12.2,7.1),C.red,Enum.Material.Neon,false)
   local badge=P("Large Dubai 997 display",Vector3.new(.4,3.9,6.0),
    Vector3.new(side*(width/2+.36),9.1,11),color(176,178,169),Enum.Material.Metal,false)
   label(badge,"997",face,C.red)
   local arabic=P("Arabic Civil Defence lower door",Vector3.new(.32,1.4,10.7),
    Vector3.new(side*(width/2+.32),4.9,-9.7),C.yellow,Enum.Material.SmoothPlastic,false)
   label(arabic,"الدفاع المدني",face,C.red)
  end
  for _,x in ipairs({-4.1,4.1}) do
   P("Blue siren light",Vector3.new(3.5,1.3,1.5),
    Vector3.new(x,13.2,-13),C.blue,Enum.Material.Neon,false)
  end
  for _,x in ipairs({-3.8,3.8}) do
   P("Fire truck headlamp",Vector3.new(2,.9,.42),
    Vector3.new(x,5,-length/2-.42),C.white,Enum.Material.Neon,false)
  end
 end
 -- Wheels, lights and mirrors shared across vehicles.
 for _,side in ipairs({-1,1}) do
  P("Warm white headlight",Vector3.new(1.5,.7,.45),
   Vector3.new(side*(width/2-2),4.6,-length/2-.2),C.white,Enum.Material.Neon,false)
  P("Rear red tail light",Vector3.new(1.7,.75,.4),
   Vector3.new(side*(width/2-2),4.7,length/2+.2),C.red,Enum.Material.Neon,false)
 end
 -- Seat above the roof line of the older block car, inside new front cabin.
 seat.Anchored=true
 seat.Transparency=1
 seat.CanCollide=false
 seat.CFrame=base*CFrame.new(-1.5,kind=="Fire" and 8 or 7.3,-length/2+7.8)
 seat.MaxSpeed=0
 m:SetAttribute("Phase4Rebuilt",true)
end
rebuild("Green Police SUV","Police")
rebuild("Blue White Ambulance","Ambulance")
rebuild("Yellow Civil Defence Truck","Fire")

-- Animated NPC vehicle models: diverse bodies, wheels, mirrors, windows, taxi roof.
local trafficFolder=group(root,"RouteTraffic")
local styles={
 {name="UAE Cream Taxi",c=color(240,210,152),roof=color(152,47,66),type="Taxi"},
 {name="Dubai Red Taxi",c=color(250,244,231),roof=color(174,43,61),type="Taxi"},
 {name="White Family Sedan",c=color(243,242,236),roof=C.white,type="Sedan"},
 {name="Graphite Executive SUV",c=color(50,62,68),roof=C.black,type="SUV"},
 {name="Gold Crossover",c=color(170,137,77),roof=C.silver,type="SUV"},
 {name="Pearl White Bus",c=C.white,roof=C.blue,type="Bus"},
 {name="Turquoise City Bus",c=color(37,150,159),roof=C.white,type="Bus"},
 {name="Silver Sedan",c=color(182,188,192),roof=C.silver,type="Sedan"},
 {name="Maroon SUV",c=color(111,43,67),roof=C.black,type="SUV"},
 {name="Sand Delivery Van",c=color(213,192,149),roof=C.white,type="Van"},
}
local function makeTraffic(i,lane,progress,speed)
 local style=styles[(i-1)%#styles+1]
 local m=Instance.new("Model")
 m.Name=style.name.." "..i
 m:SetAttribute("Lane",lane)
 m:SetAttribute("Progress",progress)
 m:SetAttribute("Speed",speed)
 m.Parent=trafficFolder
 local rootPart=part(m,"TrafficRoot",Vector3.new(.3,.3,.3),CFrame.new(),C.white,nil,false)
 rootPart.Transparency=1
 m.PrimaryPart=rootPart
 local b=(style.type=="Bus" and 22) or (style.type=="Van" and 19) or 16
 local w=(style.type=="Bus" and 9.9) or 8.9
 local height=(style.type=="Bus" and 5.8) or (style.type=="Van" and 5.5) or 3.4
 local y=(style.type=="Bus" and 6.3) or (style.type=="Van" and 5.7) or 5.0
 local function p(name,size,x,yy,z,col,mat,rot)
  return part(m,name,size,CFrame.new(x,yy,z)*(rot or CFrame.new()),col,mat,false)
 end
 p("Car lower painted body",Vector3.new(w,height,b),0,y,0,style.c,Enum.Material.Metal)
 p("Car roof",Vector3.new(w-.65,.75,b*.65),0,y+height/2+.33,1,style.roof,Enum.Material.Metal)
 p("Front windshield",Vector3.new(w-1.2,2.4,.35),0,y+height/2-.6,-b/2+.55,C.glass,Enum.Material.Glass)
 p("Rear windshield",Vector3.new(w-1.2,2,.35),0,y+height/2-.4,b/2-.5,C.glass,Enum.Material.Glass)
 for _,side in ipairs({-1,1}) do
  for _,z in ipairs({-b*.28,b*.29}) do
   local wheel=p("Black wheel",Vector3.new(2.3,4.6,4.6),side*(w/2+.3),2.75,z,C.black,Enum.Material.Rubber,CFrame.Angles(0,0,math.pi/2))
   wheel.Shape=Enum.PartType.Cylinder
   local hub=p("Alloy wheel face",Vector3.new(2.4,1.9,1.9),side*(w/2+.44),2.75,z,C.silver,Enum.Material.Metal,CFrame.Angles(0,0,math.pi/2))
   hub.Shape=Enum.PartType.Cylinder
  end
  p("Dark window band",Vector3.new(.24,1.8,b*.45),
   side*(w/2+.15),y+height/2-.4,0,C.glass,Enum.Material.Glass)
  p("Mirror",Vector3.new(.8,.6,1.2),
   side*(w/2+.7),y+height/2-1,-b*.28,C.black,Enum.Material.Metal)
  p("Headlight",Vector3.new(1.7,.7,.4),side*3,4.4,-b/2-.15,C.gold,Enum.Material.Neon)
  p("Tail light",Vector3.new(1.4,.7,.4),side*3,4.4,b/2+.15,C.red,Enum.Material.Neon)
 end
 if style.type=="Taxi" then
  local roof=p("Taxi illuminated marker",Vector3.new(3,1.2,2),0,y+height/2+1.1,0,C.gold,Enum.Material.Neon)
  label(roof,"TAXI",Enum.NormalId.Front,C.black)
 end
 if style.type=="Bus" then
  for z=-7,9,4 do
   p("Large bus side window",Vector3.new(w+.5,2.2,2.8),0,y+1.3,z,C.glass,Enum.Material.Glass)
  end
 end
 return m
end
-- Two lanes per loop with fixed constant speed, equal spacing prevents AI car overlap.
local laneSpec={
 {id="D1",hw=302,hh=232,cz=-325,n=9,speed=21},
 {id="D2",hw=317,hh=247,cz=-325,n=9,speed=21},
 {id="C1",hw=322,hh=242,cz=215,n=9,speed=19},
 {id="C2",hw=337,hh=257,cz=215,n=9,speed=19},
 {id="O1",hw=1032,hh=942,cz=0,n=8,speed=25},
 {id="O2",hw=1047,hh=957,cz=0,n=8,speed=25},
}
-- Place vehicles on real road lanes immediately in Edit mode, not piled up at origin.
local function previewPose(spec,progress)
 local points=loop(spec.hw,spec.hh,spec.cz)
 local d=progress
 for i=1,#points do
  local a,b=points[i],points[i%#points+1]
  local len=(b-a).Magnitude
  if d<=len then
   local pos=a:Lerp(b,math.clamp(d/len,0,1))
   return CFrame.lookAt(pos,pos+(b-a).Unit)
  end
  d=d-len
 end
 local a,b=points[1],points[2]
 return CFrame.lookAt(a,b)
end
local count=0
for _,spec in ipairs(laneSpec) do
 local points=loop(spec.hw,spec.hh,spec.cz)
 local dist=0
 for j=1,#points do dist=dist+(points[j%#points+1]-points[j]).Magnitude end
 for k=1,spec.n do
  count=count+1
  local position=dist*(k-1)/spec.n
  local trafficCar=makeTraffic(count,spec.id,position,spec.speed)
  trafficCar:PivotTo(previewPose(spec,position))
 end
end

-- Citizen waypoints used by live R15 humanoids. Free of car routes.
local sidewalks=group(root,"CitizenWaypoints")
for _,p in ipairs({
 {175,365},{290,365},{290,420},{175,420},
 {-175,195},{-80,195},{-80,235},{-175,235},
 {75,170},{150,170},{150,210},{75,210},
}) do
 local anchor=part(sidewalks,"Walking target",Vector3.new(.6,.6,.6),
  CFrame.new(p[1],1,p[2]),C.white,nil,false)
 anchor.Transparency=1
end

-- Keep the original signs readable but reduce their former billboard clutter.
for _,gui in ipairs(world:GetDescendants()) do
 if gui:IsA("BillboardGui") and gui.Name=="LocationSign" then
  local width=gui.Size.X.Offset
  gui.Size=UDim2.fromOffset(math.min(width,175),39)
  gui.MaxDistance=145
 end
end

-- Light cinematic grade and more transparent glass while keeping Dell-laptop performance.
L.ClockTime=14
L.Brightness=2.2
L.GlobalShadows=true
L.ShadowSoftness=.3
L.EnvironmentDiffuseScale=.68
L.EnvironmentSpecularScale=.72
pcall(function() L.LightingStyle=Enum.LightingStyle.Realistic end)
local fog=L:FindFirstChild("UAEAtmosphere")
if fog and fog:IsA("Atmosphere") then
 fog.Density=.17
 fog.Haze=.65
 fog.Glare=.12
 fog.Color=color(239,213,183)
end
local grade=L:FindFirstChild("UAEColorGrade")
if grade and grade:IsA("ColorCorrectionEffect") then
 grade.Contrast=.12
 grade.Saturation=.09
 grade.Brightness=.015
 grade.TintColor=color(255,247,234)
end

-- Replace previous camera script in Edit mode; HUD owns its own ScreenGui.
local function install(class,parent,name,source)
 local prior=parent:FindFirstChild(name)
 if prior then prior:Destroy() end
 local obj=Instance.new(class)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
 return obj
end
-- old camera from Phase 2 needs removal or it would compete with the new camera.
local oldCam=SP.StarterPlayerScripts:FindFirstChild("UAE_VehicleCamera")
if oldCam then oldCam:Destroy() end
install("LocalScript",SP.StarterPlayerScripts,"UAE_Phase4Camera",[========[
-- PHASE 4 improved chase camera for all 3 UAE emergency vehicles.
-- Exits cleanly when player leaves a seat. Does not affect walking camera.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local wasDriving=false
local function carSeat()
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then
   return model,hum
  end
 end
 return nil,hum
end
RunService:BindToRenderStep("UAE_Phase4Camera",Enum.RenderPriority.Camera.Value+1,function(dt)
 local camera=workspace.CurrentCamera
 if not camera then return end
 local car,hum=carSeat()
 if not car then
  if wasDriving then
   camera.CameraType=Enum.CameraType.Custom
   if hum then camera.CameraSubject=hum end
   camera.FieldOfView=70
   wasDriving=false
  end
  return
 end
 local typeName=car:GetAttribute("VehicleType") or "Police"
 local isFire=typeName=="Fire"
 local isAmbulance=typeName=="Ambulance"
 local height=isFire and 21 or (isAmbulance and 18 or 14)
 local distance=isFire and 43 or (isAmbulance and 38 or 34)
 local aimY=isFire and 7.5 or 5.2
 local basis=car:GetPivot()
 local eye=(basis*CFrame.new(0,height,distance)).Position
 local focus=(basis*CFrame.new(0,aimY,-14)).Position
 local desired=CFrame.lookAt(eye,focus)
 camera.CameraType=Enum.CameraType.Scriptable
 if wasDriving then
  camera.CFrame=camera.CFrame:Lerp(desired,math.clamp(dt*9,0,1))
 else
  camera.CFrame=desired
 end
 camera.FieldOfView=74
 wasDriving=true
end)

]========])
install("LocalScript",SP.StarterPlayerScripts,"UAE_Phase4HUD",[========[
-- PHASE 4 - circular local minimap, Dubai GST clock and game day/night HUD.
-- All drawn in Lua UI; no web requests or copyrighted map texture.
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local ui=Instance.new("ScreenGui")
ui.Name="UAE_Phase4_HUD"
ui.ResetOnSpawn=false
ui.DisplayOrder=10
ui.IgnoreGuiInset=false
ui.Parent=player:WaitForChild("PlayerGui")
local function round(p,r)
 local u=Instance.new("UICorner")
 u.CornerRadius=UDim.new(r or 0,0)
 u.Parent=p
end
local function txt(parent,name,text,size,pos,fontSize,col)
 local t=Instance.new("TextLabel")
 t.Name=name
 t.Text=text
 t.Size=size
 t.Position=pos
 t.BackgroundTransparency=1
 t.TextColor3=col or Color3.fromRGB(253,247,232)
 t.Font=Enum.Font.GothamBold
 t.TextSize=fontSize or 13
 t.TextXAlignment=Enum.TextXAlignment.Left
 t.Parent=parent
 return t
end
local clockBox=Instance.new("Frame")
clockBox.Name="DubaiClock"
clockBox.Size=UDim2.fromOffset(275,52)
clockBox.Position=UDim2.fromOffset(15,14)
clockBox.BackgroundColor3=Color3.fromRGB(16,35,44)
clockBox.BackgroundTransparency=.08
clockBox.BorderSizePixel=0
clockBox.Parent=ui
round(clockBox,.2)
local cborder=Instance.new("UIStroke")
cborder.Color=Color3.fromRGB(222,182,104)
cborder.Transparency=.24
cborder.Parent=clockBox
local liveTime=txt(clockBox,"DubaiLocalTime","DUBAI • --:-- GST",UDim2.new(1,-15,0,25),UDim2.fromOffset(12,3),16,Color3.fromRGB(255,232,168))
local gameTime=txt(clockBox,"DayNight","GAME TIME • --:--",UDim2.new(1,-15,0,20),UDim2.fromOffset(12,27),12)

local frame=Instance.new("Frame")
frame.Name="CircularMinimap"
frame.Size=UDim2.fromOffset(178,178)
frame.Position=UDim2.fromOffset(15,75)
frame.BackgroundColor3=Color3.fromRGB(14,39,48)
frame.BorderSizePixel=0
frame.BackgroundTransparency=.06
frame.Parent=ui
round(frame,.5)
local border=Instance.new("UIStroke")
border.Thickness=2
border.Color=Color3.fromRGB(230,185,103)
border.Transparency=.18
border.Parent=frame
local viewport=Instance.new("Frame")
viewport.Name="MapRoundMask"
viewport.AnchorPoint=Vector2.new(.5,.5)
viewport.Position=UDim2.fromScale(.5,.5)
viewport.Size=UDim2.fromOffset(163,163)
viewport.BackgroundColor3=Color3.fromRGB(181,161,118)
viewport.BorderSizePixel=0
viewport.ClipsDescendants=true
viewport.Parent=frame
round(viewport,.5)
local ocean=Instance.new("Frame")
ocean.Name="CoastBackground"
ocean.Size=UDim2.fromScale(1,1)
ocean.BackgroundColor3=Color3.fromRGB(49,119,136)
ocean.BackgroundTransparency=.7
ocean.BorderSizePixel=0
ocean.Parent=viewport
local roadsFrame=Instance.new("Frame")
roadsFrame.Name="Roads"
roadsFrame.BackgroundTransparency=1
roadsFrame.Size=UDim2.fromScale(1,1)
roadsFrame.Parent=viewport
local dot=Instance.new("Frame")
dot.Name="PlayerArrow"
dot.AnchorPoint=Vector2.new(.5,.5)
dot.Size=UDim2.fromOffset(13,13)
dot.Position=UDim2.fromScale(.5,.5)
dot.BackgroundColor3=Color3.fromRGB(232,58,65)
dot.BorderSizePixel=0
dot.ZIndex=8
dot.Parent=viewport
round(dot,.5)
local dotStroke=Instance.new("UIStroke")
dotStroke.Thickness=2
dotStroke.Color=Color3.new(1,1,1)
dotStroke.Parent=dot
local north=txt(frame,"CompassNorth","N",UDim2.fromOffset(22,20),
 UDim2.new(.5,-7,0,-4),12,Color3.fromRGB(255,222,143))
north.TextXAlignment=Enum.TextXAlignment.Center
north.ZIndex=12
local toggle=Instance.new("TextButton")
toggle.Name="MapToggle"
toggle.Size=UDim2.fromOffset(37,30)
toggle.Position=UDim2.fromOffset(155,10)
toggle.BackgroundColor3=Color3.fromRGB(23,53,62)
toggle.Text="MAP"
toggle.Font=Enum.Font.GothamBold
toggle.TextSize=11
toggle.TextColor3=Color3.new(1,1,1)
toggle.ZIndex=13
toggle.Parent=ui
round(toggle,.2)
local hint=txt(ui,"MinimapHint","M TO HIDE MAP",UDim2.fromOffset(140,21),
 UDim2.fromOffset(28,255),11,Color3.fromRGB(255,234,194))
local mission=Instance.new("Frame")
mission.Name="ExplorerMission"
mission.Size=UDim2.fromOffset(270,72)
mission.Position=UDim2.fromOffset(15,285)
mission.BackgroundColor3=Color3.fromRGB(16,37,44)
mission.BackgroundTransparency=.12
mission.BorderSizePixel=0
mission.Parent=ui
round(mission,.2)
local missionHeader=txt(mission,"Header","UAE EXPLORER • FIRST MISSION",UDim2.new(1,-14,0,21),
 UDim2.fromOffset(9,7),13,Color3.fromRGB(255,228,158))
local missionDetail=txt(mission,"Details","Visit Burj Khalifa, Sharjah, Ajman",UDim2.new(1,-14,0,41),
 UDim2.fromOffset(9,28),12)
missionDetail.TextWrapped=true

local segments={}
local function add(x1,z1,x2,z2)
 segments[#segments+1]={x1=x1,z1=z1,x2=x2,z2=z2}
end
-- The map follows the user's position; these are simplified game roads, not satellite data.
for _,z in ipairs({30,-235,335}) do add(-860,z,860,z) end
for _,x in ipairs({-390,0,390}) do add(x,-700,x,760) end
local function loop(hw,hh,cz)
 -- Round-corner route segments used by traffic, approximate polygon.
 local radius=46
 local coords={}
 local corners={
  {hw-radius,-hh+radius,-math.pi/2,0},
  {hw-radius,hh-radius,0,math.pi/2},
  {-hw+radius,hh-radius,math.pi/2,math.pi},
  {-hw+radius,-hh+radius,math.pi,math.pi*1.5}
 }
 for _,c in ipairs(corners) do
  for i=0,5 do
   local a=c[3]+(c[4]-c[3])*i/5
   coords[#coords+1]={x=c[1]+radius*math.cos(a),z=cz+c[2]+radius*math.sin(a)}
  end
 end
 for i=1,#coords do
  local a,b=coords[i],coords[(i%#coords)+1]
  add(a.x,a.z,b.x,b.z)
 end
end
loop(310,240,-325)
loop(330,250,215)
loop(1040,950,0)
local lineInstances={}
local function lineObject()
 local obj=Instance.new("Frame")
 obj.BackgroundColor3=Color3.fromRGB(246,237,205)
 obj.BackgroundTransparency=.09
 obj.BorderSizePixel=0
 obj.AnchorPoint=Vector2.new(0,.5)
 obj.Parent=roadsFrame
 return obj
end
for i=1,#segments do lineInstances[i]=lineObject() end
local sites={
 {x=-84,z=-392,name="D"},{x=-390,z=-396,name="A"},
 {x=390,z=-380,name="S"},{x=390,z=210,name="J"},
 {x=-390,z=227,name="U"},{x=410,z=580,name="R"},
 {x=-390,z=580,name="F"},
}
local pins={}
for _,item in ipairs(sites) do
 local pin=Instance.new("TextLabel")
 pin.Name="Emirate "..item.name
 pin.Size=UDim2.fromOffset(13,13)
 pin.BackgroundColor3=Color3.fromRGB(25,62,69)
 pin.TextColor3=Color3.fromRGB(250,221,148)
 pin.Font=Enum.Font.GothamBold
 pin.TextSize=10
 pin.Text=item.name
 pin.BorderSizePixel=0
 pin.AnchorPoint=Vector2.new(.5,.5)
 pin.Parent=viewport
 round(pin,.5)
 pins[#pins+1]=pin
end
local zoom=3.9 -- pixels per 10 studs; local radius about 200 studs.
local function placeMarker(worldX,worldZ,playerX,playerZ)
 return 81.5+(worldX-playerX)*.39,81.5+(worldZ-playerZ)*.39
end
local minimapVisible=true
local function toggleMap()
 minimapVisible=not minimapVisible
 frame.Visible=minimapVisible
 hint.Visible=minimapVisible
 toggle.Text=minimapVisible and "MAP" or "+"
end
toggle.MouseButton1Click:Connect(toggleMap)
UserInputService.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.M then toggleMap() end
end)
local points={
 {name="Burj Khalifa • Dubai",x=-84,z=-392},
 {name="Sharjah Heritage",x=390,z=-380},
 {name="Ajman Beach",x=390,z=210}
}
local progress=1
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
 accumulator=accumulator+dt
 if accumulator<.2 then return end
 accumulator=0
 local char=player.Character
 local root=char and char:FindFirstChild("HumanoidRootPart")
 if root then
  if minimapVisible then
   for i,edge in ipairs(segments) do
    local x1,y1=placeMarker(edge.x1,edge.z1,root.Position.X,root.Position.Z)
    local x2,y2=placeMarker(edge.x2,edge.z2,root.Position.X,root.Position.Z)
    local dx,dy=x2-x1,y2-y1
    local line=lineInstances[i]
    line.Position=UDim2.fromOffset(x1,y1)
    line.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy),3)
    line.Rotation=math.deg(math.atan2(dy,dx))
   end
   for i,item in ipairs(sites) do
    local x,y=placeMarker(item.x,item.z,root.Position.X,root.Position.Z)
    pins[i].Position=UDim2.fromOffset(x,y)
    pins[i].Visible=math.abs(x)<182 and math.abs(y)<182
   end
  end
  if progress<=#points then
   local p=points[progress]
   local planar=Vector3.new(root.Position.X-p.x,0,root.Position.Z-p.z)
   if planar.Magnitude<90 then progress=progress+1 end
  end
 end
 if progress<=#points then
  missionDetail.Text=string.format("%d/3 complete • Go to %s",progress-1,points[progress].name)
 else
  missionHeader.Text="MISSION COMPLETE! 🇦🇪"
  missionDetail.Text="You explored 3 UAE districts!"
 end
 local dubaiSec=os.time()+4*3600
 liveTime.Text="DUBAI  •  "..os.date("!%H:%M",dubaiSec).." GST"
 local h=ReplicatedStorage:GetAttribute("UAECycleHour")
 if typeof(h)=="number" then
  Lighting.ClockTime=h
  local hours=math.floor(h)%24
  local minutes=math.floor((h%1)*60)
  local period=(h>=6 and h<18) and "DAY" or "NIGHT"
  gameTime.Text=string.format("GAME %02d:%02d  •  %s  |  40-MIN CYCLE",hours,minutes,period)
 else
  gameTime.Text="GAME TIME: waiting for server"
 end
end)

]========])
install("Script",SS,"UAE_Phase4LiveTraffic",[========[
-- PHASE 4: route-locked city traffic, R15 ambient people, live day-night cycle.
-- Studio server script. All traffic vehicles non-collidable: deliberate for this v4 beta.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase4_MegaCity")
local vehicles=root:WaitForChild("RouteTraffic")
local humans=root:WaitForChild("CitizenWaypoints")
-- One-way nested ring lanes. They never cross, merge or intersect each other.
-- Cars in the same ring/lane have identical speed and are equally spaced.
local function route(hw,hh,cz)
 local coords={}
 local r=45
 local corners={
  {hw-r,-hh+r,-math.pi/2,0},
  {hw-r, hh-r,0,math.pi/2},
  {-hw+r,hh-r,math.pi/2,math.pi},
  {-hw+r,-hh+r,math.pi,math.pi*1.5}
 }
 for _,c in ipairs(corners) do
  for i=0,7 do
   local a=c[3]+(c[4]-c[3])*i/7
   coords[#coords+1]=Vector3.new(c[1]+r*math.cos(a),0,cz+c[2]+r*math.sin(a))
  end
 end
 local lengths={}
 local total=0
 for i=1,#coords do
  local len=(coords[i%#coords+1]-coords[i]).Magnitude
  lengths[i]=len
  total=total+len
 end
 return {pts=coords,lengths=lengths,length=total}
end
local routes={
 D1=route(302,232,-325), D2=route(317,247,-325),
 C1=route(322,242,215), C2=route(337,257,215),
 O1=route(1032,942,0),O2=route(1047,957,0),
}
local function positionAt(route,d)
 d=d%route.length
 for i,len in ipairs(route.lengths) do
  if d<=len then
   local a=route.pts[i]
   local b=route.pts[i%#route.pts+1]
   local pos=a:Lerp(b,math.clamp(d/len,0,1))
   local ahead=route.pts[(i+1)%#route.pts+1]
   local smooth=b:Lerp(ahead,math.min(.12,1))
   local look=(b-pos)
   if look.Magnitude<1 then look=smooth-b end
   if look.Magnitude<.01 then look=Vector3.new(0,0,-1) end
   return pos,look.Unit
  end
  d=d-len
 end
 return route.pts[1],Vector3.new(0,0,-1)
end
local cars={}
for _,model in ipairs(vehicles:GetChildren()) do
 if model:IsA("Model") and model.PrimaryPart then
  local lane=model:GetAttribute("Lane") or "D1"
  local path=routes[lane]
  if path then
   cars[#cars+1]={
    model=model,route=path,
    s=tonumber(model:GetAttribute("Progress")) or 0,
    speed=tonumber(model:GetAttribute("Speed")) or 17
   }
  end
 end
end
local clockStart=os.clock()
local function updateClock()
 local cycle=(14+(os.clock()-clockStart)*24/(40*60))%24
 ReplicatedStorage:SetAttribute("UAECycleHour",cycle)
 Lighting.ClockTime=cycle
 local night=cycle<6 or cycle>=18.2
 for _,lamp in ipairs(root:GetDescendants()) do
  if lamp:IsA("PointLight") and lamp.Name=="CityNightLamp" then
   lamp.Enabled=night
  end
 end
end
updateClock()
task.spawn(function()
 while root.Parent do
  updateClock()
  task.wait(6)
 end
end)
local accumulated=0
RunService.Heartbeat:Connect(function(dt)
 accumulated=accumulated+math.min(dt,.12)
 if accumulated<.065 then return end
 local step=math.min(accumulated,.16)
 accumulated=0
 for _,car in ipairs(cars) do
  if car.model.Parent then
   car.s=(car.s+car.speed*step)%car.route.length
   local pos,forward=positionAt(car.route,car.s)
   car.model:PivotTo(CFrame.lookAt(pos,pos+forward))
  end
 end
end)

-- Actual R15 Roblox Humanoid models. No downloaded/copy-protected avatars or accessories.
-- Rendering defaults are simple but better than floating rectangular mannequins.
local torsoColors={
 Color3.fromRGB(244,242,232),Color3.fromRGB(61,111,166),
 Color3.fromRGB(139,49,64),Color3.fromRGB(223,180,62),
 Color3.fromRGB(65,128,88),Color3.fromRGB(176,179,182),
}
local skinColors={
 Color3.fromRGB(231,188,147),Color3.fromRGB(191,142,103),
 Color3.fromRGB(145,104,80),Color3.fromRGB(247,210,166),
}
local locations={
 {Vector3.new(180,2,370),Vector3.new(279,2,370),Vector3.new(279,2,415),Vector3.new(180,2,415)},
 {Vector3.new(-165,2,200),Vector3.new(-90,2,200),Vector3.new(-90,2,228),Vector3.new(-165,2,228)},
 {Vector3.new(82,2,175),Vector3.new(148,2,175),Vector3.new(148,2,202),Vector3.new(82,2,202)},
}
local npcFolder=Instance.new("Folder")
npcFolder.Name="R15WalkingCitizens"
npcFolder.Parent=root
for i=1,15 do
 task.spawn(function()
  local description=Instance.new("HumanoidDescription")
  local skin=skinColors[(i-1)%#skinColors+1]
  local outfit=torsoColors[(i-1)%#torsoColors+1]
  description.HeadColor=skin
  description.LeftArmColor=skin
  description.RightArmColor=skin
  description.TorsoColor=outfit
  description.LeftLegColor=Color3.fromRGB(55,68,78)
  description.RightLegColor=Color3.fromRGB(55,68,78)
  description.HeightScale=.92+(i%4)*.04
  description.WidthScale=.95
  local ok,rig=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15)
  end)
  description:Destroy()
  if not ok or not rig then
   warn("UAE City Life: unable to create NPC "..i)
   return
  end
  rig.Name="UAE Resident "..i
  local hum=rig:FindFirstChildOfClass("Humanoid")
  local hrp=rig:FindFirstChild("HumanoidRootPart")
  if not hum or not hrp then rig:Destroy() return end
  local route=locations[(i-1)%#locations+1]
  local start=(i-1)%4+1
  rig.Parent=npcFolder
  rig:PivotTo(CFrame.new(route[start]))
  hum.WalkSpeed=7+(i%3)
  hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  -- Citizens don't push players or interfere with emergency vehicles.
  for _,p in ipairs(rig:GetDescendants()) do
   if p:IsA("BasePart") then
    -- Root collision keeps R15 humanoids supported by ground.
    -- Limbs are noncollidable so they do not snag on street props.
    p.CanCollide=(p.Name=="HumanoidRootPart")
   end
  end
  -- A hidden non-colliding root still moves through MoveTo; no teleporting across roads.
  while rig.Parent and root.Parent and hum.Health>0 do
   local nextIndex=start%#route+1
   local target=route[nextIndex]
   hum:MoveTo(target)
   local reached=hum.MoveToFinished:Wait()
   if not reached then hum:MoveTo(target) end
   start=nextIndex
   task.wait(.25+(i%3)*.12)
  end
 end)
 task.wait(.12)
end

]========])

print("UAE CITY LIFE PHASE 4: 52 lane-locked civilian vehicles, expanded city, updated police/ambulance/fire truck, circular minimap, GST clock, 15 R15 citizens (Play) and day/night cycle.")
