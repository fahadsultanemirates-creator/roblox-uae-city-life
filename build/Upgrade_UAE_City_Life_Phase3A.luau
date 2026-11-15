-- ROBLOX UAE CITY LIFE: PHASE 3A UPGRADE
-- Run ONCE inside Roblox Studio Command Bar in Edit mode, after Phase 2.
-- Re-running safely replaces only Phase3_LivingCity, UAE_Phase3_Animation and UAE_MinimapAndMission.
local Workspace=game:GetService("Workspace")
local ServerScriptService=game:GetService("ServerScriptService")
local StarterPlayer=game:GetService("StarterPlayer")
local world=Workspace:FindFirstChild("UAE_City_Life")
assert(world,"Missing UAE_City_Life! First run the Phase 1 generator and Phase 2 upgrade in Edit mode.")
local old=world:FindFirstChild("Phase3_LivingCity")
if old then old:Destroy() end
local root=Instance.new("Folder")
root.Name="Phase3_LivingCity"
root.Parent=world
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local WHITE=rgb(254,249,238)
local ASPHALT=rgb(49,54,61)
local SILVER=rgb(139,153,166)
local SAND=rgb(214,196,157)
local BLUE=rgb(29,142,190)
local GOLD=rgb(240,195,94)
local EMERALD=rgb(10,105,74)
local function folder(name)
 local f=Instance.new("Folder")
 f.Name=name
 f.Parent=root
 return f
end
local function makePart(parent,name,size,cf,col,material,collision)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=size
 p.CFrame=cf
 p.Anchored=true
 p.CanCollide=collision==true
 p.Color=col or WHITE
 p.Material=material or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function textOnFace(part,caption,side,fontColor)
 local g=Instance.new("SurfaceGui")
 g.Name="UAE Arabic Marking"
 g.Face=side
 g.PixelsPerStud=80
 g.CanvasSize=Vector2.new(512,256)
 g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
 g.LightInfluence=0
 g.AlwaysOnTop=false
 g.Parent=part
 local label=Instance.new("TextLabel")
 label.Name="Arabic text"
 label.Size=UDim2.fromScale(1,1)
 label.BackgroundTransparency=1
 label.Text=caption
 label.TextColor3=fontColor or WHITE
 label.TextScaled=true
 label.TextWrapped=true
 label.Font=Enum.Font.GothamBold
 label.Parent=g
end
local emergency=world:FindFirstChild("EmergencyVehicles")
assert(emergency,"EmergencyVehicles folder is missing. Keep the Phase 1 game map loaded.")
local police=emergency:FindFirstChild("Green Police SUV")
local ambulance=emergency:FindFirstChild("Blue White Ambulance")
local fire=emergency:FindFirstChild("Yellow Civil Defence Truck")
local function clearOldMarkings(model)
 if not model then return end
 for _,d in ipairs(model:GetDescendants()) do
  if d:IsA("SurfaceGui") and d.Name=="UAE Arabic Marking" then d:Destroy() end
 end
end
for _,car in ipairs({police,ambulance,fire}) do clearOldMarkings(car) end
-- Police: WHITE Arabic lettering on DARK GREEN door panels, requested exactly.
if police then
 for _,p in ipairs(police:GetChildren()) do
  if p:IsA("BasePart") and p.Name=="Dark green doors" then
   local face=p.Position.X>police:GetPivot().Position.X and Enum.NormalId.Right or Enum.NormalId.Left
   textOnFace(p,"الشرطة",face,WHITE)
  end
 end
end
-- Ambulance: Arabic on the blue lower body, facing both sides.
if ambulance then
 local blueBody=ambulance:FindFirstChild("Ambulance blue lower side")
 if blueBody and blueBody:IsA("BasePart") then
  textOnFace(blueBody,"الإسعاف",Enum.NormalId.Right,WHITE)
  textOnFace(blueBody,"الإسعاف",Enum.NormalId.Left,WHITE)
 end
end
-- Civil Defence: bright yellow side markers with Arabic captions.
if fire then
 for _,side in ipairs({-1,1}) do
  local carCf=fire.PrimaryPart and fire.PrimaryPart.CFrame or fire:GetPivot()
  local plaque=makePart(fire,"Civil Defence Arabic panel",
   Vector3.new(.4,2.15,12),carCf*CFrame.new(side*5.65,5.2,5),rgb(245,203,35),nil,false)
  textOnFace(plaque,"الدفاع المدني",side>0 and Enum.NormalId.Right or Enum.NormalId.Left,rgb(24,49,58))
 end
end

local trafficFolder=folder("AmbientTraffic")
local palette={
 {name="Dubai Cream Taxi",route="HighwaySouth",idx=3,x=0,z=30,col=rgb(234,202,135),roof=rgb(229,236,230),speed=15},
 {name="Dubai Maroon Taxi",route="HighwaySouth",idx=8,x=0,z=70,col=rgb(132,47,67),roof=WHITE,speed=13},
 {name="Family White Sedan",route="Downtown",idx=3,x=0,z=-235,col=WHITE,roof=SILVER,speed=15},
 {name="City Black Sedan",route="Downtown",idx=8,x=0,z=-207,col=rgb(40,51,65),roof=rgb(57,86,97),speed=12},
 {name="UAE City Bus",route="West",idx=3,x=-390,z=30,col=rgb(43,157,164),roof=WHITE,speed=12,bus=true},
 {name="Silver Street SUV",route="East",idx=3,x=390,z=30,col=rgb(179,184,182),roof=WHITE,speed=15},
}
local function trafficCar(d)
 local model=Instance.new("Model")
 model.Name=d.name
 model:SetAttribute("RouteName",d.route)
 model:SetAttribute("Waypoint",d.idx)
 model:SetAttribute("Speed",d.speed)
 model.Parent=trafficFolder
 local base=CFrame.new(d.x,0,d.z)
 local length=d.bus and 26 or 16
 local bodyY=d.bus and 5.8 or 4
 local height=d.bus and 6.1 or 3.2
 local rootPart=makePart(model,"Pivot",Vector3.new(.3,.3,.3),base,WHITE,nil,false)
 rootPart.Transparency=1
 model.PrimaryPart=rootPart
 local function p(name,dim,x,y,z,tint,material)
  return makePart(model,name,dim,base*CFrame.new(x,y,z),tint,material,false)
 end
 p("Vehicle body",Vector3.new(9,height,length),0,bodyY,0,d.col,Enum.Material.Metal)
 p("Vehicle roof",Vector3.new(8.4,.75,length*.65),0,bodyY+height/2+.55,1,d.roof,Enum.Material.Metal)
 p("Windscreen",Vector3.new(7.2,2.6,.45),0,bodyY+height/2-.65,-length/2+.5,BLUE,Enum.Material.Glass)
 for _,side in ipairs({-1,1}) do
  for _,z in ipairs({-length*.31,length*.29}) do
   local wheel=p("Tyre",Vector3.new(2.4,4,4),side*4.5,2.6,z,rgb(27,30,32),Enum.Material.Rubber)
   wheel.Shape=Enum.PartType.Cylinder
  end
  p("Headlight",Vector3.new(2,.9,.4),side*2.9,bodyY-.7,-length/2-.2,GOLD,Enum.Material.Neon)
  p("Rear lamp",Vector3.new(2,.7,.4),side*2.9,bodyY-.7,length/2+.2,rgb(211,48,49),Enum.Material.Neon)
 end
 if d.name:find("Taxi") then
  p("TAXI roof light",Vector3.new(3,1.3,3),0,bodyY+height/2+1.3,0,GOLD,Enum.Material.Neon)
 end
 return model
end
for _,d in ipairs(palette) do trafficCar(d) end

-- Low-poly pedestrians for city atmosphere: decorative visual walkers, no physics/AI.
local npcFolder=folder("AmbientPedestrians")
local outfits={
 {label="Resident in blue",c=rgb(32,116,169)},
 {label="Resident in white",c=WHITE},
 {label="Resident in maroon",c=rgb(136,60,75)},
 {label="Resident in yellow",c=rgb(217,168,75)},
}
for i,d in ipairs(outfits) do
 local points={{-75,132},{75,132},{75,166},{-75,166}}
 local x,z=points[i][1],points[i][2]
 local base=CFrame.new(x,0,z)
 local m=Instance.new("Model")
 m.Name=d.label
 m:SetAttribute("Waypoint",i)
 m:SetAttribute("Speed",2.5+(i%3))
 m.Parent=npcFolder
 local anchor=makePart(m,"Pivot",Vector3.new(.2,.2,.2),base,WHITE,nil,false)
 anchor.Transparency=1
 m.PrimaryPart=anchor
 makePart(m,"Torso",Vector3.new(3.2,4.2,1.8),base*CFrame.new(0,5,0),d.c,nil,false)
 local head=makePart(m,"Head",Vector3.new(2.3,2.3,2.3),base*CFrame.new(0,8.2,0),rgb(204,164,123),nil,false)
 head.Shape=Enum.PartType.Ball
 for _,side in ipairs({-1,1}) do
  makePart(m,"Arm",Vector3.new(.8,3.9,.9),base*CFrame.new(side*2.1,4.7,0),rgb(205,165,127),nil,false)
  makePart(m,"Leg",Vector3.new(1.1,3.1,1.2),base*CFrame.new(side*.8,1.6,0),rgb(53,69,85),nil,false)
 end
end

local streets=folder("ShopsAndStreetDetails")
local function shop(name,x,z,tint)
 local base=CFrame.new(x,0,z)
 makePart(streets,name.." shopfront",Vector3.new(46,18,29),base*CFrame.new(0,9,0),tint,Enum.Material.Concrete,true)
 makePart(streets,"Glass storefront",Vector3.new(38,10,1),base*CFrame.new(0,7,15),BLUE,Enum.Material.Glass,false)
 makePart(streets,"Shop awning",Vector3.new(46,2,7),base*CFrame.new(0,13,17),GOLD,Enum.Material.Metal,false)
 local panel=makePart(streets,"Store sign",Vector3.new(31,4,.5),base*CFrame.new(0,16,15.9),rgb(31,67,70),Enum.Material.SmoothPlastic,false)
 textOnFace(panel,name,Enum.NormalId.Front,WHITE)
end
shop("UAE CAFE",-181,270,rgb(224,196,166))
shop("CITY MARKET",80,290,rgb(208,214,204))
shop("BOOKS & GIFTS",-555,195,rgb(218,210,192))
-- Streetside benches, planted gardens and LED public signs
for _,x in ipairs({-135,-91,-48,50,106,149}) do
 makePart(streets,"Pedestrian bench",Vector3.new(11,1.2,3.6),
  CFrame.new(x,1.9,207),rgb(130,94,65),Enum.Material.Wood,false)
end
local crossing=folder("PedestrianCrossings")
for x=-40,40,8 do
 makePart(crossing,"Crosswalk stripe",Vector3.new(3,.12,11),
  CFrame.new(x,.42,30),WHITE,Enum.Material.SmoothPlastic,false)
end
for _,x in ipairs({-80,80}) do
 local pole=makePart(streets,"Traffic signal post",Vector3.new(1,15,1),
  CFrame.new(x,7.5,5),SILVER,Enum.Material.Metal,false)
 local light=makePart(streets,"Traffic signal panel",Vector3.new(2.5,6,2),
  CFrame.new(x,14.5,5),rgb(36,49,53),nil,false)
 for _,t in ipairs({{1.7,rgb(214,63,55)},{0,rgb(247,206,55)},{-1.7,rgb(47,190,120)}}) do
  local bulb=makePart(streets,"LED light",Vector3.new(1,1,.5),
   CFrame.new(x,14.5+t[1],3.7),t[2],Enum.Material.Neon,false)
  bulb.Shape=Enum.PartType.Ball
 end
end

-- Install runtime scripts without altering Phase 1/2 scripts.
local function install(class,parent,name,source)
 local prev=parent:FindFirstChild(name)
 if prev then prev:Destroy() end
 local script=Instance.new(class)
 script.Name=name
 script.Source=source
 script.Parent=parent
end
install("LocalScript",StarterPlayer.StarterPlayerScripts,"UAE_MinimapAndMission",[========[
-- Roblox UAE – City Life | Phase 3A schematic minimap + first exploration mission
-- Lightweight, camera independent, no imported textures. M toggles the map.
-- Coordinates represent the game prototype's districts; not a geographic map of UAE.
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAE_MinimapAndMission"
gui.ResetOnSpawn=false
gui.DisplayOrder=5
gui.IgnoreGuiInset=false
gui.Parent=player:WaitForChild("PlayerGui")

local function rounded(parent,radius)
 local u=Instance.new("UICorner")
 u.CornerRadius=UDim.new(0,radius)
 u.Parent=parent
end
local function text(parent,value,size,pos,fontSize,tint)
 local t=Instance.new("TextLabel")
 t.Size=size
 t.Position=pos
 t.BackgroundTransparency=1
 t.Text=value
 t.TextColor3=tint or Color3.fromRGB(252,246,228)
 t.TextSize=fontSize or 14
 t.TextXAlignment=Enum.TextXAlignment.Left
 t.Font=Enum.Font.GothamBold
 t.TextStrokeTransparency=1
 t.Parent=parent
 return t
end
local panel=Instance.new("Frame")
panel.Name="TopLeftMap"
panel.Position=UDim2.fromOffset(14,14)
panel.Size=UDim2.fromOffset(270,264)
panel.BackgroundColor3=Color3.fromRGB(13,34,48)
panel.BackgroundTransparency=.08
panel.BorderSizePixel=0
panel.Parent=gui
rounded(panel,13)
local border=Instance.new("UIStroke")
border.Color=Color3.fromRGB(214,175,105)
border.Thickness=1.5
border.Transparency=.28
border.Parent=panel
text(panel,"UAE CITY  •  MAP",UDim2.new(1,-54,0,34),UDim2.fromOffset(13,5),17,Color3.fromRGB(255,229,164))
local toggle=Instance.new("TextButton")
toggle.Name="Toggle"
toggle.Position=UDim2.new(1,-40,0,7)
toggle.Size=UDim2.fromOffset(28,27)
toggle.Text="–"
toggle.TextSize=20
toggle.Font=Enum.Font.GothamBold
toggle.TextColor3=Color3.new(1,1,1)
toggle.BackgroundColor3=Color3.fromRGB(40,70,82)
toggle.Parent=panel
rounded(toggle,7)

local map=Instance.new("Frame")
map.Name="SchematicDistrictMap"
map.Position=UDim2.fromOffset(9,39)
map.Size=UDim2.fromOffset(252,185)
map.BorderSizePixel=0
map.BackgroundColor3=Color3.fromRGB(37,95,114)
map.Parent=panel
rounded(map,8)
local sand=Instance.new("Frame")
sand.Size=UDim2.new(.91,0,.94,0)
sand.Position=UDim2.new(.045,0,.03,0)
sand.BorderSizePixel=0
sand.BackgroundColor3=Color3.fromRGB(180,165,128)
sand.Parent=map
rounded(sand,9)
-- Stylized network of highways, drawn in UI coordinates.
local function road(a,b,c,d,thickness)
 local dx,dy=c-a,d-b
 local len=math.sqrt(dx*dx+dy*dy)
 local line=Instance.new("Frame")
 line.Name="District Road"
 line.AnchorPoint=Vector2.new(0,.5)
 line.Position=UDim2.fromScale(a,b)
 line.Size=UDim2.new(0,len*252,0,thickness or 2)
 line.Rotation=math.deg(math.atan2(dy,dx))
 line.BorderSizePixel=0
 line.BackgroundColor3=Color3.fromRGB(230,224,198)
 line.BackgroundTransparency=.18
 line.Parent=map
end
road(.25,.24,.76,.24,3)
road(.25,.24,.25,.88,3)
road(.76,.24,.76,.89,3)
road(.25,.63,.76,.63,3)
road(.49,.2,.49,.88,2)
local districts={
 {name="Dubai",short="DXB",x=-84,z=-392},
 {name="Abu Dhabi",short="AUH",x=-390,z=-396},
 {name="Sharjah",short="SHJ",x=390,z=-380},
 {name="Ajman",short="AJM",x=390,z=210},
 {name="Umm Al Quwain",short="UAQ",x=-390,z=227},
 {name="Ras Al Khaimah",short="RAK",x=410,z=580},
 {name="Fujairah",short="FUJ",x=-390,z=580},
}
local function xy(x,z)
 return math.clamp((x+800)/1600,.035,.965),math.clamp((z+760)/1520,.04,.95)
end
for _,entry in ipairs(districts) do
 local px,pz=xy(entry.x,entry.z)
 local pin=Instance.new("Frame")
 pin.Name=entry.name
 pin.AnchorPoint=Vector2.new(.5,.5)
 pin.Position=UDim2.fromScale(px,pz)
 pin.Size=UDim2.fromOffset(8,8)
 pin.BackgroundColor3=Color3.fromRGB(254,243,204)
 pin.BorderSizePixel=0
 pin.Parent=map
 rounded(pin,8)
 local label=text(map,entry.short,UDim2.fromOffset(41,15),
  UDim2.new(px,6,pz,-7),10,Color3.fromRGB(20,46,57))
 label.Name="District "..entry.short
end
local you=Instance.new("Frame")
you.Name="YOUR LOCATION"
you.AnchorPoint=Vector2.new(.5,.5)
you.Size=UDim2.fromOffset(12,12)
you.BackgroundColor3=Color3.fromRGB(246,49,66)
you.BorderSizePixel=0
you.ZIndex=6
you.Parent=map
rounded(you,9)
local youOutline=Instance.new("UIStroke")
youOutline.Color=Color3.new(1,1,1)
youOutline.Thickness=2
youOutline.Parent=you
text(panel,"● YOU   •   7 EMIRATES   •   M TO HIDE",UDim2.new(1,-18,0,21),
 UDim2.fromOffset(11,229),11,Color3.fromRGB(228,228,220))
local status=Instance.new("Frame")
status.Name="MissionBanner"
status.Position=UDim2.new(0,14,0,288)
status.Size=UDim2.fromOffset(270,90)
status.BackgroundColor3=Color3.fromRGB(12,34,46)
status.BackgroundTransparency=.09
status.BorderSizePixel=0
status.Parent=gui
rounded(status,12)
local missionHead=text(status,"FIRST MISSION: UAE EXPLORER",
 UDim2.new(1,-18,0,25),UDim2.fromOffset(9,8),13,Color3.fromRGB(255,230,165))
local missionText=text(status,"Visit Dubai, Sharjah and Ajman!",
 UDim2.new(1,-18,0,42),UDim2.fromOffset(9,33),13,Color3.new(1,1,1))
missionText.TextWrapped=true
local targets={
 {name="Dubai – Burj Khalifa",pos=Vector3.new(-84,0,-392)},
 {name="Sharjah Heritage",pos=Vector3.new(390,0,-380)},
 {name="Ajman Beach",pos=Vector3.new(390,0,210)},
}
local current=1
local hidden=false
local function toggleMap()
 hidden=not hidden
 map.Visible=not hidden
 panel.Size=hidden and UDim2.fromOffset(270,39) or UDim2.fromOffset(270,264)
 toggle.Text=hidden and "+" or "–"
 for _,child in ipairs(panel:GetChildren()) do
  if child:IsA("TextLabel") and child.Text:find("YOU") then child.Visible=not hidden end
 end
end
toggle.MouseButton1Click:Connect(toggleMap)
UserInputService.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.M then
  toggleMap()
 end
end)
task.spawn(function()
 while gui.Parent do
  task.wait(.18)
  local character=player.Character
  local root=character and character:FindFirstChild("HumanoidRootPart")
  if root then
   local xx,zz=xy(root.Position.X,root.Position.Z)
   you.Position=UDim2.fromScale(xx,zz)
   if current<=#targets then
    local target=targets[current]
    local delta=Vector3.new(root.Position.X-target.pos.X,0,root.Position.Z-target.pos.Z)
    if delta.Magnitude<87 then
     current=current+1
    end
   end
  end
  if current<=#targets then
   missionText.Text=string.format("%d/3 visited  •  Next: %s",current-1,targets[current].name)
  else
   missionHead.Text="MISSION COMPLETE! 🇦🇪"
   missionText.Text="You explored three emirates! More missions are coming."
  end
 end
end)

]========])
install("Script",ServerScriptService,"UAE_Phase3_Animation",[========[
-- Roblox UAE City Life | Phase 3A ambient traffic & walkers
-- Simple animated visual population, not physics/NPC AI. Kept low-cost for laptops.
local RunService=game:GetService("RunService")
local root=workspace:WaitForChild("UAE_City_Life"):WaitForChild("Phase3_LivingCity")
local traffic=root:WaitForChild("AmbientTraffic")
local walkers=root:WaitForChild("AmbientPedestrians")
local routes={
 -- Roads match current prototype, with simple turn-around loops.
 HighwaySouth={
  Vector3.new(-640,0,30),Vector3.new(-250,0,30),Vector3.new(0,0,30),
  Vector3.new(250,0,30),Vector3.new(640,0,30),Vector3.new(640,0,70),
  Vector3.new(250,0,70),Vector3.new(0,0,70),Vector3.new(-250,0,70),Vector3.new(-640,0,70)
 },
 Downtown={
  Vector3.new(-490,0,-235),Vector3.new(-220,0,-235),Vector3.new(0,0,-235),
  Vector3.new(220,0,-235),Vector3.new(480,0,-235),Vector3.new(480,0,-207),
  Vector3.new(220,0,-207),Vector3.new(0,0,-207),Vector3.new(-220,0,-207),Vector3.new(-490,0,-207)
 },
 East={
  Vector3.new(390,0,-540),Vector3.new(390,0,-250),Vector3.new(390,0,30),
  Vector3.new(390,0,250),Vector3.new(390,0,530),Vector3.new(418,0,530),
  Vector3.new(418,0,250),Vector3.new(418,0,30),Vector3.new(418,0,-250),Vector3.new(418,0,-540)
 },
 West={
  Vector3.new(-390,0,-540),Vector3.new(-390,0,-250),Vector3.new(-390,0,30),
  Vector3.new(-390,0,250),Vector3.new(-390,0,530),Vector3.new(-363,0,530),
  Vector3.new(-363,0,250),Vector3.new(-363,0,30),Vector3.new(-363,0,-250),Vector3.new(-363,0,-540)
 },
}
local walkersWaypoints={
 Vector3.new(-75,0,132),Vector3.new(76,0,132),
 Vector3.new(76,0,166),Vector3.new(-75,0,166),
}
local movers={}
for _,model in ipairs(traffic:GetChildren()) do
 if model:IsA("Model") and model.PrimaryPart then
  local route=routes[model:GetAttribute("RouteName") or "HighwaySouth"]
  local idx=tonumber(model:GetAttribute("Waypoint")) or 1
  local p=route[idx]
  movers[#movers+1]={model=model,route=route,index=idx,position=p,
   speed=tonumber(model:GetAttribute("Speed")) or 13}
 end
end
for _,model in ipairs(walkers:GetChildren()) do
 if model:IsA("Model") and model.PrimaryPart then
  local idx=tonumber(model:GetAttribute("Waypoint")) or 1
  local p=walkersWaypoints[idx]
  movers[#movers+1]={model=model,route=walkersWaypoints,index=idx,
   position=p,speed=tonumber(model:GetAttribute("Speed")) or 3}
 end
end
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
 accumulator=accumulator+math.min(dt,.08)
 if accumulator<.12 then return end
 local step=math.min(accumulator,.18)
 accumulator=0
 for _,obj in ipairs(movers) do
  if obj.model.Parent then
   local nextIndex=obj.index%#obj.route+1
   local dest=obj.route[nextIndex]
   local diff=dest-obj.position
   if diff.Magnitude<obj.speed*step+1 then
    obj.position=dest
    obj.index=nextIndex
   else
    obj.position=obj.position+diff.Unit*obj.speed*step
   end
   local dir=obj.route[obj.index%#obj.route+1]-obj.position
   if dir.Magnitude>.02 then
    obj.model:PivotTo(CFrame.lookAt(obj.position,obj.position+dir.Unit))
   end
  end
 end
end)

]========])
print("ROBLOX UAE CITY LIFE Phase 3A: map + Arabic police/ambulance/fire signs + 6 moving cars + 4 pedestrians + Explorer mission.")
