-- UAE City Life 6.0 | 8 additional cross-city career missions.
-- Server-checked locations, session-only CityPoints, no simulated combat.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local request=RS:WaitForChild("UAE60_CareerRequest")
local update=RS:WaitForChild("UAE60_CareerUpdate")
local careers={
 {id="HOTEL",name="Luxury Hotel Concierge",reward=100,stops={"HOTEL","MALL","MARINA"}},
 {id="GROUND",name="DXB Ground Services",reward=130,stops={"ARRIVE","DXB","METRO","HOTEL"}},
 {id="MEDIC",name="Ambulance Community Response",reward=145,stops={"MED","MALL","CLINIC","PARK"}},
 {id="PATROL",name="Police Response Patrol",reward=150,stops={"POLICE","BANK","HOMES","FRAME"}},
 {id="FIRE",name="Civil Defence Safety Duty",reward=150,stops={"FIRE","SOUK","SHOP","PARK"}},
 {id="SKY",name="Helicopter Sightseeing Pilot",reward=175,stops={"HELIPAD","FRAME","MUSEUM","MARINA"}},
 {id="AIR",name="Passenger Jet City Tour",reward=190,stops={"DXB","MARINA","BEACH","ARRIVE"}},
 {id="TAXI",name="Dubai Airport Taxi Transfer",reward=110,stops={"TAXI","ARRIVE","HOTEL","HOMES"}},
}
local byId={}
for _,c in ipairs(careers) do
 byId[c.id]=c
 for _,stop in ipairs(c.stops) do
  assert(locations.ById[stop],"Missing Phase 6 mission landmark "..stop)
 end
end
local states={}
local recent={}
local function emit(player,t)
 if player.Parent==Players then update:FireClient(player,t) end
end
local function send(player,msg)
 local s=states[player]
 if not s then return end
 local mission=byId[s.id]
 if not mission then return end
 local loc=locations.ById[mission.stops[s.index]]
 emit(player,{
  type="waypoint",name=mission.name,
  step=s.index,total=#mission.stops,
  position=loc.position,target=loc.name,
  id=s.id,message=msg or ("Go to "..loc.name),
  points=mission.reward
 })
end
local function award(player,amount)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then
  stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player
 end
 local n=stats:FindFirstChild("CityPoints")
 if not n then
  n=Instance.new("IntValue");n.Name="CityPoints";n.Parent=stats
 end
 n.Value=n.Value+amount
end
request.OnServerEvent:Connect(function(player,cmd,id)
 if typeof(cmd)~="string" or typeof(id)~="string" or #cmd>20 or #id>20 then return end
 local now=os.clock()
 if recent[player] and now-recent[player]<.6 then return end
 recent[player]=now
 if cmd=="Start" and byId[id] then
  states[player]={id=id,index=1,after=now}
  send(player,"New career started")
 elseif cmd=="Cancel" then
  states[player]=nil
  emit(player,{type="done",message="Career shift cancelled."})
 elseif cmd=="Status" then
  send(player,"Your current career checkpoint")
 end
end)
task.spawn(function()
 while true do
  for pl,s in pairs(states) do
   if not pl.Parent then
    states[pl]=nil
   else
    local m=byId[s.id]
    local loc=m and locations.ById[m.stops[s.index]]
    local char=pl.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not loc or not m then
     states[pl]=nil
    elseif hum and root and hum.Health>0 and os.clock()-s.after>2.4 then
     local delta=Vector2.new(root.Position.X-loc.position.X,root.Position.Z-loc.position.Z)
     if delta.Magnitude<41 then
      s.index=s.index+1;s.after=os.clock()
      if s.index>#m.stops then
       states[pl]=nil
       award(pl,m.reward)
       emit(pl,{type="done",message=m.name.." completed! +"..m.reward.." CityPoints."})
      else
       send(pl,"Checkpoint reached. Follow the next career GPS.")
      end
     end
    end
   end
  end
  task.wait(1.0)
 end
end)
Players.PlayerRemoving:Connect(function(pl) states[pl]=nil;recent[pl]=nil end)
print("[UAE60] Additional playable careers:",#careers)
