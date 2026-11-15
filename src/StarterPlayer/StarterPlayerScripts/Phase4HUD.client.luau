-- PHASE 4 - circular local minimap, Dubai GST clock and game day/night HUD.
-- All drawn in Lua UI; no web requests or copyrighted map texture.
local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local ui=Instance.new("ScreenGui")
ui.Name="UAE_Phase4_HUD"
ui.ResetOnSpawn=false
ui.DisplayOrder=10
ui.IgnoreGuiInset=false
ui.Parent=player:WaitForChild("PlayerGui")
local function round(p,r)
 local u=Instance.new("UICorner")
 u.CornerRadius=UDim.new(r or 0,0)
 u.Parent=p
end
local function txt(parent,name,text,size,pos,fontSize,col)
 local t=Instance.new("TextLabel")
 t.Name=name
 t.Text=text
 t.Size=size
 t.Position=pos
 t.BackgroundTransparency=1
 t.TextColor3=col or Color3.fromRGB(253,247,232)
 t.Font=Enum.Font.GothamBold
 t.TextSize=fontSize or 13
 t.TextXAlignment=Enum.TextXAlignment.Left
 t.Parent=parent
 return t
end
local clockBox=Instance.new("Frame")
clockBox.Name="DubaiClock"
clockBox.Size=UDim2.fromOffset(275,52)
clockBox.Position=UDim2.fromOffset(15,14)
clockBox.BackgroundColor3=Color3.fromRGB(16,35,44)
clockBox.BackgroundTransparency=.08
clockBox.BorderSizePixel=0
clockBox.Parent=ui
round(clockBox,.2)
local cborder=Instance.new("UIStroke")
cborder.Color=Color3.fromRGB(222,182,104)
cborder.Transparency=.24
cborder.Parent=clockBox
local liveTime=txt(clockBox,"DubaiLocalTime","DUBAI • --:-- GST",UDim2.new(1,-15,0,25),UDim2.fromOffset(12,3),16,Color3.fromRGB(255,232,168))
local gameTime=txt(clockBox,"DayNight","GAME TIME • --:--",UDim2.new(1,-15,0,20),UDim2.fromOffset(12,27),12)

local frame=Instance.new("Frame")
frame.Name="CircularMinimap"
frame.Size=UDim2.fromOffset(178,178)
frame.Position=UDim2.fromOffset(15,75)
frame.BackgroundColor3=Color3.fromRGB(14,39,48)
frame.BorderSizePixel=0
frame.BackgroundTransparency=.06
frame.Parent=ui
round(frame,.5)
local border=Instance.new("UIStroke")
border.Thickness=2
border.Color=Color3.fromRGB(230,185,103)
border.Transparency=.18
border.Parent=frame
local viewport=Instance.new("Frame")
viewport.Name="MapRoundMask"
viewport.AnchorPoint=Vector2.new(.5,.5)
viewport.Position=UDim2.fromScale(.5,.5)
viewport.Size=UDim2.fromOffset(163,163)
viewport.BackgroundColor3=Color3.fromRGB(181,161,118)
viewport.BorderSizePixel=0
viewport.ClipsDescendants=true
viewport.Parent=frame
round(viewport,.5)
local ocean=Instance.new("Frame")
ocean.Name="CoastBackground"
ocean.Size=UDim2.fromScale(1,1)
ocean.BackgroundColor3=Color3.fromRGB(49,119,136)
ocean.BackgroundTransparency=.7
ocean.BorderSizePixel=0
ocean.Parent=viewport
local roadsFrame=Instance.new("Frame")
roadsFrame.Name="Roads"
roadsFrame.BackgroundTransparency=1
roadsFrame.Size=UDim2.fromScale(1,1)
roadsFrame.Parent=viewport
local dot=Instance.new("Frame")
dot.Name="PlayerArrow"
dot.AnchorPoint=Vector2.new(.5,.5)
dot.Size=UDim2.fromOffset(13,13)
dot.Position=UDim2.fromScale(.5,.5)
dot.BackgroundColor3=Color3.fromRGB(232,58,65)
dot.BorderSizePixel=0
dot.ZIndex=8
dot.Parent=viewport
round(dot,.5)
local dotStroke=Instance.new("UIStroke")
dotStroke.Thickness=2
dotStroke.Color=Color3.new(1,1,1)
dotStroke.Parent=dot
local north=txt(frame,"CompassNorth","N",UDim2.fromOffset(22,20),
 UDim2.new(.5,-7,0,-4),12,Color3.fromRGB(255,222,143))
north.TextXAlignment=Enum.TextXAlignment.Center
north.ZIndex=12
local toggle=Instance.new("TextButton")
toggle.Name="MapToggle"
toggle.Size=UDim2.fromOffset(37,30)
toggle.Position=UDim2.fromOffset(155,10)
toggle.BackgroundColor3=Color3.fromRGB(23,53,62)
toggle.Text="MAP"
toggle.Font=Enum.Font.GothamBold
toggle.TextSize=11
toggle.TextColor3=Color3.new(1,1,1)
toggle.ZIndex=13
toggle.Parent=ui
round(toggle,.2)
local hint=txt(ui,"MinimapHint","M TO HIDE MAP",UDim2.fromOffset(140,21),
 UDim2.fromOffset(28,255),11,Color3.fromRGB(255,234,194))
local mission=Instance.new("Frame")
mission.Name="ExplorerMission"
mission.Size=UDim2.fromOffset(270,72)
mission.Position=UDim2.fromOffset(15,285)
mission.BackgroundColor3=Color3.fromRGB(16,37,44)
mission.BackgroundTransparency=.12
mission.BorderSizePixel=0
mission.Parent=ui
round(mission,.2)
local missionHeader=txt(mission,"Header","UAE EXPLORER • FIRST MISSION",UDim2.new(1,-14,0,21),
 UDim2.fromOffset(9,7),13,Color3.fromRGB(255,228,158))
local missionDetail=txt(mission,"Details","Visit Burj Khalifa, Sharjah, Ajman",UDim2.new(1,-14,0,41),
 UDim2.fromOffset(9,28),12)
missionDetail.TextWrapped=true

local segments={}
local function add(x1,z1,x2,z2)
 segments[#segments+1]={x1=x1,z1=z1,x2=x2,z2=z2}
end
-- The map follows the user's position; these are simplified game roads, not satellite data.
for _,z in ipairs({30,-235,335}) do add(-860,z,860,z) end
for _,x in ipairs({-390,0,390}) do add(x,-700,x,760) end
local function loop(hw,hh,cz)
 -- Round-corner route segments used by traffic, approximate polygon.
 local radius=46
 local coords={}
 local corners={
  {hw-radius,-hh+radius,-math.pi/2,0},
  {hw-radius,hh-radius,0,math.pi/2},
  {-hw+radius,hh-radius,math.pi/2,math.pi},
  {-hw+radius,-hh+radius,math.pi,math.pi*1.5}
 }
 for _,c in ipairs(corners) do
  for i=0,5 do
   local a=c[3]+(c[4]-c[3])*i/5
   coords[#coords+1]={x=c[1]+radius*math.cos(a),z=cz+c[2]+radius*math.sin(a)}
  end
 end
 for i=1,#coords do
  local a,b=coords[i],coords[(i%#coords)+1]
  add(a.x,a.z,b.x,b.z)
 end
end
loop(310,240,-325)
loop(330,250,215)
loop(1040,950,0)
local lineInstances={}
local function lineObject()
 local obj=Instance.new("Frame")
 obj.BackgroundColor3=Color3.fromRGB(246,237,205)
 obj.BackgroundTransparency=.09
 obj.BorderSizePixel=0
 obj.AnchorPoint=Vector2.new(0,.5)
 obj.Parent=roadsFrame
 return obj
end
for i=1,#segments do lineInstances[i]=lineObject() end
local sites={
 {x=-84,z=-392,name="D"},{x=-390,z=-396,name="A"},
 {x=390,z=-380,name="S"},{x=390,z=210,name="J"},
 {x=-390,z=227,name="U"},{x=410,z=580,name="R"},
 {x=-390,z=580,name="F"},
}
local pins={}
for _,item in ipairs(sites) do
 local pin=Instance.new("TextLabel")
 pin.Name="Emirate "..item.name
 pin.Size=UDim2.fromOffset(13,13)
 pin.BackgroundColor3=Color3.fromRGB(25,62,69)
 pin.TextColor3=Color3.fromRGB(250,221,148)
 pin.Font=Enum.Font.GothamBold
 pin.TextSize=10
 pin.Text=item.name
 pin.BorderSizePixel=0
 pin.AnchorPoint=Vector2.new(.5,.5)
 pin.Parent=viewport
 round(pin,.5)
 pins[#pins+1]=pin
end
local zoom=3.9 -- pixels per 10 studs; local radius about 200 studs.
local function placeMarker(worldX,worldZ,playerX,playerZ)
 return 81.5+(worldX-playerX)*.39,81.5+(worldZ-playerZ)*.39
end
local minimapVisible=true
local function toggleMap()
 minimapVisible=not minimapVisible
 frame.Visible=minimapVisible
 hint.Visible=minimapVisible
 toggle.Text=minimapVisible and "MAP" or "+"
end
toggle.MouseButton1Click:Connect(toggleMap)
UserInputService.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.M then toggleMap() end
end)
local points={
 {name="Burj Khalifa • Dubai",x=-84,z=-392},
 {name="Sharjah Heritage",x=390,z=-380},
 {name="Ajman Beach",x=390,z=210}
}
local progress=1
local accumulator=0
RunService.Heartbeat:Connect(function(dt)
 accumulator=accumulator+dt
 if accumulator<.2 then return end
 accumulator=0
 local char=player.Character
 local root=char and char:FindFirstChild("HumanoidRootPart")
 if root then
  if minimapVisible then
   for i,edge in ipairs(segments) do
    local x1,y1=placeMarker(edge.x1,edge.z1,root.Position.X,root.Position.Z)
    local x2,y2=placeMarker(edge.x2,edge.z2,root.Position.X,root.Position.Z)
    local dx,dy=x2-x1,y2-y1
    local line=lineInstances[i]
    line.Position=UDim2.fromOffset(x1,y1)
    line.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy),3)
    line.Rotation=math.deg(math.atan2(dy,dx))
   end
   for i,item in ipairs(sites) do
    local x,y=placeMarker(item.x,item.z,root.Position.X,root.Position.Z)
    pins[i].Position=UDim2.fromOffset(x,y)
    pins[i].Visible=math.abs(x)<182 and math.abs(y)<182
   end
  end
  if progress<=#points then
   local p=points[progress]
   local planar=Vector3.new(root.Position.X-p.x,0,root.Position.Z-p.z)
   if planar.Magnitude<90 then progress=progress+1 end
  end
 end
 if progress<=#points then
  missionDetail.Text=string.format("%d/3 complete • Go to %s",progress-1,points[progress].name)
 else
  missionHeader.Text="MISSION COMPLETE! 🇦🇪"
  missionDetail.Text="You explored 3 UAE districts!"
 end
 local dubaiSec=os.time()+4*3600
 liveTime.Text="DUBAI  •  "..os.date("!%H:%M",dubaiSec).." GST"
 local h=ReplicatedStorage:GetAttribute("UAECycleHour")
 if typeof(h)=="number" then
  Lighting.ClockTime=h
  local hours=math.floor(h)%24
  local minutes=math.floor((h%1)*60)
  local period=(h>=6 and h<18) and "DAY" or "NIGHT"
  gameTime.Text=string.format("GAME %02d:%02d  •  %s  |  40-MIN CYCLE",hours,minutes,period)
 else
  gameTime.Text="GAME TIME: waiting for server"
 end
end)
