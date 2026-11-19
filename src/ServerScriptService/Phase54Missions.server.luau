-- UAE City Life v5.4: SERVER-controlled missions and temporary rewards.
-- 10 non-combat routes, all targets chosen from the in-game landmark catalogue.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local function remote(name)
 local found=RS:FindFirstChild(name)
 if found then return found end
 local new=Instance.new("RemoteEvent")
 new.Name=name
 new.Parent=RS
 return new
end
local request=remote("UAE_V54_MissionRequest")
local updates=remote("UAE_V54_MissionUpdate")
local missions={
 {id="MEDIC",title="Ambulance Assistance",reward=110,
  description="Community clinic checks and medical assistance.",
  stops={"CLINIC","MED","PARK"}},
 {id="POLICE",title="Dubai Police Community Patrol",reward=120,
  description="Visit the precinct, market and Dubai Frame.",
  stops={"POLICE","MARKET","FRAME"}},
 {id="FIRE",title="Civil Defence Safety Inspection",reward=120,
  description="Inspect the fire station and major shopping areas.",
  stops={"FIRE","SOUK","SHOP"}},
 {id="AIRPORT",title="Dubai Airport Shuttle",reward=120,
  description="Carry a simulated passenger from homes to DXB.",
  stops={"HOMES","DXB","ARRIVE"}},
 {id="SIGHTS",title="Dubai Landmark Photo Trail",reward=160,
  description="Visit iconic landmarks around the city.",
  stops={"BURJ","MUSEUM","FRAME","ARAB"}},
 {id="MARINA",title="Marina Safety Volunteer",reward=110,
  description="Visit the marina, cruise port and beach walk.",
  stops={"MARINA","CRUISE","BEACH"}},
 {id="DELIVERY",title="Karak & Grocery Delivery",reward=90,
  description="Deliver a simulated order through neighbourhood stops.",
  stops={"KARAK","MARKET","HOMES"}},
 {id="METRO",title="Public Transport Explorer",reward=140,
  description="Ride the city on foot between metro, E11 and airport.",
  stops={"METRO","E11","MUSEUM","DXB"}},
 {id="HEALTH",title="Dubai Healthcare Checkup",reward=100,
  description="Visit the hospital, clinic and community park.",
  stops={"MED","CLINIC","PARK"}},
 {id="CLEANUP",title="Community Park Volunteer",reward=90,
  description="Help with simulated city park and beach checks.",
  stops={"PARK","GARDEN","BEACH"}},
}
local byId={}
for _,mission in ipairs(missions) do
 byId[mission.id]=mission
 for _,id in ipairs(mission.stops) do
  assert(locations.ById[id],"Unknown mission target: "..id)
 end
end
local sessions={}
local lastRequest={}
local function tell(player,message)
 if player.Parent==Players then updates:FireClient(player,message) end
end
local function currentStep(player,prefix)
 local state=sessions[player]
 if not state then return end
 local mission=byId[state.id]
 local loc=locations.ById[mission.stops[state.stage]]
 tell(player,{
  state="active",
  id=mission.id,title=mission.title,
  stage=state.stage,total=#mission.stops,
  destinationId=loc.id,destinationName=loc.name,
  destinationPosition=loc.position,
  reward=mission.reward,
  message=prefix or ("Visit "..loc.name),
 })
end
local function start(player,id)
 local mission=byId[id]
 if not mission then return end
 sessions[player]={id=mission.id,stage=1,activated=os.clock()}
 currentStep(player,"New mission: "..mission.title)
end
local function canRequest(player)
 local now=os.clock()
 if lastRequest[player] and now-lastRequest[player]<.7 then return false end
 lastRequest[player]=now
 return true
end
request.OnServerEvent:Connect(function(player,kind,id)
 if typeof(kind)~="string" or #kind>20 then return end
 if typeof(id)~="string" or #id>20 then return end
 if not canRequest(player) then return end
 if kind=="Start" then
  start(player,id)
 elseif kind=="Cancel" then
  sessions[player]=nil
  tell(player,{state="cancelled",message="Mission cancelled."})
 elseif kind=="Status" then
  currentStep(player,"Current mission in progress")
 end
end)
local function addPoints(player,points)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then
  stats=Instance.new("Folder")
  stats.Name="leaderstats"
  stats.Parent=player
 end
 local score=stats:FindFirstChild("CityPoints")
 if not score then
  score=Instance.new("IntValue")
  score.Name="CityPoints"
  score.Parent=stats
 end
 score.Value=score.Value+points
end
task.spawn(function()
 while true do
  for player,state in pairs(sessions) do
   local def=byId[state.id]
   local loc=def and locations.ById[def.stops[state.stage]]
   local character=player.Character
   local hum=character and character:FindFirstChildOfClass("Humanoid")
   local root=character and character:FindFirstChild("HumanoidRootPart")
   if not player.Parent or not def or not loc then
    sessions[player]=nil
   elseif root and hum and hum.Health>0 and os.clock()-state.activated>2.25 then
    -- horizontal radius allows destinations underneath elevated stations.
    local delta=Vector2.new(root.Position.X-loc.position.X,
     root.Position.Z-loc.position.Z)
    if delta.Magnitude<=36 then
     state.stage=state.stage+1
     state.activated=os.clock()
     if state.stage>#def.stops then
      sessions[player]=nil
      addPoints(player,def.reward)
      tell(player,{state="complete",id=def.id,
       message=def.title.." completed! +"..def.reward.." CityPoints."})
     else
      currentStep(player,"Checkpoint reached. Travel to the next destination.")
     end
    end
   end
  end
  task.wait(1)
 end
end)
Players.PlayerRemoving:Connect(function(player)
 sessions[player]=nil
 lastRequest[player]=nil
end)
print("UAE v5.4 mission service: "..#missions.." routes ready")
