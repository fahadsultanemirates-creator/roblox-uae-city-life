-- UAE CITY LIFE 6.0: visual fleet overhaul on existing V4/V5 anchored driving rigs.
-- Cars retain the old scripted driver system. These are higher-detail procedural
-- models, NOT fully sprung mesh chassis. Old "tyre legs" are hidden, wheel
-- cylinders re-positioned at physically sensible local x/z spots.
local world=workspace:WaitForChild("UAE_City_Life")
local cars=world:WaitForChild("EmergencyVehicles")
local expansion=world:WaitForChild("Phase60_ProductionPass")
local fleet=Instance.new("Folder")
fleet.Name="VehicleArtAndGarages"
fleet.Parent=expansion
local Colors={
 white=Color3.fromRGB(240,242,239),black=Color3.fromRGB(24,28,33),
 dark=Color3.fromRGB(32,58,68),blue=Color3.fromRGB(38,93,151),
 green=Color3.fromRGB(19,91,73),red=Color3.fromRGB(196,42,45),
 gold=Color3.fromRGB(235,178,79),silver=Color3.fromRGB(169,179,183),
 glass=Color3.fromRGB(73,136,169),light=Color3.fromRGB(255,239,193),
 tyre=Color3.fromRGB(20,23,27),metal=Color3.fromRGB(115,122,127),
}
local processed=setmetatable({},{__mode="k"})
local function part(parent,name,sz,cf,col,mat)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Anchored=true
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.Color=col;p.Material=mat or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local function wedge(parent,name,sz,cf,col)
 local p=Instance.new("WedgePart")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Anchored=true
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
 p.Color=col;p.Material=Enum.Material.Metal;p.Parent=parent;return p
end
local function label(parent,text,sz,cf,bg)
 local p=part(parent,"Service bilingual lettering",sz,cf,bg,Enum.Material.Metal)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=55
 gui.Parent=p
 local t=Instance.new("TextLabel")
 t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1
 t.TextColor3=Colors.white;t.Font=Enum.Font.GothamBold
 t.TextScaled=true;t.TextWrapped=true;t.Text=text;t.Parent=gui
 return p
end
local function inferClass(model)
 local title=string.lower(model.Name)
 local kind=tostring(model:GetAttribute("VehicleType") or "")
 local all=title.." "..string.lower(kind)
 if all:find("ambul",1,true) or all:find("medical",1,true) then return "Ambulance" end
 if all:find("fire",1,true) or all:find("defence",1,true) or
  all:find("rescue",1,true) then return "Fire" end
 if all:find("police",1,true) or all:find("patrol",1,true) then return "Police" end
 if all:find("bus",1,true) then return "Bus" end
 if all:find("taxi",1,true) then return "Taxi" end
 if all:find("suv",1,true) or all:find("family",1,true) then return "SUV" end
 if all:find("car",1,true) or all:find("sedan",1,true) then return "Sedan" end
 return nil
end
local function classifyDimensions(model,class)
 local bmin,bmax=Vector3.new(100,100,100),Vector3.new(-100,-100,-100)
 local pivot=model:GetPivot()
 local pieces=0
 -- Only large body panels and seats, not billboards, wheels or light bars.
 for _,obj in ipairs(model:GetDescendants()) do
  if obj:IsA("BasePart") and not string.find(string.lower(obj.Name),"wheel") and
   not string.find(string.lower(obj.Name),"tyre") and
   not string.find(string.lower(obj.Name),"rim") and
   obj.Size.X>=2 and obj.Size.Z>=3 and
   obj.Size.Y>=.8 and obj.Size.Y<=18 then
   local rel=pivot:PointToObjectSpace(obj.Position)
   bmin=Vector3.new(math.min(bmin.X,rel.X-obj.Size.X*.5),
    math.min(bmin.Y,rel.Y-obj.Size.Y*.5),math.min(bmin.Z,rel.Z-obj.Size.Z*.5))
   bmax=Vector3.new(math.max(bmax.X,rel.X+obj.Size.X*.5),
    math.max(bmax.Y,rel.Y+obj.Size.Y*.5),math.max(bmax.Z,rel.Z+obj.Size.Z*.5))
   pieces=pieces+1
  end
 end
 local length=class=="Fire" and 34 or class=="Ambulance" and 25 or
  class=="Bus" and 37 or class=="SUV" and 23 or 19
 local width=class=="Fire" and 12.5 or class=="Ambulance" and 11.5 or
  class=="Bus" and 12 or 9.7
 if pieces>=2 then
  -- Ignore massive stray bounds from parked scenery and long ropes.
  local detectedX=math.abs(bmax.X-bmin.X)
  local detectedZ=math.abs(bmax.Z-bmin.Z)
  if detectedX>=6 and detectedX<=20 then width=detectedX end
  if detectedZ>=13 and detectedZ<=49 then length=detectedZ end
 end
 return math.clamp(width,8,14),math.clamp(length,17,44)
end
local function style(model,class)
 if processed[model] then return end
 processed[model]=true
 if not model:IsA("Model") or model:GetAttribute("UAE60NoArt") then return end
 local pivot=model:GetPivot()
 local width,length=classifyDimensions(model,class)
 -- Old wheels are often flat Cuboid parts standing like legs; hide, not destroy.
 for _,item in ipairs(model:GetDescendants()) do
  if item:IsA("BasePart") and (
   string.find(string.lower(item.Name),"tyre") or
   string.find(string.lower(item.Name),"tire") or
   string.find(string.lower(item.Name),"wheel") or
   string.find(string.lower(item.Name),"rim") ) then
   item.Transparency=1
   item.CanCollide=false
  end
 end
 local art=Instance.new("Model")
 art.Name="UAE60_RefinedBody"
 art.Parent=model
 local cf=function(x,y,z) return pivot*CFrame.new(x,y,z) end
 local carBody=class=="Police" and Colors.white or
  class=="Ambulance" and Colors.white or
  class=="Fire" and Colors.gold or
  class=="Taxi" and Color3.fromRGB(235,224,195) or
  class=="SUV" and Color3.fromRGB(200,210,214) or
  class=="Bus" and Color3.fromRGB(242,235,218) or Color3.fromRGB(65,132,156)
 -- Thin shaped body overlays, not a giant visible box that hides wheels.
 part(art,"Lower body sill",Vector3.new(width-.4,1.1,length-.4),
  cf(0,3.2,0),Colors.black,Enum.Material.Metal)
 part(art,"Refined painted flank",Vector3.new(width-.3,1.8,length-.9),
  cf(0,4.35,0),carBody,Enum.Material.Metal)
 local short=class=="Sedan" or class=="Taxi" or class=="Police" or class=="SUV"
 if short then
  part(art,"Upper cabin front",Vector3.new(width-1.8,2.8,length*.46),
   cf(0,7.0,1.4),Colors.glass,Enum.Material.Glass)
  part(art,"Body color roof",Vector3.new(width-1.4,.65,length*.46),
   cf(0,8.7,1.4),carBody,Enum.Material.Metal)
  wedge(art,"Sloped front bonnet",Vector3.new(width-.8,2.0,length*.24),
   cf(0,6,-length*.38)*CFrame.Angles(0,math.pi,0),carBody)
  wedge(art,"Tapered rear deck",Vector3.new(width-.8,2.1,length*.18),
   cf(0,6,length*.41),carBody)
 else
  part(art,"Cabin silhouette",Vector3.new(width-.9,4.5,length*.26),
   cf(0,7.6,-length*.28),Colors.glass,Enum.Material.Glass)
  part(art,"Rear fitted cargo compartment",Vector3.new(width-.6,5.2,length*.53),
   cf(0,7.0,length*.20),carBody,Enum.Material.Metal)
  wedge(art,"Front aerodynamic nose",Vector3.new(width-.9,3.0,length*.17),
   cf(0,6,-length*.43)*CFrame.Angles(0,math.pi,0),carBody)
 end
 for _,dir in ipairs({-1,1}) do
  local posX=dir*(width*.48)
  for _,z in ipairs({-length*.31,length*.31}) do
   -- Cylinder's axle is local X. Diameter is Y/Z. Wheel visual sits on ground.
   local tire=part(art,"Correct vertical rubber wheel",
    Vector3.new(1.8,4.7,4.7),cf(posX,2.7,z),Colors.tyre,Enum.Material.Rubber)
   tire.Shape=Enum.PartType.Cylinder
   local hub=part(art,"Five-spoke wheel center",
    Vector3.new(.26,2.7,2.7),cf(posX+dir*1,2.7,z),Colors.silver,Enum.Material.Metal)
   hub.Shape=Enum.PartType.Cylinder
   for spoke=1,5 do
    local angle=spoke*math.pi*2/5
    part(art,"Rim spoke",Vector3.new(.29,.38,1.15),
     cf(posX+dir*1.18,2.7+math.sin(angle)*.78,z+math.cos(angle)*.78)*
      CFrame.Angles(angle,0,0),Colors.metal,Enum.Material.Metal)
   end
  end
  part(art,"Wing mirror",Vector3.new(1.1,.65,1.25),
   cf(dir*(width*.56),7.0,-length*.24),Colors.black,Enum.Material.Metal)
  part(art,"Front LED lamp",Vector3.new(width*.20,.6,.3),
   cf(dir*width*.25,4.8,-length*.5-.08),Colors.light,Enum.Material.Neon)
  part(art,"Rear red brake lamp",Vector3.new(width*.22,.5,.3),
   cf(dir*width*.26,4.8,length*.5+.08),Colors.red,Enum.Material.Neon)
 end
 if class=="Ambulance" then
  part(art,"Paramedic blue belt",Vector3.new(width+.18,1.7,length*.65),
   cf(0,6.15,length*.15),Colors.blue,Enum.Material.Metal)
  label(art,"AMBULANCE  |  إسعاف",Vector3.new(width*.72,1.6,.3),
   cf(0,6.3,length*.47+.2),Colors.blue)
 elseif class=="Police" then
  part(art,"Green police door stripe",Vector3.new(width+.3,1.2,length*.52),
   cf(0,5.3,0),Colors.green,Enum.Material.Metal)
  label(art,"POLICE  |  الشرطة",Vector3.new(width*.85,1.8,.3),
   cf(0,5.4,length*.33),Colors.green)
 elseif class=="Fire" then
  part(art,"Civil defence red band",Vector3.new(width+.2,1.4,length*.72),
   cf(0,5.5,0),Colors.red,Enum.Material.Metal)
  label(art,"CIVIL DEFENCE  |  الدفاع المدني",Vector3.new(width*.85,2,.3),
   cf(0,6.4,length*.41),Colors.red)
 elseif class=="Taxi" then
  part(art,"Taxi roof sign",Vector3.new(4,1.3,2),
   cf(0,9.45,0),Colors.gold,Enum.Material.SmoothPlastic)
 end
 if class=="Police" or class=="Ambulance" or class=="Fire" then
  part(art,"Roof emergency red bar",Vector3.new(width*.36,.55,1.7),
   cf(-width*.2,10.2,-1),Colors.red,Enum.Material.Neon)
  part(art,"Roof emergency blue bar",Vector3.new(width*.36,.55,1.7),
   cf(width*.2,10.2,-1),Colors.blue,Enum.Material.Neon)
 end
 model:SetAttribute("UAE60Visuals","Body+Wheels")
 model:SetAttribute("UAE60Class",class)
end
local function process(model)
 if not model or not model:IsA("Model") or processed[model] then return end
 local class=inferClass(model)
 if class then style(model,class) end
end
for _,model in ipairs(cars:GetChildren()) do process(model) end
local v4=world:FindFirstChild("Phase4_MegaCity")
if v4 then
 for _,m in ipairs(v4:GetDescendants()) do
  if m:IsA("Model") and m:FindFirstChildWhichIsA("VehicleSeat",true) then
   process(m)
  end
 end
end
cars.ChildAdded:Connect(function(model)
 task.defer(function()
  if model.Parent then process(model) end
 end)
end)
print("[UAE6] Fleet art: corrected wheel cylinders and vehicle class silhouettes")
