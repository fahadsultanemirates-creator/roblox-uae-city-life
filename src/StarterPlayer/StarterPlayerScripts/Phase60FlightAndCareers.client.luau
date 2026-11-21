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
