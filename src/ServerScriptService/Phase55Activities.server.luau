-- v5.5 playable interiors and activities. Original schematic Dubai layout.
-- Lobby, hospital and airport activities are functional server-side roleplay loops.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_RealLife")
local spaces=Instance.new("Folder")
spaces.Name="PlayableInteriors"
spaces.Parent=root
local function rgb(r,g,b)return Color3.fromRGB(r,g,b)end
local white=rgb(237,235,225)
local stone=rgb(194,189,177)
local navy=rgb(33,66,82)
local teal=rgb(43,128,144)
local gold=rgb(221,174,85)
local function part(parent,name,size,x,y,z,color,mat,solid)
 local p=Instance.new("Part")
 p.Name=name;p.Size=size;p.Position=Vector3.new(x,y,z)
 p.Color=color or white;p.Material=mat or Enum.Material.SmoothPlastic
 p.Anchored=true;p.CanCollide=solid==true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent;return p
end
local function sign(parent,name,words,x,y,z,w,h)
 local p=part(parent,name,Vector3.new(w,h,.4),x,y,z,navy,Enum.Material.Metal,false)
 local gui=Instance.new("SurfaceGui")
 gui.Face=Enum.NormalId.Front;gui.PixelsPerStud=30;gui.Parent=p
 local label=Instance.new("TextLabel")
 label.Size=UDim2.fromScale(1,1);label.BackgroundTransparency=1
 label.Font=Enum.Font.GothamBold;label.TextScaled=true;label.TextWrapped=true
 label.TextColor3=white;label.Text=words;label.Parent=gui
 return p
end
local cooldown={}
local notify=RS:FindFirstChild("UAE55_Notice") or Instance.new("RemoteEvent")
notify.Name="UAE55_Notice";notify.Parent=RS
local function tell(player,msg)
 if player.Parent==Players then notify:FireClient(player,msg) end
end
local function reward(player,points)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player end
 local v=stats:FindFirstChild("CityPoints")
 if not v then v=Instance.new("IntValue");v.Name="CityPoints";v.Parent=stats end
 v.Value=v.Value+points
end
local function action(parent,base,actionText,x,y,z,callback)
 local terminal=part(parent,base,Vector3.new(5,5,2),x,y,z,teal,Enum.Material.Metal,true)
 local prompt=Instance.new("ProximityPrompt")
 prompt.ActionText=actionText;prompt.ObjectText=base
 prompt.HoldDuration=.6;prompt.MaxActivationDistance=13
 prompt.RequiresLineOfSight=false;prompt.Parent=terminal
 prompt.Triggered:Connect(function(player)
  local char=player.Character
  local rootPart=char and char:FindFirstChild("HumanoidRootPart")
  if not rootPart or (rootPart.Position-terminal.Position).Magnitude>17 then return end
  local key=tostring(player.UserId)..":"..base
  if cooldown[key] and os.clock()-cooldown[key]<2 then return end
  cooldown[key]=os.clock()
  callback(player)
 end)
 return terminal
end
local function room(name,x,z,w,d,theme,title)
 local m=Instance.new("Model");m.Name=name;m.Parent=spaces
 part(m,"Polished lobby floor",Vector3.new(w,1,d),x,1,z,stone,Enum.Material.Marble,true)
 part(m,"Back wall",Vector3.new(w,19,1),x,10,z+d/2,white,Enum.Material.Concrete,true)
 part(m,"Left wall",Vector3.new(1,19,d),x-w/2,10,z,white,Enum.Material.Concrete,true)
 part(m,"Right wall",Vector3.new(1,19,d),x+w/2,10,z,white,Enum.Material.Concrete,true)
 part(m,"Roof with lighting",Vector3.new(w,1,d),x,20,z,white,Enum.Material.Concrete,true)
 part(m,"Reception desk",Vector3.new(22,4,5),x,3.5,z+10,theme,Enum.Material.Marble,true)
 part(m,"Reception glass panel",Vector3.new(21,3,.5),x,7,z+12,teal,Enum.Material.Glass,false)
 for _,dx in ipairs({-w*.35,w*.35}) do
  part(m,"Sofa seating",Vector3.new(13,2.5,7),x+dx,2.8,z-6,navy,Enum.Material.Fabric,true)
 end
 sign(m,"Entrance signage",title,x,13,z+d/2-.8,w*.7,5)
 -- open front is deliberate, so players can walk inside
 return m
end
local hotel=room("Dubai Hotel Playable Lobby",-550,-920,80,65,gold,
 "DUBAI HOTEL  |  HOTEL RECEPTION")
local hotelStatus={}
action(hotel,"Hotel Check-in","Check in",-550,4,-915,function(player)
 hotelStatus[player.UserId]=true
 tell(player,"Hotel check-in complete. Your guest room is ready.")
 reward(player,20)
end)
action(hotel,"Hotel Room Access","Enter guest room",-575,4,-920,function(player)
 if not hotelStatus[player.UserId] then tell(player,"Check in at reception first.") return end
 local char=player.Character
 if char then char:PivotTo(CFrame.new(-550,5,-878)) end
 tell(player,"Welcome to your guest room.")
end)
local guest=Instance.new("Model");guest.Name="Hotel Guest Room";guest.Parent=spaces
part(guest,"Guest suite floor",Vector3.new(43,1,39),-550,1,-868,stone,Enum.Material.Marble,true)
part(guest,"Guest room bed frame",Vector3.new(18,2,12),-550,2.5,-856,navy,Enum.Material.Wood,true)
part(guest,"White duvet",Vector3.new(17,1,11),-550,4,-856,white,Enum.Material.Fabric,true)
action(guest,"Guest Check-out","Check out",-534,4,-878,function(player)
 hotelStatus[player.UserId]=nil
 tell(player,"Checked out. Thank you for visiting!")
end)
local hospital=room("Dubai Medical Centre Playable Reception",-235,-1095,86,68,teal,
 "HOSPITAL  |  MEDICAL RECEPTION")
local patientState={}
action(hospital,"Patient Registration","Register as patient",-235,4,-1095,function(player)
 patientState[player.UserId]="waiting"
 tell(player,"Patient registered. Proceed to the examination desk.")
end)
action(hospital,"Medical Examination","Complete checkup",-265,4,-1100,function(player)
 if patientState[player.UserId]~="waiting" then
  tell(player,"Please register at reception first.") return end
 patientState[player.UserId]="checked"
 tell(player,"Examination complete. Proceed to pharmacy.")
end)
action(hospital,"Hospital Pharmacy","Collect prescription",-205,4,-1100,function(player)
 if patientState[player.UserId]~="checked" then
  tell(player,"Complete registration and examination first.") return end
 patientState[player.UserId]=nil
 reward(player,30)
 tell(player,"Hospital visit completed. +30 CityPoints.")
end)
local airport=room("DXB Playable Airport Terminal",-1020,-980,110,75,navy,
 "DXB  |  INTERNATIONAL TERMINAL")
local flightState={}
action(airport,"Airport Check-in Desk","Check in for flight",-1050,4,-980,function(player)
 flightState[player.UserId]="checkin"
 tell(player,"Flight check-in complete. Proceed to security.")
end)
action(airport,"Airport Security","Clear security",-1020,4,-980,function(player)
 if flightState[player.UserId]~="checkin" then
  tell(player,"Please check in first.") return end
 flightState[player.UserId]="security"
 tell(player,"Security cleared. Proceed to boarding gate.")
end)
action(airport,"Airport Boarding Gate","Board flight",-990,4,-980,function(player)
 if flightState[player.UserId]~="security" then
  tell(player,"Complete check-in and security first.") return end
 flightState[player.UserId]=nil
 reward(player,40)
 tell(player,"Boarding complete! +40 CityPoints. Flight simulation ends here.")
end)
-- Functional cafe transaction, for a small everyday activity.
local cafe=room("Karak Cafe Interactive Counter",-225,-595,54,48,gold,
 "KARAK CAFE  |  ORDER COUNTER")
action(cafe,"Karak Order Counter","Order karak tea",-225,4,-595,function(player)
 tell(player,"Fresh karak tea served! Enjoy your visit.")
end)
Players.PlayerRemoving:Connect(function(p)
 hotelStatus[p.UserId]=nil;patientState[p.UserId]=nil;flightState[p.UserId]=nil
end)
print("[v5.5] Interactive hotel, guest room, hospital, airport and cafe ready")
