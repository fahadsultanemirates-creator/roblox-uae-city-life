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
