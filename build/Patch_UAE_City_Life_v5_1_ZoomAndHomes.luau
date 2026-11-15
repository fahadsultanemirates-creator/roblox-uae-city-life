-- UAE CITY LIFE | VERSION 5.1: ZOOM FIX + ROLEPLAY HOMES
-- Open your saved v5 place, STOP Play mode, run this one script in Studio Command Bar.
-- Back up v5 first. Do NOT rerun v5 mega city generator.
-- Replaces only old client HUD/camera and its OWN Phase51_RoleplayHomes folder.
local workspace=game:GetService("Workspace")
local SP=game:GetService("StarterPlayer")
local SS=game:GetService("ServerScriptService")
local world=workspace:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase5_DubaiModern"),
 "This patch requires your SAVED Version 5 Dubai Modern game. Open v5 in Studio first.")
local function col(r,g,b) return Color3.fromRGB(r,g,b) end
local white=col(238,231,206)
local blue=col(76,152,181)
local sand=col(201,177,135)
local cream=col(224,216,200)
local glass=col(105,181,202)
local dark=col(38,56,66)
local function make(parent,name,size,cf,color,material,collide)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=size
 p.CFrame=cf
 p.Color=color or white
 p.Material=material or Enum.Material.SmoothPlastic
 p.Anchored=true
 p.CanCollide=collide==true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local previous=world:FindFirstChild("Phase51_RoleplayHomes")
if previous then previous:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase51_RoleplayHomes"
root.Parent=world
local houses=Instance.new("Folder")
houses.Name="Villas"
houses.Parent=root
local street=Instance.new("Folder")
street.Name="ResidentialStreet"
street.Parent=root
make(street,"UAE Community Road",Vector3.new(875,.8,29),
 CFrame.new(0,.3,-733),col(56,62,67),Enum.Material.Asphalt,true)
for x=-420,420,30 do
 make(street,"Road Centerline",Vector3.new(15,.14,.7),
  CFrame.new(x,.76,-733),white,nil,false)
end
make(street,"Villa Front Sidewalk",Vector3.new(900,1.2,16),
 CFrame.new(0,.5,-760),cream,Enum.Material.Concrete,true)
local houseColors={
 {col(232,214,180),col(154,178,184)},
 {col(223,215,204),col(115,170,190)},
 {col(211,226,215),col(116,175,169)},
 {col(229,212,194),col(201,153,126)},
}
local xPositions={-330,-195,195,330}
for i,x in ipairs(xPositions) do
 local z=-812
 local c=houseColors[i]
 local villa=Instance.new("Model")
 villa.Name="UAE Villa "..i
 villa.Parent=houses
 villa:SetAttribute("OwnerUserId",0)
 villa:SetAttribute("OwnerName","")
 villa:SetAttribute("Locked",false)
 villa:SetAttribute("DoorOpen",false)
 local function piece(name,dim,dx,y,dz,tint,mat,solid)
  return make(villa,name,dim,CFrame.new(x+dx,y,z+dz),tint,mat,solid)
 end
 piece("Stone house foundation",Vector3.new(78,1.4,60),0,.7,0,sand,Enum.Material.Concrete,true)
 piece("Villa finished floor",Vector3.new(64,.6,48),0,1.7,0,c[1],Enum.Material.WoodPlanks,true)
 piece("Back wall",Vector3.new(64,15,2),0,9.2,-24,c[1],Enum.Material.Concrete,true)
 piece("Left wall",Vector3.new(2,15,48),-32,9.2,0,c[1],Enum.Material.Concrete,true)
 piece("Right wall",Vector3.new(2,15,48),32,9.2,0,c[1],Enum.Material.Concrete,true)
 piece("Front wall left",Vector3.new(25,15,2),-19,9.2,24,c[1],Enum.Material.Concrete,true)
 piece("Front wall right",Vector3.new(25,15,2),19,9.2,24,c[1],Enum.Material.Concrete,true)
 piece("Door arch above",Vector3.new(13,7,2),0,13.2,24,c[1],Enum.Material.Concrete,true)
 piece("White roof",Vector3.new(71,2,55),0,18.2,0,col(242,237,219),Enum.Material.Concrete,true)
 piece("Terrace roof border",Vector3.new(73,1.1,57),0,19.6,0,c[2],Enum.Material.Metal,false)
 piece("Porch slab",Vector3.new(21,.8,18),0,1.7,30,cream,Enum.Material.Concrete,true)
 local door=piece("FrontDoor",Vector3.new(10,8,.85),0,6.3,25.15,col(135,95,57),Enum.Material.Wood,true)
 local doorHandle=piece("Door Handle",Vector3.new(.7,.7,.4),3.7,6.5,25.8,col(233,185,74),Enum.Material.Metal,false)
 for _,sx in ipairs({-20,20}) do
  piece("Panoramic window",Vector3.new(12,8,.4),sx,9.7,25.2,glass,Enum.Material.Glass,false)
  piece("Window silver frame top",Vector3.new(13,.7,.8),sx,14,25.4,c[2],Enum.Material.Metal,false)
  piece("Window silver frame sides",Vector3.new(.7,8,.8),sx+6,9.7,25.5,c[2],Enum.Material.Metal,false)
  piece("Window silver frame sides",Vector3.new(.7,8,.8),sx-6,9.7,25.5,c[2],Enum.Material.Metal,false)
 end
 local wallSign=piece("StatusSign",Vector3.new(25,4,.5),0,15.3,25.3,dark,Enum.Material.SmoothPlastic,false)
 local signGui=Instance.new("SurfaceGui")
 signGui.Name="Villa Owner"
 signGui.Face=Enum.NormalId.Back
 signGui.PixelsPerStud=60
 signGui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
 signGui.Parent=wallSign
 local signText=Instance.new("TextLabel")
 signText.Name="OwnerName"
 signText.Size=UDim2.fromScale(1,1)
 signText.Font=Enum.Font.GothamBold
 signText.TextScaled=true
 signText.TextWrapped=true
 signText.Text="UAE Villa "..i.."\nAVAILABLE"
 signText.TextColor3=col(249,229,173)
 signText.BackgroundTransparency=1
 signText.Parent=signGui
 -- Living room furniture, kitchen counter and bed: enough to roleplay inside.
 piece("Sofa upholstered base",Vector3.new(15,3,7),15,3.5,-7,c[2],Enum.Material.Fabric,true)
 piece("Sofa backrest",Vector3.new(15,6,1.5),15,5.6,-10,c[2],Enum.Material.Fabric,true)
 piece("Living room table",Vector3.new(9,1.2,5),9,3.2,5,col(143,110,82),Enum.Material.Wood,true)
 piece("Kitchen counter",Vector3.new(17,4.2,5),-18,4.3,-15,col(207,204,195),Enum.Material.Marble,true)
 piece("Kitchen basin",Vector3.new(5,.4,3),-18,6.5,-15,col(105,133,142),Enum.Material.Metal,false)
 local bed=piece("Bed",Vector3.new(14,1.5,8),-15,3.4,5,col(224,233,228),Enum.Material.Fabric,true)
 piece("Bed headboard",Vector3.new(14,4,1),-15,4,1,col(129,100,77),Enum.Material.Wood,true)
 piece("Pillow",Vector3.new(4,.7,2.5),-19,4.5,5,white,Enum.Material.Fabric,false)
 -- Side garage area is decorative; player car spawning is future work.
 piece("Driveway garage slab",Vector3.new(22,.9,39),48,.9,11,cream,Enum.Material.Concrete,true)
 piece("Garage bay shelter",Vector3.new(25,1.5,25),48,12.5,-1,c[2],Enum.Material.Metal,false)
 for _,gx in ipairs({37,59}) do
  piece("Garage carport pillar",Vector3.new(1.4,11,1.4),gx,6,-11,c[2],Enum.Material.Metal,true)
 end
 local claimPad=piece("ClaimPad",Vector3.new(8,.4,8),-16,2.1,35,col(76,163,112),Enum.Material.Neon,false)
 local lockPad=piece("LockPad",Vector3.new(5,4,.8),22,5.5,25.6,col(212,177,79),Enum.Material.Metal,false)
 local function prompt(on,name,action)
  local q=Instance.new("ProximityPrompt")
  q.Name=name
  q.ActionText=action
  q.ObjectText="UAE Villa "..i
  q.MaxActivationDistance=12
  q.HoldDuration=.25
  q.RequiresLineOfSight=false
  q.Parent=on
 end
 prompt(claimPad,"ClaimHouse","Claim / release")
 prompt(door,"OpenDoor","Open / close")
 prompt(lockPad,"HomeLock","Lock / unlock")
 prompt(bed,"RestAtHome","Rest")
end
-- Switch out previous v5 HUD/camera only; do NOT delete missions, vehicles or city.
local scripts=SP:WaitForChild("StarterPlayerScripts")
for _,name in ipairs({
 "UAE_Phase5HUD","UAE_Phase5Camera","UAE_Phase51HUD","UAE_Phase51Camera",
 "UAE_Phase4HUD","UAE_Phase4Camera","UAE_VehicleCamera",
}) do
 local oldScript=scripts:FindFirstChild(name)
 if oldScript then oldScript:Destroy() end
end
local oldHomes=SS:FindFirstChild("UAE_Phase51Homes")
if oldHomes then oldHomes:Destroy() end
local function install(class,parent,name,source)
 local obj=Instance.new(class)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
end
install("LocalScript",scripts,"UAE_Phase51HUD",[========[
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
gui.Name="UAE_V51_HUD"
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
radar.Size=UDim2.fromOffset(116,116)
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
local mapCenter=Vector2.new(58,58)
local radius=51
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
me.Position=UDim2.fromOffset(58,58)
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
local plus=button(gui,"ZoomIn","+",UDim2.fromOffset(25,25),UDim2.fromOffset(138,22))
local minus=button(gui,"ZoomOut","−",UDim2.fromOffset(25,25),UDim2.fromOffset(138,51))
local fullMapButton=button(gui,"FullMapButton","MAP",UDim2.fromOffset(54,25),UDim2.fromOffset(12,132))
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
local zoomMin,zoomMax=.7,20
local scaleReadout=label(gui,"RadarZoomHint","MAP 2.7",
 UDim2.fromOffset(110,20),UDim2.fromOffset(12,161),10,cream)
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
 if mouse.X>=pos.X and mouse.X<=pos.X+116 and mouse.Y>=pos.Y and mouse.Y<=pos.Y+116 then
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
install("LocalScript",scripts,"UAE_Phase51Camera",[========[
-- UAE CITY LIFE v5.1: unified on-foot AND in-vehicle camera.
-- Mouse wheel or the +/- buttons zoom. Right-drag rotates. PageUp/Down change elevation.
-- Camera controls are on the RIGHT; minimap zoom buttons are on the LEFT.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local currentDistance=22
local yaw=0
local pitch=math.rad(18)
local rightHeld=false
local lastMode="OnFoot"
local cameraGui=Instance.new("ScreenGui")
cameraGui.Name="UAE_V51_CameraControls"
cameraGui.ResetOnSpawn=false
cameraGui.IgnoreGuiInset=false
cameraGui.DisplayOrder=35
cameraGui.Parent=player:WaitForChild("PlayerGui")
local function makeButton(name,text,y)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Size=UDim2.fromOffset(44,37)
 b.AnchorPoint=Vector2.new(1,0)
 b.Position=UDim2.new(1,-16,0,y)
 b.Text=text
 b.Font=Enum.Font.GothamBold
 b.TextSize=19
 b.TextColor3=Color3.fromRGB(248,240,213)
 b.BackgroundColor3=Color3.fromRGB(21,47,56)
 b.BackgroundTransparency=.08
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.ZIndex=4
 b.Parent=cameraGui
 local r=Instance.new("UICorner")
 r.CornerRadius=UDim.new(0,9)
 r.Parent=b
 return b
end
local plus=makeButton("CameraZoomIn","+ ",113)
local minus=makeButton("CameraZoomOut","−",157)
local up=makeButton("CameraUp","↑",209)
local down=makeButton("CameraDown","↓",253)
local indicator=Instance.new("TextLabel")
indicator.Name="CameraDistance"
indicator.Size=UDim2.fromOffset(87,25)
indicator.AnchorPoint=Vector2.new(1,0)
indicator.Position=UDim2.new(1,-10,0,298)
indicator.Font=Enum.Font.GothamBold
indicator.TextSize=11
indicator.TextColor3=Color3.fromRGB(252,243,218)
indicator.BackgroundColor3=Color3.fromRGB(23,48,58)
indicator.BackgroundTransparency=.17
indicator.Text="CAMERA 22"
indicator.Parent=cameraGui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,7)
corner.Parent=indicator
local function isDriving()
 local char=player.Character
 local hum=char and char:FindFirstChildOfClass("Humanoid")
 local seat=hum and hum.SeatPart
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local car=seat.Parent
  if car and car:IsA("Model") and car:GetAttribute("UAEVehicle")==true then
   return car,char,hum
  end
 end
 return nil,char,hum
end
local function limits()
 local car=isDriving()
 return car and 14 or 6,car and 100 or 80
end
local function zoomBy(factor)
 local near,far=limits()
 currentDistance=math.clamp(currentDistance*factor,near,far)
 indicator.Text=string.format("CAMERA %d",math.round(currentDistance))
end
plus.Activated:Connect(function() zoomBy(.77) end)
minus.Activated:Connect(function() zoomBy(1.30) end)
up.Activated:Connect(function() pitch=math.clamp(pitch+math.rad(10),math.rad(7),math.rad(73)) end)
down.Activated:Connect(function() pitch=math.clamp(pitch-math.rad(10),math.rad(7),math.rad(73)) end)
local function overMap()
 local gui=player.PlayerGui:FindFirstChild("UAE_V51_HUD") or player.PlayerGui:FindFirstChild("UAE_V5_HUD")
 if not gui then return false end
 local full=gui:FindFirstChild("ExpandedCityMap")
 if full and full.Visible then return true end
 local radar=gui:FindFirstChild("SmallRadar")
 if not radar then return false end
 local mouse=UIS:GetMouseLocation()
 local a=radar.AbsolutePosition
 local b=radar.AbsoluteSize
 return mouse.X>=a.X and mouse.X<=a.X+b.X and mouse.Y>=a.Y and mouse.Y<=a.Y+b.Y
end
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 and not overMap() then
  rightHeld=true
 end
 if processed then return end
 if input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(10),math.rad(7),math.rad(73))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(10),math.rad(7),math.rad(73))
 elseif input.KeyCode==Enum.KeyCode.C then
  currentDistance=22
  pitch=math.rad(18)
  yaw=0
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then rightHeld=false end
end)
UIS.InputChanged:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseWheel then
  if not overMap() then
   zoomBy(input.Position.Z>0 and .83 or 1.2)
  end
 elseif input.UserInputType==Enum.UserInputType.MouseMovement and rightHeld then
  yaw=yaw-input.Delta.X*.006
  pitch=math.clamp(pitch+input.Delta.Y*.004,math.rad(7),math.rad(73))
 end
end)
local wasActive=false
RunService:BindToRenderStep("UAE_Phase51UnifiedCamera",Enum.RenderPriority.Camera.Value+2,function(dt)
 local cam=workspace.CurrentCamera
 local car,char,hum=isDriving()
 local root=char and char:FindFirstChild("HumanoidRootPart")
 if not cam or not root then
  if wasActive and cam then
   cam.CameraType=Enum.CameraType.Custom
  end
  wasActive=false
  return
 end
 local mode=car and "Driving" or "OnFoot"
 if mode~=lastMode then
  currentDistance=car and 39 or 22
  pitch=math.rad(18)
  yaw=0
  lastMode=mode
 end
 local basis=car and car:GetPivot() or root.CFrame
 local vertical=car and 6.6 or 2.5
 local lookAt=(basis*CFrame.new(0,vertical,0)).Position
 local outward=basis*CFrame.Angles(0,yaw,0)
 local dist=math.max(currentDistance,6)
 local height=math.sin(pitch)*dist
 local behind=math.cos(pitch)*dist
 local wanted=(outward*CFrame.new(0,vertical+height,behind)).Position
 local direction=wanted-lookAt
 local params=RaycastParams.new()
 params.FilterType=Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances=car and {char,car} or {char}
 params.IgnoreWater=true
 local hit=workspace:Raycast(lookAt,direction,params)
 if hit then wanted=hit.Position-direction.Unit*1.1 end
 local desired=CFrame.lookAt(wanted,lookAt)
 cam.CameraType=Enum.CameraType.Scriptable
 cam.CFrame=cam.CFrame:Lerp(desired,wasActive and math.clamp(dt*9,0,1) or 1)
 cam.Focus=CFrame.new(lookAt)
 cam.FieldOfView=70
 wasActive=true
end)

]========])
install("Script",SS,"UAE_Phase51Homes",[========[
-- UAE CITY LIFE v5.1: server-controlled Brookhaven-style house roleplay.
-- Every user may keep their own Roblox avatar. Claims are per server/session.
-- Neither house ownership nor furnishings are saved across servers yet.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local homes=world:WaitForChild("Phase51_RoleplayHomes")
local catalog=homes:WaitForChild("Villas")
local ownedByUser={}
local function getCharacterRoot(player)
 local character=player.Character
 return character and character:FindFirstChild("HumanoidRootPart")
end
local function near(player,p,maxDistance)
 local root=getCharacterRoot(player)
 return root and (root.Position-p.Position).Magnitude <=maxDistance
end
local function setNotice(model,message)
 local status=model:FindFirstChild("StatusSign",true)
 local gui=status and status:FindFirstChildOfClass("SurfaceGui")
 local label=gui and gui:FindFirstChildOfClass("TextLabel")
 if label then label.Text=message end
end
local function resetHome(home)
 home:SetAttribute("OwnerUserId",0)
 home:SetAttribute("OwnerName","")
 home:SetAttribute("Locked",false)
 home:SetAttribute("DoorOpen",false)
 home:SetAttribute("DoorVersion",(home:GetAttribute("DoorVersion") or 0)+1)
 local door=home:FindFirstChild("FrontDoor")
 if door and door:IsA("BasePart") then
  door.CanCollide=true
  door.Transparency=.06
 end
 setNotice(home,home.Name.."\nAVAILABLE")
end
local function canUseDoor(player,home)
 local owner=home:GetAttribute("OwnerUserId") or 0
 local locked=home:GetAttribute("Locked")
 return not locked or owner==player.UserId
end
for _,home in ipairs(catalog:GetChildren()) do
 if home:IsA("Model") then
  resetHome(home)
  local claim=home:FindFirstChild("ClaimPad")
  local door=home:FindFirstChild("FrontDoor")
  local lock=home:FindFirstChild("LockPad")
  local bed=home:FindFirstChild("Bed")
  local claimPrompt=claim and claim:FindFirstChildOfClass("ProximityPrompt")
  local doorPrompt=door and door:FindFirstChildOfClass("ProximityPrompt")
  local lockPrompt=lock and lock:FindFirstChildOfClass("ProximityPrompt")
  local bedPrompt=bed and bed:FindFirstChildOfClass("ProximityPrompt")
  if claimPrompt then
   claimPrompt.Triggered:Connect(function(player)
    if not near(player,claim,15) then return end
    local owner=home:GetAttribute("OwnerUserId") or 0
    if owner==player.UserId then
     ownedByUser[player.UserId]=nil
     resetHome(home)
     return
    end
    if owner~=0 then return end
    local previous=ownedByUser[player.UserId]
    if previous and previous.Parent then resetHome(previous) end
    ownedByUser[player.UserId]=home
    home:SetAttribute("OwnerUserId",player.UserId)
    home:SetAttribute("OwnerName",player.DisplayName)
    home:SetAttribute("Locked",false)
    setNotice(home,home.Name.."\n"..player.DisplayName.."'s home")
   end)
  end
  if doorPrompt then
   doorPrompt.Triggered:Connect(function(player)
    if not near(player,door,15) or not canUseDoor(player,home) then return end
    local newState=not home:GetAttribute("DoorOpen")
    home:SetAttribute("DoorOpen",newState)
    door.CanCollide=not newState
    door.Transparency=newState and .76 or .06
    home:SetAttribute("DoorVersion",(home:GetAttribute("DoorVersion") or 0)+1)
    local version=home:GetAttribute("DoorVersion")
    if newState then
     task.delay(9,function()
      if home.Parent and home:GetAttribute("DoorVersion")==version then
       home:SetAttribute("DoorOpen",false)
       door.CanCollide=true
       door.Transparency=.06
      end
     end)
    end
   end)
  end
  if lockPrompt then
   lockPrompt.Triggered:Connect(function(player)
    if not near(player,lock,15) then return end
    if home:GetAttribute("OwnerUserId")~=player.UserId then return end
    local locked=not home:GetAttribute("Locked")
    home:SetAttribute("Locked",locked)
    setNotice(home,home.Name.."\n"..player.DisplayName..(locked and " • LOCKED" or " • OPEN"))
   end)
  end
  if bedPrompt then
   bedPrompt.Triggered:Connect(function(player)
    if not near(player,bed,15) or not canUseDoor(player,home) then return end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health>0 then
     hum.Health=math.min(hum.MaxHealth,hum.Health+25)
    end
   end)
  end
 end
end
Players.PlayerRemoving:Connect(function(player)
 local home=ownedByUser[player.UserId]
 if home and home.Parent then resetHome(home) end
 ownedByUser[player.UserId]=nil
end)

]========])
print("UAE City Life v5.1 patch installed: camera zoom both on foot & in car, smaller minimap, 4 interactive claimable Dubai villas.")
