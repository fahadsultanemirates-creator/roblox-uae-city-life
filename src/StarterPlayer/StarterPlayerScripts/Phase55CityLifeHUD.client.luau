-- UAE City Life v5.5: compact feedback/UI for city services and traffic incident response.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local remote=RS:WaitForChild("UAE55_ServiceStatus",30)
if not remote then warn("[UAE v5.5] Services server event missing");return end
local gui=Instance.new("ScreenGui")
gui.Name="UAE55_ServiceHUD";gui.ResetOnSpawn=false;gui.DisplayOrder=39
gui.Parent=player:WaitForChild("PlayerGui")
local bg=Color3.fromRGB(22,47,61)
local tint=Color3.fromRGB(248,223,174)
local fg=Color3.fromRGB(236,246,243)
local function corner(obj,r)
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=obj
end
local function label(par,s,size,pos,bounds,color)
 local t=Instance.new("TextLabel")
 t.Text=s;t.TextSize=size;t.Font=Enum.Font.GothamSemibold
 t.TextColor3=color or tint;t.BackgroundTransparency=1
 t.TextWrapped=true;t.TextXAlignment=Enum.TextXAlignment.Left
 t.Position=pos;t.Size=bounds;t.Parent=par;return t
end
local btn=Instance.new("TextButton")
btn.Name="CityLifeInfoButton";btn.Text="LIFE  •  L"
btn.Font=Enum.Font.GothamBold;btn.TextSize=12;btn.TextColor3=fg
btn.Size=UDim2.fromOffset(90,30);btn.Position=UDim2.new(1,-183,0,54)
btn.BackgroundColor3=bg;btn.Parent=gui;corner(btn,8)
local pop=Instance.new("Frame")
pop.Name="ServiceInstructions";pop.BackgroundColor3=bg
pop.Size=UDim2.fromOffset(274,278);pop.Position=UDim2.new(1,-286,0,89)
pop.BorderSizePixel=0;pop.Visible=false;pop.Parent=gui;corner(pop,12)
label(pop,"LIVING CITY  •  SERVICES",14,UDim2.fromOffset(11,7),
 UDim2.fromOffset(255,23),tint)
label(pop,"HOSPITAL: check in → treatment\nHOTEL: book room → rest\nAIRPORT: check in → boarding transfer\nPOLICE / CIVIL DEFENCE: accept road rescue\nACCIDENT: inspect → clear → repair\nUse E when near a service desk.\nSearch for these places in MAP / M.",11,
 UDim2.fromOffset(11,33),UDim2.fromOffset(252,142),fg)
local travelRemote=RS:WaitForChild("UAE55_ServiceTravel",25)
local destinations={
 {"HOSPITAL","Hospital"},{"HOTEL","Hotel"},{"AIRPORT","Airport"},
 {"POLICE","Police"},{"ACCIDENT","Incident"}
}
for i,entry in ipairs(destinations) do
 local b=Instance.new("TextButton")
 b.Name="Travel_"..entry[2]
 b.Text=entry[1]
 b.Font=Enum.Font.GothamBold
 b.TextSize=10;b.TextColor3=fg
 b.BackgroundColor3=Color3.fromRGB(50,117,126)
 b.Size=UDim2.fromOffset(80,31)
 b.Position=UDim2.fromOffset(10+((i-1)%3)*87,179+math.floor((i-1)/3)*38)
 b.Parent=pop
 corner(b,7)
 b.Activated:Connect(function()
  pop.Visible=false
  if travelRemote then travelRemote:FireServer(entry[2]) end
 end)
end
label(pop,"FAST TRAVEL • click a destination",
 10,UDim2.fromOffset(11,256),UDim2.fromOffset(252,16),tint)
btn.Activated:Connect(function() pop.Visible=not pop.Visible end)
UIS.InputBegan:Connect(function(input,processed)
 if processed or UIS:GetFocusedTextBox() then return end
 if input.KeyCode==Enum.KeyCode.L then pop.Visible=not pop.Visible end
end)
local news=Instance.new("Frame")
news.Name="CityServiceFeedback";news.Size=UDim2.fromOffset(310,65)
news.AnchorPoint=Vector2.new(.5,0);news.Position=UDim2.new(.5,0,0,67)
news.BackgroundColor3=bg;news.BackgroundTransparency=.06
news.BorderSizePixel=0;news.Parent=gui;news.Visible=false
corner(news,11)
local h=label(news,"CITY SERVICES",13,UDim2.fromOffset(10,4),
 UDim2.new(1,-20,0,22),tint)
local body=label(news,"",11,UDim2.fromOffset(10,24),
 UDim2.new(1,-20,1,-27),fg)
local route=Instance.new("Frame")
route.Name="ServiceRoute";route.AnchorPoint=Vector2.new(1,1)
route.Position=UDim2.new(1,-11,1,-58);route.Size=UDim2.fromOffset(205,39)
route.BackgroundColor3=bg;route.Parent=gui;route.Visible=false;corner(route,9)
local routeText=label(route,"",10,UDim2.fromOffset(8,4),
 UDim2.new(1,-15,1,-8),tint)
local destination=nil
local destinationName=nil
local revision=0
remote.OnClientEvent:Connect(function(data)
 if typeof(data)~="table" then return end
 if typeof(data.title)~="string" or typeof(data.message)~="string" then return end
 if #data.message>280 then return end
 h.Text=data.title;body.Text=data.message
 news.Visible=true
 revision=revision+1
 local token=revision
 task.delay(7,function()
  if news.Parent and revision==token then news.Visible=false end
 end)
 if typeof(data.destination)=="Vector3" then
  destination=data.destination
  destinationName=data.destinationName or "Your destination"
 else
  destination=nil
  destinationName=nil
  route.Visible=false
 end
end)
task.spawn(function()
 while gui.Parent do
  task.wait(.35)
  local character=player.Character
  local playerRoot=character and character:FindFirstChild("HumanoidRootPart")
  if destination and playerRoot then
   local diff=destination-playerRoot.Position
   local dist=Vector2.new(diff.X,diff.Z).Magnitude
   route.Visible=true
   routeText.Text=string.format("SERVICE GPS • %s\n%d studs away",
    destinationName or "City destination",math.floor(dist))
   if dist<22 then routeText.Text="You've reached: "..(destinationName or "Destination") end
  else
   route.Visible=false
  end
 end
end)
print("[UAE v5.5] Compact City Life HUD running; press L for service instructions")
