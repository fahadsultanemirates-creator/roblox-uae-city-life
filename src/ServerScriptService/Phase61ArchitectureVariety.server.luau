-- UAE City Life 6.1: architectural variety on existing E11 towers and street shops.
-- Facade palette, crowns, balconies, shade canopies and distinct commercial awnings.
-- No wholesale city destruction; performance-aware limited facade part budget.
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase61_QualityFoundation")
local gallery=Instance.new("Folder")
gallery.Name="ArchitecturalStreetRedesign"
gallery.Parent=root
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local styles={
 {name="Limestone Arabesque",wall=rgb(226,209,180),glass=rgb(78,149,157),frame=rgb(183,150,97),mat=Enum.Material.Concrete},
 {name="Black Steel Tower",wall=rgb(74,83,91),glass=rgb(64,112,154),frame=rgb(173,188,192),mat=Enum.Material.Slate},
 {name="Pearl White Residence",wall=rgb(238,233,216),glass=rgb(114,176,177),frame=rgb(213,191,146),mat=Enum.Material.Concrete},
 {name="Warm Terracotta Offices",wall=rgb(183,115,90),glass=rgb(74,127,152),frame=rgb(93,73,72),mat=Enum.Material.Brick},
 {name="Sky Blue Glass Office",wall=rgb(137,182,198),glass=rgb(60,126,179),frame=rgb(226,230,224),mat=Enum.Material.Metal},
 {name="Sandstone Heritage",wall=rgb(191,164,119),glass=rgb(91,143,142),frame=rgb(134,113,84),mat=Enum.Material.Concrete},
}
local function part(parent,name,sz,cf,color,material)
 local p=Instance.new("Part")
 p.Name=name
 p.Size=sz;p.CFrame=cf
 p.Color=color;p.Material=material
 p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.CanTouch=false
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
local modern=world:FindFirstChild("SheikhZayedArchitecture",true)
local changed=0
if modern then
 local towers={}
 for _,f in ipairs(modern:GetChildren()) do
  if f:FindFirstChild("Limestone tower frame") then
   towers[#towers+1]=f
  end
 end
 table.sort(towers,function(a,b)return a.Name<b.Name end)
 for i,tower in ipairs(towers) do
  local core=tower:FindFirstChild("Limestone tower frame")
  if core and core:IsA("BasePart") then
   changed=changed+1
   local style=styles[(i-1)%#styles+1]
   core.Color=style.wall;core.Material=style.mat
   core.CanCollide=true
   local cf=core.CFrame
   local w,h,d=core.Size.X,core.Size.Y,core.Size.Z
   tower:SetAttribute("UAE61Architecture",style.name)
   for _,obj in ipairs(tower:GetDescendants()) do
    if obj:IsA("BasePart") then
     if obj.Name:find("glass",1,true) or obj.Name:find("glazed",1,true) or
        obj.Name:find("window",1,true) then
      obj.Color=style.glass
      obj.Material=Enum.Material.Glass
      obj.Transparency=.17
     end
    end
   end
   local front=d*.5+.9
   local roof=h*.5
   -- Choose visibly different facade details, not identical repeating window strips.
   if i%4==1 then
    for _,sx in ipairs({-w*.35,w*.35}) do
     part(gallery,"Arabesque vertical sandstone ribs",
      Vector3.new(1.8,h*.82,1.1),cf*CFrame.new(sx,0,front),
      style.frame,Enum.Material.Concrete)
    end
    part(gallery,"Gold stepped skyline crown",Vector3.new(w*.74,3.2,d*.78),
     cf*CFrame.new(0,h*.5+3,0),style.frame,Enum.Material.Metal)
   elseif i%4==2 then
    for level=1,math.min(7,math.floor(h/22)) do
     local y=-h*.5+level*(h/8)
     part(gallery,"Deep shaded black steel floor",Vector3.new(w*.92,1.1,d+3),
      cf*CFrame.new(0,y,0),style.frame,Enum.Material.Metal)
    end
    part(gallery,"Glass high-rise spire",Vector3.new(5,22,5),
     cf*CFrame.new(0,h*.5+12,0),style.glass,Enum.Material.Glass)
   elseif i%4==3 then
    for level=1,math.min(9,math.floor(h/16)) do
     local y=-h*.5+level*15
     for _,sgn in ipairs({-1,1}) do
      part(gallery,"Residence projecting balcony",Vector3.new(w*.24,.6,7),
       cf*CFrame.new(sgn*w*.32,y,front+2),
       style.frame,Enum.Material.Concrete)
     end
    end
    part(gallery,"Roof terrace pergola",Vector3.new(w*.65,1.6,d*.5),
     cf*CFrame.new(0,h*.5+5,0),style.frame,Enum.Material.WoodPlanks)
   else
    for _,sx in ipairs({-w*.31,-w*.11,w*.11,w*.31}) do
     part(gallery,"Terracotta facade fin",Vector3.new(.9,h*.85,2),
      cf*CFrame.new(sx,0,front),style.frame,Enum.Material.Metal)
    end
    part(gallery,"Angular parapet",Vector3.new(w*.82,3.2,d*.68),
     cf*CFrame.new(0,h*.5+4,0),style.frame,Enum.Material.Metal)
   end
   local frontSign=part(gallery,"Building entrance sunshade",
    Vector3.new(w*.48,1,9),cf*CFrame.new(0,-h*.5+9,front+4),
    style.frame,Enum.Material.Metal)
  end
 end
end
-- Retail fronts: varied Arabic-inspired tile/warm timber/metal colors and awnings.
local storefront=world:FindFirstChild("CityBusinesses",true)
if storefront then
 local colors={rgb(201,122,75),rgb(55,110,120),rgb(144,92,116),
  rgb(193,156,74),rgb(84,130,93),rgb(54,87,124)}
 local shops=storefront:GetChildren()
 for i,shop in ipairs(shops) do
  local tint=colors[(i-1)%#colors+1]
  for _,obj in ipairs(shop:GetDescendants()) do
   if obj:IsA("BasePart") and (string.find(obj.Name,"Awning",1,true) or
      obj.Name:find("awning") or obj.Name:find("sign") or
      obj.Name:find("Sign") or obj.Name:find("facade")) then
     obj.Color=tint
    end
  end
 end
end
-- Additional clear district markers, placed on side pavements.
local markers={
 {"DOWNTOWN DUBAI",110,-355,rgb(132,99,68)},
 {"BUSINESS DISTRICT",360,-1065,rgb(46,95,110)},
 {"AIRPORT & DXB",-930,-1035,rgb(50,95,124)},
 {"DUBAI MARINA",1045,-1195,rgb(43,106,109)},
}
for _,marker in ipairs(markers) do
 local textLabel,x,z,bg=marker[1],marker[2],marker[3],marker[4]
 local sign=part(gallery,"District monument",Vector3.new(36,7,.7),
  CFrame.new(x,13,z),bg,Enum.Material.Metal)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front
 gui.PixelsPerStud=35
 gui.Parent=sign
 local label=Instance.new("TextLabel")
 label.Text=textLabel
 label.TextScaled=true
 label.TextWrapped=true
 label.Font=Enum.Font.GothamBold
 label.TextColor3=rgb(241,229,202)
 label.BackgroundTransparency=1
 label.Size=UDim2.fromScale(1,1)
 label.Parent=gui
end
print("[UAE 6.1] Architecture: restyled",changed,"E11 towers with varied crowns, materials, colors and balconies.")
