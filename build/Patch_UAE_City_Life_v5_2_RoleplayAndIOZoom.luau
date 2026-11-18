-- UAE CITY LIFE | VERSION 5.2 ROLEPLAY & ZOOM REPAIR
-- IMPORTANT: Install on saved v5.1 in Roblox Studio EDIT mode; back up first.
-- Standalone v5.2 patch; preserves the previous map, buildings and 4 UAE flags.
-- Realistic imported car and Dubai landmark meshes are NOT included.
local W=game:GetService("Workspace")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer")
local Lighting=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local world=W:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase5_DubaiModern"),
 "V5 Dubai Modern place required. Open saved v5.1 in Studio EDIT mode first.")
assert(world:FindFirstChild("Phase51_RoleplayHomes"),
 "Please install the v5.1 Zoom & Homes patch first, then this v5.2 patch.")
local prior=world:FindFirstChild("Phase52_RoleplayDistrict")
if prior then prior:Destroy() end
local city=Instance.new("Folder")
city.Name="Phase52_RoleplayDistrict"
city.Parent=world
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local C={
 night=rgb(31,50,62),road=rgb(43,48,53),warm=rgb(240,226,201),
 cream=rgb(222,213,196),teal=rgb(86,161,170),stone=rgb(169,176,177),
 mint=rgb(70,134,110),gold=rgb(220,171,88),white=rgb(248,247,239),
 blue=rgb(40,106,144),grey=rgb(132,141,145),palm=rgb(40,118,66),
 wood=rgb(151,108,76),asphalt=rgb(57,63,68)
}
local function folder(parent,name)
 local f=Instance.new("Folder")
 f.Name=name
 f.Parent=parent
 return f
end
local function part(parent,name,size,pos,color,material,solid)
 local p=Instance.new("Part")
 p.Name=name
 p.Anchored=true
 p.CanCollide=solid==true
 p.Size=size
 p.CFrame=pos
 p.Color=color or C.cream
 p.Material=material or Enum.Material.SmoothPlastic
 p.CastShadow=true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function sign(surface,text,face,textcolor)
 local gui=Instance.new("SurfaceGui")
 gui.Face=face or Enum.NormalId.Front
 gui.PixelsPerStud=45
 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
 gui.LightInfluence=.05
 gui.Parent=surface
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.fromScale(1,1)
 lbl.BackgroundTransparency=1
 lbl.Font=Enum.Font.GothamBold
 lbl.TextScaled=true
 lbl.TextWrapped=true
 lbl.Text=text
 lbl.TextColor3=textcolor or C.white
 lbl.Parent=gui
end
local function item(parent,name,x,y,z,sx,sy,sz,color,mat,solid)
 return part(parent,name,Vector3.new(sx,sy,sz),CFrame.new(x,y,z),color,mat,solid)
end
local street=folder(city,"BoulevardAndSidewalks")
-- Commercial district at z=-615, north of existing v5.1 house street.
item(street,"Business boulevard",0,.25,-715,930,.55,38,C.road,Enum.Material.Asphalt,true)
item(street,"Shop promenade",0,.58,-666,940,1.15,20,C.warm,Enum.Material.Concrete,true)
item(street,"Villa pedestrian path",0,.58,-765,940,1.15,16,C.warm,Enum.Material.Concrete,true)
for x=-450,450,33 do
 item(street,"Lane marking",x,.6,-715,15,.11,.6,C.white,Enum.Material.SmoothPlastic,false)
end
for x=-405,405,135 do
 for n=0,7 do
  item(street,"Marked pedestrian crossing",x-15+n*4,.62,-694,2.3,.12,13,C.white,nil,false)
 end
end
for x=-430,430,55 do
 local lamp=item(street,"Urban streetlight",x,11,-672,.8,22,.8,C.grey,Enum.Material.Metal,false)
 item(street,"Streetlight arm",x+3.2,22,-672,7,.7,.7,C.grey,Enum.Material.Metal,false)
 local head=item(street,"Warm LED Streetlight",x+6.4,21.7,-672,2.4,.65,2.6,C.gold,Enum.Material.Neon,false)
 local light=Instance.new("PointLight")
 light.Name="V52NightLamp"
 light.Enabled=false
 light.Brightness=1.4
 light.Range=25
 light.Color=C.gold
 light.Parent=head
end
-- Upgraded villa facades and greenery without modifying ownership or door scripts.
local exterior=folder(city,"VillaFacadesAndGardens")
for index,x in ipairs({-330,-195,195,330}) do
 local z=-812
 for _,side in ipairs({-1,1}) do
  item(exterior,"House vertical front pilaster",x+side*30,10,z+25,2.3,18,2.4,
   C.white,Enum.Material.Concrete,false)
  item(exterior,"Modern balcony glass",x+side*12,14.5,z+28,18,4,.6,
   C.teal,Enum.Material.Glass,false)
  item(exterior,"Landscaped ornamental hedge",x+side*30,2.9,z+42,17,3,5,
   C.mint,Enum.Material.Grass,false)
 end
 item(exterior,"Luxury home facade accent",x,20,z,68,1,54,C.gold,Enum.Material.Metal,false)
 item(exterior,"Home covered porch ceiling",x,13.8,z+32,24,.8,17,C.cream,Enum.Material.Concrete,false)
 item(exterior,"Villa gateway path",x,.75,z+51,13,.6,27,C.warm,Enum.Material.Concrete,true)
 for _,dx in ipairs({-31,31}) do
  item(exterior,"Garden path lantern",x+dx,4,z+40,1,8,1,C.grey,Enum.Material.Metal,false)
  item(exterior,"Lamp glow",x+dx,8.5,z+40,2,.7,2,C.gold,Enum.Material.Neon,false)
 end
end
-- More layered realistic low-poly palm silhouette near streets and home gardens.
local green=folder(city,"PalmLandscaping")
local function palm(x,z,h)
 item(green,"Palm segmented trunk",x,h/2,z,2.4,h,2.4,C.wood,Enum.Material.Wood,false)
 for j=1,5 do
  local angle=(j-1)*2*math.pi/5
  local sx=x+7*math.cos(angle)
  local sz=z+7*math.sin(angle)
  part(green,"Natural palm leaf",Vector3.new(17,1.4,4),
   CFrame.new(sx,h+1,sz)*CFrame.Angles(0,-angle,math.rad((j%2==0 and 7 or -7))),
   C.palm,Enum.Material.Grass,false)
 end
end
for x=-420,420,70 do
 palm(x,-640,16+(math.abs(x)%4))
end
for _,x in ipairs({-420,-275,-95,95,275,420}) do palm(x,-852,13) end
-- 6 OPEN FRONT SHOPS: real walk-in interiors with usable counters.
local stores=folder(city,"CityBusinesses")
local specs={
 {name="DUBAI CLINIC",service="Hospital",x=-370,tint=rgb(228,235,231),banner=C.mint},
 {name="KARAK CAFE",service="Cafe",x=-225,tint=rgb(222,210,180),banner=rgb(169,101,67)},
 {name="CITY MARKET",service="Market",x=-80,tint=rgb(222,226,225),banner=C.blue},
 {name="HOTEL AL WASL",service="Hotel",x=80,tint=rgb(231,214,192),banner=C.gold},
 {name="DUBAI BANK",service="Bank",x=225,tint=rgb(224,222,211),banner=C.mint},
 {name="FASHION SOUQ",service="Fashion",x=370,tint=rgb(225,216,218),banner=rgb(157,93,117)},
}
for _,s in ipairs(specs) do
 local z=-605
 local model=Instance.new("Model")
 model.Name=s.name
 model:SetAttribute("Service",s.service)
 model.Parent=stores
 local function b(name,x,y,zp,sx,sy,sz,color,mat,solid)
  return item(model,name,x,y,zp,sx,sy,sz,color,mat,solid)
 end
 b("Terrazzo walk-in ground floor",s.x,.75,z,113,1.5,69,C.warm,Enum.Material.Marble,true)
 b("Back solid wall",s.x,13,z+34,113,24,2,s.tint,Enum.Material.Concrete,true)
 for _,dx in ipairs({-55,55}) do
  b("Side limestone wall",s.x+dx,13,z,3,24,70,s.tint,Enum.Material.Concrete,true)
  b("Building facade pilaster",s.x+dx,13,z-35,3.4,24,3.4,C.cream,Enum.Material.Concrete,true)
 end
 b("Raised flat roof",s.x,25.8,z,120,2.5,76,C.cream,Enum.Material.Concrete,true)
 b("Roof top color trim",s.x,28,z,121,1.1,77,s.banner,Enum.Material.Metal,false)
 b("Front glazed display left",s.x-31,11,z-34,40,15,.7,C.teal,Enum.Material.Glass,false)
 b("Front glazed display right",s.x+31,11,z-34,40,15,.7,C.teal,Enum.Material.Glass,false)
 b("Stainless column left",s.x-10,11,z-35,1,17,1,C.grey,Enum.Material.Metal,false)
 b("Stainless column right",s.x+10,11,z-35,1,17,1,C.grey,Enum.Material.Metal,false)
 b("Open entrance overhead lintel",s.x,19,z-35,22,2.4,2,s.tint,Enum.Material.Concrete,false)
 b("Shop entrance canopy",s.x,21,z-41,110,1.3,10,s.banner,Enum.Material.Metal,false)
 local fascia=b("Business name plate",s.x,23.8,z-37,99,5,.8,C.night,Enum.Material.Metal,false)
 sign(fascia,s.name,Enum.NormalId.Front,C.white)
 for _,sx in ipairs({-40,-20,20,40}) do
  b("Shop interior ceiling lamp",s.x+sx,22,z,4,.6,9,C.gold,Enum.Material.Neon,false)
 end
 local counter=b("ServiceCounter",s.x,4.2,z+8,38,5.2,8,C.cream,Enum.Material.Wood,true)
 local counterTrim=b("Countertop",s.x,7,z+8,39,.7,9,C.grey,Enum.Material.Marble,false)
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="Use"..s.service.."Service"
 prompt.ActionText="Use service"
 prompt.ObjectText=s.name
 prompt.MaxActivationDistance=12
 prompt.RequiresLineOfSight=false
 prompt.HoldDuration=.35
 prompt.Parent=counter
 if s.service=="Cafe" then
  for _,dx in ipairs({-38,0,38}) do
   b("Cafe seating table",s.x+dx,3.7,z-17,11,1.1,10,C.wood,Enum.Material.Wood,true)
  end
 elseif s.service=="Market" then
  for _,dx in ipairs({-36,36}) do
   b("Shopping aisle shelf",s.x+dx,7,z-12,11,11,21,C.grey,Enum.Material.Metal,true)
  end
 elseif s.service=="Hospital" then
  for _,dx in ipairs({-31,31}) do
   b("Hospital patient bed",s.x+dx,3.3,z-14,15,2,8,C.white,Enum.Material.Fabric,true)
  end
 elseif s.service=="Hotel" then
  for _,dx in ipairs({-30,30}) do
   b("Hotel lounge sofa",s.x+dx,4,z-13,18,3.2,9,s.banner,Enum.Material.Fabric,true)
  end
 else
  b("Store display cabinet",s.x,9,z+25,50,13,5,C.teal,Enum.Material.Glass,false)
 end
end
-- Model 2 visually improved bus stops and street furniture.
local transport=folder(city,"CityTransportDetails")
local function bus(name,x,z,bodyColor)
 local m=Instance.new("Model")
 m.Name=name
 m.Parent=transport
 item(m,"Bus main long body",x,6,z,11,7.6,34,bodyColor,Enum.Material.Metal,false)
 item(m,"Bus upper curved roof",x,10.3,z,10.6,1,32,C.white,Enum.Material.Metal,false)
 for _,dir in ipairs({-1,1}) do
  for _,zz in ipairs({-10,0,10}) do
   item(m,"Bus panoramic side window",x+dir*5.55,7.8,z+zz,.3,3.8,8,
    C.teal,Enum.Material.Glass,false)
  end
  for _,zz in ipairs({-11,11}) do
   local tyre=item(m,"Bus rubber wheel",x+dir*5.85,2.5,z+zz,1.8,5,5,
    rgb(27,30,32),Enum.Material.Rubber,false)
   tyre.Shape=Enum.PartType.Cylinder
   local hub=item(m,"Bus silver rim",x+dir*6.83,2.5,z+zz,.3,2.8,2.8,C.grey,Enum.Material.Metal,false)
   hub.Shape=Enum.PartType.Cylinder
  end
 end
 item(m,"Bus front windshield",x,7.5,z-17.1,9,4,.3,C.teal,Enum.Material.Glass,false)
 item(m,"Bus door",x+5.64,5.1,z-8,.3,5.9,5,C.cream,Enum.Material.Glass,false)
end
bus("Dubai RTA bus",460,-728,C.white)
bus("Dubai City Tour", -460,-728,rgb(213,173,97))
for x=-500,500,200 do
 item(transport,"Public bench seat",x,2.6,-668,11,1.1,4,C.wood,Enum.Material.Wood,true)
 item(transport,"Public bench backrest",x,4.5,-666.3,11,3,.8,C.wood,Enum.Material.Wood,false)
end
-- Small 3D district guide, not big floating billboard signs.
local info=item(transport,"New district welcome sign",-460,14,-670,53,7,1.2,C.night,Enum.Material.Metal,false)
sign(info,"DUBAI CITY LIFE  |  HOMES  •  SHOPS  •  ROLES",Enum.NormalId.Front,C.gold)
-- Reduce older billboard clutter around spawn, preserving owner status and UI function.
for _,obj in ipairs(world:GetDescendants()) do
 if obj:IsA("BillboardGui") then
  local noisy=false
  for _,lbl in ipairs(obj:GetDescendants()) do
   if lbl:IsA("TextLabel") then
    local caption=string.upper(lbl.Text)
    if string.find(caption,"POLICE") and string.find(caption,"AMBULANCE") or
     string.find(caption,"WELCOME TO UAE") then noisy=true end
   end
  end
  if noisy then
   obj.Size=UDim2.fromOffset(185,34)
   obj.MaxDistance=85
  end
 end
end
-- Better original-toy aesthetic: clear glass and softer sun for this laptop.
Lighting.GlobalShadows=true
Lighting.ShadowSoftness=.35
Lighting.EnvironmentDiffuseScale=.7
Lighting.EnvironmentSpecularScale=.72
local grade=Lighting:FindFirstChild("UAEColorGrade")
if grade and grade:IsA("ColorCorrectionEffect") then
 grade.Contrast=.10
 grade.Saturation=.08
 grade.Brightness=.018
end
-- Clock-aware neighbourhood lampposts.
for _,name in ipairs({"UAE_V52_RoleplayServer","UAE_V52_NightLights","UAE_V52_Shoppers"}) do
 local oldScript=SS:FindFirstChild(name)
 if oldScript then oldScript:Destroy() end
end
local startupScripts=SP:WaitForChild("StarterPlayerScripts")
for _,name in ipairs({
 "UAE_Phase5HUD","UAE_Phase5Camera","UAE_Phase51HUD",
 "UAE_Phase51Camera","UAE_VehicleCamera","UAE_Phase4Camera",
 "UAE_Phase4HUD","UAE_V52_HUD","UAE_V52_Camera","UAE_V52_Menu"
}) do
 local oldScript=startupScripts:FindFirstChild(name)
 if oldScript then oldScript:Destroy() end
end
SP.CameraMode=Enum.CameraMode.Classic
SP.CameraMinZoomDistance=4
SP.CameraMaxZoomDistance=110
local function install(class,parent,name,source)
 local obj=Instance.new(class)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
end
install("LocalScript",startupScripts,"UAE_V52_Camera",[========[
-- UAE City Life v5.2: reliable third-person zoom with I/O on laptop.
-- Some Roblox CoreScripts consume I/O key events; poll IsKeyDown each frame.
-- O = zoom OUT, I = zoom IN. Mouse wheel and camera-orbit are extras.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V52_CameraStatus"
gui.ResetOnSpawn=false
gui.DisplayOrder=24
gui.Parent=player:WaitForChild("PlayerGui")
local hint=Instance.new("TextLabel")
hint.Name="CameraZoomStatus"
hint.AnchorPoint=Vector2.new(1,1)
hint.Position=UDim2.new(1,-12,1,-12)
hint.Size=UDim2.fromOffset(160,22)
hint.BackgroundColor3=Color3.fromRGB(22,43,55)
hint.BackgroundTransparency=.24
hint.BorderSizePixel=0
hint.TextColor3=Color3.fromRGB(244,232,209)
hint.TextSize=11
hint.Font=Enum.Font.GothamSemibold
hint.Text="I Zoom In  |  O Zoom Out"
hint.Parent=gui
local round=Instance.new("UICorner")
round.CornerRadius=UDim.new(0,7)
round.Parent=hint
local currentDistance=20
local orbit=0
local elevation=math.rad(19)
local mouseHeld=false
local lastType=nil
local lastKeyStep=0
local lastStatus=0
local initialized=false
local function vehicle()
 local character=player.Character
 local hum=character and character:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then
   return model,character,hum
  end
 end
 return nil,character,hum
end
local function maxRange()
 local car=vehicle()
 return car and 12 or 5,car and 105 or 75
end
local function zoom(ratio)
 local near,far=maxRange()
 currentDistance=math.clamp(currentDistance*ratio,near,far)
 hint.Text=string.format("I / O  ZOOM   %d studs",math.round(currentDistance))
end
local function resetCamera()
 currentDistance=20
 orbit=0
 elevation=math.rad(19)
end
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then
  mouseHeld=true
 end
 if processed or UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.C then
  resetCamera()
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  elevation=math.clamp(elevation+math.rad(9),math.rad(8),math.rad(74))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  elevation=math.clamp(elevation-math.rad(9),math.rad(8),math.rad(74))
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=false end
end)
UIS.InputChanged:Connect(function(input,processed)
 if UIS:GetFocusedTextBox() then return end
 if input.UserInputType==Enum.UserInputType.MouseWheel and not processed then
  zoom(input.Position.Z>0 and .82 or 1.21)
 elseif input.UserInputType==Enum.UserInputType.MouseMovement and mouseHeld then
  orbit=orbit-input.Delta.X*.006
  elevation=math.clamp(elevation+input.Delta.Y*.004,math.rad(8),math.rad(74))
 end
end)
RunService:BindToRenderStep("UAE_V52_KBZoomCamera",Enum.RenderPriority.Camera.Value+70,function(dt)
 local camera=workspace.CurrentCamera
 if not camera then return end
 local car,char,hum=vehicle()
 local root=char and char:FindFirstChild("HumanoidRootPart")
 if not root or not hum or hum.Health<=0 then
  initialized=false
  camera.CameraType=Enum.CameraType.Custom
  return
 end
 local mode=car and "Vehicle" or "Walk"
 if mode~=lastType then
  lastType=mode
  currentDistance=car and 35 or 20
  initialized=false
 end
 -- Roblox default camera may process I/O before InputBegan; reading key STATE works.
 local now=os.clock()
 if not UIS:GetFocusedTextBox() and now-lastKeyStep>=.11 then
  if UIS:IsKeyDown(Enum.KeyCode.I) then
   zoom(.89)
   lastKeyStep=now
  elseif UIS:IsKeyDown(Enum.KeyCode.O) then
   zoom(1.13)
   lastKeyStep=now
  end
 end
 -- Explicit CFrame placement prevents old camera settings ignoring zoom.
 local basis=car and car:GetPivot() or root.CFrame
 local height=car and 5.7 or 2.3
 local target=(basis*CFrame.new(0,height,0)).Position
 local localView=basis*CFrame.Angles(0,orbit,0)
 local intended=(localView*CFrame.new(0,height+currentDistance*math.sin(elevation),
  currentDistance*math.cos(elevation))).Position
 local vec=intended-target
 if vec.Magnitude<1 then return end
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=car and {char,car} or {char}
 params.IgnoreWater=true
 local hit=workspace:Raycast(target,vec,params)
 if hit then intended=hit.Position-vec.Unit*1.3 end
 camera.CameraType=Enum.CameraType.Scriptable
 local goal=CFrame.lookAt(intended,target)
 camera.CFrame=initialized and camera.CFrame:Lerp(goal,math.clamp(dt*13,0,1)) or goal
 camera.Focus=CFrame.new(target)
 camera.FieldOfView=70
 initialized=true
end)

]========])
install("LocalScript",startupScripts,"UAE_V52_HUD",[========[
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
gui.Name="UAE_V52_HUD"
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
radar.Size=UDim2.fromOffset(96,96)
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
local mapCenter=Vector2.new(48,48)
local radius=42
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
me.Position=UDim2.fromOffset(48,48)
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
local plus=button(gui,"ZoomIn","+",UDim2.fromOffset(22,22),UDim2.fromOffset(112,18))
local minus=button(gui,"ZoomOut","−",UDim2.fromOffset(22,22),UDim2.fromOffset(112,43))
local fullMapButton=button(gui,"FullMapButton","MAP",UDim2.fromOffset(47,21),UDim2.fromOffset(12,114))
fullMapButton.TextSize=10
local clock=Instance.new("Frame")
clock.Name="CompactDubaiClock"
clock.AnchorPoint=Vector2.new(1,0)
clock.Position=UDim2.new(1,-15,0,15)
clock.Size=UDim2.fromOffset(173,38)
clock.BackgroundColor3=navy
clock.BackgroundTransparency=.16
clock.Parent=gui
corner(clock,0,9)
local dubaiTime=label(clock,"DubaiTime","DUBAI --:-- GST",
 UDim2.new(1,-16,0,19),UDim2.fromOffset(10,1),12,cream)
local cycleTime=label(clock,"GameCycle","GAME --:--  •  DAY",
 UDim2.new(1,-16,0,17),UDim2.fromOffset(10,20),9,col(207,226,222))
local missionNotice=Instance.new("Frame")
missionNotice.Name="CompactMission"
missionNotice.AnchorPoint=Vector2.new(0,1)
missionNotice.Position=UDim2.new(0,12,1,-12)
missionNotice.Size=UDim2.fromOffset(219,34)
missionNotice.BackgroundColor3=navy
missionNotice.BackgroundTransparency=.12
missionNotice.BorderSizePixel=0
missionNotice.Parent=gui
corner(missionNotice,0,9)
local missionLabel=label(missionNotice,"MissionStatus","🇦🇪 Explore Dubai • Visit Burj Khalifa",
 UDim2.new(1,-16,1,-6),UDim2.fromOffset(8,3),10,cream)
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
local zoomMin,zoomMax=.7,20
local scaleReadout=label(gui,"RadarZoomHint","MAP 2.7",
 UDim2.fromOffset(110,16),UDim2.fromOffset(12,138),10,cream)
local function setZoom(value)
 zoom=math.clamp(value,zoomMin,zoomMax)
 scaleReadout.Text=string.format("MAP %0.1f  •  +/−",zoom)
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
 if mouse.X>=pos.X and mouse.X<=pos.X+96 and mouse.Y>=pos.Y and mouse.Y<=pos.Y+96 then
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
install("LocalScript",startupScripts,"UAE_V52_Menu",[========[
-- UAE CITY LIFE 5.2: one small CITY button opens Brookhaven-style travel and car options.
-- All important actions are validated on the server; UI does not grant assets itself.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local actions=RS:WaitForChild("UAE_V52_CityAction",30)
local feedback=RS:WaitForChild("UAE_V52_CityFeedback",30)
if not actions or not feedback then
 warn("UAE v5.2 City menu: server is not installed")
 return
end
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V52_CityMenu"
gui.ResetOnSpawn=false
gui.DisplayOrder=38
gui.Parent=player:WaitForChild("PlayerGui")
local navy=Color3.fromRGB(19,43,56)
local cream=Color3.fromRGB(250,232,204)
local aqua=Color3.fromRGB(60,146,153)
local gold=Color3.fromRGB(224,171,85)
local function round(part,n)
 local obj=Instance.new("UICorner")
 obj.CornerRadius=UDim.new(0,n or 8)
 obj.Parent=part
end
local function label(parent,txt,sz,pos,size)
 local l=Instance.new("TextLabel")
 l.BackgroundTransparency=1
 l.Text=txt
 l.TextColor3=cream
 l.TextSize=sz
 l.Font=Enum.Font.GothamBold
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.Position=pos
 l.Size=size
 l.Parent=parent
 return l
end
local function button(parent,txt,pos,size,bg)
 local b=Instance.new("TextButton")
 b.Text=txt
 b.Font=Enum.Font.GothamBold
 b.TextSize=12
 b.TextColor3=cream
 b.BackgroundColor3=bg or aqua
 b.Position=pos
 b.Size=size
 b.AutoButtonColor=true
 b.Parent=parent
 round(b,9)
 return b
end
local launch=button(gui,"CITY",UDim2.new(1,-85,1,-95),UDim2.fromOffset(71,37),navy)
launch.TextSize=15
local panel=Instance.new("Frame")
panel.Name="RoleplayOptions"
panel.Size=UDim2.fromOffset(342,358)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.52)
panel.BackgroundColor3=navy
panel.BackgroundTransparency=.02
panel.Visible=false
panel.BorderSizePixel=0
panel.Parent=gui
round(panel,13)
local stroke=Instance.new("UIStroke")
stroke.Color=gold
stroke.Thickness=1.4
stroke.Parent=panel
label(panel,"DUBAI • CITY LIFE",17,UDim2.fromOffset(17,9),UDim2.fromOffset(265,27))
label(panel,"Visit a district, claim a home or drive a car",11,
 UDim2.fromOffset(17,38),UDim2.fromOffset(315,19))
local close=button(panel,"X",UDim2.new(1,-45,0,9),UDim2.fromOffset(32,30),Color3.fromRGB(105,60,63))
local t1=label(panel,"PLACES",12,UDim2.fromOffset(16,68),UDim2.fromOffset(140,22))
local t2=label(panel,"YOUR VEHICLE",12,UDim2.fromOffset(177,68),UDim2.fromOffset(150,22))
local destinations={
 {"Homes & Villas","Homes"},
 {"Sheikh Zayed Road","E11"},
 {"Burj Khalifa","Downtown"},
 {"Dubai Marina","Marina"},
 {"Airport","Airport"},
}
local ride={
 {"Dubai Taxi","Taxi"},
 {"Family SUV","Family"},
 {"City Sedan","Sedan"},
 {"Remove my car","RemoveCar"},
}
local choices={}
for i,a in ipairs(destinations) do
 local b=button(panel,a[1],UDim2.fromOffset(15,94+(i-1)*45),
  UDim2.fromOffset(146,35),aqua)
 b.Activated:Connect(function()
  actions:FireServer("Travel",a[2])
  panel.Visible=false
 end)
end
for i,a in ipairs(ride) do
 local b=button(panel,a[1],UDim2.fromOffset(178,94+(i-1)*45),
  UDim2.fromOffset(147,35),i==4 and Color3.fromRGB(117,88,78) or aqua)
 b.Activated:Connect(function()
  actions:FireServer(i==4 and "RemoveCar" or "SpawnCar",a[2])
  panel.Visible=false
 end)
end
local tip=label(panel,"I = zoom in   •   O = zoom out   •   M = map",11,
 UDim2.fromOffset(17,324),UDim2.fromOffset(315,22))
local notice=label(gui,"",12,UDim2.new(.5,-160,0,66),UDim2.fromOffset(320,36))
notice.TextXAlignment=Enum.TextXAlignment.Center
notice.BackgroundTransparency=.16
notice.BackgroundColor3=navy
notice.Visible=false
round(notice,10)
local nonce=0
local function toast(msg)
 nonce=nonce+1
 local token=nonce
 notice.Text=msg
 notice.Visible=true
 task.delay(4,function()
  if nonce==token and notice.Parent then notice.Visible=false end
 end)
end
feedback.OnClientEvent:Connect(function(message)
 if typeof(message)=="string" and #message<180 then toast(message) end
end)
task.delay(2.5,function()
 if gui.Parent then toast("New Dubai district: click CITY or press B to visit!") end
end)
local function toggle()
 panel.Visible=not panel.Visible
end
launch.Activated:Connect(toggle)
close.Activated:Connect(toggle)
UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.KeyCode==Enum.KeyCode.B then toggle() end
end)

]========])
install("Script",SS,"UAE_V52_RoleplayServer",[========[
-- UAE City Life v5.2 server authority for city travel, interactive shops and personal cars.
-- Uses the original UAE_Driving and UAE_DrivingInput scripts for prototype driving.
-- Dynamic seats get their own server-checked proximity entry binding.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local roleplay=world:WaitForChild("Phase52_RoleplayDistrict")
local cars=world:WaitForChild("EmergencyVehicles")
local action=RS:FindFirstChild("UAE_V52_CityAction") or Instance.new("RemoteEvent")
action.Name="UAE_V52_CityAction"
action.Parent=RS
local feedback=RS:FindFirstChild("UAE_V52_CityFeedback") or Instance.new("RemoteEvent")
feedback.Name="UAE_V52_CityFeedback"
feedback.Parent=RS
local types={
 Taxi={body=Color3.fromRGB(236,224,195),trim=Color3.fromRGB(203,70,59),glass=Color3.fromRGB(49,105,137)},
 Family={body=Color3.fromRGB(219,221,218),trim=Color3.fromRGB(49,78,91),glass=Color3.fromRGB(49,105,137)},
 Sedan={body=Color3.fromRGB(37,105,131),trim=Color3.fromRGB(26,43,55),glass=Color3.fromRGB(49,105,137)},
}
local travel={
 Homes=Vector3.new(0,5,-747),
 E11=Vector3.new(107,5,-1200),
 Downtown=Vector3.new(115,6,-392),
 Marina=Vector3.new(1085,6,-1250),
 Airport=Vector3.new(-1055,6,-1330),
}
local carSlots={
 Vector3.new(-130,1,-689),Vector3.new(-78,1,-689),Vector3.new(-26,1,-689),
 Vector3.new(26,1,-689),Vector3.new(78,1,-689),Vector3.new(130,1,-689),
}
local owned={}
local lastAction={}
local function tell(player,msg)
 if player.Parent==Players then feedback:FireClient(player,msg) end
end
local function characterRoot(player)
 local ch=player.Character
 local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 if hum and root and hum.Health>0 then return root,hum end
 return nil,nil
end
local function allowed(player)
 if lastAction[player] and os.clock()-lastAction[player]<1.3 then return false end
 lastAction[player]=os.clock()
 return true
end
local function safeRemove(player)
 local prior=owned[player]
 if prior then
  if prior.Parent then prior:Destroy() end
  owned[player]=nil
 end
end
local function part(parent,name,size,cf,color,material)
 local p=Instance.new("Part")
 p.Name=name
 p.Anchored=true
 p.CanCollide=false
 p.CastShadow=true
 p.Size=size
 p.CFrame=cf
 p.Color=color
 p.Material=material or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function makeCar(player,typ,pos)
 local colors=types[typ]
 local model=Instance.new("Model")
 model.Name="Personal "..typ.." • "..player.UserId
 model:SetAttribute("UAEVehicle",true)
 model:SetAttribute("VehicleType",typ)
 model:SetAttribute("OwnerUserId",player.UserId)
 model.Parent=cars
 local root=part(model,"VehiclePivot",Vector3.new(.2,.2,.2),CFrame.new(),
  Color3.fromRGB(241,241,241))
 root.Transparency=1
 model.PrimaryPart=root
 local function add(name,size,x,y,z,color,mat)
  return part(model,name,size,CFrame.new(x,y,z),color,mat)
 end
 local length=(typ=="Family") and 22 or 19
 local side=(typ=="Family") and 5.2 or 4.8
 add("Dark underbody",Vector3.new(side*2,1.3,length),0,3.3,0,colors.trim,Enum.Material.Metal)
 add("Modern car side body",Vector3.new(side*2,2.7,length-2),0,4.4,0,colors.body,Enum.Material.Metal)
 add("Rounded front bonnet",Vector3.new(side*2-.25,1.2,6),0,5,-length/2+3,colors.body,Enum.Material.Metal)
 add("Cabin lower shape",Vector3.new(side*2-.9,2,10),0,6.5,1.1,colors.body,Enum.Material.Metal)
 add("Car roof",Vector3.new(side*2-1.6,.8,8),0,8,1.25,colors.body,Enum.Material.Metal)
 for _,dir in ipairs({-1,1}) do
  local x=dir*side
  for _,z in ipairs({-length*.32,length*.32}) do
   local tyre=add("Vertical rubber tyre",Vector3.new(1.8,5.1,5.1),x,2.6,z,
    Color3.fromRGB(26,29,33),Enum.Material.Rubber)
   tyre.Shape=Enum.PartType.Cylinder
   local rim=add("Alloy rim",Vector3.new(.25,2.8,2.8),x+dir*.98,2.6,z,
    Color3.fromRGB(192,197,197),Enum.Material.Metal)
   rim.Shape=Enum.PartType.Cylinder
  end
  add("Side door glazing",Vector3.new(.3,2.1,8.7),dir*(side-.27),7.3,1.4,
   colors.glass,Enum.Material.Glass)
  add("Door handle",Vector3.new(.35,.22,1.6),dir*(side+.1),5.55,1.3,
   Color3.fromRGB(222,229,223),Enum.Material.Metal)
  add("LED front light",Vector3.new(2.6,.65,.35),dir*(side-1.7),5,
   -length/2-.05,Color3.fromRGB(255,245,196),Enum.Material.Neon)
  add("Rear red light",Vector3.new(2.6,.65,.35),dir*(side-1.7),5,
   length/2+.05,Color3.fromRGB(201,45,52),Enum.Material.Neon)
 end
 add("Front windshield",Vector3.new(side*2-1.5,2.7,.4),0,6.7,-4,
  colors.glass,Enum.Material.Glass)
 add("Rear windshield",Vector3.new(side*2-1.5,2.5,.4),0,6.8,5.8,
  colors.glass,Enum.Material.Glass)
 add("Front silver grille",Vector3.new(side*1.3,1,.35),0,3.9,-length/2-.15,
  Color3.fromRGB(57,67,73),Enum.Material.Metal)
 local seat=Instance.new("VehicleSeat")
 seat.Name="DriverSeat"
 seat.Anchored=true
 seat.CanCollide=false
 seat.Transparency=1
 seat.Size=Vector3.new(3,.8,3)
 seat.CFrame=CFrame.new(0,7,-1)
 seat.MaxSpeed=0
 seat.Parent=model
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="EntryPrompt"
 prompt.ActionText="Drive"
 prompt.ObjectText="Your "..typ
 prompt.MaxActivationDistance=16
 prompt.RequiresLineOfSight=false
 prompt.Parent=seat
 if typ=="Taxi" then
  local roof=add("Dubai taxi roof sign",Vector3.new(5,1.1,2.3),
   0,8.95,1,Color3.fromRGB(236,228,199),Enum.Material.SmoothPlastic)
  local g=Instance.new("SurfaceGui")
  g.Face=Enum.NormalId.Front
  g.PixelsPerStud=40
  g.Parent=roof
  local t=Instance.new("TextLabel")
  t.BackgroundTransparency=1
  t.Size=UDim2.fromScale(1,1)
  t.Text="DUBAI TAXI"
  t.Font=Enum.Font.GothamBold
  t.TextScaled=true
  t.TextColor3=Color3.fromRGB(19,59,91)
  t.Parent=g
 end
 model:PivotTo(CFrame.new(pos))
 prompt.Triggered:Connect(function(p)
  local rootPart,hum=characterRoot(p)
  if p~=player or not rootPart or not hum then return end
  if (rootPart.Position-seat.Position).Magnitude>19 then return end
  if seat.Occupant==nil then
   seat:Sit(hum)
  end
 end)
 return model
end
local function nearestFreeSlot()
 for _,slot in ipairs(carSlots) do
  local free=true
  for _,model in pairs(owned) do
   if model and model.Parent and (model:GetPivot().Position-slot).Magnitude<23 then
    free=false
    break
   end
  end
  if free then return slot end
 end
 return nil
end
action.OnServerEvent:Connect(function(player,kind,choice)
 if typeof(kind)~="string" or typeof(choice)~="string" then return end
 if #kind>20 or #choice>24 then return end
 if not allowed(player) then return end
 local rootPart,hum=characterRoot(player)
 if not rootPart then return end
 if kind=="Travel" then
  local position=travel[choice]
  if not position then return end
  local character=player.Character
  if hum.Sit then
   hum.Sit=false
   task.wait(.15)
  end
  if character and character.Parent then
   character:PivotTo(CFrame.new(position))
   tell(player,"Welcome to "..(choice=="Homes" and "UAE Villas" or choice).."!")
  end
 elseif kind=="SpawnCar" then
  if not types[choice] then return end
  local pos=rootPart.Position
  if math.abs(pos.X)>590 or pos.Z < -920 or pos.Z > -550 then
   tell(player,"Open CITY → Homes first to visit the garage area.")
   return
  end
  local spot=nearestFreeSlot()
  if not spot then
   tell(player,"Garage spaces are occupied. Try again soon.")
   return
  end
  safeRemove(player)
  owned[player]=makeCar(player,choice,spot)
  tell(player,choice.." ready near the residential garages. Press E to drive.")
 elseif kind=="RemoveCar" then
  safeRemove(player)
  tell(player,"Your personal vehicle has been removed.")
 end
end)
-- Trim the enormous old GAME OWNER billboard without removing owner recognition.
local function tidyOwnerTag(character)
 task.delay(2,function()
  if not character.Parent then return end
  local head=character:FindFirstChild("Head")
  local label=head and head:FindFirstChild("UAEGameOwnerTag")
  if label and label:IsA("BillboardGui") then
   label.Size=UDim2.fromOffset(120,29)
   label.StudsOffset=Vector3.new(0,2.9,0)
   label.MaxDistance=75
  end
 end)
end
Players.PlayerAdded:Connect(function(player)
 player.CharacterAdded:Connect(tidyOwnerTag)
end)
for _,player in ipairs(Players:GetPlayers()) do
 player.CharacterAdded:Connect(tidyOwnerTag)
 if player.Character then tidyOwnerTag(player.Character) end
end
Players.PlayerRemoving:Connect(function(player)
 safeRemove(player)
 lastAction[player]=nil
end)
-- The retail interactions are individual roleplay activities, never an economy exploit.
local business=roleplay:WaitForChild("CityBusinesses")
local lastShopUse={}
for _,shop in ipairs(business:GetChildren()) do
 local counter=shop:FindFirstChild("ServiceCounter")
 local prompt=counter and counter:FindFirstChildOfClass("ProximityPrompt")
 local activity=shop:GetAttribute("Service")
 if prompt and activity then
  prompt.Triggered:Connect(function(player)
   local rootPart,hum=characterRoot(player)
   if not rootPart or (rootPart.Position-counter.Position).Magnitude>15 then return end
   local key=tostring(player.UserId)..":"..tostring(activity)
   if lastShopUse[key] and os.clock()-lastShopUse[key]<25 then
    tell(player,"This service is ready again shortly.")
    return
   end
   lastShopUse[key]=os.clock()
   if activity=="Hospital" then
    hum.Health=hum.MaxHealth
    tell(player,"Hospital: you've been treated. Welcome back!")
   elseif activity=="Cafe" then
    hum.Health=math.min(hum.MaxHealth,hum.Health+12)
    tell(player,"Cafe: enjoy your karak tea!")
   else
    tell(player,shop.Name.." • roleplay service completed.")
    local leader=player:FindFirstChild("leaderstats")
    local points=leader and leader:FindFirstChild("CityPoints")
    if points then points.Value=points.Value+5 end
   end
  end)
 end
end

]========])
install("Script",SS,"UAE_V52_Shoppers",[========[
-- UAE City Life v5.2: lightweight neighborhood pedestrian loop.
-- Uses Roblox's own R15 rig creator; models are basic, not photorealistic.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local area=world:WaitForChild("Phase52_RoleplayDistrict")
local crowd=Instance.new("Folder")
crowd.Name="ShoppingStreetResidents"
crowd.Parent=area
local positions={
 {Vector3.new(-370,4,-682),Vector3.new(-290,4,-682),Vector3.new(-290,4,-740)},
 {Vector3.new(-225,4,-682),Vector3.new(-150,4,-682),Vector3.new(-150,4,-744)},
 {Vector3.new(-60,4,-681),Vector3.new(0,4,-681),Vector3.new(0,4,-745)},
 {Vector3.new(110,4,-682),Vector3.new(170,4,-682),Vector3.new(170,4,-741)},
 {Vector3.new(265,4,-680),Vector3.new(330,4,-680),Vector3.new(330,4,-740)},
 {Vector3.new(399,4,-683),Vector3.new(430,4,-733),Vector3.new(397,4,-733)},
}
local palette={
 Color3.fromRGB(232,188,150),Color3.fromRGB(160,118,86),
 Color3.fromRGB(111,81,65),Color3.fromRGB(207,153,122),
 Color3.fromRGB(188,130,94),Color3.fromRGB(224,195,155),
}
local shirts={
 Color3.fromRGB(81,131,168),Color3.fromRGB(236,224,201),
 Color3.fromRGB(65,113,91),Color3.fromRGB(157,85,101),
 Color3.fromRGB(210,182,120),Color3.fromRGB(77,80,102),
}
for i,waypoints in ipairs(positions) do
 task.spawn(function()
  local desc=Instance.new("HumanoidDescription")
  local skin=palette[i]
  desc.HeadColor=skin
  desc.LeftArmColor=skin
  desc.RightArmColor=skin
  desc.TorsoColor=shirts[i]
  desc.LeftLegColor=Color3.fromRGB(61,76,96)
  desc.RightLegColor=Color3.fromRGB(61,76,96)
  desc.HeightScale=1
  local ok,rig=pcall(function()
   return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
  end)
  desc:Destroy()
  if not ok or not rig then warn("v5.2 shopper "..i.." not created") return end
  rig.Name="Dubai Shopper "..i
  local hum=rig:FindFirstChildOfClass("Humanoid")
  if not hum then rig:Destroy() return end
  hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
  hum.WalkSpeed=7+i%3
  rig.Parent=crowd
  rig:PivotTo(CFrame.new(waypoints[1]))
  for _,p in ipairs(rig:GetDescendants()) do
   if p:IsA("BasePart") then p.CanCollide=(p.Name=="HumanoidRootPart") end
  end
  while crowd.Parent and hum.Health>0 do
   for n=2,#waypoints do
    if not rig.Parent or hum.Health<=0 then break end
    hum:MoveTo(waypoints[n])
    hum.MoveToFinished:Wait()
    task.wait(.2)
   end
   if rig.Parent and hum.Health>0 then
    hum:MoveTo(waypoints[1])
    hum.MoveToFinished:Wait()
   end
  end
 end)
 task.wait(.12)
end

]========])
install("Script",SS,"UAE_V52_NightLights",[========[
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local lights=world:WaitForChild("Phase52_RoleplayDistrict")
while lights.Parent do
 local hour=RS:GetAttribute("UAECycleHour")
 local isNight=typeof(hour)=="number" and (hour>=18 or hour<6)
 for _,obj in ipairs(lights:GetDescendants()) do
  if obj:IsA("PointLight") and obj.Name=="V52NightLamp" then obj.Enabled=isNight end
 end
 task.wait(6)
end
]========])

print("UAE CITY LIFE v5.2 READY: I/O camera zoom, smaller HUD, City travel menu, drivable taxis, modern service shops, upgraded home neighbourhood.")
