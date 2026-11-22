-- UAE CITY LIFE 6.1: distinct original vehicle bodies for existing drivable fleets.
-- Requires external licensed meshes for photorealism; these are refined procedural prototypes.
local world=workspace:WaitForChild("UAE_City_Life")
local fleet=world:WaitForChild("EmergencyVehicles")
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local C={snow=rgb(237,240,239),black=rgb(26,29,33),steel=rgb(158,174,180),
 blue=rgb(38,98,153),green=rgb(22,98,70),red=rgb(200,48,60),yellow=rgb(237,188,67),
 glass=rgb(66,131,162),taxi=rgb(229,215,178),lux=rgb(45,67,81),
 gray=rgb(88,98,109),amber=rgb(255,229,171),silver=rgb(208,218,216)}
local configured={}
local function vehicleClass(model)
 local kind=tostring(model:GetAttribute("VehicleType") or "")
 local name=string.lower(model.Name.." "..kind)
 if name:find("aircraft") or name:find("helicopter") then return nil end
 if name:find("ambul",1,true) then return "Ambulance" end
 if name:find("fire",1,true) or name:find("civil",1,true) or name:find("rescue",1,true) then return "Fire" end
 if name:find("police",1,true) then return "Police" end
 if name:find("taxi",1,true) then return "Taxi" end
 if name:find("bus",1,true) then return "Bus" end
 if name:find("family",1,true) or name:find("suv",1,true) then return "SUV" end
 return "Sedan"
end
local configs={
 Sedan={w=9.4,l=19,roof=8.3,wheel=4.5,paint=C.lux,trim=C.steel},
 Taxi={w=9.6,l=19.4,roof=8.5,wheel=4.6,paint=C.taxi,trim=C.red},
 SUV={w=10.7,l=22.5,roof=9.7,wheel=5.1,paint=C.snow,trim=C.black},
 Police={w=10.5,l=22.8,roof=9.6,wheel=5.0,paint=C.snow,trim=C.green},
 Ambulance={w=11.6,l=26,roof=11.7,wheel=5.1,paint=C.snow,trim=C.blue},
 Fire={w=12.5,l=33,roof=12.8,wheel=5.8,paint=C.yellow,trim=C.red},
 Bus={w=12.2,l=33,roof=12.7,wheel=5.2,paint=C.snow,trim=C.green},
}
local function create(parent,class,name,size,cf,col,material,alpha)
 local obj=Instance.new(class)
 obj.Name=name
 obj.Size=size
 obj.CFrame=cf
 obj.Color=col
 obj.Material=material or Enum.Material.Metal
 obj.Anchored=true
 obj.CanCollide=false
 obj.CanQuery=false
 obj.CanTouch=false
 obj.Transparency=alpha or 0
 obj.TopSurface=Enum.SurfaceType.Smooth
 obj.BottomSurface=Enum.SurfaceType.Smooth
 obj.Parent=parent
 return obj
end
local function signage(parent,content,cf,w,h,bg)
 local plate=create(parent,"Part","Vehicle service label",
  Vector3.new(w,h,.24),cf,bg)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=35
 gui.Parent=plate
 local txt=Instance.new("TextLabel")
 txt.Size=UDim2.fromScale(1,1)
 txt.BackgroundTransparency=1
 txt.Font=Enum.Font.GothamBold
 txt.TextScaled=true
 txt.TextWrapped=true
 txt.TextColor3=C.snow
 txt.Text=content
 txt.Parent=gui
end
local function style(model)
 if configured[model] or not model.Parent or model:GetAttribute("UAE61NoSkin") then return end
 local kind=vehicleClass(model)
 local cfg=configs[kind]
 if not cfg then return end
 configured[model]=true
 -- Pivot preservation is mandatory: the driving script moves the Model using PivotTo.
 local pivot=model:GetPivot()
 local seat=model:FindFirstChildWhichIsA("VehicleSeat",true)
 local existing=model:FindFirstChild("UAE61_DistinctVehicleBody")
 if existing then existing:Destroy() end
 local new=Instance.new("Model")
 new.Name="UAE61_DistinctVehicleBody"
 new.Parent=model
 -- Original v4/v5/v6 cosmetics are hidden but preserved in the saved version.
 for _,obj in ipairs(model:GetDescendants()) do
  if obj:IsA("BasePart") and not obj:IsDescendantOf(new) and obj~=seat then
   if obj:GetAttribute("UAE61PrevTransparency")==nil then
    obj:SetAttribute("UAE61PrevTransparency",obj.Transparency)
   end
   obj.Transparency=1
   obj.CanCollide=false
   obj.CanQuery=false
  end
 end
 local function p(class,name,size,x,y,z,tint,mat,alpha,rotation)
  return create(new,class,name,size,
   pivot*CFrame.new(x,y,z)*(rotation or CFrame.new()),tint,mat,alpha)
 end
 local w,l,r=cfg.w,cfg.l,cfg.roof
 local front=-l*.5
 local rear=l*.5
 local tall=kind=="Ambulance" or kind=="Fire" or kind=="Bus"
 p("Part","Underbody deep sill",Vector3.new(w-.2,1.0,l-1),0,3.4,0,C.black)
 p("Part","Layered painted metal chassis",Vector3.new(w,2.1,l-.6),0,4.6,0,cfg.paint)
 p("Part","Rear contoured bumper",Vector3.new(w+.3,.8,.9),0,3.7,rear,C.steel)
 p("Part","Front grille and bumper",Vector3.new(w+.3,.85,1.0),0,3.75,front,C.black)
 local glazingH=2.6
 if tall then
  local cabinSection=kind=="Fire" and 10.4 or kind=="Bus" and l-3.5 or 9.1
  local cabZ=front+cabinSection*.5
  p("Part","Tall commercial driver's cab",Vector3.new(w-.5,r-4.6,cabinSection),
   0,(r+4.6)/2+2.2,cabZ,cfg.paint)
  p("Part","Full-height smoked windscreen",Vector3.new(w-1.2,3.1,.30),
   0,8.1,front+.45,C.glass,Enum.Material.Glass,.15)
  if kind=="Ambulance" or kind=="Fire" then
   local rearLen=l-cabinSection
   p("Part","Dedicated service box",Vector3.new(w-.5,r-4.7,rearLen-.5),
    0,4.7+(r-4.7)/2,front+cabinSection+rearLen*.5,cfg.paint)
   p("Part","Raised rear equipment roof",Vector3.new(w-.15,.8,rearLen-.4),
    0,r,front+cabinSection+rearLen*.5,C.snow)
  else
   for _,z in ipairs({-8,-1,6,12}) do
    p("Part","Bus continuous passenger window",Vector3.new(w+.1,2.9,4.3),
     0,8,z,C.glass,Enum.Material.Glass,.12)
   end
  end
 else
  local roofLength=(kind=="SUV" or kind=="Police") and l*.57 or l*.46
  local roofZ=(kind=="SUV" or kind=="Police") and .7 or 1.3
  p("Part","Shaped glass passenger cabin",Vector3.new(w-1.15,2.6,roofLength),
   0,7.2,roofZ,C.glass,Enum.Material.Glass,.16)
  p("Part","Painted aerodynamic roof",Vector3.new(w-1.0,.7,roofLength+.55),
   0,r,roofZ,cfg.paint)
  p("WedgePart","Sloped vehicle bonnet",Vector3.new(w-.7,1.8,5.0),
   0,5.8,front+2.6,cfg.paint,Enum.Material.Metal,0,CFrame.Angles(0,math.pi,0))
  p("WedgePart","Tapered boot",Vector3.new(w-.9,1.1,3.4),
   0,5.7,rear-1.7,cfg.paint)
  if kind=="SUV" or kind=="Police" then
   for _,sgn in ipairs({-1,1}) do
    p("Part","Elevated SUV luggage rail",Vector3.new(.5,.55,roofLength),
     sgn*(w*.5-.95),r+.57,roofZ,C.black)
   end
  end
 end
 p("Part","Two-tone side contour stripe",Vector3.new(w+.1,.46,l-.5),
  0,5.8,0,cfg.trim)
 for _,sgn in ipairs({-1,1}) do
  local wheelOffsets=kind=="Fire" and {front+5,0,rear-5} or {front+5,rear-5}
  for _,z in ipairs(wheelOffsets) do
   local tire=p("Part","Upright circular rubber wheel",
    Vector3.new(1.6,cfg.wheel,cfg.wheel),sgn*(w*.5+.14),
    1.1+cfg.wheel*.5,z,C.black,Enum.Material.Rubber)
   tire.Shape=Enum.PartType.Cylinder
   local rim=p("Part","Aluminium wheel rim",
    Vector3.new(.22,cfg.wheel*.62,cfg.wheel*.62),
    sgn*(w*.5+1.03),1.1+cfg.wheel*.5,z,C.steel)
   rim.Shape=Enum.PartType.Cylinder
  end
  p("Part","Side-view mirror",Vector3.new(1.3,.75,1.5),
   sgn*(w*.5+.35),7.0,front+5,C.black)
  p("Part","Modern white headlight",Vector3.new(2.2,.72,.3),
   sgn*(w*.5-1.5),5.1,front-.14,C.amber,Enum.Material.Neon)
  p("Part","Wrapped red tail light",Vector3.new(2.3,.68,.3),
   sgn*(w*.5-1.5),5.1,rear+.13,C.red,Enum.Material.Neon)
  local wx=sgn*(w*.5+.08)
  if tall then
   p("Part","Passenger cabin side glass",Vector3.new(.22,2.7,4.7),
    wx,8,front+5,C.glass,Enum.Material.Glass,.12)
  else
   p("Part","Main door side glass",Vector3.new(.22,2.0,l*.33),
    wx,7.25,1.2,C.glass,Enum.Material.Glass,.12)
   p("Part","Realistic dark door seam",Vector3.new(.27,2,.2),
    wx,6.7,1.2,C.black)
   p("Part","Silver door handles",Vector3.new(.3,.25,1.3),
    wx,5.85,2.8,C.steel)
  end
 end
 if kind=="Taxi" then
  p("Part","TAXI illuminated roof sign",Vector3.new(4.5,1.2,2.4),
   0,r+.9,0,C.amber,Enum.Material.Neon)
 elseif kind=="Ambulance" then
  p("Part","Ambulance dark blue side graphic",Vector3.new(w+.25,1.7,l*.65),
   0,7.0,2.4,C.blue)
  signage(new,"AMBULANCE  |  الإسعاف",
   pivot*CFrame.new(0,7.1,rear*.40),w*.78,1.7,C.blue)
 elseif kind=="Fire" then
  p("Part","Civil Defence high visibility red band",Vector3.new(w+.25,1.3,l*.75),
   0,6.4,2.7,C.red)
  signage(new,"CIVIL DEFENCE  |  الدفاع المدني",
   pivot*CFrame.new(0,7.3,rear*.40),w*.8,1.7,C.red)
 elseif kind=="Police" then
  p("Part","Dubai Police dark green doors",Vector3.new(w+.2,1.1,l*.54),
   0,5.4,.4,C.green)
  signage(new,"DUBAI POLICE  |  شرطة دبي",
   pivot*CFrame.new(0,5.45,rear*.20),w*.78,1.5,C.green)
 end
 if kind=="Police" or kind=="Ambulance" or kind=="Fire" then
  p("Part","Blue emergency lightbar",Vector3.new(2.9,.75,2),
   -2,r+1,front+7,C.blue,Enum.Material.Neon)
  p("Part","Red emergency lightbar",Vector3.new(2.9,.75,2),
   2,r+1,front+7,C.red,Enum.Material.Neon)
 end
 model:SetAttribute("UAE61ArtStyle",kind)
end
local function scan(obj)
 if not obj:IsA("VehicleSeat") or obj.Name~="DriverSeat" then return end
 local model=obj:FindFirstAncestorOfClass("Model")
 if model and model:GetAttribute("UAEVehicle")==true then
  local success,err=pcall(style,model)
  if not success then warn("[UAE61] Vehicle model error:",model.Name,err) end
 end
end
for _,object in ipairs(fleet:GetDescendants()) do scan(object) end
fleet.DescendantAdded:Connect(function(obj)
 if obj:IsA("VehicleSeat") then
  task.delay(.35,function() if obj.Parent then scan(obj) end end)
 end
end)
print("[UAE 6.1] Fleet: 7 distinct vehicle silhouettes with upright wheels and preserved driving seats.")
