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
