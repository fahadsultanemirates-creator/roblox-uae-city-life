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
