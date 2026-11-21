-- UAE6: simple extra missions panel and navigation for the long journeys.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Run=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local req=RS:WaitForChild("UAE60_QuestRequest",30)
local updates=RS:WaitForChild("UAE60_QuestUpdate",30)
if not req or not updates then return end
local options={
 {"RESCUE","Ambulance Emergency Dispatch",180},
 {"POLICE","City Safety Patrol",150},
 {"FIRE","Civil Defence Rescue Drill",180},
 {"AIR","Pilot Training & City Flyover",230},
 {"HOTEL","International Tourist Transfer",170},
 {"COAST","Marina Search & Safety",170},
}
local gui=Instance.new("ScreenGui")
gui.Name="UAE60_MissionBrowser";gui.ResetOnSpawn=false
gui.DisplayOrder=78;gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(20,43,56)
local ink=Color3.fromRGB(244,227,191)
local function round(p)
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,8);c.Parent=p
end
local function button(parent,txt,x,y,w,h)
 local b=Instance.new("TextButton")
 b.Text=txt;b.Size=UDim2.fromOffset(w,h)
 b.Position=UDim2.fromOffset(x,y)
 b.BackgroundColor3=bg;b.TextColor3=ink
 b.Font=Enum.Font.GothamBold;b.TextSize=12
 b.Parent=parent;round(b);return b
end
local launch=button(gui,"BIG MISSIONS",0,0,103,33)
launch.Position=UDim2.new(1,-115,1,-236)
local panel=Instance.new("Frame")
panel.Name="MissionPanel"
panel.Size=UDim2.fromOffset(348,400)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.5)
panel.BackgroundColor3=bg
panel.Visible=false
panel.Parent=gui;round(panel)
local head=Instance.new("TextLabel")
head.Text="CITY LIFE • LONG MISSIONS"
head.Size=UDim2.new(1,-50,0,37)
head.Position=UDim2.fromOffset(12,5)
head.BackgroundTransparency=1;head.TextColor3=ink
head.Font=Enum.Font.GothamBold;head.TextSize=16
head.Parent=panel
local close=button(panel,"X",310,8,29,29)
close.Activated:Connect(function()panel.Visible=false end)
for i,q in ipairs(options) do
 local b=button(panel,q[2].."   +"..q[3].." pts",12,45+(i-1)*49,325,42)
 b.Activated:Connect(function()
  req:FireServer("Start",q[1]);panel.Visible=false
 end)
end
local cancel=button(panel,"CANCEL CURRENT LONG MISSION",12,345,325,37)
cancel.Activated:Connect(function()
 req:FireServer("Cancel","");panel.Visible=false
end)
local function toggle()
 panel.Visible=not panel.Visible
end
launch.Activated:Connect(toggle)
UIS.InputBegan:Connect(function(input,processed)
 if not processed and not UIS:GetFocusedTextBox() and input.KeyCode==Enum.KeyCode.L then
  toggle()
 end
end)
local status=Instance.new("TextLabel")
status.Name="MissionProgress"
status.AnchorPoint=Vector2.new(.5,1)
status.Position=UDim2.new(.5,0,1,-15)
status.Size=UDim2.fromOffset(380,43)
status.BackgroundColor3=bg;status.BackgroundTransparency=.13
status.TextColor3=ink;status.Font=Enum.Font.GothamBold
status.TextSize=12;status.TextWrapped=true
status.Parent=gui;status.Visible=false;round(status)
local marker=Instance.new("Part")
marker.Name="UAE60_ClientMissionBeacon"
marker.Size=Vector3.new(.2,.2,.2)
marker.Transparency=1;marker.CanCollide=false
marker.CanTouch=false;marker.CanQuery=false
marker.Anchored=true;marker.Parent=workspace
local board=Instance.new("BillboardGui")
board.Name="MissionGoldWaypoint"
board.Adornee=marker;board.Size=UDim2.fromOffset(150,38)
board.AlwaysOnTop=true;board.MaxDistance=550
board.StudsOffsetWorldSpace=Vector3.new(0,9,0)
board.Enabled=false;board.Parent=marker
local title=Instance.new("TextLabel")
title.Size=UDim2.fromScale(1,1);title.Text="NEXT STOP"
title.TextWrapped=true;title.TextScaled=true
title.Font=Enum.Font.GothamBold;title.TextColor3=ink
title.BackgroundColor3=bg;title.Parent=board;round(title)
local dest=nil
local ending=0
updates.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" then return end
 if data.status=="active" and typeof(data.position)=="Vector3" then
  dest=data
  marker.CFrame=CFrame.new(data.position)
  board.Enabled=true
  title.Text=tostring(data.name)
  status.Visible=true
 elseif data.status=="complete" or data.status=="cancelled" then
  dest=nil
  board.Enabled=false
  status.Text=tostring(data.message or "Mission ended")
  status.Visible=true
  ending=os.clock()+5
 end
end)
local ticked=0
Run.RenderStepped:Connect(function(dt)
 ticked=ticked+dt
 if ticked<.25 then return end
 ticked=0
 if dest then
  local char=player.Character
  local root=char and char:FindFirstChild("HumanoidRootPart")
  local distance=root and (root.Position-dest.position).Magnitude or 0
  status.Text=string.format("%s  %d/%d\n%s • %d studs",
   tostring(dest.title),dest.stage,dest.total,tostring(dest.name),math.floor(distance))
 elseif status.Visible and ending>0 and os.clock()>ending then
  status.Visible=false;ending=0
 end
end)
task.delay(2.5,function()
 if req.Parent then req:FireServer("Status","") end
end)
