-- UAE City Life Phase 6: coherent visual/art-direction pass, optimized for a laptop.
-- Stylized original city geometry. Custom licensed MeshParts would still be required for AAA.
local L=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local low=root:GetAttribute("LowPerformance")==true
local group=Instance.new("Folder")
group.Name="CityVisualRefinement"
group.Parent=root
local function rgb(r,g,b)return Color3.fromRGB(r,g,b) end
local P={concrete=rgb(197,196,187),brick=rgb(191,172,148),metal=rgb(118,143,151),
 glass=rgb(88,155,188),sand=rgb(193,170,126),stone=rgb(221,218,201),
 night=rgb(33,62,84),amber=rgb(249,222,155),road=rgb(49,57,61),white=rgb(232,226,211),
 green=rgb(63,137,100),silver=rgb(178,188,186),red=rgb(201,77,72)}
local function part(parent,name,size,cf,color,mat,collidable)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true
 p.Color=color or P.stone;p.Material=mat or Enum.Material.Concrete
 p.CanCollide=collidable==true;p.CastShadow=collidable==true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function sign(parent,text,cf,wide,tint)
 local plate=part(parent,"Road sign",Vector3.new(wide,5,.4),cf,tint or P.night,Enum.Material.Metal,false)
 local s=Instance.new("SurfaceGui")
 s.Face=Enum.NormalId.Front;s.PixelsPerStud=45;s.Parent=plate
 local t=Instance.new("TextLabel")
 t.Text=text;t.TextScaled=true;t.TextWrapped=true
 t.Font=Enum.Font.GothamBold;t.TextColor3=P.white
 t.BackgroundTransparency=1;t.Size=UDim2.fromScale(1,1);t.Parent=s
end
local function lamp(x,z)
 part(group,"City smart streetlamp",Vector3.new(.6,15,.6),CFrame.new(x,7.8,z),P.metal,Enum.Material.Metal,false)
 local light=part(group,"City LED lamp",Vector3.new(4,.3,1.1),
  CFrame.new(x+1.3,15.2,z),P.amber,Enum.Material.Neon,false)
 if not low then
  local pl=Instance.new("PointLight")
  pl.Name="UAE60NightLight";pl.Color=P.amber;pl.Brightness=1.1
  pl.Range=35;pl.Enabled=false;pl.Parent=light
 end
end
local function palm(x,z,height)
 part(group,"Dubai palm trunk",Vector3.new(1.9,height,1.9),CFrame.new(x,height/2+.7,z),
  P.brick,Enum.Material.Wood,false)
 for n=0,4 do
  local a=n*math.pi*2/5
  part(group,"Curved palm crown",Vector3.new(13,1.2,3.3),
   CFrame.new(x+4*math.cos(a),height+.7,z+4*math.sin(a))*
    CFrame.Angles(0,-a,math.rad(n%2==0 and 13 or -11)),P.green,Enum.Material.Grass,false)
 end
end
local count=0
-- E11 pedestrian promenade: clear lane margins and crossing islands.
for _,z in ipairs({-1450,-1360,-1270,-1180,-1090,-1000}) do
 for _,side in ipairs({-1,1}) do
  local x=side*97
  lamp(x,z);count=count+1
  if not low or z%2==0 then palm(x+side*15,z,13) end
 end
end
-- Airport passenger plaza: more navigable entrance, canopy columns and realistic wayfinding.
local a=Instance.new("Folder");a.Name="DXBArrivalsArchitecture";a.Parent=group
part(a,"Glass departure canopy",Vector3.new(128,1.3,21),CFrame.new(-1078,18,-900),P.glass,Enum.Material.Glass,false)
for _,x in ipairs({-1132,-1100,-1064,-1030}) do
 part(a,"Terminal silver canopy column",Vector3.new(1.4,17,1.4),CFrame.new(x,9.4,-901),P.silver,Enum.Material.Metal,true)
end
sign(a,"DXB  •  DEPARTURES  |  المغادرة",CFrame.new(-1082,13,-912),107,P.night)
part(a,"Airport valet pickup kerb",Vector3.new(130,.4,8),CFrame.new(-1080,1.4,-888),P.white,Enum.Material.Concrete,false)
-- Hospital external canopy, wheelchair ramp-style entrance and taxi approach.
local h=Instance.new("Folder");h.Name="DubaiHospitalEntrance";h.Parent=group
part(h,"Emergency vehicle entrance awning",Vector3.new(94,1.2,16),CFrame.new(-235,16,-1056),P.white,Enum.Material.Concrete,false)
sign(h,"HOSPITAL  |  الطوارئ  •  EMERGENCY",CFrame.new(-235,12,-1065),80,P.red)
for _,x in ipairs({-274,-196}) do
 part(h,"Hospital glass canopy support",Vector3.new(1.2,14,1.2),CFrame.new(x,7.9,-1060),P.silver,Enum.Material.Metal,false)
end
-- Hotel proper visual entrance and facade. Interior prompts are in the service module.
local hotel=Instance.new("Folder");hotel.Name="AlWaslHotelFacade";hotel.Parent=group
part(hotel,"Hotel covered drive-up canopy",Vector3.new(80,1,18),CFrame.new(-550,17,-884),P.white,Enum.Material.Marble,false)
for _,x in ipairs({-579,-521}) do
 part(hotel,"Hotel sculpted arrival column",Vector3.new(2.3,16,2.3),CFrame.new(x,8.8,-880),P.silver,Enum.Material.Marble,true)
end
sign(hotel,"AL WASL GRAND HOTEL  |  فندق الوصل",CFrame.new(-550,12,-894),76,P.night)
local ppath=part(hotel,"Stone arrival red carpet",Vector3.new(13,.12,30),
 CFrame.new(-550,1.45,-891),P.brick,Enum.Material.Fabric,false)
-- Neighborhood sidewalk improvements and traffic crossings for safer walking.
local walk=Instance.new("Folder");walk.Name="PedestrianFriendlyRoads";walk.Parent=group
for _,z in ipairs({-728,-664,-986,-1200}) do
 for i=-4,4 do
  part(walk,"Pedestrian zebra crossing",Vector3.new(8,.09,1.9),
   CFrame.new(i*10,1.3,z),P.white,Enum.Material.SmoothPlastic,false)
 end
end
local suburb=Instance.new("Folder");suburb.Name="PalmBoulevard";suburb.Parent=group
for _,x in ipairs({-335,-200,-65,70,205,340}) do
 palm(x,-750,13)
 if not low then lamp(x,-750) end
end
-- Upgrade a limited number of existing window surfaces, not thousands of components.
local windows=0
for _,obj in ipairs(world:GetDescendants()) do
 if obj:IsA("BasePart") and not obj:IsDescendantOf(root) and obj.Material==Enum.Material.Glass then
  obj.Reflectance=math.min(obj.Reflectance,.1)
  if obj.Transparency<.1 then obj.Transparency=.11 end
  windows=windows+1
  if windows>1200 then break end
 end
end
-- Avoid stacking multiple heavy filters from earlier versions.
for _,name in ipairs({"UAE55_CinemaGrade","UAE55_DesertAir","UAE55_NightBloom","UAE55_SunRays"}) do
 local old=L:FindFirstChild(name)
 if old and (old:IsA("PostEffect") or old:IsA("Atmosphere")) then
  old:Destroy()
 end
end
pcall(function() L.Technology=Enum.Technology.Future end)
L.GlobalShadows=not low
L.Brightness=2.2
L.ShadowSoftness=.45
L.EnvironmentDiffuseScale=.65
L.EnvironmentSpecularScale=.7
local atmosphere=Instance.new("Atmosphere")
atmosphere.Name="UAE60_Atmosphere";atmosphere.Density=.18
atmosphere.Haze=1;atmosphere.Offset=.1
atmosphere.Color=rgb(218,225,226);atmosphere.Decay=rgb(177,188,192)
atmosphere.Glare=.12;atmosphere.Parent=L
local cc=Instance.new("ColorCorrectionEffect")
cc.Name="UAE60_ColorGrade";cc.Brightness=0
cc.Contrast=.09;cc.Saturation=.08;cc.TintColor=rgb(255,247,233)
cc.Parent=L
if not low then
 local bloom=Instance.new("BloomEffect")
 bloom.Name="UAE60_Bloom";bloom.Intensity=.15
 bloom.Threshold=1.5;bloom.Size=18;bloom.Parent=L
end
task.spawn(function()
 while root.Parent do
  local hour=RS:GetAttribute("UAECycleHour")
  local night=typeof(hour)=="number" and (hour>=18 or hour<6)
  for _,obj in ipairs(group:GetDescendants()) do
   if obj:IsA("PointLight") and obj.Name=="UAE60NightLight" then
    obj.Enabled=night
   end
  end
  task.wait(8)
 end
end)
print("[UAE60] Dubai visual pass: promenades, airport, hospital and hotel fronts, lights; windows:",windows)
