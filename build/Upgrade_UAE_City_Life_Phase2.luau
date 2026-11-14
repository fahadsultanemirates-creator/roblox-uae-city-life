-- UAE CITY LIFE | Phase 2 world polish (run in Studio Command Bar, Edit mode)
-- Requires the Phase 1 generated Workspace.UAE_City_Life folder.
-- Preserves buildings, emergency vehicles and the four existing UAE flags.
local ws=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local StarterPlayer=game:GetService("StarterPlayer")
local world=ws:FindFirstChild("UAE_City_Life")
assert(world,"Run build/Create_UAE_City_Life.luau first, then this upgrade.")
local old=world:FindFirstChild("Phase2_GulfStyle")
if old then old:Destroy() end
local p2=Instance.new("Folder")
p2.Name="Phase2_GulfStyle"
p2.Parent=world
local function color(r,g,b) return Color3.fromRGB(r,g,b) end
local function group(name)
 local folder=Instance.new("Folder")
 folder.Name=name
 folder.Parent=p2
 return folder
end
local function block(parent,name,size,x,y,z,tint,material,collision)
 local part=Instance.new("Part")
 part.Name=name
 part.Size=size
 part.CFrame=CFrame.new(x,y,z)
 part.Color=tint or color(235,230,210)
 part.Material=material or Enum.Material.SmoothPlastic
 part.Anchored=true
 part.CanCollide=collision~=false
 part.TopSurface=Enum.SurfaceType.Smooth
 part.BottomSurface=Enum.SurfaceType.Smooth
 part.Parent=parent
 return part
end
local white=color(248,245,231)
local glass=color(73,167,190)
local gold=color(247,217,147)
local concrete=color(212,202,178)
local silver=color(145,155,157)
local road=color(48,57,63)
local palm=color(34,125,67)
local function tree(parent,x,z)
 block(parent,"Palm trunk",Vector3.new(2.6,16,2.6),x,8,z,color(135,99,63),Enum.Material.Wood)
 for _,v in ipairs({{11,0},{-11,0},{0,11},{0,-11}}) do
  block(parent,"Palm canopy",Vector3.new(18,2.2,9),x+v[1]/2,17,z+v[2]/2,palm,Enum.Material.Grass,false)
 end
end
local function sign(parent,text,x,y,z)
 local anchor=block(parent,"Sign mount",Vector3.new(1,1,1),x,y,z,white,nil,false)
 anchor.Transparency=1
 local gui=Instance.new("BillboardGui")
 gui.Size=UDim2.fromOffset(235,48)
 gui.AlwaysOnTop=true
 gui.MaxDistance=190
 gui.Adornee=anchor
 gui.Parent=anchor
 local label=Instance.new("TextLabel")
 label.Size=UDim2.fromScale(1,1)
 label.Text=text
 label.Font=Enum.Font.GothamBold
 label.TextScaled=true
 label.BackgroundColor3=color(24,46,53)
 label.BackgroundTransparency=.1
 label.TextColor3=gold
 label.Parent=gui
 local corner=Instance.new("UICorner")
 corner.CornerRadius=UDim.new(0,9)
 corner.Parent=label
end
local function tower(parent,name,x,z,h)
 block(parent,name,Vector3.new(34,h,36),x,h/2,z,concrete,Enum.Material.Concrete)
 block(parent,"Roof",Vector3.new(38,2,40),x,h+1,z,white,Enum.Material.Metal)
 for y=11,h-7,10 do
  block(parent,"Glazed facade band",Vector3.new(32,3,.8),x,y,z+18.5,glass,Enum.Material.Glass,false)
 end
end
local function streetlight(parent,x,z)
 block(parent,"Street light post",Vector3.new(.75,24,.75),x,12,z,silver,Enum.Material.Metal)
 block(parent,"Light arm",Vector3.new(9,.8,.8),x+4,24,z,silver,Enum.Material.Metal)
 local lamp=block(parent,"Warm street LED",Vector3.new(3,.6,2.2),x+8,23.5,z,gold,Enum.Material.Neon,false)
 local light=Instance.new("PointLight")
 light.Brightness=1.1
 light.Color=gold
 light.Range=26
 light.Parent=lamp
end
local marina=group("Dubai_Marina")
block(marina,"Marina teal water",Vector3.new(310,.3,172),205,.24,-675,color(32,136,166),Enum.Material.Glass,false)
block(marina,"Palm promenade",Vector3.new(330,1,25),205,.7,-567,concrete,Enum.Material.Concrete)
block(marina,"Marina seawall",Vector3.new(330,3,3),205,1.5,-583,silver,Enum.Material.Concrete)
block(marina,"Timber pier",Vector3.new(22,1,95),240,.8,-659,color(138,102,66),Enum.Material.Wood)
for _,x in ipairs({98,151,282,323}) do tree(marina,x,-542) end
for _,a in ipairs({{105,-520,61},{235,-520,76},{306,-514,49}}) do tower(marina,"Modern waterfront tower",a[1],a[2],a[3]) end
sign(marina,"DUBAI MARINA",205,29,-575)
local airport=group("UAE_Airport")
block(airport,"Airport runway",Vector3.new(65,.4,292),-660,.3,-666,road,Enum.Material.Asphalt)
for z=-788,-550,36 do
 block(airport,"Runway dashed line",Vector3.new(2,.2,18),-660,.65,z,white,Enum.Material.Neon,false)
end
tower(airport,"Airport terminal", -785,-667,28)
block(airport,"Airport terminal glass front",Vector3.new(38,20,.8),-785,16,-648,glass,Enum.Material.Glass,false)
sign(airport,"UAE AIRPORT",-770,54,-630)
local bridge=group("Marina_Bridge")
block(bridge,"Elevated bridge deck",Vector3.new(36,2,160),388,5,-675,road,Enum.Material.Asphalt)
for _,x in ipairs({369,407}) do
 block(bridge,"Bridge safety rail",Vector3.new(2,5,160),x,8,-675,white,Enum.Material.Concrete)
end
for _,z in ipairs({-740,-671,-605}) do
 block(bridge,"Bridge column",Vector3.new(7,9,7),388,0,z,silver,Enum.Material.Concrete)
end
for z=-740,-610,30 do
 block(bridge,"Bridge lane dashed line",Vector3.new(.8,.2,15),388,6.1,z,white,nil,false)
end
local city=group("Highrise_Boulevard")
for _,v in ipairs({
 {-265,-102,42},{-175,-105,58},{170,-106,42},{272,-105,62},
 {-255,164,42},{-175,162,56},{170,165,45},{270,165,58},
}) do tower(city,"Sunlit city block",v[1],v[2],v[3]) end
for x=-645,655,125 do
 if math.abs(x)>70 then
  streetlight(city,x,-7)
  streetlight(city,x,74)
 end
end
for z=-530,570,140 do
 if math.abs(z+235)>80 and math.abs(z-30)>75 then streetlight(city,62,z) end
end
local park=group("UAE_Family_Park")
block(park,"Green park",Vector3.new(145,1,92),220,.5,360,color(96,153,83),Enum.Material.Grass)
for _,p in ipairs({{172,332},{210,386},{263,334},{290,384}}) do tree(park,p[1],p[2]) end
for x=170,270,50 do block(park,"Wooden bench",Vector3.new(13,1.6,4),x,2,357,color(127,84,60),Enum.Material.Wood) end
sign(park,"UAE FAMILY PARK",223,27,361)

-- Make oversize floating labels more readable at normal viewing distances.
for _,item in ipairs(world:GetDescendants()) do
 if item:IsA("BillboardGui") and item.Name=="LocationSign" then
  local w=item.Size.X.Offset
  item.Size=UDim2.fromOffset(math.floor(w*.72),48)
  item.MaxDistance=230
 end
end
-- Disable the default template spawn if the generated UAE spawn exists.
local templateSpawn=ws:FindFirstChild("SpawnLocation")
local uaeSpawn=world:FindFirstChild("UAE Player Spawn",true)
if templateSpawn and templateSpawn:IsA("SpawnLocation") and uaeSpawn then
 templateSpawn.Enabled=false
end

for _,name in ipairs({"UAEAtmosphere","UAEBloom","UAEColorGrade","UAESunRays"}) do
 local oldEffect=Lighting:FindFirstChild(name)
 if oldEffect then oldEffect:Destroy() end
end
Lighting.ClockTime=17.3
Lighting.Brightness=2.3
Lighting.GlobalShadows=true
Lighting.ShadowSoftness=.35
Lighting.EnvironmentDiffuseScale=.65
Lighting.EnvironmentSpecularScale=.6
pcall(function() Lighting.Technology=Enum.Technology.Future end)
local atmosphere=Instance.new("Atmosphere")
atmosphere.Name="UAEAtmosphere"
atmosphere.Density=.25
atmosphere.Haze=1.1
atmosphere.Glare=.15
atmosphere.Color=color(245,214,172)
atmosphere.Decay=color(130,163,187)
atmosphere.Parent=Lighting
local grade=Instance.new("ColorCorrectionEffect")
grade.Name="UAEColorGrade"
grade.Contrast=.08
grade.Saturation=.13
grade.TintColor=color(255,244,229)
grade.Parent=Lighting
local bloom=Instance.new("BloomEffect")
bloom.Name="UAEBloom"
bloom.Intensity=.17
bloom.Size=18
bloom.Threshold=1.6
bloom.Parent=Lighting
local sun=Instance.new("SunRaysEffect")
sun.Name="UAESunRays"
sun.Intensity=.045
sun.Spread=.7
sun.Parent=Lighting

-- Install corrected third-person driving camera into StarterPlayerScripts.
local source=[========[
-- Phase 2: Third-person chase camera for UAE emergency vehicles
-- Client only. This does not replace the avatar or force camera behavior when walking.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local wasDriving = false
local function getCarAndHumanoid()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local seat = humanoid and humanoid.SeatPart
    if seat and seat:IsA("VehicleSeat") and seat.Name == "DriverSeat" then
        local model = seat.Parent
        if model and model:IsA("Model") and model:GetAttribute("UAEVehicle") == true then
            return model, humanoid
        end
    end
    return nil, humanoid
end
RunService:BindToRenderStep("UAECityVehicleChase", Enum.RenderPriority.Camera.Value + 1, function(dt)
    local car, humanoid = getCarAndHumanoid()
    local camera = workspace.CurrentCamera
    if not camera then return end
    if car then
        -- Fixed over-the-shoulder chase camera; aim ahead of driver and above roofline.
        camera.CameraType = Enum.CameraType.Scriptable
        local pivot = car:GetPivot()
        local target = (pivot * CFrame.new(0, 5, -7)).Position
        local eye = (pivot * CFrame.new(0, 17, 31)).Position
        local desired = CFrame.lookAt(eye, target)
        if not wasDriving then
            camera.CFrame = desired
        else
            camera.CFrame = camera.CFrame:Lerp(desired, math.clamp(dt * 7, 0, 1))
        end
        camera.FieldOfView = 74
        wasDriving = true
    elseif wasDriving then
        camera.CameraType = Enum.CameraType.Custom
        if humanoid then camera.CameraSubject = humanoid end
        camera.FieldOfView = 70
        wasDriving = false
    end
end)

]========]
local scripts=StarterPlayer:WaitForChild("StarterPlayerScripts")
local existing=scripts:FindFirstChild("UAE_VehicleCamera")
if existing then existing:Destroy() end
local cameraScript=Instance.new("LocalScript")
cameraScript.Name="UAE_VehicleCamera"
cameraScript.Source=source
cameraScript.Parent=scripts
print("UAE CITY LIFE PHASE 2 READY: golden-hour lighting, marina, airport, bridge, park, architecture and chase camera.")
