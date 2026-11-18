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
