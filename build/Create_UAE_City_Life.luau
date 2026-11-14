-- ROBLOX UAE – CITY LIFE v0.1
-- Run in Roblox Studio's Command Bar, in Edit mode. No passwords, API keys or HTTP calls.
-- Re-running replaces ONLY the existing generated Workspace.UAE_City_Life map and UAE_* runtime scripts.
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local old = Workspace:FindFirstChild("UAE_City_Life")
if old then old:Destroy() end
local world = Instance.new("Folder")
world.Name = "UAE_City_Life"
world.Parent = Workspace
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local C = {
    sand=rgb(235,218,169), road=rgb(48,57,66), stripe=rgb(244,240,211),
    curb=rgb(185,185,177), dark=rgb(35,49,58), white=rgb(249,250,247),
    green=rgb(17,103,75), blue=rgb(20,120,193), red=rgb(210,37,45),
    yellow=rgb(247,209,26), glass=rgb(78,171,207), silver=rgb(160,170,172),
    sea=rgb(36,169,218), palm=rgb(40,138,74), trunk=rgb(128,92,55),
    gold=rgb(209,173,92), peach=rgb(223,177,136), grass=rgb(124,177,109),
}
local function folder(parent, name)
    local item = Instance.new("Folder")
    item.Name = name
    item.Parent = parent
    return item
end
local function block(parent, name, size, cf, color, material, collide)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = cf
    part.Anchored = true
    part.CanCollide = (collide ~= false)
    part.Color = color or C.white
    part.Material = material or Enum.Material.SmoothPlastic
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = parent
    return part
end
local function ball(parent, name, radius, pos, color, material)
    local part=block(parent,name,Vector3.new(radius*2,radius*2,radius*2),CFrame.new(pos),color,material)
    part.Shape=Enum.PartType.Ball
    return part
end
local function sign(parent, name, pos, title, color, width)
    local anchor=block(parent,name.." Sign Anchor",Vector3.new(2,2,2),CFrame.new(pos),C.white,nil,false)
    anchor.Transparency=1
    local gui=Instance.new("BillboardGui")
    gui.Name="LocationSign"
    gui.Adornee=anchor
    gui.Size=UDim2.new(0,width or 250,0,70)
    gui.StudsOffset=Vector3.new(0,2,0)
    gui.AlwaysOnTop=true
    gui.MaxDistance=430
    gui.Parent=anchor
    local text=Instance.new("TextLabel")
    text.Name="Text"
    text.Size=UDim2.fromScale(1,1)
    text.BackgroundColor3=rgb(17,42,56)
    text.BackgroundTransparency=0.14
    text.Text=title
    text.TextColor3=color or C.white
    text.TextScaled=true
    text.TextStrokeTransparency=0.55
    text.Font=Enum.Font.GothamBold
    text.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,13)
    corner.Parent=text
end
local function tree(parent,x,z)
    block(parent,"Palm trunk",Vector3.new(3,19,3),CFrame.new(x,10,z),C.trunk,Enum.Material.Wood)
    for j=0,4 do
        local ang=math.pi*2*j/5
        local dx,dz=math.cos(ang),math.sin(ang)
        block(parent,"Palm frond",Vector3.new(5,2,20),CFrame.new(x+dx*8,21,z+dz*8)*CFrame.Angles(0,-ang,math.rad(-9)),C.palm,Enum.Material.Grass,false)
    end
    ball(parent,"Palm crown",4,Vector3.new(x,22,z),C.palm,Enum.Material.Grass)
end
local function flag(parent,x,y,z)
    local g=folder(parent,"UAE Flag")
    block(g,"Red hoist",Vector3.new(3,9,0.5),CFrame.new(x-5.5,y,z),rgb(216,35,48))
    block(g,"Green stripe",Vector3.new(9,3,0.5),CFrame.new(x+0.5,y+3,z),rgb(0,127,65))
    block(g,"White stripe",Vector3.new(9,3,0.5),CFrame.new(x+0.5,y,z),rgb(252,252,250))
    block(g,"Black stripe",Vector3.new(9,3,0.5),CFrame.new(x+0.5,y-3,z),rgb(15,20,18))
end
local function road(parent,name,x,z,sx,sz)
    block(parent,name,Vector3.new(sx,0.35,sz),CFrame.new(x,0.1,z),C.road,Enum.Material.Asphalt)
    if sx>sz then
        for px=x-sx/2+16,x+sx/2-16,36 do
            block(parent,"Lane line",Vector3.new(17,.07,0.8),CFrame.new(px,0.31,z),C.stripe,nil,false)
        end
    else
        for pz=z-sz/2+16,z+sz/2-16,36 do
            block(parent,"Lane line",Vector3.new(0.8,.07,17),CFrame.new(x,0.31,pz),C.stripe,nil,false)
        end
    end
end
local function building(parent,x,z,w,h,d,color)
    block(parent,"Building",Vector3.new(w,h,d),CFrame.new(x,h/2,z),color,Enum.Material.Concrete)
    block(parent,"Roof",Vector3.new(w+4,3,d+4),CFrame.new(x,h+1.5,z),C.white,Enum.Material.Concrete)
    for i=-1,1 do
        block(parent,"Window",Vector3.new(7,8,.4),CFrame.new(x+i*w/4,h*.57,z+d/2+.27),C.glass,Enum.Material.Glass,false)
    end
end

-- Main roads and welcome
local terrain=folder(world,"TerrainAndRoads")
block(terrain,"UAE Desert Ground",Vector3.new(1750,2,1700),CFrame.new(0,-2,50),C.sand,Enum.Material.Sand)
road(terrain,"Central East-West Highway",0,30,1470,48)
road(terrain,"Central North-South Highway",0,80,48,1300)
road(terrain,"Western Emirates Road",-390,80,45,1240)
road(terrain,"Eastern Emirates Road",390,80,45,1240)
road(terrain,"Dubai-Sharjah Road",0,-235,1100,36)
road(terrain,"Northern Connector",0,335,1100,36)
for x=-600,600,150 do
    if math.abs(x)>55 then tree(terrain,x,-4) end
end
for z=-540,650,130 do
    if math.abs(z-30)>65 and math.abs(z+235)>55 then tree(terrain,58,z) end
end
local hub=folder(world,"WelcomePlaza")
block(hub,"Welcome Plaza",Vector3.new(180,1,125),CFrame.new(0,.6,123),C.white,Enum.Material.Concrete)
local spawn=Instance.new("SpawnLocation")
spawn.Name="UAE Player Spawn"
spawn.Size=Vector3.new(24,1,24)
spawn.CFrame=CFrame.new(0,1.6,143)
spawn.Anchored=true
spawn.Neutral=true
spawn.Duration=0
spawn.Color=C.green
spawn.Material=Enum.Material.Neon
spawn.Parent=hub
sign(hub,"Welcome",Vector3.new(0,17,170),"WELCOME TO UAE CITY LIFE 🇦🇪",C.gold,510)
for _,p in ipairs({{-74,112},{75,113},{-74,168},{74,168}}) do tree(hub,p[1],p[2]) end

-- Dubai
local dubai=folder(world,"01_Dubai")
block(dubai,"Downtown Dubai Plaza",Vector3.new(320,1,280),CFrame.new(0,.5,-385),C.curb,Enum.Material.Concrete)
local level=0
for i=1,13 do
    local h=23
    local w=math.max(8,58-i*3.6)
    local p=block(dubai,"Burj Khalifa - tier "..i,Vector3.new(w,h,w),CFrame.new(-84,level+h/2,-392),i%2==0 and C.glass or rgb(112,169,187),Enum.Material.Glass)
    p.Reflectance=.12
    level=level+h
end
block(dubai,"Burj Khalifa - spire",Vector3.new(3,55,3),CFrame.new(-84,level+27.5,-392),C.silver,Enum.Material.Metal)
sign(dubai,"Burj Khalifa",Vector3.new(-84,65,-320),"BURJ KHALIFA",C.white,280)
building(dubai,100,-399,148,38,110,C.peach)
sign(dubai,"Dubai Mall",Vector3.new(105,49,-339),"DUBAI MALL",C.gold,240)
flag(dubai,100,28,-343) -- Flag 1, on mall
for _,p in ipairs({{-150,-280},{165,-280},{-150,-505},{160,-505}}) do tree(dubai,p[1],p[2]) end

-- Abu Dhabi
local abu=folder(world,"02_AbuDhabi")
block(abu,"Abu Dhabi Plaza",Vector3.new(298,1,275),CFrame.new(-390,.4,-380),C.curb,Enum.Material.Concrete)
building(abu,-390,-396,125,28,106,C.white)
for _,offset in ipairs({{-70,-52},{70,-52},{-70,52},{70,52}}) do
    local x,z=-390+offset[1],-396+offset[2]
    block(abu,"Mosque minaret",Vector3.new(9,78,9),CFrame.new(x,39,z),C.white,Enum.Material.Marble)
    ball(abu,"Minaret finial",6,Vector3.new(x,80,z),C.gold,Enum.Material.Metal)
end
for _,dx in ipairs({-39,0,39}) do ball(abu,"Grand Mosque dome",21,Vector3.new(-390+dx,38,-396),C.white,Enum.Material.Marble) end
sign(abu,"Abu Dhabi",Vector3.new(-390,78,-275),"ABU DHABI • GRAND MOSQUE",C.white,330)
building(abu,-495,-295,38,30,40,C.peach)
flag(abu,-495,18,-274.7) -- Flag 2, building facade

-- Sharjah
local sharjah=folder(world,"03_Sharjah")
block(sharjah,"Sharjah Square",Vector3.new(300,1,265),CFrame.new(390,.4,-380),C.curb,Enum.Material.Concrete)
building(sharjah,387,-398,150,45,100,rgb(219,200,166))
sign(sharjah,"Sharjah",Vector3.new(390,60,-319),"SHARJAH • HERITAGE",C.gold,260)
flag(sharjah,387,30,-347.7) -- Flag 3, heritage building
for _,p in ipairs({{270,-289},{510,-290},{280,-490},{504,-490}}) do tree(sharjah,p[1],p[2]) end

-- Ajman
local ajman=folder(world,"04_Ajman")
block(ajman,"Ajman Beach",Vector3.new(280,.25,110),CFrame.new(390,.2,206),C.sea,Enum.Material.Glass,false)
block(ajman,"Beach sand",Vector3.new(285,.5,56),CFrame.new(390,.5,290),C.sand,Enum.Material.Sand)
building(ajman,315,176,92,26,45,rgb(242,215,173))
flag(ajman,315,17,199) -- Flag 4, beachside building
sign(ajman,"Ajman",Vector3.new(405,50,276),"AJMAN • BEACH",C.white,240)
for _,x in ipairs({290,340,475,505}) do tree(ajman,x,312) end

-- Umm Al Quwain
local uaq=folder(world,"05_UmmAlQuwain")
block(uaq,"Umm Al Quwain Lagoon",Vector3.new(305,.3,140),CFrame.new(-390,.2,227),C.sea,Enum.Material.Glass,false)
block(uaq,"Lagoon Boardwalk",Vector3.new(240,1,25),CFrame.new(-390,.7,317),C.trunk,Enum.Material.Wood)
sign(uaq,"Umm Al Quwain",Vector3.new(-390,32,323),"UMM AL QUWAIN • LAGOON",C.white,330)
for _,x in ipairs({-510,-440,-345,-275}) do tree(uaq,x,340) end

-- Ras Al Khaimah
local rak=folder(world,"06_RasAlKhaimah")
for i=1,7 do
    local x=300+(i-1)*40
    local mountain=Instance.new("WedgePart")
    mountain.Name="Jebel Jais-inspired Mountain"
    mountain.Size=Vector3.new(53,65+(i%3)*20,95)
    mountain.CFrame=CFrame.new(x,mountain.Size.Y/2,595)*CFrame.Angles(0,math.rad(i*25),0)
    mountain.Color=rgb(140,116,96)
    mountain.Material=Enum.Material.Slate
    mountain.Anchored=true
    mountain.Parent=rak
end
sign(rak,"Ras Al Khaimah",Vector3.new(410,85,535),"RAS AL KHAIMAH • JEBEL JAIS",C.white,370)

-- Fujairah
local fuj=folder(world,"07_Fujairah")
block(fuj,"Fujairah Fort",Vector3.new(125,30,87),CFrame.new(-390,15,580),rgb(201,151,102),Enum.Material.Sandstone)
for _,offset in ipairs({{-56,-40},{56,-40},{-56,40},{56,40}}) do
    block(fuj,"Fort tower",Vector3.new(19,53,19),CFrame.new(-390+offset[1],27,580+offset[2]),rgb(181,126,82),Enum.Material.Sandstone)
end
for j=1,3 do
    local mountain=Instance.new("WedgePart")
    mountain.Name="Fujairah Mountains"
    mountain.Size=Vector3.new(78,85,90)
    mountain.CFrame=CFrame.new(-570+j*90,42,675)
    mountain.Color=rgb(138,116,93)
    mountain.Material=Enum.Material.Slate
    mountain.Anchored=true
    mountain.Parent=fuj
end
sign(fuj,"Fujairah",Vector3.new(-390,78,529),"FUJAIRAH • FORT & MOUNTAINS",C.white,340)

-- Three original block-model emergency vehicles: approximate prototypes, not photo-accurate meshes.
local vehicles=folder(world,"EmergencyVehicles")
local function createVehicle(title,category,x,z,length,mainColor)
    local model=Instance.new("Model")
    model.Name=title
    model:SetAttribute("UAEVehicle",true)
    model:SetAttribute("VehicleType",category)
    model.Parent=vehicles
    local origin=CFrame.new(x,0,z)
    local function part(name,size,offset,color,material)
        return block(model,name,size,origin*CFrame.new(offset),color,material,false)
    end
    local chassis=part("Chassis",Vector3.new(10,1.3,length),Vector3.new(0,3.4,0),C.dark,Enum.Material.Metal)
    model.PrimaryPart=chassis
    part("Body",Vector3.new(10,4.2,length-2),Vector3.new(0,5.8,0),mainColor)
    for _,side in ipairs({-1,1}) do
        for _,zf in ipairs({-.31,.31}) do
            local wheel=part("Wheel",Vector3.new(2.8,5.2,5.2),Vector3.new(side*5.1,2.8,zf*length),rgb(21,23,24),Enum.Material.Rubber)
            wheel.Shape=Enum.PartType.Cylinder
            local hub=part("Wheel hub",Vector3.new(2.9,2.1,2.1),Vector3.new(side*5.14,2.8,zf*length),C.silver,Enum.Material.Metal)
            hub.Shape=Enum.PartType.Cylinder
        end
    end
    part("Windshield",Vector3.new(8.4,3.1,.35),Vector3.new(0,7,-length/2+1.2),C.glass,Enum.Material.Glass)
    part("Rear window",Vector3.new(8.4,2,.35),Vector3.new(0,7,length/2-1.2),C.glass,Enum.Material.Glass)
    for _,side in ipairs({-1,1}) do
        part("Headlight",Vector3.new(1.8,.9,.5),Vector3.new(side*3.3,4.5,-length/2-.18),rgb(255,247,177),Enum.Material.Neon)
        part("Brake light",Vector3.new(1.6,.9,.5),Vector3.new(side*3.3,4.6,length/2+.1),C.red,Enum.Material.Neon)
    end
    local seat=Instance.new("VehicleSeat")
    seat.Name="DriverSeat"
    seat.Size=Vector3.new(3.3,.8,3)
    seat.CFrame=origin*CFrame.new(0,7,-1.4)
    seat.Transparency=1
    seat.Anchored=true
    seat.CanCollide=false
    seat.MaxSpeed=0
    seat.Parent=model
    local prompt=Instance.new("ProximityPrompt")
    prompt.Name="EntryPrompt"
    prompt.ActionText="Drive "..title
    prompt.ObjectText="UAE Emergency Vehicle"
    prompt.MaxActivationDistance=17
    prompt.RequiresLineOfSight=false
    prompt.HoldDuration=0
    prompt.Parent=seat
    return model,part
end
local police,p=createVehicle("Green Police SUV","Police",-62,67,19,C.white)
for _,side in ipairs({-1,1}) do
    p("Dark green doors",Vector3.new(.3,3.2,8),Vector3.new(side*5.12,6.3,0),C.green)
    p("Green side stripe",Vector3.new(.32,.65,16),Vector3.new(side*5.13,4.7,0),C.green)
end
p("Police white roof",Vector3.new(10,1,10),Vector3.new(0,8.35,0),C.white)
p("Blue police lightbar",Vector3.new(7,.8,1.8),Vector3.new(0,9.25,0),C.blue,Enum.Material.Neon)
local ambulance,a=createVehicle("Blue White Ambulance","Ambulance",0,67,25,C.white)
a("Ambulance blue lower side",Vector3.new(10.3,2,23),Vector3.new(0,4.65,.15),C.blue)
a("Ambulance white roof",Vector3.new(10.5,1,17),Vector3.new(0,8.5,2.3),C.white)
for _,side in ipairs({-1,1}) do
    a("Medical red marking",Vector3.new(.35,.75,13),Vector3.new(side*5.3,7,1.5),C.red)
end
a("Red medical roof light",Vector3.new(4,.7,1.7),Vector3.new(-2,9.25,-4),C.red,Enum.Material.Neon)
a("Blue medical roof light",Vector3.new(4,.7,1.7),Vector3.new(2,9.25,-4),C.blue,Enum.Material.Neon)
local fire,f=createVehicle("Yellow Civil Defence Truck","Fire",70,67,30,C.yellow)
f("Tall equipment body",Vector3.new(10.5,4.5,17),Vector3.new(0,8,5),C.yellow)
for _,side in ipairs({-1,1}) do
    for i=-1,1 do
        f("Grey equipment locker",Vector3.new(.3,3.7,4.7),Vector3.new(side*5.43,8.25,5+i*5.1),C.silver,Enum.Material.Metal)
        f("Red reflective stripe",Vector3.new(.39,.65,4.7),Vector3.new(side*5.49,5.1,5+i*5.1),C.red,Enum.Material.Neon)
    end
end
f("Fire engine roof",Vector3.new(10.6,.8,14),Vector3.new(0,10.5,5),C.white)
f("Fire blue emergency lights",Vector3.new(7,1.1,2),Vector3.new(0,9.5,-9.5),C.blue,Enum.Material.Neon)
sign(world,"Vehicle area",Vector3.new(0,23,36),"POLICE  |  AMBULANCE  |  FIRE",C.gold,480)
Lighting.ClockTime=14.2
Lighting.Brightness=2
Lighting.Ambient=rgb(155,172,185)
Lighting.OutdoorAmbient=rgb(170,189,192)

-- Install runtime scripts in the selected Roblox place (Studio command bar permissions needed)
local function installScript(class,parent,name,source)
    local prior=parent:FindFirstChild(name)
    if prior then prior:Destroy() end
    local s=Instance.new(class)
    s.Name=name
    s.Source=source
    s.Parent=parent
end
installScript("Script",game:GetService("ServerScriptService"),"UAE_Driving",[======[
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local vehicles=workspace:WaitForChild("UAE_City_Life"):WaitForChild("EmergencyVehicles")
local remote=ReplicatedStorage:FindFirstChild("UAE_DriveInput")
if not remote then
    remote=Instance.new("RemoteEvent")
    remote.Name="UAE_DriveInput"
    remote.Parent=ReplicatedStorage
end
local controls={}
local speeds={Police=40,Ambulance=35,Fire=28}
local function carFromSeat(seat)
    if typeof(seat)~="Instance" or not seat:IsA("VehicleSeat") then return nil end
    local model=seat.Parent
    if not model or not model:IsA("Model") then return nil end
    if model.Parent~=vehicles or model:GetAttribute("UAEVehicle")~=true then return nil end
    if model:FindFirstChild("DriverSeat")~=seat then return nil end
    return model
end
remote.OnServerEvent:Connect(function(player,seat,throttle,steer)
    local car=carFromSeat(seat)
    if not car then return end
    local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or seat.Occupant~=humanoid then return end
    if typeof(throttle)~="number" or typeof(steer)~="number" then return end
    if throttle~=throttle or steer~=steer then return end
    controls[car]={throttle=math.clamp(throttle,-1,1),steer=math.clamp(steer,-1,1),updated=os.clock()}
end)
for _,obj in ipairs(vehicles:GetDescendants()) do
    if obj:IsA("VehicleSeat") then
        local car=carFromSeat(obj)
        if car then
            local prompt=obj:FindFirstChild("EntryPrompt")
            if prompt then prompt.Triggered:Connect(function(player)
                local humanoid=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health>0 and obj.Occupant==nil then obj:Sit(humanoid) end
            end) end
            obj:GetPropertyChangedSignal("Occupant"):Connect(function()
                if not obj.Occupant then controls[car]=nil end
            end)
        end
    end
end
RunService.Heartbeat:Connect(function(dt)
    dt=math.min(dt,.1)
    for car,ctrl in pairs(controls) do
        if not car.Parent then controls[car]=nil else
            local seat=car:FindFirstChild("DriverSeat")
            if not seat or not seat.Occupant or os.clock()-ctrl.updated>.55 then controls[car]=nil else
                local speed=ctrl.throttle*(speeds[car:GetAttribute("VehicleType")] or 30)*dt
                local turn=math.rad(54)*ctrl.steer*dt
                car:PivotTo(car:GetPivot()*CFrame.Angles(0,-turn,0)*CFrame.new(0,0,-speed))
            end
        end
    end
end)
]======])
installScript("Script",game:GetService("ServerScriptService"),"UAE_OwnerTag",[======[
local Players=game:GetService("Players")
local OWNER_USERNAME="Muhammadsultan59966"
local function onCharacter(player,character)
    if string.lower(player.Name)~=string.lower(OWNER_USERNAME) then return end
    local head=character:WaitForChild("Head",10)
    if not head then return end
    local tag=Instance.new("BillboardGui")
    tag.Name="UAEGameOwnerTag"
    tag.Size=UDim2.new(0,190,0,48)
    tag.StudsOffset=Vector3.new(0,3.2,0)
    tag.AlwaysOnTop=true
    tag.Adornee=head
    tag.Parent=head
    local label=Instance.new("TextLabel")
    label.BackgroundTransparency=1
    label.Size=UDim2.fromScale(1,1)
    label.Font=Enum.Font.GothamBold
    label.TextScaled=true
    label.TextColor3=Color3.fromRGB(255,235,125)
    label.TextStrokeTransparency=.25
    label.Text="👑 GAME OWNER"
    label.Parent=tag
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character) onCharacter(player,character) end)
end)
]======])
installScript("LocalScript",game:GetService("StarterPlayer").StarterPlayerScripts,"UAE_DrivingInput",[======[
local UserInputService=game:GetService("UserInputService")
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local remote=ReplicatedStorage:WaitForChild("UAE_DriveInput")
local player=Players.LocalPlayer
local function pressed(key) return UserInputService:IsKeyDown(key) and 1 or 0 end
while true do
    task.wait(.12)
    if not UserInputService:GetFocusedTextBox() then
        local character=player.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local seat=humanoid and humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") and seat.Name=="DriverSeat" then
            local car=seat.Parent
            if car and car:GetAttribute("UAEVehicle")==true then
                remote:FireServer(seat,pressed(Enum.KeyCode.W)-pressed(Enum.KeyCode.S),
                    pressed(Enum.KeyCode.D)-pressed(Enum.KeyCode.A))
            end
        end
    end
end
]======])
installScript("LocalScript",game:GetService("StarterPlayer").StarterPlayerScripts,"UAE_Welcome",[======[
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="UAECityWelcome"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel")
label.Name="WelcomeMessage"
label.AnchorPoint=Vector2.new(.5,0)
label.Position=UDim2.fromScale(.5,.035)
label.Size=UDim2.new(.8,0,0,80)
label.BackgroundColor3=Color3.fromRGB(13,67,67)
label.BackgroundTransparency=.12
label.TextColor3=Color3.new(1,1,1)
label.Font=Enum.Font.GothamBold
label.TextScaled=true
label.TextWrapped=true
label.Text="🇦🇪 Welcome to Roblox UAE – City Life! Explore 7 emirates. Press E near a vehicle to drive; W/A/S/D to steer."
label.Parent=gui
local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,12)
corner.Parent=label
task.delay(13,function() if gui.Parent then gui:Destroy() end end)
]======])
print("ROBLOX UAE – CITY LIFE: generated seven emirates, Burj Khalifa, Dubai Mall, four UAE flags and three prototype emergency vehicles.")
