-- v5.5 visual pass: tuned PBR-like Roblox materials, atmosphere and detail.
-- No external meshes or copyrighted assets. Keep geometry budget bounded.
local Lighting=game:GetService("Lighting")
local W=game:GetService("Workspace")
local world=W:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local visuals=Instance.new("Folder")
visuals.Name="GraphicsAndStreets"
visuals.Parent=root
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
Lighting.Technology=Enum.Technology.Future
Lighting.GlobalShadows=true
Lighting.ShadowSoftness=.42
Lighting.EnvironmentDiffuseScale=.65
Lighting.EnvironmentSpecularScale=.75
Lighting.ExposureCompensation=-.08
Lighting.Brightness=2.3
local function effect(class,name)
 local e=Lighting:FindFirstChild(name)
 if not e then e=Instance.new(class);e.Name=name;e.Parent=Lighting end
 return e
end
local atmosphere=effect("Atmosphere","UAE55_DesertAir")
atmosphere.Density=.22
atmosphere.Offset=.14
atmosphere.Color=rgb(220,218,207)
atmosphere.Decay=rgb(164,180,194)
atmosphere.Glare=.19
atmosphere.Haze=1.1
local color=effect("ColorCorrectionEffect","UAE55_CinemaGrade")
color.Brightness=.012
color.Contrast=.10
color.Saturation=.08
color.TintColor=rgb(255,245,231)
local bloom=effect("BloomEffect","UAE55_NightBloom")
bloom.Intensity=.16
bloom.Size=18
bloom.Threshold=1.8
local rays=effect("SunRaysEffect","UAE55_SunRays")
rays.Intensity=.035
rays.Spread=.65
local function part(parent,name,size,cf,color,material,solid)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.CFrame=cf;p.Anchored=true
 p.Color=color;p.Material=material;p.CanCollide=solid==true
 p.CastShadow=solid==true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function light(x,z)
 local pole=part(visuals,"Realistic boulevard lamp",Vector3.new(.65,17,.65),
  CFrame.new(x,9,z),rgb(116,123,128),Enum.Material.Metal,false)
 local arm=part(visuals,"LED streetlight arm",Vector3.new(7,.55,.8),
  CFrame.new(x+3,17.5,z),rgb(120,130,138),Enum.Material.Metal,false)
 local led=part(visuals,"Warm LED lamp",Vector3.new(3,.22,1.2),
  CFrame.new(x+5,17.15,z),rgb(255,224,163),Enum.Material.Neon,false)
 local point=Instance.new("PointLight")
 point.Name="UAE55NightLamp";point.Brightness=1.3;point.Range=36
 point.Color=rgb(255,229,181);point.Enabled=false;point.Parent=led
end
-- Build a handful of recognizable urban details rather than a heavy city-wide clone.
for _,z in ipairs({-1450,-1370,-1290,-1210,-1130,-1050,-970}) do
 for _,x in ipairs({-100,100}) do light(x,z) end
end
for _,z in ipairs({-1420,-1280,-1140,-1000}) do
 for _,x in ipairs({-120,120}) do
  part(visuals,"Roadside concrete planter",Vector3.new(15,2.1,7),
   CFrame.new(x,1.5,z),rgb(190,184,170),Enum.Material.Concrete,true)
  part(visuals,"Planter greenery",Vector3.new(13,1.2,5),
   CFrame.new(x,3.1,z),rgb(48,112,72),Enum.Material.Grass,false)
 end
end
-- Existing towers: subtle material improvement, without overwriting all building colors.
local count=0
for _,item in ipairs(world:GetDescendants()) do
 if item:IsA("BasePart") and item.Parent~=visuals then
  if item.Material==Enum.Material.Glass then
   item.Reflectance=math.min(item.Reflectance,.12)
   if item.Transparency<.1 then item.Transparency=.08 end
   count=count+1
  elseif item.Material==Enum.Material.Asphalt then
   item.Reflectance=0
  end
 end
end
local RS=game:GetService("ReplicatedStorage")
task.spawn(function()
 while root.Parent do
  local hour=RS:GetAttribute("UAECycleHour")
  local night=typeof(hour)=="number" and (hour>=18 or hour<6)
  for _,obj in ipairs(visuals:GetDescendants()) do
   if obj:IsA("PointLight") and obj.Name=="UAE55NightLamp" then
    obj.Enabled=night
   end
  end
  task.wait(8)
 end
end)
print("[v5.5] Visual pass: Future lighting, atmospheric grade, street detail; glass panels updated:",count)
