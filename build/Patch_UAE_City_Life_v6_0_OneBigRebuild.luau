-- UAE CITY LIFE v6.0 | BIG QUALITY & PLAYABILITY REBUILD
-- ONE INSTALLER on your saved v5.5, in Studio EDIT mode only.
-- Preserves world folders, the v5.4 city map and missions, and the older car controls.
-- BEFORE RUNNING: File > Save to File As > UAE_City_Life_v5_5_BACKUP.rbxl
local RunService=game:GetService("RunService")
assert(not RunService:IsRunning(),"STOP Play mode before installing Phase 6.")
local workspaceService=game:GetService("Workspace")
local server=game:GetService("ServerScriptService")
local playerScripts=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local replicated=game:GetService("ReplicatedStorage")
local world=workspaceService:FindFirstChild("UAE_City_Life")
assert(world,"Open your existing UAE City Life game. A blank Baseplate will not work.")
assert(world:FindFirstChild("Phase54_CityExpansion"),
 "Requires working v5.4 Dubai Atlas and its city world.")
local phase55=world:FindFirstChild("Phase55_RealLife")
 or world:FindFirstChild("Phase55_ProductionPass")
 or world:GetAttribute("InstalledVersion")=="5.5"
 or world:GetAttribute("InstalledVersion")=="6.0"
assert(phase55,
 "Requires the saved v5.5 place; an earlier v5.4-only scene is not enough.")
assert(replicated:FindFirstChild("UAE_V54_Locations"),
 "The v5.4 location catalogue is missing. Restore your saved v5.5 backup.")
-- Set true for lower-end laptop performance (fewer citizens and simpler lighting).
local LOW_PERFORMANCE=false
local old=world:FindFirstChild("Phase60_World")
if old then old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase60_World"
root:SetAttribute("LowPerformance",LOW_PERFORMANCE)
root.Parent=world
local function event(name)
 local old=replicated:FindFirstChild(name)
 if old and old:IsA("RemoteEvent") then return old end
 if old then old:Destroy() end
 local e=Instance.new("RemoteEvent")
 e.Name=name;e.Parent=replicated
 return e
end
event("UAE60_Notice")
event("UAE60_FlightInput")
event("UAE60_CareerRequest")
event("UAE60_CareerUpdate")
local function replace(kind,parent,name,source)
 local old=parent:FindFirstChild(name)
 if old then old:Destroy() end
 local obj=Instance.new(kind)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
 return obj
end
-- First prepare all new scripts; only then switch off replaced v5.5 prototypes.
replace("Script",server,"UAE60_Graphics",[========[
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

]========])
replace("Script",server,"UAE60_Places",[========[
-- UAE City Life 6.0 | playable Dubai interiors and everyday service loops.
-- Session-only progress and server-validated interactions. No DataStore.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local folder=Instance.new("Folder");folder.Name="RealLifeInteriors";folder.Parent=root
local notice=RS:WaitForChild("UAE60_Notice")
local function rgb(r,g,b)return Color3.fromRGB(r,g,b) end
local C={white=rgb(241,236,222),dark=rgb(35,50,60),gold=rgb(226,183,95),
 blue=rgb(66,144,172),glass=rgb(112,187,202),light=rgb(245,244,225),
 sand=rgb(196,176,141),wood=rgb(123,87,61),green=rgb(58,135,111),
 red=rgb(192,63,66),silver=rgb(176,191,191)}
local function p(parent,name,size,cf,color,mat,collide)
 local o=Instance.new("Part")
 o.Name=name;o.Size=size;o.CFrame=cf;o.Color=color or C.white
 o.Anchored=true;o.CanCollide=collide==true
 o.Material=mat or Enum.Material.SmoothPlastic
 o.TopSurface=Enum.SurfaceType.Smooth
 o.BottomSurface=Enum.SurfaceType.Smooth
 o.Parent=parent
 return o
end
local function label(parent,text,cf,w,h,tint)
 local plate=p(parent,"Wayfinding bilingual sign",Vector3.new(w,h,.35),cf,tint or C.dark,Enum.Material.Metal,false)
 local g=Instance.new("SurfaceGui")
 g.Face=Enum.NormalId.Front;g.PixelsPerStud=40;g.Parent=plate
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1);t.Text=text
 t.Font=Enum.Font.GothamBold;t.TextScaled=true;t.TextWrapped=true
 t.BackgroundTransparency=1;t.TextColor3=C.white;t.Parent=g
end
local function reward(pl,amount)
 if amount<=0 then return end
 local stats=pl:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=pl end
 local value=stats:FindFirstChild("CityPoints")
 if not value then value=Instance.new("IntValue");value.Name="CityPoints";value.Parent=stats end
 value.Value=value.Value+amount
end
local function message(pl,msg)
 if pl.Parent==Players then notice:FireClient(pl,msg) end
end
local state={}
local locks={}
local function step(pl,flow,expected,nextStep,txt,pay)
 local id=pl.UserId
 state[id]=state[id] or {}
 local current=state[id][flow] or 0
 if current~=expected then
  message(pl,"Complete earlier steps first. Visit the reception counter.")
  return false
 end
 state[id][flow]=nextStep
 message(pl,txt)
 if pay then reward(pl,pay) end
 return true
end
local function prompt(parent,actionText,title,cf,func)
 local terminal=p(parent,actionText,Vector3.new(4.2,4.5,2.1),
  cf,C.blue,Enum.Material.Metal,true)
 local pro=Instance.new("ProximityPrompt")
 pro.ActionText=actionText;pro.ObjectText=title;pro.MaxActivationDistance=12
 pro.RequiresLineOfSight=false;pro.HoldDuration=.5;pro.Parent=terminal
 pro.Triggered:Connect(function(pl)
  local char=pl.Character
  local hum=char and char:FindFirstChildOfClass("Humanoid")
  local rootPart=char and char:FindFirstChild("HumanoidRootPart")
  if not hum or hum.Health<=0 or not rootPart or (rootPart.Position-terminal.Position).Magnitude>15 then return end
  local key=pl.UserId..":"..title..":"..actionText
  local now=os.clock()
  if locks[key] and now-locks[key]<1 then return end
  locks[key]=now
  func(pl,rootPart)
 end)
 return terminal
end
local function room(name,x,z,w,d,height,primary,header)
 local group=Instance.new("Model");group.Name=name;group.Parent=folder
 local cf=CFrame.new(x,0,z)
 local function add(n,size,ax,ay,az,col,mat,solid)
  return p(group,n,size,cf*CFrame.new(ax,ay,az),col,mat,solid)
 end
 add("Large walkable polished floor",Vector3.new(w,1.1,d),0,.7,0,C.sand,Enum.Material.Marble,true)
 add("Rear marble wall",Vector3.new(w,height,1),0,height/2,z*0+d/2,C.white,Enum.Material.Concrete,true)
 add("West wall",Vector3.new(1,height,d),-w/2,height/2,0,C.white,Enum.Material.Concrete,true)
 add("East wall",Vector3.new(1,height,d),w/2,height/2,0,C.white,Enum.Material.Concrete,true)
 add("Roof with skylight glass",Vector3.new(w,1,d),0,height+.5,0,C.glass,Enum.Material.Glass,false)
 add("Reception marble counter",Vector3.new(25,4.1,5),0,3.3,8,primary,Enum.Material.Marble,true)
 add("Reception desktop",Vector3.new(25,.25,5.5),0,5.55,8,C.white,Enum.Material.Marble,false)
 -- front remains open for walk-in access from sidewalk
 for _,dx in ipairs({-w*.35,w*.35}) do
  add("Cushioned waiting sofa",Vector3.new(13,2.7,7),dx,2.65,-8,C.dark,Enum.Material.Fabric,true)
  add("Low polished table",Vector3.new(8,1.2,4),dx,1.9,-16,C.wood,Enum.Material.Wood,true)
  local lamp=add("Ceiling circular lamp",Vector3.new(3,.6,3),dx,height-.65,0,C.light,Enum.Material.Neon,false)
  lamp.Shape=Enum.PartType.Ball
 end
 for _,offset in ipairs({-w*.25,w*.25}) do
  add("Entrance facade pillar",Vector3.new(1.1,height,1.1),offset,height/2,-d/2,C.silver,Enum.Material.Metal,false)
 end
 label(group,header,cf*CFrame.new(0,height*.65,d/2-.65),w*.78,5,primary)
 return group,cf
end
local hotel,H=room("Al Wasl Hotel Detailed Lobby",-550,-920,86,70,22,C.gold,
 "AL WASL HOTEL  |  فندق الوصل")
prompt(hotel,"Hotel check-in","Hotel Reception",H*CFrame.new(-12,4,-2),function(pl)
 step(pl,"hotel",0,1,"Hotel check-in confirmed. Collect your room key.")
end)
prompt(hotel,"Collect room key","Hotel Reception",H*CFrame.new(7,4,-2),function(pl)
 step(pl,"hotel",1,2,"Room 201 unlocked. Use the elevator.")
end)
local roomFloor=p(hotel,"Hotel guest level floor",Vector3.new(54,1,45),
 H*CFrame.new(0,27,5),C.sand,Enum.Material.Marble,true)
p(hotel,"Guest bed",Vector3.new(18,2,13),H*CFrame.new(0,29,15),C.white,Enum.Material.Fabric,true)
p(hotel,"Guest suite lounge sofa",Vector3.new(16,3,5),H*CFrame.new(-16,29,0),C.dark,Enum.Material.Fabric,true)
prompt(hotel,"Lift to guest room","Hotel elevator",H*CFrame.new(32,4,-18),function(pl,rootPart)
 if not state[pl.UserId] or state[pl.UserId].hotel~=2 then
  message(pl,"Collect your room key first.");return
 end
 rootPart.CFrame=H*CFrame.new(0,31,-9)
 message(pl,"Welcome to your guest suite, Room 201.")
end)
prompt(hotel,"Check out of room","Hotel Room 201",H*CFrame.new(16,30,-5),function(pl,rootPart)
 if step(pl,"hotel",2,0,"Hotel stay complete! +40 CityPoints",40) then
  rootPart.CFrame=H*CFrame.new(0,5,-26)
 end
end)
local hospital,M=room("Dubai Hospital Detailed Medical Facility",-235,-1095,106,76,22,C.green,
 "DUBAI HOSPITAL  |  مستشفى دبي")
prompt(hospital,"Patient registration","Hospital front desk",M*CFrame.new(-28,4,-8),function(pl)
 step(pl,"hospital",0,1,"Registered as a patient. Go to the triage station.")
end)
prompt(hospital,"Nurse triage","Hospital triage",M*CFrame.new(-10,4,-8),function(pl)
 step(pl,"hospital",1,2,"Triage complete. Proceed to the doctor.")
end)
prompt(hospital,"Doctor examination","Examination room",M*CFrame.new(12,4,-8),function(pl)
 step(pl,"hospital",2,3,"Examination finished. Collect discharge notes at the pharmacy.")
end)
prompt(hospital,"Pharmacy discharge","Hospital pharmacy",M*CFrame.new(35,4,-8),function(pl)
 step(pl,"hospital",3,0,"Hospital visit complete! +55 CityPoints",55)
end)
for _,x in ipairs({-34,0,34}) do
 p(hospital,"Patient clinic bed",Vector3.new(13,2,7),M*CFrame.new(x,2.5,24),C.white,Enum.Material.Fabric,true)
 p(hospital,"Nurse work light",Vector3.new(1,4,1),M*CFrame.new(x,7,25),C.light,Enum.Material.Neon,false)
end
local airport,A=room("DXB Airport Passenger Terminal",-1080,-919,118,86,25,C.blue,
 "DXB AIRPORT  |  مطار دبي الدولي")
prompt(airport,"Flight check-in","DXB airline counter",A*CFrame.new(-39,4,-7),function(pl)
 step(pl,"flight",0,1,"Check-in complete. Boarding pass issued. Go to baggage screening.")
end)
prompt(airport,"Baggage security","DXB security",A*CFrame.new(-15,4,-7),function(pl)
 step(pl,"flight",1,2,"Security passed. Visit immigration.")
end)
prompt(airport,"Passport control","DXB immigration",A*CFrame.new(12,4,-7),function(pl)
 step(pl,"flight",2,3,"Passport processed. Proceed to boarding gate.")
end)
prompt(airport,"Board departing flight","DXB boarding gate",A*CFrame.new(43,4,-7),function(pl,rootPart)
 if not step(pl,"flight",3,4,"Boarding started; the aircraft departs shortly.",nil) then return end
 local id=pl.UserId
 task.delay(7,function()
  if pl.Parent~=Players or not state[id] or state[id].flight~=4 then return end
  state[id].flight=0
  local char=pl.Character
  local r=char and char:FindFirstChild("HumanoidRootPart")
  if r then r.CFrame=CFrame.new(-967,6,-1128) end
  reward(pl,75)
  message(pl,"Flight transfer complete! Arrivals reached. +75 CityPoints.")
 end)
end)
for _,x in ipairs({-39,-13,13,39}) do
 p(airport,"Airport departure seat row",Vector3.new(10,2.1,5),
 A*CFrame.new(x,2.2,27),C.dark,Enum.Material.Fabric,true)
 p(airport,"Flight information display",Vector3.new(11,4,.4),
 A*CFrame.new(x,14,40),C.blue,Enum.Material.Neon,false)
end
local police,P=room("Dubai Police Public Service Centre",-1125,-474,84,65,22,C.blue,
 "DUBAI POLICE  |  شرطة دبي")
prompt(police,"File community report","Police service desk",P*CFrame.new(-12,4,-5),function(pl)
 step(pl,"police",0,1,"Report filed. Speak with the duty officer.")
end)
prompt(police,"Talk to duty officer","Dubai Police",P*CFrame.new(15,4,-5),function(pl)
 step(pl,"police",1,0,"Police assistance complete! +35 CityPoints",35)
end)
local fire,F=room("Civil Defence Safety Centre",-1120,-624,82,62,21,C.gold,
 "CIVIL DEFENCE  |  الدفاع المدني")
prompt(fire,"Report emergency drill","Civil Defence desk",F*CFrame.new(-10,4,-5),function(pl)
 step(pl,"fire",0,1,"Emergency drill assigned. Check the evacuation plan.")
end)
prompt(fire,"Confirm safety inspection","Civil Defence",F*CFrame.new(17,4,-5),function(pl)
 step(pl,"fire",1,0,"Safety inspection complete! +35 CityPoints",35)
end)
local cafe,K=room("Dubai Karak Cafe",-225,-594,51,45,15,C.gold,
 "KARAK CAFE  |  كرك دبي")
prompt(cafe,"Order karak tea","Karak Cafe",K*CFrame.new(0,4,-4),function(pl)
 message(pl,"Fresh karak served. Enjoy the café!")
end)
Players.PlayerRemoving:Connect(function(pl)
 state[pl.UserId]=nil
 for key in pairs(locks) do
  if string.sub(key,1,#tostring(pl.UserId))==tostring(pl.UserId) then locks[key]=nil end
 end
end)
print("[UAE60] Hotel, hospital, DXB, police, Civil Defence and cafe roleplay service flows ready")

]========])
replace("Script",server,"UAE60_Vehicles",[========[
-- UAE City Life 6.0 | improved visual vehicle shapes + collision proxy.
-- Vehicle driving is still handled by the previous UAE_Driving system.
-- Rebuilds cosmetic appearance ONLY; leaves seats, prompts and movement scripts intact.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local notices=RS:WaitForChild("UAE60_Notice")
local clock=RS
local active={}
local originals={}
local lastImpact={}
local function rgb(r,g,b)return Color3.fromRGB(r,g,b) end
local C={
 white=rgb(242,242,233),glass=rgb(76,141,169),shadow=rgb(26,36,43),
 steel=rgb(152,165,176),black=rgb(23,27,30),wheel=rgb(25,27,30),
 green=rgb(17,104,76),gold=rgb(237,190,78),blue=rgb(24,81,142),
 red=rgb(192,50,55),cream=rgb(231,217,185),orange=rgb(214,104,48),
}
local function subtype(model)
 local name=string.lower(model.Name)
 local ty=string.lower(tostring(model:GetAttribute("VehicleType") or ""))
 local function has(word)return string.find(name,word,1,true) or string.find(ty,word,1,true)end
 if has("aircraft") or has("helicopter") or has("plane") then return nil end
 if has("ambulance") then return "Ambulance" end
 if has("civil") or has("fire") or has("rescue") then return "Fire" end
 if has("police") or has("patrol") then return "Police" end
 if has("taxi") then return "Taxi" end
 if has("bus") then return "Bus" end
 if has("family") or has("suv") then return "SUV" end
 if has("sedan") then return "Sedan" end
 if model:GetAttribute("UAEVehicle")==true then return "Sedan" end
 if model:IsDescendantOf(world:FindFirstChild("EmergencyVehicles") or world) then return "Ambulance" end
 return nil
end
local function sizeFor(kind)
 if kind=="Fire" then return 12.8,32,12.0 end
 if kind=="Ambulance" then return 11.7,25,10.6 end
 if kind=="Bus" then return 12.3,34,12 end
 if kind=="SUV" or kind=="Police" then return 10.5,22.5,8.4 end
 return 9.8,20.5,7.9
end
local function part(parent,class,name,sz,cf,col,mat,alpha)
 local o=Instance.new(class or "Part")
 o.Name=name
 o.Size=sz;o.CFrame=cf;o.Anchored=true;o.CanCollide=false
 o.CanTouch=false;o.CanQuery=false
 o.Material=mat or Enum.Material.SmoothPlastic
 o.Color=col or C.white
 o.Transparency=alpha or 0
 o.TopSurface=Enum.SurfaceType.Smooth
 o.BottomSurface=Enum.SurfaceType.Smooth
 o.Parent=parent
 return o
end
local function sign(parent,title,cf,w,h,face,tint)
 local p=part(parent,"Part","Bilingual designation",Vector3.new(w,h,.18),cf,tint or C.blue,Enum.Material.Metal)
 local s=Instance.new("SurfaceGui")
 s.Name="VehicleText";s.Face=face or Enum.NormalId.Front
 s.PixelsPerStud=42;s.Parent=p
 local t=Instance.new("TextLabel")
 t.BackgroundTransparency=1;t.Size=UDim2.fromScale(1,1)
 t.Font=Enum.Font.GothamBold;t.TextScaled=true
 t.TextWrapped=true;t.TextColor3=C.white;t.Text=title;t.Parent=s
 return p
end
local function make(model,kind,allowStatic)
 if active[model] or model:FindFirstChild("UAE60_HighDetailSkin") then return end
 local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
 if not seat and not allowStatic then return end
 -- Some legacy emergency vehicles have no PrimaryPart. Preserve their original pivot.
 if not model.PrimaryPart then
  local originalPivot=model:GetPivot()
  local stub=Instance.new("Part")
  stub.Name="UAE60PreservedVehiclePivot"
  stub.Size=Vector3.new(.2,.2,.2)
  stub.CFrame=originalPivot
  stub.Anchored=true;stub.CanCollide=false
  stub.Transparency=1;stub.Parent=model
  model.PrimaryPart=stub
 end
 local w,len,h=sizeFor(kind)
 local pivot=model:GetPivot()
 local outer=Instance.new("Model");outer.Name="UAE60_HighDetailSkin";outer.Parent=model
 local function place(class,name,sz,x,y,z,col,mat,alpha,rotation)
  return part(outer,class,name,sz,pivot*CFrame.new(x,y,z)*(rotation or CFrame.new()),col,mat,alpha)
 end
 local body=C.white
 local stripe=C.shadow
 if kind=="Police" then body=C.white;stripe=C.green
 elseif kind=="Ambulance" then body=C.white;stripe=C.blue
 elseif kind=="Fire" then body=C.gold;stripe=C.red
 elseif kind=="Taxi" then body=C.cream;stripe=C.orange
 elseif kind=="Bus" then body=C.cream;stripe=C.green
 elseif kind=="Sedan" then body=C.blue;stripe=C.shadow
 elseif kind=="SUV" then body=C.white;stripe=C.shadow end
 local roofY=(kind=="Fire" or kind=="Bus") and 10.9 or (kind=="Ambulance" and 10.25 or 8.15)
 local front=-len/2
 local rear=len/2
 -- sculpted multi-layer vehicle silhouette with bevelled bumpers and recessed windows.
 place("Part","Undertray",Vector3.new(w-.35,1.05,len-.35),0,3.55,0,C.shadow,Enum.Material.Metal)
 place("Part","Finished metallic side panel",Vector3.new(w,3.2,len-.8),0,5,0,body,Enum.Material.Metal)
 place("Part","Side belt stripe",Vector3.new(w+.12,1.0,len-.3),0,5.6,0,stripe,Enum.Material.Metal)
 place("Part","Floor sill",Vector3.new(w+1,.6,len-.8),0,3.15,0,C.shadow,Enum.Material.Metal)
 local tall=(kind=="Fire" or kind=="Ambulance" or kind=="Bus")
 local noseLen=tall and 6.8 or 7
 local cabinZ=tall and (front+noseLen/2+1.5) or 1.0
 if tall then
  place("Part","Raised service compartment",Vector3.new(w-.5,roofY-5.8,len-noseLen-.6),
   0,(roofY+5.65)/2,2.7,body,Enum.Material.Metal)
  place("Part","Front driver cabin",Vector3.new(w-.7,3.4,noseLen),0,7,front+noseLen/2+1,body,Enum.Material.Metal)
 else
  place("Part","Roof contour",Vector3.new(w-1,1,len*.41),0,roofY,1,body,Enum.Material.Metal)
  place("WedgePart","Sloped hood",Vector3.new(w-.45,1.8,5.3),
   0,6.1,front+2.6,body,Enum.Material.Metal)
 end
 for _,side in ipairs({-1,1}) do
  local sx=side*w/2
  local axlefront=front+5.3
  local axlerear=rear-5.1
  for _,z in ipairs({axlefront,axlerear}) do
   -- Cylinder default axis is X, which is horizontal axle orientation.
   local wheel=place("Part","UAE60 Tire",Vector3.new(1.5,4.55,4.55),
    sx+side*.2,2.36,z,C.wheel,Enum.Material.Rubber)
   wheel.Shape=Enum.PartType.Cylinder
   local rim=place("Part","UAE60 Alloy wheel",Vector3.new(.22,2.8,2.8),
    sx+side*1.04,2.36,z,C.steel,Enum.Material.Metal)
   rim.Shape=Enum.PartType.Cylinder
   local hub=place("Part","Centre wheel hub",Vector3.new(.24,.85,.85),
    sx+side*1.19,2.36,z,C.shadow,Enum.Material.Metal)
   hub.Shape=Enum.PartType.Cylinder
  end
  local cabY=tall and 7.9 or 7.25
  local windowLen=tall and 4.7 or 6.8
  local wx=side*(w/2+.075)
  local windowZ=tall and front+3.8 or 1.0
  place("Part","Tinted side window",Vector3.new(.22,2.15,windowLen),
   wx,cabY,windowZ,C.glass,Enum.Material.Glass,.15)
  place("Part","Door separator",Vector3.new(.23,2.2,.22),
   wx+side*.08,cabY,windowZ,C.shadow,Enum.Material.Metal)
  place("Part","Painted mirror",Vector3.new(1.3,1.1,1.8),
   sx+side*.68,6.7,front+5,body,Enum.Material.Metal)
  place("Part","Door pull handle",Vector3.new(.3,.32,1.4),
   sx+side*.1,5.85,windowZ+2.6,C.steel,Enum.Material.Metal)
  place("Part","Side step",Vector3.new(1.0,.35,5),
   sx+side*.55,3.3,windowZ,C.steel,Enum.Material.Metal)
  place("Part","Rear red lamp",Vector3.new(1.75,1,.45),
   side*(w/2-1.3),5.0,rear+.11,C.red,Enum.Material.Neon)
  place("Part","Front LED lamp",Vector3.new(1.9,.75,.45),
   side*(w/2-1.3),5.1,front-.11,C.cream,Enum.Material.Neon)
 end
 place("Part","Front grille",Vector3.new(w*.48,1.1,.25),0,4.6,front-.25,C.shadow,Enum.Material.Metal)
 place("Part","Front bumper",Vector3.new(w+.6,.75,1.1),0,3.9,front-.25,C.steel,Enum.Material.Metal)
 place("Part","Rear bumper",Vector3.new(w+.5,.65,1.05),0,3.9,rear+.2,C.steel,Enum.Material.Metal)
 -- front and back glazing
 local winFront=tall and (front+.7) or (front+6.1)
 place("Part","Front windshield",Vector3.new(w-1.1,2.4,.22),
  0,tall and 7.9 or 7.4,winFront,C.glass,Enum.Material.Glass,.12)
 if tall then
  place("Part","Cargo roof panel",Vector3.new(w+.1,.7,len-noseLen-1),0,roofY,3.1,body,Enum.Material.Metal)
  for _,z in ipairs({1.0,4.1,7.2}) do
   place("Part","Service compartment seam",Vector3.new(w+.15,.14,.2),0,7,z,stripe,Enum.Material.Metal)
  end
 end
 if kind=="Police" then
  sign(outer,"شرطة دبي  |  DUBAI POLICE",pivot*CFrame.new(0,6.05,rear*.12),w*.85,1.0,Enum.NormalId.Front,C.green)
 elseif kind=="Ambulance" then
  sign(outer,"الإسعاف  |  AMBULANCE",pivot*CFrame.new(0,7.1,rear*.27),w*.86,1.25,Enum.NormalId.Front,C.blue)
 elseif kind=="Fire" then
  sign(outer,"الدفاع المدني  |  CIVIL DEFENCE",pivot*CFrame.new(0,7.2,rear*.23),w*.82,1.2,Enum.NormalId.Front,C.red)
 elseif kind=="Taxi" then
  place("Part","Taxi illuminated rooftop",Vector3.new(5.0,1.1,2.5),0,roofY+.9,0,C.cream,Enum.Material.Neon)
 end
 if kind=="Police" or kind=="Fire" or kind=="Ambulance" then
  local left=place("Part","Lightbar blue",Vector3.new(2.6,.9,2.7),
   -2.4,roofY+1.2,front+6,C.blue,Enum.Material.Neon)
  local right=place("Part","Lightbar red",Vector3.new(2.6,.9,2.7),
   2.4,roofY+1.2,front+6,C.red,Enum.Material.Neon)
  for _,p in ipairs({left,right}) do
   local g=Instance.new("PointLight");g.Name="UAE60EmergencyLight"
   g.Brightness=0;g.Range=30;g.Parent=p
  end
 end
 -- Only hide old decorative parts after successfully making the new skin.
 for _,p in ipairs(model:GetDescendants()) do
  if p:IsA("BasePart") and not p:IsDescendantOf(outer) and p~=seat then
   if not originals[p] then originals[p]=p.Transparency end
   p.Transparency=1
  end
 end
 active[model]={skin=outer,kind=kind,last=model:GetPivot().Position,lastTime=os.clock()}
 model:SetAttribute("UAE60Skin",kind)
 model:SetAttribute("UAE60Damage",0)
end
local function tryModel(obj)
 if not obj:IsA("VehicleSeat") then return end
 local model=obj:FindFirstAncestorOfClass("Model")
 if model and not model:GetAttribute("UAE60Aircraft") then
  local kind=subtype(model)
  if kind then
   local ok,err=pcall(make,model,kind)
   if not ok then warn("[UAE60] skin failed:",model.Name,err) end
  end
 end
end
for _,obj in ipairs(world:GetDescendants()) do tryModel(obj) end
-- Several v5.4 police / fire display cars have no seats; repaint them too.
for _,folderName in ipairs({"CommunityServiceFleet"}) do
 local fleet=world:FindFirstChild(folderName,true)
 if fleet then
  for _,model in ipairs(fleet:GetChildren()) do
   if model:IsA("Model") then
    local kind=subtype(model)
    if kind then
     local ok,err=pcall(make,model,kind,true)
     if not ok then warn("[UAE60] display vehicle skin failed:",err) end
    end
   end
  end
 end
end
-- Upgrade the old stationary buses when they are Models and not already styled.
local upgradedBuses=0
for _,model in ipairs(world:GetDescendants()) do
 if model:IsA("Model") and upgradedBuses<8 and
   string.find(string.lower(model.Name),"%f[%a]bus%f[%A]") and not active[model] then
  local ok=pcall(make,model,"Bus",true)
  if ok then upgradedBuses=upgradedBuses+1 end
 end
end
world.DescendantAdded:Connect(function(obj)
 if obj:IsA("VehicleSeat") then task.delay(.22,tryModel,obj) end
end)
-- Anchored legacy cars use PivotTo, so measure actual displacement instead of physics velocity.
local elapsed=0
RunService.Heartbeat:Connect(function(dt)
 elapsed=elapsed+dt
 if elapsed<.22 then return end
 local now=os.clock()
 local step=elapsed;elapsed=0
 for model,state in pairs(active) do
  if not model.Parent then active[model]=nil
  elseif state.skin.Parent then
   local pos=model:GetPivot().Position
   local speed=(pos-state.last).Magnitude/math.max(step,.07)
   state.last=pos
   local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
   local player=seat and seat.Occupant and Players:GetPlayerFromCharacter(seat.Occupant.Parent)
   if player and speed>22 and (not lastImpact[model] or now-lastImpact[model]>4) then
    local forward=model:GetPivot().LookVector
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances={model}
    local hit=workspace:Raycast(pos+forward*4+Vector3.new(0,3,0),forward*12,params)
    if hit and hit.Instance and hit.Instance.CanCollide and math.abs(hit.Normal.Y)<.7 then
     lastImpact[model]=now
     local damage=math.clamp(math.floor(speed*.27),5,24)
     model:SetAttribute("UAE60Damage",math.clamp((model:GetAttribute("UAE60Damage") or 0)+damage,0,100))
     local bumper=state.skin:FindFirstChild("Front bumper")
     if bumper then bumper.Color=C.red:Lerp(C.black,math.min(1,(model:GetAttribute("UAE60Damage") or 0)/100)) end
     notices:FireClient(player,"Vehicle impact detected. Damage +"..damage.." | Visit the repair garage.")
    end
   end
  end
 end
end)
-- Collision damage service garage: the older v5.5 crash script is disabled.
local garage=Instance.new("Folder")
garage.Name="VehicleRepairWorkshop";garage.Parent=root
local pad=part(garage,"Part","Garage repair service bay",Vector3.new(39,1,35),
 CFrame.new(-320,1.6,-1030),C.steel,Enum.Material.Concrete,0)
pad.CanCollide=true
local desk=part(garage,"Part","Workshop service terminal",Vector3.new(5,7,2),
 CFrame.new(-325,5,-1042),C.green,Enum.Material.Metal,0)
desk.CanCollide=true
local prompt=Instance.new("ProximityPrompt")
prompt.ActionText="Repair vehicle"
prompt.ObjectText="UAE City Auto Service"
prompt.HoldDuration=1;prompt.MaxActivationDistance=17
prompt.RequiresLineOfSight=false;prompt.Parent=desk
prompt.Triggered:Connect(function(pl)
 local char=pl.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local rootPart=char and char:FindFirstChild("HumanoidRootPart")
 if not hum or hum.Health<=0 or not rootPart or (rootPart.Position-desk.Position).Magnitude>20 then return end
 local nearest,best=nil,48
 for model,state in pairs(active) do
  if model.Parent and state.skin.Parent then
   local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
   local owner=model:GetAttribute("OwnerUserId")
   local authorized=not owner or owner==pl.UserId
   if seat and authorized then
    local distance=(seat.Position-pad.Position).Magnitude
    if distance<best then nearest=model;best=distance end
   end
  end
 end
 if not nearest then notices:FireClient(pl,"Park your vehicle at the repair workshop.") return end
 nearest:SetAttribute("UAE60Damage",0)
 local skin=active[nearest] and active[nearest].skin
 local bumper=skin and skin:FindFirstChild("Front bumper")
 if bumper then bumper.Color=C.steel end
 notices:FireClient(pl,"Repair completed. Vehicle damage restored to zero.")
end)
print("[UAE60] Vehicle cosmetics, crash sensor and repair workshop installed.")

]========])
replace("Script",server,"UAE60_Aircraft",[========[
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

]========])
replace("Script",server,"UAE60_Humans",[========[
-- UAE CITY LIFE 6: R15 pedestrians for the single-install Phase60_World build.
-- Uses Roblox-owned default R15 rig construction and humanoid walking, no copied characters.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase60_World")
local folder=Instance.new("Folder")
folder.Name="WalkingHumanCitizens"
folder.Parent=root
local stations={
 {"Hotel Receptionist",{-545,-910},{-550,-906},{-559,-907}},
 {"Hospital Nurse",{-225,-1081},{-222,-1077},{-233,-1074}},
 {"Airport Staff",{-1020,-957},{-1006,-954},{-1010,-971}},
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
 {"Hotel Guest",{-580,-915},{-566,-905},{-545,-940}},
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
local nMax=perf and 7 or math.min(#stations,12) -- Dell laptop NPC performance budget
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
   pcall(function() hrp:SetNetworkOwner(nil) end)
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

]========])
replace("Script",server,"UAE60_Careers",[========[
-- UAE City Life 6.0 | 8 additional cross-city career missions.
-- Server-checked locations, session-only CityPoints, no simulated combat.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local request=RS:WaitForChild("UAE60_CareerRequest")
local update=RS:WaitForChild("UAE60_CareerUpdate")
local careers={
 {id="HOTEL",name="Luxury Hotel Concierge",reward=100,stops={"HOTEL","MALL","MARINA"}},
 {id="GROUND",name="DXB Ground Services",reward=130,stops={"ARRIVE","DXB","METRO","HOTEL"}},
 {id="MEDIC",name="Ambulance Community Response",reward=145,stops={"MED","MALL","CLINIC","PARK"}},
 {id="PATROL",name="Police Response Patrol",reward=150,stops={"POLICE","BANK","HOMES","FRAME"}},
 {id="FIRE",name="Civil Defence Safety Duty",reward=150,stops={"FIRE","SOUK","SHOP","PARK"}},
 {id="SKY",name="Helicopter Sightseeing Pilot",reward=175,stops={"HELIPAD","FRAME","MUSEUM","MARINA"}},
 {id="AIR",name="Passenger Jet City Tour",reward=190,stops={"DXB","MARINA","BEACH","ARRIVE"}},
 {id="TAXI",name="Dubai Airport Taxi Transfer",reward=110,stops={"TAXI","ARRIVE","HOTEL","HOMES"}},
}
local byId={}
for _,c in ipairs(careers) do
 byId[c.id]=c
 for _,stop in ipairs(c.stops) do
  assert(locations.ById[stop],"Missing Phase 6 mission landmark "..stop)
 end
end
local states={}
local recent={}
local function emit(player,t)
 if player.Parent==Players then update:FireClient(player,t) end
end
local function send(player,msg)
 local s=states[player]
 if not s then return end
 local mission=byId[s.id]
 if not mission then return end
 local loc=locations.ById[mission.stops[s.index]]
 emit(player,{
  type="waypoint",name=mission.name,
  step=s.index,total=#mission.stops,
  position=loc.position,target=loc.name,
  id=s.id,message=msg or ("Go to "..loc.name),
  points=mission.reward
 })
end
local function award(player,amount)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then
  stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player
 end
 local n=stats:FindFirstChild("CityPoints")
 if not n then
  n=Instance.new("IntValue");n.Name="CityPoints";n.Parent=stats
 end
 n.Value=n.Value+amount
end
request.OnServerEvent:Connect(function(player,cmd,id)
 if typeof(cmd)~="string" or typeof(id)~="string" or #cmd>20 or #id>20 then return end
 local now=os.clock()
 if recent[player] and now-recent[player]<.6 then return end
 recent[player]=now
 if cmd=="Start" and byId[id] then
  states[player]={id=id,index=1,after=now}
  send(player,"New career started")
 elseif cmd=="Cancel" then
  states[player]=nil
  emit(player,{type="done",message="Career shift cancelled."})
 elseif cmd=="Status" then
  send(player,"Your current career checkpoint")
 end
end)
task.spawn(function()
 while true do
  for pl,s in pairs(states) do
   if not pl.Parent then
    states[pl]=nil
   else
    local m=byId[s.id]
    local loc=m and locations.ById[m.stops[s.index]]
    local char=pl.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not loc or not m then
     states[pl]=nil
    elseif hum and root and hum.Health>0 and os.clock()-s.after>2.4 then
     local delta=Vector2.new(root.Position.X-loc.position.X,root.Position.Z-loc.position.Z)
     if delta.Magnitude<41 then
      s.index=s.index+1;s.after=os.clock()
      if s.index>#m.stops then
       states[pl]=nil
       award(pl,m.reward)
       emit(pl,{type="done",message=m.name.." completed! +"..m.reward.." CityPoints."})
      else
       send(pl,"Checkpoint reached. Follow the next career GPS.")
      end
     end
    end
   end
  end
  task.wait(1.0)
 end
end)
Players.PlayerRemoving:Connect(function(pl) states[pl]=nil;recent[pl]=nil end)
print("[UAE60] Additional playable careers:",#careers)

]========])
replace("LocalScript",playerScripts,"UAE60_FlightCareersHUD",[========[
-- UAE City Life Phase 6 client | pilot controls, career browser and activity notices.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local RS=game:GetService("ReplicatedStorage")
local pl=Players.LocalPlayer
local flight=RS:WaitForChild("UAE60_FlightInput",25)
local message=RS:WaitForChild("UAE60_Notice",25)
local careers=RS:WaitForChild("UAE60_CareerRequest",25)
local updates=RS:WaitForChild("UAE60_CareerUpdate",25)
if not flight or not message or not careers or not updates then
 warn("[UAE60] One or more server remote events were not installed.")
 return
end
local gui=Instance.new("ScreenGui")
gui.Name="UAE60_RoleplayController"
gui.ResetOnSpawn=false;gui.DisplayOrder=82
gui.Parent=pl:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(21,44,60)
local buttonCol=Color3.fromRGB(54,132,150)
local accent=Color3.fromRGB(234,191,100)
local light=Color3.fromRGB(247,239,217)
local function rounded(obj,r)
 local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,r or 8)
 corner.Parent=obj
end
local function b(parent,label,pos,size,tint)
 local x=Instance.new("TextButton")
 x.Size=size;x.Position=pos
 x.Text=label;x.Font=Enum.Font.GothamBold;x.TextSize=12
 x.TextColor3=light;x.BackgroundColor3=tint or buttonCol
 x.BorderSizePixel=0;x.Parent=parent;rounded(x)
 return x
end
local function t(parent,msg,pos,size,sz)
 local l=Instance.new("TextLabel")
 l.Text=msg;l.Size=size;l.Position=pos
 l.Font=Enum.Font.GothamSemibold;l.TextSize=sz or 12
 l.TextColor3=light;l.BackgroundTransparency=1
 l.TextWrapped=true;l.TextXAlignment=Enum.TextXAlignment.Left
 l.Parent=parent;return l
end
local notice=t(gui,"",UDim2.new(.5,-235,0,62),UDim2.fromOffset(470,58),13)
notice.AnchorPoint=Vector2.new(0,0)
notice.BackgroundTransparency=.08;notice.BackgroundColor3=bg
notice.Visible=false;rounded(notice,9)
local noticeId=0
local function show(msg)
 noticeId=noticeId+1
 local n=noticeId
 notice.Text=tostring(msg)
 notice.Visible=true
 task.delay(5,function()
  if n==noticeId and gui.Parent then notice.Visible=false end
 end)
end
message.OnClientEvent:Connect(function(msg)
 if typeof(msg)=="string" and #msg<300 then show(msg) end
end)
local missionButton=b(gui,"CAREERS",UDim2.new(1,-85,1,-242),
 UDim2.fromOffset(72,35),bg)
local panel=Instance.new("Frame")
panel.Name="UAE60CareerMissions"
panel.Size=UDim2.fromOffset(340,434)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.5)
panel.BackgroundColor3=bg;panel.BorderSizePixel=0
panel.Visible=false;panel.Parent=gui;rounded(panel,12)
local title=t(panel,"DUBAI CAREERS & REAL-LIFE MISSIONS",
 UDim2.fromOffset(14,10),UDim2.fromOffset(286,27),15)
title.TextColor3=accent
local help=t(panel,"Select a career, follow GPS and reach checkpoints.",
 UDim2.fromOffset(14,40),UDim2.fromOffset(315,24),11)
local close=b(panel,"X",UDim2.fromOffset(305,8),UDim2.fromOffset(28,28),Color3.fromRGB(112,64,69))
local missions={
 {"Luxury Hotel Concierge","HOTEL"},
 {"DXB Ground Services","GROUND"},
 {"Ambulance Community Response","MEDIC"},
 {"Police Response Patrol","PATROL"},
 {"Civil Defence Safety Duty","FIRE"},
 {"Helicopter Sightseeing Pilot","SKY"},
 {"Passenger Jet City Tour","AIR"},
 {"Dubai Airport Taxi Transfer","TAXI"},
}
for i,entry in ipairs(missions) do
 local btn=b(panel,entry[1],UDim2.fromOffset(14,73+(i-1)*41),
  UDim2.fromOffset(311,34),i%2==0 and bg or buttonCol)
 btn.Activated:Connect(function()
  careers:FireServer("Start",entry[2])
  panel.Visible=false
 end)
end
local cancel=b(panel,"End current career",UDim2.fromOffset(14,407),
 UDim2.fromOffset(310,23),Color3.fromRGB(107,81,78))
cancel.Activated:Connect(function()
 careers:FireServer("Cancel","NONE")
 panel.Visible=false
end)
close.Activated:Connect(function()panel.Visible=false end)
missionButton.Activated:Connect(function()panel.Visible=not panel.Visible end)
UIS.InputBegan:Connect(function(input,used)
 if not used and not UIS:GetFocusedTextBox() and input.KeyCode==Enum.KeyCode.L then
  panel.Visible=not panel.Visible
 end
end)
local status=t(gui,"CAREERS: Select a mission",UDim2.new(.5,-190,1,-56),
 UDim2.fromOffset(380,40),12)
status.BackgroundColor3=bg;status.BackgroundTransparency=.13
status.Visible=false;rounded(status)
local marker=Instance.new("Part")
marker.Name="UAE60_LocalCareerGPS"
marker.Size=Vector3.new(.2,.2,.2)
marker.CanCollide=false;marker.CanQuery=false;marker.CanTouch=false
marker.Anchored=true;marker.Transparency=1
marker.Parent=workspace
local billboard=Instance.new("BillboardGui")
billboard.Adornee=marker;billboard.AlwaysOnTop=true
billboard.MaxDistance=400;billboard.Size=UDim2.fromOffset(155,36)
billboard.StudsOffsetWorldSpace=Vector3.new(0,8,0)
billboard.Enabled=false;billboard.Parent=marker
local tag=t(billboard,"NEXT DESTINATION",UDim2.fromScale(0,0),
 UDim2.fromScale(1,1),12)
tag.TextXAlignment=Enum.TextXAlignment.Center
tag.BackgroundColor3=bg;tag.BackgroundTransparency=.05
rounded(tag,7)
local active=nil
local doneUntil=0
updates.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" then return end
 if data.type=="waypoint" and typeof(data.position)=="Vector3" then
  active=data
  marker.CFrame=CFrame.new(data.position)
  tag.Text=data.target or "NEXT STOP"
  billboard.Enabled=true;status.Visible=true
 elseif data.type=="done" then
  active=nil;billboard.Enabled=false
  status.Text=tostring(data.message or "Career completed")
  status.Visible=true;doneUntil=os.clock()+5
  show(data.message or "Career finished")
 end
end)
-- Flight control panel appears ONLY when the player is seated in a Phase 6 aircraft.
local flightPanel=Instance.new("Frame")
flightPanel.Name="UAE60CockpitHUD"
flightPanel.Size=UDim2.fromOffset(305,150)
flightPanel.Position=UDim2.new(1,-317,1,-311)
flightPanel.BackgroundColor3=bg;flightPanel.BackgroundTransparency=.09
flightPanel.Visible=false;flightPanel.Parent=gui;rounded(flightPanel,10)
t(flightPanel,"PILOT CONTROLS  •  W/S SPEED  A/D TURN",
 UDim2.fromOffset(9,2),UDim2.fromOffset(289,31),12)
local keys={"W","S","A","D","R","F"}
local subtitles={"FORWARD","SLOW","LEFT","RIGHT","CLIMB","DESCEND"}
local held={}
local function pilot()
 local char=pl.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if not seat or seat.Name~="UAE60PilotSeat" then return false end
 local model=seat:FindFirstAncestorOfClass("Model")
 return model and model:GetAttribute("UAE60Aircraft")~=nil
end
local function sendKey(key,on)
 if not pilot() then return end
 held[key]=on and true or nil
 flight:FireServer(key,on)
end
for i,key in ipairs(keys) do
 local col=(i-1)%3
 local row=math.floor((i-1)/3)
 local btn=b(flightPanel,key.."  "..subtitles[i],
  UDim2.fromOffset(7+col*99,38+row*49),UDim2.fromOffset(94,42),buttonCol)
 btn.TextSize=10
 btn.MouseButton1Down:Connect(function()sendKey(key,true)end)
 btn.MouseButton1Up:Connect(function()sendKey(key,false)end)
 btn.InputBegan:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.Touch then sendKey(key,true) end
 end)
 btn.InputEnded:Connect(function(input)
  if input.UserInputType==Enum.UserInputType.Touch then sendKey(key,false) end
 end)
end
UIS.InputBegan:Connect(function(input,used)
 -- When seated, Roblox's default movement controls can mark WASD as processed.
 -- Ignore processed only for pilot keys; still protect focused text boxes.
 if UIS:GetFocusedTextBox() then return end
 if input.UserInputType==Enum.UserInputType.Keyboard then
  local key=input.KeyCode.Name
  if table.find(keys,key) and pilot() then sendKey(key,true) end
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.Keyboard then
  local key=input.KeyCode.Name
  if table.find(keys,key) then sendKey(key,false) end
 end
end)
local elapsed=0
local keepalive=0
RunService.RenderStepped:Connect(function(dt)
 elapsed=elapsed+dt;keepalive=keepalive+dt
 if elapsed>.3 then
  elapsed=0
  local sitting=pilot()
  flightPanel.Visible=sitting and true or false
  if active then
   local char=pl.Character
   local root=char and char:FindFirstChild("HumanoidRootPart")
   local dist=root and math.floor((root.Position-active.position).Magnitude) or 0
   status.Text=string.format("%s (%d/%d): %s  •  %d studs",
    active.name or "Mission",active.step or 1,active.total or 1,
    active.target or "Target",dist)
  elseif doneUntil>0 and os.clock()>doneUntil then
   status.Visible=false;doneUntil=0
  end
 end
 if keepalive>.42 then
  keepalive=0
  if pilot() then
   for key in pairs(held) do flight:FireServer(key,true) end
  else table.clear(held) end
 end
end)
task.delay(3,function()
 if careers.Parent then careers:FireServer("Status","CURRENT") end
end)
print("[UAE60] Cockpit + 8 career UI ready. L=careers, W/S/A/D/R/F fly.")

]========])
-- Disable old v5.5 implementations that conflict with the rebuilt interfaces.
-- DO NOT DELETE THEM: reversing a test can restore these old scripts.
for _,name in ipairs({
 "UAE55_Graphics","UAE55_Activities","UAE55_VehicleIncidents","UAE55_Citizens"
}) do
 local old=server:FindFirstChild(name)
 if old and old:IsA("Script") then
  old:SetAttribute("DisabledForPhase60",true)
  old.Disabled=true
 end
end
-- Legacy 5.5 notification script can coexist, but suppress duplicate popups.
local oldNotice=playerScripts:FindFirstChild("UAE55_Notifications")
if oldNotice and oldNotice:IsA("LocalScript") then
 oldNotice:SetAttribute("DisabledForPhase60",true)
 oldNotice.Disabled=true
end
world:SetAttribute("InstalledVersion","6.0")
print("UAE CITY LIFE PHASE 6 INSTALLED: vehicles, wheels, aircraft, hotel, hospital, airport, human NPCs, 8 careers.")
print("Now SAVE AS a new UAE_City_Life_v6_0.rbxl file, then press PLAY to generate the runtime world.")
print("Use E to interact, L for CAREERS, W/S/A/D/R/F to pilot aircraft after entering its seat.")
