-- UAE CITY LIFE v5.3 | CONTROLS + PLAYABLE COMMUNITY PARK
-- Incremental patch. Requires v5.2 scene; run in Studio Edit Mode, NOT Play mode.
-- Save a separate backup of v5.2 first; retains all previous city landmarks.
local W=game:GetService("Workspace")
local SS=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer")
local world=W:FindFirstChild("UAE_City_Life")
assert(world and world:FindFirstChild("Phase52_RoleplayDistrict"),
 "This patch needs the WORKING Version 5.2 scene. Open v5.2 in Edit mode first.")
local existing=world:FindFirstChild("Phase53CommunityPark")
if existing then existing:Destroy() end
local park=Instance.new("Folder")
park.Name="Phase53CommunityPark"
park.Parent=world
local function color(r,g,b) return Color3.fromRGB(r,g,b) end
local C={
 cream=color(235,224,201),white=color(248,243,227),sand=color(191,163,118),
 teal=color(71,157,165),deep=color(21,52,63),green=color(79,139,87),
 leaf=color(44,113,65),wood=color(131,88,55),metal=color(135,148,152),
 yellow=color(223,182,96),water=color(60,179,208),asphalt=color(69,72,70)
}
local function group(name)
 local f=Instance.new("Folder")
 f.Name=name
 f.Parent=park
 return f
end
local function part(parent,name,sz,cf,clr,material,collide)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=sz
 p.CFrame=cf
 p.Color=clr or C.cream
 p.Material=material or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Anchored=true
 p.CanCollide=collide==true
 p.Parent=parent
 return p
end
local function vpart(parent,name,sz,x,y,z,clr,material,solid)
 return part(parent,name,sz,CFrame.new(x,y,z),clr,material,solid)
end
local function surfaceLabel(partObj,word)
 local s=Instance.new("SurfaceGui")
 s.Face=Enum.NormalId.Front
 s.PixelsPerStud=45
 s.LightInfluence=.15
 s.Parent=partObj
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1)
 t.BackgroundTransparency=1
 t.Font=Enum.Font.GothamBold
 t.Text=word
 t.TextScaled=true
 t.TextColor3=C.white
 t.Parent=s
end
local landscape=group("Landscape")
-- Community park between the existing west/east villa groups, no villa overwritten.
vpart(landscape,"Stone park foundation",Vector3.new(158,1.5,133),
 0,.45,-850,C.sand,Enum.Material.Concrete,true)
vpart(landscape,"Grass lawn",Vector3.new(146,.3,119),
 0,1.45,-850,C.green,Enum.Material.Grass,false)
vpart(landscape,"Main accessible walk",Vector3.new(12,.3,130),
 0,1.72,-841,C.cream,Enum.Material.Concrete,true)
vpart(landscape,"Cross park walking path",Vector3.new(145,.3,10),
 0,1.8,-860,C.cream,Enum.Material.Concrete,true)
vpart(landscape,"Community welcome plaza",Vector3.new(54,.4,25),
 0,1.7,-792,C.cream,Enum.Material.Marble,true)
local sign=vpart(landscape,"AL WASL PARK welcome",Vector3.new(44,5,.9),
 0,11,-785,C.deep,Enum.Material.Metal,false)
surfaceLabel(sign,"AL WASL • FAMILY PARK")
for _,x in ipairs({-18,18}) do
 vpart(landscape,"Park entry pillar",Vector3.new(2,16,2),
  x,8,-785,C.cream,Enum.Material.Concrete,true)
end
local fountain=group("GardenFountain")
local basin=vpart(fountain,"Circular stone fountain",Vector3.new(2.4,27,27),
  0,2.5,-853,C.white,Enum.Material.Marble,false)
basin.Shape=Enum.PartType.Cylinder
basin.CFrame=basin.CFrame*CFrame.Angles(0,0,math.pi/2)
local pool=vpart(fountain,"Reflective blue water",Vector3.new(.35,22,22),
  0,3.75,-853,C.water,Enum.Material.Glass,false)
pool.Shape=Enum.PartType.Cylinder
pool.CFrame=pool.CFrame*CFrame.Angles(0,0,math.pi/2)
pool.Transparency=.16
local center=vpart(fountain,"Palm shaped water sculpture",Vector3.new(3,9,3),
  0,9,-853,C.metal,Enum.Material.Metal,false)
center.Shape=Enum.PartType.Cylinder
for _,j in ipairs({1,2,3,4}) do
 local angle=j*math.pi/2
 local x=9*math.cos(angle)
 local z=-853+9*math.sin(angle)
 local column=vpart(fountain,"Decorative fountain stream",Vector3.new(.45,6,.45),
  x,7.1,z,C.water,Enum.Material.Neon,false)
 column.Transparency=.12
end
local seating=group("RestAreas")
for _,s in ipairs({
 {-52,-874,0},{52,-874,0},{-52,-825,0},{52,-825,0},
 {-35,-900,0},{35,-900,0},
}) do
 local x,z=s[1],s[2]
 local base=vpart(seating,"Park bench seat",Vector3.new(12,.9,4),
  x,3.1,z,C.wood,Enum.Material.WoodPlanks,true)
 vpart(seating,"Bench backrest",Vector3.new(12,4,.9),
  x,5,z+1.65,C.wood,Enum.Material.Wood,false)
 for _,xoff in ipairs({-5,5}) do
  vpart(seating,"Bench steel frame",Vector3.new(.6,2.7,3.7),
   x+xoff,2.1,z,C.metal,Enum.Material.Metal,false)
 end
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="TakeABreak"
 prompt.ObjectText="Al Wasl Family Park"
 prompt.ActionText="Sit and relax"
 prompt.HoldDuration=.3
 prompt.MaxActivationDistance=12
 prompt.RequiresLineOfSight=false
 prompt.Parent=base
end
-- Park trees: stylized original geometry; modest part count for a Dell laptop.
local trees=group("LandscapedTrees")
for _,pt in ipairs({
 {-62,-890,14},{-62,-842,12},{-62,-802,15},{62,-891,15},
 {62,-835,14},{62,-802,13},{-27,-913,12},{29,-913,15},
}) do
 local x,z,h=pt[1],pt[2],pt[3]
 vpart(trees,"Palm trunk",Vector3.new(2.2,h,2.2),
  x,1.8+h/2,z,C.wood,Enum.Material.Wood,false)
 for j=1,5 do
  local a=(j-1)*2*math.pi/5
  local leaf=part(trees,"Palm feather leaf",Vector3.new(12,1.3,4),
   CFrame.new(x+4*math.cos(a),2.1+h,z+4*math.sin(a))*
    CFrame.Angles(0,-a,math.rad((j%2==0 and 8 or -8))),
   C.leaf,Enum.Material.Grass,false)
 end
end
local kiosks=group("JobKiosks")
for _,job in ipairs({
 {"Taxi", "TAXI DRIVER", -42, color(214,168,68)},
 {"Medic", "CLINIC HELPER", 0, color(83,166,150)},
 {"Tour", "DUBAI TOUR GUIDE", 42, color(101,142,193)}
}) do
 local role,label,x,tint=job[1],job[2],job[3],job[4]
 local stand=vpart(kiosks,"Park "..role.." Job Kiosk",Vector3.new(26,7,2),
  x,6,-796,C.deep,Enum.Material.Metal,false)
 stand:SetAttribute("RoleKey",role)
 local panel=vpart(kiosks,"Kiosk colour accent",Vector3.new(26,1,2.2),
  x,10,-796,tint,Enum.Material.Neon,false)
 surfaceLabel(stand,label)
 for _,dx in ipairs({-11,11}) do
  vpart(kiosks,"Kiosk slim post",Vector3.new(.8,6,.8),
   x+dx,1.9,-795,C.metal,Enum.Material.Metal,false)
 end
 local prompt=Instance.new("ProximityPrompt")
 prompt.Name="Choose"..role.."Shift"
 prompt.ActionText="Start "..label
 prompt.ObjectText="Dubai City Life Jobs"
 prompt.MaxActivationDistance=12
 prompt.RequiresLineOfSight=false
 prompt.Parent=stand
end
local details=group("StreetLifeDetails")
for _,x in ipairs({-70,-35,35,70}) do
 vpart(details,"Park lantern pillar",Vector3.new(1,11,1),
  x,7,-790,C.metal,Enum.Material.Metal,false)
 local light=vpart(details,"Warm park lamp",Vector3.new(3,.7,3),
  x,13,-790,C.yellow,Enum.Material.Neon,false)
 local pt=Instance.new("PointLight")
 pt.Name="V53NightLamp"
 pt.Range=24
 pt.Brightness=1.3
 pt.Enabled=false
 pt.Parent=light
end
-- KEEP all earlier roads, three emergency cars, the city and UAE flags.
local scripts=SP:WaitForChild("StarterPlayerScripts")
for _,name in ipairs({
 "UAE_Phase5Camera","UAE_Phase51Camera","UAE_V52_Camera",
 "UAE_V53_Camera","UAE_V53_Jobs",
}) do
 local old=scripts:FindFirstChild(name)
 if old then old:Destroy() end
end
for _,name in ipairs({"UAE_V53_JobsServer","UAE_V53_ParkInteractions"}) do
 local old=SS:FindFirstChild(name)
 if old then old:Destroy() end
end
local function install(kind,parent,name,source)
 local obj=Instance.new(kind)
 obj.Name=name
 obj.Source=source
 obj.Parent=parent
end
install("LocalScript",scripts,"UAE_V53_Camera",[========[
-- UAE CITY LIFE v5.3: keyboard/buttons zoom ONLY; mouse right-drag rotates camera.
-- I = zoom in, O = zoom out. Mousewheel is intentionally NOT used for zoom.
-- ContextActionService has higher input priority than default Roblox camera keys.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local CAS=game:GetService("ContextActionService")
local RS=game:GetService("RunService")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V53_CameraControls"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=42
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(19,45,56)
local fg=Color3.fromRGB(250,238,216)
local function control(name,caption,y)
 local b=Instance.new("TextButton")
 b.Name=name
 b.AnchorPoint=Vector2.new(1,0)
 b.Position=UDim2.new(1,-12,0,y)
 b.Size=UDim2.fromOffset(40,34)
 b.BackgroundColor3=bg
 b.BackgroundTransparency=.1
 b.BorderSizePixel=0
 b.AutoButtonColor=true
 b.Text=caption
 b.TextSize=17
 b.Font=Enum.Font.GothamBold
 b.TextColor3=fg
 b.Parent=gui
 local rounded=Instance.new("UICorner")
 rounded.CornerRadius=UDim.new(0,8)
 rounded.Parent=b
 return b
end
local zoomIn=control("ZoomIn_I","I +",185)
local zoomOut=control("ZoomOut_O","O −",225)
local reset=control("CameraReset","C",265)
local info=Instance.new("TextLabel")
info.Name="CameraHelp"
info.AnchorPoint=Vector2.new(1,0)
info.Position=UDim2.new(1,-59,0,185)
info.Size=UDim2.fromOffset(130,74)
info.BackgroundColor3=bg
info.BackgroundTransparency=.15
info.BorderSizePixel=0
info.TextColor3=fg
info.Font=Enum.Font.GothamMedium
info.TextSize=12
info.TextWrapped=true
info.Text="I / O  •  ZOOM\nRight-drag • LOOK\nCAM 20 studs"
info.Parent=gui
local c=Instance.new("UICorner")
c.CornerRadius=UDim.new(0,8)
c.Parent=info

local dist=20
local yaw=0
local pitch=math.rad(16)
local mouseHeld=false
local modeWas=""
local initialized=false
local nextRepeat=0
local function state()
 local ch=player.Character
 local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 local seat=hum and hum.SeatPart
 local car=nil
 if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
  local model=seat.Parent
  if model and model:IsA("Model") and model:GetAttribute("UAEVehicle")==true then car=model end
 end
 return ch,hum,root,car
end
local function zoom(inward)
 local _,_,_,car=state()
 dist=math.clamp(dist*(inward and .84 or 1.2),car and 12 or 5,car and 100 or 75)
 info.Text=string.format("I / O  •  ZOOM\nRight-drag • LOOK\nCAM %d studs",math.round(dist))
end
local function defaultView()
 dist=20
 yaw=0
 pitch=math.rad(16)
 info.Text="I / O  •  ZOOM\nRight-drag • LOOK\nCAM 20 studs"
end
zoomIn.Activated:Connect(function() zoom(true) end)
zoomOut.Activated:Connect(function() zoom(false) end)
reset.Activated:Connect(defaultView)
-- Keyboard action handlers take priority over Roblox's default I/O camera bindings.
local function onKeyboard(actionName,inputState)
 if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
 if inputState==Enum.UserInputState.Begin then
  zoom(actionName=="UAE_V53_ZoomIn")
  nextRepeat=os.clock()+.28
 end
 return Enum.ContextActionResult.Sink
end
CAS:BindActionAtPriority("UAE_V53_ZoomIn",onKeyboard,false,4000,Enum.KeyCode.I)
CAS:BindActionAtPriority("UAE_V53_ZoomOut",onKeyboard,false,4000,Enum.KeyCode.O)
UIS.InputBegan:Connect(function(input,processed)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=true end
 if UIS:GetFocusedTextBox() or processed then return end
 if input.KeyCode==Enum.KeyCode.C then defaultView()
 elseif input.KeyCode==Enum.KeyCode.PageUp then
  pitch=math.clamp(pitch+math.rad(9),math.rad(5),math.rad(77))
 elseif input.KeyCode==Enum.KeyCode.PageDown then
  pitch=math.clamp(pitch-math.rad(9),math.rad(5),math.rad(77))
 end
end)
UIS.InputEnded:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton2 then mouseHeld=false end
end)
UIS.WindowFocusReleased:Connect(function() mouseHeld=false end)
UIS.InputChanged:Connect(function(input)
 -- Mouse movement rotates the camera while the right button is held.
 -- The scroll wheel is NOT bound to zoom, as requested.
 if mouseHeld and input.UserInputType==Enum.UserInputType.MouseMovement then
  yaw=yaw-input.Delta.X*.008
  pitch=math.clamp(pitch+input.Delta.Y*.005,math.rad(5),math.rad(77))
 end
end)
RS:BindToRenderStep("UAE_V53_OrbitCamera",Enum.RenderPriority.Camera.Value+90,function(dt)
 local camera=workspace.CurrentCamera
 local ch,hum,root,car=state()
 if not camera or not root or not hum or hum.Health<=0 then
  if camera then camera.CameraType=Enum.CameraType.Custom end
  initialized=false
  return
 end
 local mode=car and "Car" or "Walk"
 if mode~=modeWas then
  modeWas=mode
  initialized=false
  dist=car and 37 or 20
  info.Text=string.format("I / O  •  ZOOM\nRight-drag • LOOK\nCAM %d studs",dist)
 end
 if not UIS:GetFocusedTextBox() and os.clock()>nextRepeat then
  if UIS:IsKeyDown(Enum.KeyCode.I) then zoom(true);nextRepeat=os.clock()+.12
  elseif UIS:IsKeyDown(Enum.KeyCode.O) then zoom(false);nextRepeat=os.clock()+.12 end
 end
 local basis=car and car:GetPivot() or root.CFrame
 local height=car and 5.8 or 2.6
 local focus=(basis*CFrame.new(0,height,0)).Position
 local behind=basis*CFrame.Angles(0,yaw,0)
 local desired=(behind*CFrame.new(0,height+dist*math.sin(pitch),
  dist*math.cos(pitch))).Position
 local ray=desired-focus
 if ray.Magnitude<.2 then return end
 local param=RaycastParams.new()
 param.FilterType=Enum.RaycastFilterType.Exclude
 param.FilterDescendantsInstances=car and {ch,car} or {ch}
 param.IgnoreWater=true
 local hit=workspace:Raycast(focus,ray,param)
 if hit then desired=hit.Position-ray.Unit*1.3 end
 camera.CameraType=Enum.CameraType.Scriptable
 local goal=CFrame.lookAt(desired,focus)
 camera.CFrame=initialized and camera.CFrame:Lerp(goal,math.clamp(dt*12,0,1)) or goal
 camera.Focus=CFrame.new(focus)
 camera.FieldOfView=70
 initialized=true
end)

]========])
install("LocalScript",scripts,"UAE_V53_Jobs",[========[
-- UAE City Life v5.3 compact JOBS menu + GPS shift progress.
-- All progress and points are determined by the server, not this client UI.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local action=RS:WaitForChild("UAE_V53_JobRequest",30)
local update=RS:WaitForChild("UAE_V53_JobUpdate",30)
if not action or not update then warn("v5.3 jobs: server events unavailable") return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V53_RoleplayJobs"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.DisplayOrder=41
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(20,44,57)
local gold=Color3.fromRGB(235,191,117)
local white=Color3.fromRGB(244,234,218)
local aqua=Color3.fromRGB(68,145,152)
local function rounded(part,pixels)
 local c=Instance.new("UICorner")
 c.CornerRadius=UDim.new(0,pixels or 8)
 c.Parent=part
end
local function button(parent,name,txt,pos,size,color)
 local b=Instance.new("TextButton")
 b.Name=name
 b.Text=txt
 b.Size=size
 b.Position=pos
 b.Font=Enum.Font.GothamBold
 b.TextSize=13
 b.TextColor=white
 b.BackgroundColor3=color or aqua
 b.BorderSizePixel=0
 b.Parent=parent
 rounded(b)
 return b
end
local function text(parent,name,txt,pos,size,sz)
 local label=Instance.new("TextLabel")
 label.Name=name
 label.Text=txt
 label.Position=pos
 label.Size=size
 label.BackgroundTransparency=1
 label.Font=Enum.Font.GothamSemibold
 label.TextSize=sz or 12
 label.TextColor3=white
 label.TextWrapped=true
 label.TextXAlignment=Enum.TextXAlignment.Left
 label.Parent=parent
 return label
end
local launch=button(gui,"JobsButton","JOBS",
 UDim2.new(1,-85,1,-144),UDim2.fromOffset(71,37),bg)
local panel=Instance.new("Frame")
panel.Name="JobChoices"
panel.Size=UDim2.fromOffset(302,255)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.52)
panel.BackgroundColor3=bg
panel.BorderSizePixel=0
panel.Visible=false
panel.Parent=gui
rounded(panel,13)
local border=Instance.new("UIStroke")
border.Color=gold
border.Thickness=1.2
border.Parent=panel
text(panel,"Title","DUBAI COMMUNITY JOBS",
 UDim2.fromOffset(16,11),UDim2.fromOffset(246,27),16)
text(panel,"Subtitle","Choose a shift. Follow the destination marker.",
 UDim2.fromOffset(16,45),UDim2.fromOffset(272,27),11)
local close=button(panel,"Close","X",UDim2.fromOffset(263,10),
 UDim2.fromOffset(27,27),Color3.fromRGB(115,73,74))
close.Activated:Connect(function() panel.Visible=false end)
local options={
 {"Taxi Driver  •  55 pts","Taxi"},
 {"Clinic Helper  •  55 pts","Medic"},
 {"Dubai Tour Guide  •  70 pts","Tour"},
}
for n,entry in ipairs(options) do
 local b=button(panel,"Role"..entry[2],entry[1],UDim2.fromOffset(16,81+(n-1)*44),
  UDim2.fromOffset(270,37),aqua)
 b.Activated:Connect(function()
  action:FireServer("Start",entry[2])
  panel.Visible=false
 end)
end
local cancel=button(panel,"EndShift","End current shift",
 UDim2.fromOffset(16,217),UDim2.fromOffset(270,27),Color3.fromRGB(110,78,73))
cancel.Activated:Connect(function()
 action:FireServer("Cancel","None")
 panel.Visible=false
end)
launch.Activated:Connect(function() panel.Visible=not panel.Visible end)
UIS.InputBegan:Connect(function(input,processed)
 if not processed and not UIS:GetFocusedTextBox() and input.KeyCode==Enum.KeyCode.J then
  panel.Visible=not panel.Visible
 end
end)
local banner=Instance.new("TextLabel")
banner.Name="CurrentShift"
banner.AnchorPoint=Vector2.new(.5,1)
banner.Position=UDim2.new(.5,0,1,-13)
banner.Size=UDim2.fromOffset(348,38)
banner.BackgroundColor3=bg
banner.BackgroundTransparency=.08
banner.BorderSizePixel=0
banner.Font=Enum.Font.GothamSemibold
banner.TextSize=12
banner.TextColor3=white
banner.TextWrapped=true
banner.Text="JOBS  •  Choose your first Dubai shift"
banner.Visible=false
banner.Parent=gui
rounded(banner,10)
local waypoint=Instance.new("Part")
waypoint.Name="UAE_LocalJobMarker"
waypoint.Size=Vector3.new(.2,.2,.2)
waypoint.Anchored=true
waypoint.CanCollide=false
waypoint.CanTouch=false
waypoint.CanQuery=false
waypoint.Transparency=1
waypoint.Parent=workspace
local beacon=Instance.new("BillboardGui")
beacon.Name="NextJobDestination"
beacon.Adornee=waypoint
beacon.Size=UDim2.fromOffset(140,42)
beacon.AlwaysOnTop=true
beacon.MaxDistance=300
beacon.StudsOffsetWorldSpace=Vector3.new(0,8,0)
beacon.Enabled=false
beacon.Parent=waypoint
local markerText=Instance.new("TextLabel")
markerText.Size=UDim2.fromScale(1,1)
markerText.BackgroundColor3=bg
markerText.BackgroundTransparency=.12
markerText.TextColor3=gold
markerText.Font=Enum.Font.GothamBold
markerText.TextScaled=true
markerText.TextWrapped=true
markerText.Text="NEXT STOP"
markerText.Parent=beacon
rounded(markerText,8)
local active=nil
local noticeExpires=0
update.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" or typeof(data.kind)~="string" then return end
 if data.kind=="progress" and typeof(data.position)=="Vector3" then
  active={title=tostring(data.name),step=data.step,total=data.total,
   label=tostring(data.label),position=data.position}
  waypoint.CFrame=CFrame.new(data.position)
  beacon.Enabled=true
  markerText.Text="JOB DESTINATION"
  banner.Visible=true
 elseif data.kind=="completed" or data.kind=="cancelled" then
  active=nil
  beacon.Enabled=false
  banner.Text=tostring(data.message or "Shift complete")
  banner.Visible=true
  noticeExpires=os.clock()+5
 end
end)
local counter=0
RunService.RenderStepped:Connect(function(dt)
 counter=counter+dt
 if counter<.3 then return end
 counter=0
 if active then
  local ch=player.Character
  local root=ch and ch:FindFirstChild("HumanoidRootPart")
  local meters=root and math.floor((root.Position-active.position).Magnitude) or 0
  banner.Text=string.format("%s  %d/%d | %s | %d studs",
   active.title,active.step,active.total,active.label,meters)
 elseif noticeExpires>0 and os.clock()>noticeExpires then
  banner.Visible=false
  noticeExpires=0
 end
end)
task.delay(2.5,function()
 if action.Parent then action:FireServer("Status","Current") end
end)

]========])
install("Script",SS,"UAE_V53_JobsServer",[========[
-- UAE CITY LIFE v5.3: server-authoritative, noncombat city roleplay jobs.
-- Players can use a kiosk or JOBS button. Rewards are session-only CityPoints.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local park=world:WaitForChild("Phase53CommunityPark")
local function event(name)
 local obj=RS:FindFirstChild(name)
 if not obj then obj=Instance.new("RemoteEvent");obj.Name=name;obj.Parent=RS end
 return obj
end
local request=event("UAE_V53_JobRequest")
local update=event("UAE_V53_JobUpdate")
local jobs={
 Taxi={
  title="Dubai Taxi Service",
  reward=55,
  steps={
   {label="Pick up a guest at Karak Cafe",pos=Vector3.new(-225,5,-671)},
   {label="Drive to Hotel Al Wasl",pos=Vector3.new(80,5,-671)},
   {label="Return to the residential taxi stand",pos=Vector3.new(5,5,-746)},
  }
 },
 Medic={
  title="Clinic Community Helper",
  reward=55,
  steps={
   {label="Report to Dubai Clinic",pos=Vector3.new(-370,5,-669)},
   {label="Visit the community park",pos=Vector3.new(0,5,-855)},
   {label="Return to the clinic",pos=Vector3.new(-370,5,-669)},
  }
 },
 Tour={
  title="Dubai Sightseeing Guide",
  reward=70,
  steps={
   {label="Start the tour at the community park",pos=Vector3.new(0,5,-855)},
   {label="Visit Sheikh Zayed Road",pos=Vector3.new(107,5,-1200)},
   {label="Arrive near Burj Khalifa",pos=Vector3.new(115,6,-392)},
  }
 },
}
local state={}
local lastStart={}
local function notify(player,payload)
 if player.Parent==Players then update:FireClient(player,payload) end
end
local function sendStep(player,current,phrase)
 local job=jobs[current.kind]
 if not job then return end
 local item=job.steps[current.step]
 notify(player,{
  kind="progress",name=job.title,step=current.step,total=#job.steps,
  label=item.label,position=item.pos,reward=job.reward,message=phrase or ""
 })
end
local function start(player,kind)
 if not jobs[kind] then return end
 if player.Parent~=Players then return end
 local now=os.clock()
 if lastStart[player] and now-lastStart[player]<2 then return end
 lastStart[player]=now
 state[player]={kind=kind,step=1,stageStarted=now}
 sendStep(player,state[player],"New shift: "..jobs[kind].title)
end
request.OnServerEvent:Connect(function(player,command,kind)
 if typeof(command)~="string" or typeof(kind)~="string" then return end
 if command=="Start" then
  start(player,kind)
 elseif command=="Cancel" then
  state[player]=nil
  notify(player,{kind="cancelled",message="Shift ended. Choose another job anytime."})
 elseif command=="Status" then
  local current=state[player]
  if current then sendStep(player,current,"Current shift") end
 end
end)
local boards=park:WaitForChild("JobKiosks")
for _,kiosk in ipairs(boards:GetChildren()) do
 local prompt=kiosk:IsA("BasePart") and kiosk:FindFirstChildOfClass("ProximityPrompt")
 local job=kiosk:GetAttribute("RoleKey")
 if prompt and typeof(job)=="string" and jobs[job] then
  prompt.Triggered:Connect(function(player)
   local char=player.Character
   local root=char and char:FindFirstChild("HumanoidRootPart")
   if root and (root.Position-kiosk.Position).Magnitude<16 then start(player,job) end
  end)
 end
end
task.spawn(function()
 while park.Parent do
  for player,current in pairs(state) do
   local def=jobs[current.kind]
   local step=def and def.steps[current.step]
   local char=player.Character
   local hum=char and char:FindFirstChildOfClass("Humanoid")
   local root=char and char:FindFirstChild("HumanoidRootPart")
   if not player.Parent or not def then
    state[player]=nil
   elseif step and root and hum and hum.Health>0 then
    if os.clock()-current.stageStarted>2 and
     (root.Position-step.pos).Magnitude<=24 then
     current.step=current.step+1
     current.stageStarted=os.clock()
     if current.step>#def.steps then
      state[player]=nil
      local stats=player:FindFirstChild("leaderstats")
      local score=stats and stats:FindFirstChild("CityPoints")
      if not score then
       if not stats then
        stats=Instance.new("Folder")
        stats.Name="leaderstats"
        stats.Parent=player
       end
       score=Instance.new("IntValue")
       score.Name="CityPoints"
       score.Parent=stats
      end
      score.Value=score.Value+def.reward
      notify(player,{kind="completed",name=def.title,
        message="Shift complete! +"..def.reward.." CityPoints"})
     else
      sendStep(player,current,"Checkpoint completed. Next destination:")
     end
    end
   end
  end
  task.wait(1.25)
 end
end)
Players.PlayerRemoving:Connect(function(player)
 state[player]=nil
 lastStart[player]=nil
end)

]========])
install("Script",SS,"UAE_V53_ParkInteractions",[========[
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local park=world:WaitForChild("Phase53CommunityPark")
local seating=park:WaitForChild("RestAreas")
local cooldown={}
for _,p in ipairs(seating:GetChildren()) do
 local q=p:IsA("BasePart") and p:FindFirstChildOfClass("ProximityPrompt")
 if q then
  q.Triggered:Connect(function(player)
   local char=player.Character
   local hum=char and char:FindFirstChildOfClass("Humanoid")
   local root=char and char:FindFirstChild("HumanoidRootPart")
   if not hum or not root or hum.Health<=0 or (root.Position-p.Position).Magnitude>15 then return end
   if cooldown[player] and os.clock()-cooldown[player]<15 then return end
   cooldown[player]=os.clock()
   hum.Health=math.min(hum.MaxHealth,hum.Health+12)
  end)
 end
end
task.spawn(function()
 while park.Parent do
  local h=RS:GetAttribute("UAECycleHour")
  local night=typeof(h)=="number" and (h>=18 or h<6)
  for _,obj in ipairs(park:GetDescendants()) do
   if obj:IsA("PointLight") and obj.Name=="V53NightLamp" then obj.Enabled=night end
  end
  task.wait(8)
 end
end)
game:GetService("Players").PlayerRemoving:Connect(function(pl) cooldown[pl]=nil end)
]========])
print("UAE CITY LIFE v5.3 READY: I/O keys and visible zoom buttons, mouse right-drag to look, playable city jobs and community park.")
