-- UAE City Life 5.5: higher-detail lane-following cars + repaired procedural wheel orientation.
-- This traffic is visual, anchored and noncolliding; do not mistake it for a physics traffic engine.
local RunService=game:GetService("RunService")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_LivingCity")
local lightMode=root:GetAttribute("PerformanceMode")==true
local vehicles=Instance.new("Folder")
vehicles.Name="V55LaneTraffic"
vehicles.Parent=root
local RGB=Color3.fromRGB
local palette={
 RGB(211,219,216),RGB(34,78,116),RGB(159,48,47),
 RGB(231,223,191),RGB(58,67,75),RGB(195,196,202),
 RGB(150,107,64),RGB(41,101,94),
}
local asphalt=RGB(40,44,52)
local window=RGB(49,94,116)
local chrome=RGB(202,213,212)
local function part(model,name,sz,relative,color,material,shape)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=relative
 p.Color=color;p.Material=material or Enum.Material.SmoothPlastic
 p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CastShadow=true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 if shape then p.Shape=shape end
 p.Parent=model
 return p
end
local function makeCar(idx)
 local kind=({"Sedan","Sedan","SUV","Taxi","Sedan","SUV","Van","Taxi"})[(idx-1)%8+1]
 local tint=palette[(idx-1)%#palette+1]
 local m=Instance.new("Model");m.Name="V55_Traffic_"..kind.."_"..idx;m.Parent=vehicles
 local pivot=part(m,"Pivot",Vector3.new(.15,.15,.15),CFrame.new(),tint)
 pivot.Transparency=1
 m.PrimaryPart=pivot
 local length=kind=="Van" and 24 or (kind=="SUV" and 21 or 19)
 local bodyWidth=kind=="Van" and 11.5 or 10.3
 part(m,"Low dark undercarriage",Vector3.new(bodyWidth,1,length),
 CFrame.new(0,3.1,0),asphalt,Enum.Material.Metal)
 part(m,"Rounded panel body",Vector3.new(bodyWidth,2.3,length),
 CFrame.new(0,4.6,0),tint,Enum.Material.Metal)
 part(m,"Front bumper",Vector3.new(bodyWidth+.4,.9,1.15),
 CFrame.new(0,3.55,-length/2-.2),chrome,Enum.Material.Metal)
 part(m,"Rear bumper",Vector3.new(bodyWidth+.2,.7,1),
 CFrame.new(0,3.6,length/2+.2),asphalt,Enum.Material.Metal)
 local cabinLength=(kind=="Van" and 12 or 10)
 part(m,"Passenger window glass",Vector3.new(bodyWidth-.7,2.8,cabinLength),
 CFrame.new(0,6.7,1),window,Enum.Material.Glass)
 part(m,"Vehicle roof",Vector3.new(bodyWidth-.75,.7,cabinLength+.6),
 CFrame.new(0,8.3,1),tint,Enum.Material.Metal)
 part(m,"Bonnet paint",Vector3.new(bodyWidth-.5,.8,5),
 CFrame.new(0,5.4,-length/2+2.7),tint,Enum.Material.Metal)
 local wheels={}
 for _,side in ipairs({-1,1}) do
  for _,z in ipairs({-length*.32,length*.32}) do
   local wheel=part(m,"Wheel Rubber",Vector3.new(4.4,1.5,4.4),
    CFrame.new(side*(bodyWidth/2+.3),2.4,z)*CFrame.Angles(0,0,math.pi/2),
    RGB(25,27,30),Enum.Material.Rubber,Enum.PartType.Cylinder)
   local hub=part(m,"Wheel Alloy Rim",Vector3.new(2.5,1.55,2.5),
    CFrame.new(side*(bodyWidth/2+.45),2.4,z)*CFrame.Angles(0,0,math.pi/2),
    chrome,Enum.Material.Metal,Enum.PartType.Cylinder)
   wheels[#wheels+1]=wheel
   wheels[#wheels+1]=hub
  end
  part(m,"Door seam",Vector3.new(.12,2.7,.16),
   CFrame.new(side*(bodyWidth/2+.06),4.9,1.6),asphalt,Enum.Material.Metal)
  part(m,"Silver door handle",Vector3.new(.15,.24,1.8),
   CFrame.new(side*(bodyWidth/2+.1),5.4,2),chrome,Enum.Material.Metal)
  part(m,"LED front lamp",Vector3.new(2.1,.65,.3),
   CFrame.new(side*(bodyWidth/2-1.6),4.8,-length/2-.28),
   RGB(255,244,200),Enum.Material.Neon)
  part(m,"Red rear lamp",Vector3.new(2.1,.65,.3),
   CFrame.new(side*(bodyWidth/2-1.6),4.8,length/2+.28),
   RGB(194,54,63),Enum.Material.Neon)
 end
 part(m,"Black front grille",Vector3.new(bodyWidth*.45,.9,.25),
 CFrame.new(0,3.95,-length/2-.42),asphalt,Enum.Material.Metal)
 if kind=="Taxi" then
  local roof=part(m,"Dubai taxi roof sign",Vector3.new(4.3,1.1,2),
   CFrame.new(0,9,1),RGB(244,227,176),Enum.Material.SmoothPlastic)
  local gui=Instance.new("SurfaceGui");gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=25;gui.Parent=roof
  local label=Instance.new("TextLabel");label.Size=UDim2.fromScale(1,1)
  label.Text="TAXI";label.BackgroundTransparency=1
  label.TextColor3=RGB(22,76,98);label.TextScaled=true
  label.Font=Enum.Font.GothamBold;label.Parent=gui
 end
 local localWheels={}
 for _,wheel in ipairs(wheels) do
  localWheels[#localWheels+1]={p=wheel,rel=m:GetPivot():ToObjectSpace(wheel.CFrame)}
 end
 return m,localWheels
end
-- E11 lane traffic uses consistent one-direction lane paths, so new cars don't cross each other.
local routes={
 {x=-55,dir=-1},{x=-32,dir=-1},{x=32,dir=1},{x=55,dir=1},
}
local fleet={}
local perLane=lightMode and 2 or 3
for lane,route in ipairs(routes) do
 for number=1,perLane do
  local idx=(lane-1)*perLane+number
  local model,parts=makeCar(idx)
  fleet[#fleet+1]={model=model,wheels=parts,route=route,
   alpha=(number-1)/perLane,rotation=0,speed=lightMode and 18 or 21}
 end
end
local elapsed=0
RunService.Heartbeat:Connect(function(dt)
 elapsed=elapsed+math.min(dt,.1)
 if elapsed<.09 then return end
 local step=math.min(elapsed,.16)
 elapsed=0
 for _,obj in ipairs(fleet) do
  obj.alpha=(obj.alpha+step*obj.speed/480)%1
  obj.rotation=obj.rotation+step*obj.speed/2.1
  local z=obj.route.dir==1 and (-1455+obj.alpha*480) or (-975-obj.alpha*480)
  local cf=CFrame.new(obj.route.x,0,z)*CFrame.Angles(0,obj.route.dir==1 and math.pi or 0,0)
  obj.model:PivotTo(cf)
  -- Rotate visual wheel cylinders around their axle; no physical car dynamics.
  for _,data in ipairs(obj.wheels) do
   data.p.CFrame=cf*data.rel*CFrame.Angles(0,obj.rotation,0)
  end
 end
end)
-- Older procedural models incorrectly put the cylinder axle vertically. Fix wheels once.
local function fixLegacy(model)
 if not model:IsA("Model") or model:GetAttribute("UAE55TyresFixed") then return end
 if model:IsDescendantOf(vehicles) then return end
 local count=0
 for _,part in ipairs(model:GetDescendants()) do
  if part:IsA("Part") and part.Shape==Enum.PartType.Cylinder then
   local n=string.lower(part.Name)
   if n:find("wheel") or n:find("tyre") or n:find("tire") or n:find("rim") then
    local dim=part.Size
    local diameter=math.max(dim.X,dim.Y,dim.Z)
    local axle=math.min(dim.X,dim.Y,dim.Z)
    if diameter>=2.2 and axle<=3 then
     part.Size=Vector3.new(diameter,axle,diameter)
     part.CFrame=part.CFrame*CFrame.Angles(0,0,math.pi/2)
     count=count+1
    end
   end
  end
 end
 if count>0 then model:SetAttribute("UAE55TyresFixed",true) end
end
-- Existing car models may be spawned after server start.
task.spawn(function()
 while root.Parent do
  local cars=world:FindFirstChild("EmergencyVehicles")
  if cars then for _,m in ipairs(cars:GetChildren()) do fixLegacy(m) end end
  local phase=world:FindFirstChild("Phase54_CityExpansion")
  local static=phase and phase:FindFirstChild("CommunityServiceFleet",true)
  if static then for _,m in ipairs(static:GetChildren()) do fixLegacy(m) end end
  task.wait(6)
 end
end)
print("[UAE v5.5] "..#fleet.." higher-detail E11 lane traffic cars; legacy procedural tyres corrected")
