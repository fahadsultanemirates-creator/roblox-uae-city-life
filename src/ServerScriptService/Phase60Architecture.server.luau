-- UAE CITY LIFE 6: focused architectural overhaul (budgeted procedural details).
-- Detailed material silhouettes, glazing, awnings, signs, crosswalks.
-- Quality upgrade within Roblox Parts; international-level game art still needs meshes.
local Lighting=game:GetService("Lighting")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local phase=world:WaitForChild("Phase60_ProductionPass")
local root=Instance.new("Folder")
root.Name="ModernStreetsAndArchitecture"
root.Parent=phase
local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
local C={
 glass=rgb(72,151,177),silver=rgb(185,193,195),
 blue=rgb(39,91,120),cream=rgb(232,228,217),
 gold=rgb(231,186,100),dark=rgb(33,52,64),
 sand=rgb(190,172,143),white=rgb(246,244,228),
 green=rgb(43,124,79),brown=rgb(145,105,73)
}
local function part(name,sz,cf,color,mat,collide)
 local p=Instance.new("Part")
 p.Name=name;p.Size=sz;p.CFrame=cf;p.Color=color
 p.Material=mat or Enum.Material.SmoothPlastic;p.Anchored=true
 p.CanCollide=collide==true
 p.CastShadow=collide==true
 p.TopSurface=Enum.SurfaceType.Smooth
 p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=root;return p
end
local function sign(text,x,y,z,width)
 local board=part("Legible road destination board",Vector3.new(width,6,.65),
  CFrame.new(x,y,z),C.blue,Enum.Material.Metal,false)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=34;gui.Parent=board
 local l=Instance.new("TextLabel")
 l.Text=text;l.TextScaled=true;l.TextWrapped=true
 l.Font=Enum.Font.GothamBold;l.TextColor3=C.white
 l.BackgroundTransparency=1;l.Size=UDim2.fromScale(1,1)
 l.Parent=gui
 return board
end
-- Towers with glazed vertical ribs and readable multiple window bands,
-- placed around existing x/z coordinates, not into villa/playable interiors.
local buildings={
 {-285,-1430,132,62,48}, {-470,-1410,172,64,56},
 {-285,-1270,213,58,49}, {-510,-1280,146,52,55},
 {480,-1430,196,54,49},{660,-1390,132,65,52},
 {490,-1270,210,60,49},{690,-1240,113,57,55},
}
for i,entry in ipairs(buildings) do
 local x,z,height,w,d=unpack(entry)
 local frontZ=z-d*.5-.65
 part("Architectural glass facade "..i,Vector3.new(w*.84,height*.82,.8),
  CFrame.new(x,height*.44+3,frontZ),C.glass,Enum.Material.Glass,false).Transparency=.25
 for floor=1,math.floor(height/18) do
  local y=4+floor*16
  part("Brushed steel horizontal mullion",Vector3.new(w*.88,.38,1),
   CFrame.new(x,y,frontZ-.5),C.silver,Enum.Material.Metal,false)
 end
 for _,side in ipairs({-.32,0,.32}) do
  part("Tower vertical aluminium fin",Vector3.new(.7,height*.81,1.1),
   CFrame.new(x+side*w,height*.44+3,frontZ-.6),C.silver,Enum.Material.Metal,false)
 end
 part("Rooftop LED facade",Vector3.new(w*.8,1.0,1.2),
  CFrame.new(x,height+4,frontZ),i%2==0 and C.gold or C.blue,Enum.Material.Neon,false)
 part("Tower lobby glass canopy",Vector3.new(w*.47,.8,11),
  CFrame.new(x,7,frontZ-4.5),C.silver,Enum.Material.Metal,false)
end
-- Wayfinding signs put main services on the street.
for _,s in ipairs({
 {"DXB AIRPORT  |  مطار دبي",-1070,-1180,62},
 {"HOSPITAL  |  المستشفى",-235,-1195,60},
 {"HOTEL & RECEPTION",-550,-1005,62},
 {"DUBAI POLICE  |  شرطة دبي",-935,-480,66},
 {"CIVIL DEFENCE  |  الدفاع المدني",-935,-630,72},
 {"MARINA & COAST  |  دبي مارينا",1080,-1250,72},
 {"CITY ATLAS  |  CITY MISSIONS",30,-1180,74}
}) do
 local txt,x,z,w=s[1],s[2],s[3],s[4]
 part("Road sign support column",Vector3.new(1.2,17,1.2),
  CFrame.new(x-22,9,z),C.silver,Enum.Material.Metal,false)
 sign(txt,x,18,z,w)
end
-- Modern painted road pedestrian crossings at business junctions.
local crossings={
 {0,-1010,105},{0,-1430,105},{-940,-705,34},
 {-235,-1155,44},{-550,-985,44},{-1020,-1110,54}
}
for _,e in ipairs(crossings) do
 local x,z,length=e[1],e[2],e[3]
 for j=1,8 do
  local px=x-length/2+j*length/9
  part("Reflective crosswalk zebra paint",Vector3.new(3,.13,7),
   CFrame.new(px,1.15,z),C.white,Enum.Material.SmoothPlastic,false)
 end
end
-- Faceted traffic lights, functional night-time illumination, road benches.
for _,e in ipairs({
 {-100,-1010},{100,-1010},{-100,-1430},{100,-1430},
 {-960,-705},{-950,-480},{-950,-630}
}) do
 local x,z=e[1],e[2]
 part("Traffic signal mast",Vector3.new(.9,16,.9),
  CFrame.new(x,8,z),C.dark,Enum.Material.Metal,false)
 local box=part("Vertical traffic signal",Vector3.new(2.2,5.5,2),
  CFrame.new(x,15,z),C.dark,Enum.Material.Metal,false)
 for idx,color in ipairs({rgb(198,58,55),rgb(245,172,59),rgb(58,194,131)}) do
  local bulb=part("Signal illuminated disc",Vector3.new(1,1,.32),
   CFrame.new(x,17.5-idx*1.5,z-1.05),color,Enum.Material.Neon,false)
  bulb.Shape=Enum.PartType.Ball
 end
end
for _,e in ipairs({{-235,-1145},{-550,-970},{-1020,-1105},
 {1050,-1260},{-940,-865}}) do
 local x,z=e[1],e[2]
 part("City waiting bench",Vector3.new(13,.7,4),
  CFrame.new(x,2.5,z),C.brown,Enum.Material.WoodPlanks,true)
 part("Bench backrest",Vector3.new(13,4,.5),
  CFrame.new(x,4.5,z+1.5),C.brown,Enum.Material.WoodPlanks,false)
end
-- Directional, low intensity scene grading. No overriding old game's day/night.
pcall(function()
 Lighting.EnvironmentDiffuseScale=.8
 Lighting.EnvironmentSpecularScale=.85
 Lighting.ShadowSoftness=.33
 Lighting.ExposureCompensation=0
end)
local grade=Lighting:FindFirstChild("UAE60_ArchitectureGrade")
if not grade then
 grade=Instance.new("ColorCorrectionEffect")
 grade.Name="UAE60_ArchitectureGrade";grade.Parent=Lighting
end
grade.Contrast=.055
grade.Saturation=.045
grade.TintColor=rgb(255,248,239)
print("[UAE6] Exterior art: glass facade ribs, lobby canopies, signage, crossings, traffic signals")
