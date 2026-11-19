-- UAE City Life v5.5: server-authoritative usable hotel/hospital/airport and accident roleplay.
-- Prompt actions are checked for real player distance (client can forge ProximityPrompt).
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local root=world:WaitForChild("Phase55_LivingCity")
local services=root:WaitForChild("FunctionalCityInteriors")
local crash=root:WaitForChild("RoadIncidentRoleplayScene")
local status=RS:FindFirstChild("UAE55_ServiceStatus")
if not status then
 status=Instance.new("RemoteEvent");status.Name="UAE55_ServiceStatus";status.Parent=RS
end
local state={}
local lastUsed={}
local lastCompleted={}
local waypoints={
 Hospital=Vector3.new(-235,5,-1090),
 Hotel=Vector3.new(-550,5,-870),
 Airport=Vector3.new(-1150,5,-996),
 Accident=Vector3.new(-830,5,-740),
 CivilDefence=Vector3.new(-1120,5,-650),
 Police=Vector3.new(-1120,5,-475)
}
local function send(player,title,message,target)
 if player.Parent~=Players then return end
 status:FireClient(player,{
  title=title,message=message,
  destination=target and waypoints[target] or nil,
  destinationName=target,
 })
end
local function getState(player)
 if not state[player] then
  state[player]={checkedHospital=false,checkedHotel=false,checkedAirport=false,
   caseStage=0}
 end
 return state[player]
end
local function getRoot(player)
 local char=player.Character
 local h=char and char:FindFirstChildOfClass("Humanoid")
 local rootPart=char and char:FindFirstChild("HumanoidRootPart")
 if h and h.Health>0 and rootPart then return rootPart,h end
end
local function points(player,amount)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player end
 local score=stats:FindFirstChild("CityPoints")
 if not score then score=Instance.new("IntValue");score.Name="CityPoints";score.Parent=stats end
 score.Value=math.clamp(score.Value+amount,0,2000000000)
end
local function valid(player,node)
 local char,h=getRoot(player)
 if not char or not h then return nil end
 if (char.Position-node.Position).Magnitude>17 then return nil end
 local last=lastUsed[player] or {}
 local action=node:GetAttribute("UAE55Action")
 local now=os.clock()
 if last[action] and now-last[action]<1.2 then return nil end
 last[action]=now
 lastUsed[player]=last
 return h
end
local function handle(player,node)
 local hum=valid(player,node)
 if not hum then return end
 local s=getState(player)
 local action=node:GetAttribute("UAE55Action")
 if action=="HospitalCheckIn" then
  s.checkedHospital=true
  send(player,"DUBAI HOSPITAL","Your appointment is registered. Visit the treatment desk.","Hospital")
 elseif action=="HospitalTreat" then
  if not s.checkedHospital then
   send(player,"HOSPITAL","Check in at the reception counter first.","Hospital")
   return
  end
  hum.Health=hum.MaxHealth
  s.checkedHospital=false
  points(player,8)
  send(player,"HOSPITAL","Treatment complete; health restored. +8 CityPoints.")
 elseif action=="HotelCheckIn" then
  s.checkedHotel=true
  send(player,"AL WASL HOTEL","Guest room assigned. Use the guest-room rest point.","Hotel")
 elseif action=="HotelRest" then
  if not s.checkedHotel then
   send(player,"HOTEL","Please check in before resting.","Hotel")
   return
  end
  s.checkedHotel=false
  hum.Health=hum.MaxHealth
  points(player,6)
  send(player,"HOTEL","You rested in your room. Health restored; +6 CityPoints.")
 elseif action=="AirportCheckIn" then
  s.checkedAirport=true
  send(player,"DXB AIRPORT","Boarding pass issued for a simulated sightseeing transfer. Visit the gate.","Airport")
 elseif action=="AirportBoard" then
  if not s.checkedAirport then
   send(player,"AIRPORT","Check in at the terminal first.","Airport")
   return
  end
  s.checkedAirport=false
  local character=player.Character
  if character and character.Parent then
   if hum.Sit then hum.Sit=false end
   character:PivotTo(CFrame.new(1085,8,-1250))
  end
  points(player,15)
  send(player,"SIGHTSEEING TRANSFER","Arrived at Dubai Marina! This is a fast-travel simulation, not a flyable aircraft. +15 CityPoints.")
 elseif action=="PoliceReport" then
  send(player,"CITY POLICE","Incident noted. For road rescue, join a response shift at this reception.","Police")
 elseif action=="AccidentAccept" then
  local now=os.clock()
  if lastCompleted[player] and now-lastCompleted[player]<35 then
   send(player,"ROAD RESCUE","You have completed a case recently. Another case opens shortly.")
   return
  end
  s.caseStage=1
  send(player,"ROAD RESCUE","Dispatch received: staged traffic collision. Visit the crash scene and inspect.","Accident")
 elseif action=="AccidentInspect" then
  if s.caseStage~=1 then
   send(player,"ACCIDENT SCENE","Start a response shift at Police or Civil Defence first.","Police")
   return
  end
  s.caseStage=2
  send(player,"ROAD RESCUE","Scene assessed. Approach the rescue equipment beside the vehicle.","Accident")
 elseif action=="AccidentClear" then
  if s.caseStage~=2 then
   send(player,"ACCIDENT SCENE","Inspect the incident scene before clearing the road.","Accident")
   return
  end
  s.caseStage=3
  send(player,"ROAD RESCUE","The road is safe. Repair the demonstration vehicle to close the case.","Accident")
 elseif action=="AccidentRepair" then
  if s.caseStage~=3 then
   send(player,"ACCIDENT SCENE","You must complete the inspection and clearance steps first.","Accident")
   return
  end
  s.caseStage=0
  lastCompleted[player]=os.clock()
  points(player,140)
  send(player,"RESCUE COMPLETED","Incident closed, damaged vehicle repaired (roleplay). +140 CityPoints.")
 end
end
local count=0
for _,collection in ipairs({services,crash}) do
 for _,node in ipairs(collection:GetDescendants()) do
  if node:IsA("BasePart") and node:GetAttribute("UAE55Action") then
   local prompt=node:FindFirstChild("CityLifeServicePrompt")
   if prompt and prompt:IsA("ProximityPrompt") then
    prompt.Triggered:Connect(function(player) handle(player,node) end)
    count=count+1
   end
  end
 end
end
Players.PlayerRemoving:Connect(function(player)
 state[player]=nil;lastUsed[player]=nil;lastCompleted[player]=nil
end)
print("[UAE v5.5] Interactive city services started: "..count.." check-in, treatment, hotel, airport and road-rescue prompts")
