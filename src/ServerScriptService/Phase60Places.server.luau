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
