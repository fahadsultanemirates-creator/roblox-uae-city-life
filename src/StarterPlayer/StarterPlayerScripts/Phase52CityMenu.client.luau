-- UAE CITY LIFE 5.2: one small CITY button opens Brookhaven-style travel and car options.
-- All important actions are validated on the server; UI does not grant assets itself.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local actions=RS:WaitForChild("UAE_V52_CityAction",30)
local feedback=RS:WaitForChild("UAE_V52_CityFeedback",30)
if not actions or not feedback then
 warn("UAE v5.2 City menu: server is not installed")
 return
end
local gui=Instance.new("ScreenGui")
gui.Name="UAE_V52_CityMenu"
gui.ResetOnSpawn=false
gui.DisplayOrder=38
gui.Parent=player:WaitForChild("PlayerGui")
local navy=Color3.fromRGB(19,43,56)
local cream=Color3.fromRGB(250,232,204)
local aqua=Color3.fromRGB(60,146,153)
local gold=Color3.fromRGB(224,171,85)
local function round(part,n)
 local obj=Instance.new("UICorner")
 obj.CornerRadius=UDim.new(0,n or 8)
 obj.Parent=part
end
local function label(parent,txt,sz,pos,size)
 local l=Instance.new("TextLabel")
 l.BackgroundTransparency=1
 l.Text=txt
 l.TextColor3=cream
 l.TextSize=sz
 l.Font=Enum.Font.GothamBold
 l.TextXAlignment=Enum.TextXAlignment.Left
 l.Position=pos
 l.Size=size
 l.Parent=parent
 return l
end
local function button(parent,txt,pos,size,bg)
 local b=Instance.new("TextButton")
 b.Text=txt
 b.Font=Enum.Font.GothamBold
 b.TextSize=12
 b.TextColor3=cream
 b.BackgroundColor3=bg or aqua
 b.Position=pos
 b.Size=size
 b.AutoButtonColor=true
 b.Parent=parent
 round(b,9)
 return b
end
local launch=button(gui,"CITY",UDim2.new(1,-85,1,-95),UDim2.fromOffset(71,37),navy)
launch.TextSize=15
local panel=Instance.new("Frame")
panel.Name="RoleplayOptions"
panel.Size=UDim2.fromOffset(342,358)
panel.AnchorPoint=Vector2.new(.5,.5)
panel.Position=UDim2.fromScale(.5,.52)
panel.BackgroundColor3=navy
panel.BackgroundTransparency=.02
panel.Visible=false
panel.BorderSizePixel=0
panel.Parent=gui
round(panel,13)
local stroke=Instance.new("UIStroke")
stroke.Color=gold
stroke.Thickness=1.4
stroke.Parent=panel
label(panel,"DUBAI • CITY LIFE",17,UDim2.fromOffset(17,9),UDim2.fromOffset(265,27))
label(panel,"Visit a district, claim a home or drive a car",11,
 UDim2.fromOffset(17,38),UDim2.fromOffset(315,19))
local close=button(panel,"X",UDim2.new(1,-45,0,9),UDim2.fromOffset(32,30),Color3.fromRGB(105,60,63))
local t1=label(panel,"PLACES",12,UDim2.fromOffset(16,68),UDim2.fromOffset(140,22))
local t2=label(panel,"YOUR VEHICLE",12,UDim2.fromOffset(177,68),UDim2.fromOffset(150,22))
local destinations={
 {"Homes & Villas","Homes"},
 {"Sheikh Zayed Road","E11"},
 {"Burj Khalifa","Downtown"},
 {"Dubai Marina","Marina"},
 {"Airport","Airport"},
}
local ride={
 {"Dubai Taxi","Taxi"},
 {"Family SUV","Family"},
 {"City Sedan","Sedan"},
 {"Remove my car","RemoveCar"},
}
local choices={}
for i,a in ipairs(destinations) do
 local b=button(panel,a[1],UDim2.fromOffset(15,94+(i-1)*45),
  UDim2.fromOffset(146,35),aqua)
 b.Activated:Connect(function()
  actions:FireServer("Travel",a[2])
  panel.Visible=false
 end)
end
for i,a in ipairs(ride) do
 local b=button(panel,a[1],UDim2.fromOffset(178,94+(i-1)*45),
  UDim2.fromOffset(147,35),i==4 and Color3.fromRGB(117,88,78) or aqua)
 b.Activated:Connect(function()
  actions:FireServer(i==4 and "RemoveCar" or "SpawnCar",a[2])
  panel.Visible=false
 end)
end
local tip=label(panel,"I = zoom in   •   O = zoom out   •   M = map",11,
 UDim2.fromOffset(17,324),UDim2.fromOffset(315,22))
local notice=label(gui,"",12,UDim2.new(.5,-160,0,66),UDim2.fromOffset(320,36))
notice.TextXAlignment=Enum.TextXAlignment.Center
notice.BackgroundTransparency=.16
notice.BackgroundColor3=navy
notice.Visible=false
round(notice,10)
local nonce=0
local function toast(msg)
 nonce=nonce+1
 local token=nonce
 notice.Text=msg
 notice.Visible=true
 task.delay(4,function()
  if nonce==token and notice.Parent then notice.Visible=false end
 end)
end
feedback.OnClientEvent:Connect(function(message)
 if typeof(message)=="string" and #message<180 then toast(message) end
end)
task.delay(2.5,function()
 if gui.Parent then toast("New Dubai district: click CITY or press B to visit!") end
end)
local function toggle()
 panel.Visible=not panel.Visible
end
launch.Activated:Connect(toggle)
close.Activated:Connect(toggle)
UIS.InputBegan:Connect(function(input,processed)
 if processed then return end
 if input.KeyCode==Enum.KeyCode.B then toggle() end
end)
