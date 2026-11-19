-- UAE CITY LIFE 5.4: integrated map, mission browser and objective guidance.
-- "Map" is a schematic of this ROBLOX GAME, not real Dubai GPS geography.
-- Replaces UAE_V52_HUD (not the camera or CITY / JOBS menus).
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local all=locations.List
local byId=locations.ById
local missions={
 {id="MEDIC",name="Ambulance Assistance",reward=110},
 {id="POLICE",name="Dubai Police Community Patrol",reward=120},
 {id="FIRE",name="Civil Defence Safety Inspection",reward=120},
 {id="AIRPORT",name="Dubai Airport Shuttle",reward=120},
 {id="SIGHTS",name="Dubai Landmark Photo Trail",reward=160},
 {id="MARINA",name="Marina Safety Volunteer",reward=110},
 {id="DELIVERY",name="Karak & Grocery Delivery",reward=90},
 {id="METRO",name="Public Transport Explorer",reward=140},
 {id="HEALTH",name="Dubai Healthcare Checkup",reward=100},
 {id="CLEANUP",name="Community Park Volunteer",reward=90},
}
local request=RS:WaitForChild("UAE_V54_MissionRequest",25)
local updates=RS:WaitForChild("UAE_V54_MissionUpdate",25)
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V54_CityGuide"
gui.ResetOnSpawn=false
gui.DisplayOrder=27
gui.IgnoreGuiInset=false
gui.Parent=player:WaitForChild("PlayerGui")
local C={
 navy=Color3.fromRGB(17,41,53),
 dark=Color3.fromRGB(30,66,77),
 sand=Color3.fromRGB(245,225,188),
 white=Color3.fromRGB(240,245,242),
 teal=Color3.fromRGB(62,151,163),
 gold=Color3.fromRGB(240,192,103),
 grass=Color3.fromRGB(65,111,93),
 sea=Color3.fromRGB(34,106,142),
 road=Color3.fromRGB(217,207,170),
 red=Color3.fromRGB(232,81,75),
}
local function round(obj,pixels)
 local u=Instance.new("UICorner")
 u.CornerRadius=UDim.new(0,pixels or 8)
 u.Parent=obj
end
local function stroke(obj,tint,w)
 local s=Instance.new("UIStroke")
 s.Color=tint
 s.Thickness=w or 1.1
 s.Parent=obj
end
local function frame(parent,name,pos,size,color,z)
 local f=Instance.new("Frame")
 f.Name=name
 f.Position=pos
 f.Size=size
 f.BackgroundColor3=color or C.navy
 f.BorderSizePixel=0
 f.ZIndex=z or 20
 f.Parent=parent
 return f
end
local function text(parent,name,caption,pos,size,fontSize,color,z)
 local l=Instance.new("TextLabel")
 l.Name=name
 l.Text=caption
 l.Position=pos
 l.Size=size
 l.BackgroundTransparency=1
 l.TextColor3=color or C.sand
 l.TextSize=fontSize or 12
 l.Font=Enum.Font.GothamSemibold
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.TextWrapped=true
 l.ZIndex=z or 22
 l.Parent=parent
 return l
end
local function button(parent,name,caption,pos,size,color,z)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Text=caption
 b.Position=pos
 b.Size=size
 b.BackgroundColor3=color or C.dark
 b.TextColor3=C.white
 b.TextSize=12
 b.Font=Enum.Font.GothamBold
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.ZIndex=z or 22
 b.Parent=parent
 round(b,7)
 return b
end
local function mapColor(cat)
 if cat=="Landmarks" then return C.gold end
 if cat=="Transport" then return C.teal end
 if cat=="Services" then return Color3.fromRGB(240,116,108) end
 if cat=="Shopping" then return Color3.fromRGB(179,160,229) end
 if cat=="Living" then return Color3.fromRGB(200,228,175) end
 return C.sand
end
-- Compact radar stays in top-left and never covers the game world.
local radar=frame(gui,"CircularRadar",UDim2.fromOffset(12,48),
 UDim2.fromOffset(100,100),C.dark,20)
round(radar,50)
stroke(radar,C.gold,2)
local miniMe=frame(radar,"You",UDim2.fromOffset(46,46),UDim2.fromOffset(8,8),C.red,24)
round(miniMe,6)
local miniNorth=text(radar,"North","N",UDim2.fromOffset(45,4),UDim2.fromOffset(12,15),11,C.sand,23)
local miniTarget=frame(radar,"DestinationPin",UDim2.fromOffset(45,5),
 UDim2.fromOffset(9,9),C.gold,24)
round(miniTarget,5)
miniTarget.Visible=false
local radarOpen=button(gui,"OpenCityMap","MAP / M",UDim2.fromOffset(12,152),
 UDim2.fromOffset(100,25),C.navy,24)
local clickRadar=button(radar,"OpenByClickingRadar","",
 UDim2.fromScale(0,0),UDim2.fromScale(1,1),C.dark,26)
clickRadar.BackgroundTransparency=1
local clock=frame(gui,"DubaiClock",UDim2.new(1,-183,0,13),
 UDim2.fromOffset(171,37),C.navy,24)
round(clock,8)
local liveClock=text(clock,"DubaiTime","DUBAI --:-- GST",UDim2.fromOffset(7,3),
 UDim2.fromOffset(155,16),11,C.gold,25)
local dayNight=text(clock,"DayNight","GAME --:--  •  DAY",UDim2.fromOffset(7,20),
 UDim2.fromOffset(155,14),10,C.white,25)
local guideStatus=frame(gui,"RouteStatus",UDim2.new(0,12,1,-53),
 UDim2.fromOffset(265,41),C.navy,24)
round(guideStatus,9)
local guideText=text(guideStatus,"DestinationStatus","MAP: Select a destination to navigate",
 UDim2.fromOffset(8,4),UDim2.new(1,-16,1,-8),11,C.sand,25)
local missionQuick=button(gui,"MissionQuick","MISSIONS",UDim2.new(1,-85,1,-190),
 UDim2.fromOffset(72,36),C.dark,26)
-- Major map panel. It is used on demand, never permanently overlays the game.
local panel=frame(gui,"CityAtlas",UDim2.fromScale(.5,.5),
 UDim2.new(.91,0,.84,0),C.navy,50)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Visible=false
round(panel,12)
stroke(panel,C.gold,1.5)
local limit=Instance.new("UISizeConstraint")
limit.MaxSize=Vector2.new(1010,660)
limit.MinSize=Vector2.new(340,290)
limit.Parent=panel
local header=text(panel,"Title","DUBAI CITY ATLAS",
 UDim2.fromOffset(13,7),UDim2.new(.43,0,0,27),17,C.gold,51)
local close=button(panel,"Close","✕",UDim2.new(1,-43,0,8),
 UDim2.fromOffset(31,27),Color3.fromRGB(118,71,76),53)
local search=Instance.new("TextBox")
search.Name="SearchDestinations"
search.PlaceholderText="Find a place..."
search.Text=""
search.ClearTextOnFocus=false
search.Position=UDim2.new(.47,0,0,8)
search.Size=UDim2.new(.47,-43,0,27)
search.Font=Enum.Font.GothamMedium
search.TextSize=12
search.TextColor3=C.navy
search.BackgroundColor3=C.white
search.ZIndex=53
search.Parent=panel
round(search,7)
local tabRow=frame(panel,"CategoryBar",UDim2.fromOffset(11,44),
 UDim2.new(1,-22,0,36),C.navy,51)
tabRow.BackgroundTransparency=1
local listArea=frame(panel,"Sidebar",UDim2.fromOffset(11,85),
 UDim2.new(.35,-13,1,-134),C.dark,52)
round(listArea,7)
local infoHeader=text(listArea,"ListHeading","DESTINATIONS",UDim2.fromOffset(9,4),
 UDim2.new(1,-18,0,23),12,C.gold,54)
local listing=Instance.new("ScrollingFrame")
listing.Name="DestinationsAndMissions"
listing.Position=UDim2.fromOffset(5,29)
listing.Size=UDim2.new(1,-10,1,-34)
listing.BackgroundTransparency=1
listing.ScrollBarThickness=4
listing.ScrollBarImageColor3=C.gold
listing.BorderSizePixel=0
listing.ZIndex=55
listing.CanvasSize=UDim2.fromOffset(0,1000)
listing.Parent=listArea
local map=frame(panel,"SchematicMap",UDim2.new(.35,7,0,85),
 UDim2.new(.65,-20,1,-134),C.grass,52)
round(map,7)
map.ClipsDescendants=true
local water=frame(map,"GulfCoast",UDim2.new(.79,0,0,0),
 UDim2.new(.21,0,1,0),C.sea,53)
water.BackgroundTransparency=.05
local mapNote=text(map,"MapLegend","IN-GAME MAP  •  SELECT A DOT",UDim2.fromOffset(9,5),
 UDim2.new(1,-18,0,17),10,C.white,61)
local mapFooter=text(panel,"Footer","Red = your location • Gold = selected • Map shows in-game distances",
 UDim2.new(0,13,1,-43),UDim2.new(1,-24,0,22),11,C.sand,54)
local confirm=button(panel,"KeepWaypoint","KEEP GPS",UDim2.new(1,-100,1,-41),
 UDim2.fromOffset(85,26),C.teal,55)
local roads={
 {-1500,-1130,1400,-1130}, {-1500,-1200,1400,-1200},
 {-1500,-1280,1400,-1280}, {-900,-985,850,-985},
 {-500,-780,-500,750},{-390,-800,-390,750},
 {0,-1450,0,810},{390,-800,390,800},{-990,30,1000,30},
 {-990,-235,1000,-235},{-990,470,1000,470},
 {-940,-920,-940,-440},{-975,-710,-905,-710},
 {-460,-715,460,-715},{-460,-665,460,-665},
}
local roadFrames={}
for i=1,#roads do
 roadFrames[i]=frame(map,"Road"..i,UDim2.fromOffset(0,0),
  UDim2.fromOffset(10,2),C.road,54)
 roadFrames[i].AnchorPoint=Vector2.new(0,.5)
end
local pinWidgets={}
for _,loc in ipairs(all) do
 local pin=button(map,"Pin_"..loc.id,"●",UDim2.fromOffset(0,0),
  UDim2.fromOffset(14,14),mapColor(loc.category),57)
 pin.TextColor3=C.navy
 pin.TextSize=15
 pin.AnchorPoint=Vector2.new(.5,.5)
 round(pin,7)
 pinWidgets[loc.id]=pin
end
local you=frame(map,"YouAreHere",UDim2.fromOffset(0,0),
 UDim2.fromOffset(12,12),C.red,59)
you.AnchorPoint=Vector2.new(.5,.5)
round(you,7)
stroke(you,C.white,1)
local route=frame(map,"StraightLineGuide",UDim2.fromOffset(0,0),
 UDim2.fromOffset(10,3),C.gold,56)
route.AnchorPoint=Vector2.new(0,.5)
route.Visible=false
local selectedLabel=text(map,"SelectedPinLabel","",UDim2.fromOffset(0,0),
 UDim2.fromOffset(180,22),10,C.gold,59)
selectedLabel.TextXAlignment=Enum.TextXAlignment.Center
selectedLabel.BackgroundColor3=C.navy
selectedLabel.BackgroundTransparency=.05
round(selectedLabel,6)
selectedLabel.Visible=false
local bounds=locations.Bounds
local function normalized(x,z)
 return (x-bounds.xmin)/(bounds.xmax-bounds.xmin),
  (z-bounds.zmin)/(bounds.zmax-bounds.zmin)
end
local function mapPoint(x,z)
 local nx,nz=normalized(x,z)
 return Vector2.new(nx*map.AbsoluteSize.X,nz*map.AbsoluteSize.Y)
end
local function paintLine(obj,a,b,thick)
 local dir=b-a
 local length=dir.Magnitude
 if length<1 then obj.Visible=false return end
 obj.Visible=true
 obj.Position=UDim2.fromOffset(a.X,a.Y)
 obj.Size=UDim2.fromOffset(length,thick)
 obj.Rotation=math.deg(math.atan2(dir.Y,dir.X))
end
local currentPage="Places"
local currentCategory="All"
local manualId=nil
local missionId=nil
local missionTitle=nil
local missionStep=0
local jobWaypoint=nil
local lastStatus=""
local selectionStatus=""
local function activeDestination()
 if missionId and byId[missionId] then return byId[missionId] end
 if jobWaypoint then return jobWaypoint end
 return manualId and byId[manualId] or nil
end
local function selectId(id)
 if not byId[id] then return end
 manualId=id
 selectionStatus=byId[id].name
 if not missionId and not jobWaypoint then lastStatus="GPS: "..selectionStatus end
end
local missionButtons={}
local navButtons={}
local function clearRows()
 for _,widget in ipairs(navButtons) do widget:Destroy() end
 navButtons={}
end
local function listButton(txt,extra,y,callback)
 local b=button(listing,"Entry","",UDim2.fromOffset(4,y),
  UDim2.new(1,-12,0,43),C.navy,56)
 b.Text=""
 local name=text(b,"Name",txt,UDim2.fromOffset(8,3),
  UDim2.new(1,-16,0,19),12,C.sand,57)
 local sub=text(b,"Sub",extra,UDim2.fromOffset(8,22),
  UDim2.new(1,-16,0,16),10,C.white,57)
 b.Activated:Connect(callback)
 navButtons[#navButtons+1]=b
end
local function updateList()
 clearRows()
 local searchWord=string.lower(search.Text)
 local y=0
 if currentPage=="Missions" then
  infoHeader.Text="CITY MISSIONS"
  for _,m in ipairs(missions) do
   if searchWord=="" or string.find(string.lower(m.name),searchWord,1,true) then
    listButton(m.name,"+"..m.reward.." CityPoints  •  Start shift",y,function()
     if request then request:FireServer("Start",m.id) end
     panel.Visible=false
    end)
    y=y+47
   end
  end
 else
  infoHeader.Text=currentCategory=="All" and "ALL DESTINATIONS" or string.upper(currentCategory)
  for _,loc in ipairs(all) do
   local visible=currentCategory=="All" or loc.category==currentCategory
   local textMatch=searchWord=="" or
    string.find(string.lower(loc.name),searchWord,1,true) or
    string.find(string.lower(loc.description),searchWord,1,true)
   if visible and textMatch then
    listButton(loc.name,loc.category.." • "..loc.description,y,function()
     selectId(loc.id)
     panel.Visible=false
    end)
    y=y+47
   end
  end
 end
 if y==0 then
  listButton("No results","Try another search or category.",0,function() end)
  y=49
 end
 listing.CanvasSize=UDim2.fromOffset(0,y+6)
end
local function setCategory(cat)
 currentCategory=cat
 currentPage="Places"
 search.Text=""
 updateList()
end
for i,name in ipairs({"All","Landmarks","Services","Transport","Shopping","Living","Leisure","Missions"}) do
 local b=button(tabRow,"Tab_"..name,name,
  UDim2.new((i-1)/8,1,0,2),UDim2.new(1/8,-3,0,29),
  name=="Missions" and C.teal or C.dark,53)
 b.TextSize=9
 b.Activated:Connect(function()
  if name=="Missions" then
   currentPage="Missions"
   search.Text=""
   updateList()
  else
   setCategory(name)
  end
 end)
end
search:GetPropertyChangedSignal("Text"):Connect(updateList)
for _,loc in ipairs(all) do
 pinWidgets[loc.id].Activated:Connect(function()
  selectId(loc.id)
 end)
end
local function showPage(page)
 currentPage=page or "Places"
 panel.Visible=true
 updateList()
end
local function toggleMap()
 if panel.Visible then
  panel.Visible=false
 else
  showPage("Places")
 end
end
radarOpen.Activated:Connect(toggleMap)
clickRadar.Activated:Connect(toggleMap)
missionQuick.Activated:Connect(function()
 if panel.Visible and currentPage=="Missions" then panel.Visible=false
 else showPage("Missions") end
end)
close.Activated:Connect(function() panel.Visible=false end)
confirm.Activated:Connect(function() panel.Visible=false end)
UIS.InputBegan:Connect(function(input,processed)
 if processed or UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.M then toggleMap()
 elseif input.KeyCode==Enum.KeyCode.K then
  if panel.Visible and currentPage=="Missions" then panel.Visible=false
  else showPage("Missions") end
 end
end)
if updates then
 updates.OnClientEvent:Connect(function(data)
  if typeof(data)~="table" then return end
  if data.state=="active" and typeof(data.destinationId)=="string" and byId[data.destinationId] then
   missionId=data.destinationId
   missionTitle=data.title
   missionStep=data.stage
   selectionStatus=data.destinationName
   lastStatus=data.message or "Next mission destination"
  elseif data.state=="complete" or data.state=="cancelled" then
   missionId=nil
   missionTitle=nil
   lastStatus=data.message or "Mission ended"
  end
 end)
end
local olderJobs=RS:FindFirstChild("UAE_V53_JobUpdate")
if olderJobs then
 olderJobs.OnClientEvent:Connect(function(msg)
  if typeof(msg)~="table" then return end
  if msg.kind=="progress" and typeof(msg.position)=="Vector3" then
   jobWaypoint={name=msg.label or "Job destination",position=msg.position}
  elseif msg.kind=="cancelled" or msg.kind=="completed" then
   jobWaypoint=nil
  end
 end)
end
local legacy=RS:FindFirstChild("UAE_MissionUpdate")
if legacy then
 legacy.OnClientEvent:Connect(function(message)
  if typeof(message)=="string" and #message<200 and not missionId then
   lastStatus=message
  end
 end)
end
local function drawMap(playerPos)
 local w,h=map.AbsoluteSize.X,map.AbsoluteSize.Y
 if w<80 or h<80 then return end
 for i,r in ipairs(roads) do
  paintLine(roadFrames[i],mapPoint(r[1],r[2]),mapPoint(r[3],r[4]),2.7)
 end
 for _,loc in ipairs(all) do
  pinWidgets[loc.id].Position=UDim2.fromOffset(
   mapPoint(loc.position.X,loc.position.Z).X,
   mapPoint(loc.position.X,loc.position.Z).Y)
 end
 you.Position=UDim2.fromOffset(mapPoint(playerPos.X,playerPos.Z).X,
  mapPoint(playerPos.X,playerPos.Z).Y)
 local target=activeDestination()
 if target then
  local from=mapPoint(playerPos.X,playerPos.Z)
  local to=mapPoint(target.position.X,target.position.Z)
  paintLine(route,from,to,3)
  local x=math.clamp(to.X-90,2,w-185)
  local y=math.clamp(to.Y-26,19,h-25)
  selectedLabel.Position=UDim2.fromOffset(x,y)
  selectedLabel.Text=target.name
  selectedLabel.Visible=true
 else
  route.Visible=false
  selectedLabel.Visible=false
 end
end
-- One client-only GPS beacon makes the selected destination visible in 3D.
local gpsAnchor=Instance.new("Part")
gpsAnchor.Name="UAE_V54_LocalGPSDestination"
gpsAnchor.Anchored=true
gpsAnchor.CanCollide=false
gpsAnchor.CanTouch=false
gpsAnchor.CanQuery=false
gpsAnchor.Size=Vector3.new(.2,.2,.2)
gpsAnchor.Transparency=1
gpsAnchor.Parent=workspace
local gpsBillboard=Instance.new("BillboardGui")
gpsBillboard.Name="WaypointBeacon"
gpsBillboard.Adornee=gpsAnchor
gpsBillboard.AlwaysOnTop=true
gpsBillboard.Size=UDim2.fromOffset(154,42)
gpsBillboard.MaxDistance=450
gpsBillboard.StudsOffsetWorldSpace=Vector3.new(0,6,0)
gpsBillboard.Enabled=false
gpsBillboard.Parent=gpsAnchor
local worldLabel=text(gpsBillboard,"DestinationLabel","GPS DESTINATION",
 UDim2.fromScale(0,0),UDim2.fromScale(1,1),13,C.gold,1)
worldLabel.TextXAlignment=Enum.TextXAlignment.Center
worldLabel.BackgroundColor3=C.navy
worldLabel.BackgroundTransparency=.08
round(worldLabel,8)
local function updateRadarAndText(root)
 local target=activeDestination()
 if target then
  gpsAnchor.CFrame=CFrame.new(target.position+Vector3.new(0,7,0))
  worldLabel.Text=target.name
  gpsBillboard.Enabled=true
 else
  gpsBillboard.Enabled=false
 end
 if not root then
  miniTarget.Visible=false
  return
 end
 local pt=root.Position
 if target then
  local dv=Vector2.new(target.position.X-pt.X,target.position.Z-pt.Z)
  local d=dv.Magnitude
  local capped=d>1 and dv.Unit*math.min(d/15,37) or Vector2.zero
  miniTarget.Position=UDim2.fromOffset(50+capped.X-4,50+capped.Y-4)
  miniTarget.Visible=true
  local look=Vector2.new(root.CFrame.LookVector.X,root.CFrame.LookVector.Z)
  local message="Ahead"
  if look.Magnitude>.1 and d>2 then
   local dir=dv.Unit
   local theta=math.deg(math.atan2(look.X*dir.Y-look.Y*dir.X,look:Dot(dir)))
   if math.abs(theta)>40 then
    message=theta>0 and "Turn right" or "Turn left"
   end
  end
  guideText.Text=string.format("GPS • %s\n%d studs • %s",target.name,math.floor(d),message)
 else
  miniTarget.Visible=false
  guideText.Text=(lastStatus~="" and lastStatus or "MAP: choose a destination")
 end
end
task.spawn(function()
 local ticked=0
 while gui.Parent do
  task.wait(.3)
  local char=player.Character
  local root=char and char:FindFirstChild("HumanoidRootPart")
  updateRadarAndText(root)
  if panel.Visible and root then drawMap(root.Position) end
  liveClock.Text="DUBAI  "..os.date("!%H:%M",os.time()+4*3600).." GST"
  local hour=RS:GetAttribute("UAECycleHour")
  if typeof(hour)=="number" then
   dayNight.Text=string.format("GAME %02d:%02d  •  %s",math.floor(hour)%24,
    math.floor((hour%1)*60),(hour>=6 and hour<18) and "DAY" or "NIGHT")
  end
 end
end)
updateList()
task.delay(4,function()
 if request then request:FireServer("Status","CURRENT") end
end)
print("[UAE v5.4] City Atlas started; 32 destinations, GPS guide and 10 missions")
