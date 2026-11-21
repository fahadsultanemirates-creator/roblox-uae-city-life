-- UAE6: six longer server-authoritative roleplay journeys (session-only).
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local quests={
 {id="RESCUE",title="Emergency Response Dispatch",reward=180,
  stops={{"Hospital Emergency Reception",-235,-1095},
   {"Airport Arrivals",-970,-1120},{"Hospital Return",-235,-1095}}},
 {id="POLICE",title="City Safety Patrol",reward=150,
  stops={{"Police Operations Office",-1135,-480},
   {"Downtown Mall Area",100,-399},{"Police Duty Return",-1135,-480}}},
 {id="FIRE",title="Civil Defence Rescue Drill",reward=180,
  stops={{"Civil Defence Training",-1135,-630},
   {"E11 Road Safety Incident",0,-1200},{"Civil Defence Return",-1135,-630}}},
 {id="AIR",title="Pilot Training & City Flyover",reward=230,
  stops={{"DXB Airport Terminal",-1020,-925},
   {"Aircraft Runway",-1280,-1350},{"Museum Flyover",315,-1180},
   {"Dubai Marina",1060,-1285}}},
 {id="HOTEL",title="International Tourist Transfer",reward=170,
  stops={{"DXB Arrivals",-970,-1120},
   {"Hotel Guest Check-in",-550,-890},
   {"Burj Khalifa Downtown",-84,-392}}},
 {id="COAST",title="Marina Search & Safety",reward=170,
  stops={{"Dubai Marina",1060,-1285},
   {"Cruise Port",1110,-1450},{"Jumeirah Beach Walk",1050,-720}}},
}
local lookup={}
for _,q in ipairs(quests) do lookup[q.id]=q end
local start=RS:FindFirstChild("UAE60_QuestRequest")
if not start then start=Instance.new("RemoteEvent");start.Name="UAE60_QuestRequest";start.Parent=RS end
local update=RS:FindFirstChild("UAE60_QuestUpdate")
if not update then update=Instance.new("RemoteEvent");update.Name="UAE60_QuestUpdate";update.Parent=RS end
local active={}
local last={}
local function send(player,state,phrase)
 local quest=lookup[state.id]
 local stop=quest.stops[state.step]
 update:FireClient(player,{status="active",id=quest.id,title=quest.title,
  stage=state.step,total=#quest.stops,name=stop[1],
  position=Vector3.new(stop[2],5,stop[3]),reward=quest.reward,message=phrase})
end
start.OnServerEvent:Connect(function(player,action,id)
 if typeof(action)~="string" or typeof(id)~="string" or #action>16 or #id>22 then return end
 local now=os.clock()
 if last[player] and now-last[player]<.7 then return end
 last[player]=now
 if action=="Start" and lookup[id] then
  active[player]={id=id,step=1,since=now}
  send(player,active[player],"Mission started! Follow the golden GPS destination.")
 elseif action=="Cancel" then
  active[player]=nil
  update:FireClient(player,{status="cancelled",message="Mission cancelled."})
 elseif action=="Status" and active[player] then
  send(player,active[player],"Continue to the next checkpoint.")
 end
end)
local function award(player,reward)
 local stats=player:FindFirstChild("leaderstats")
 if not stats then stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player end
 local points=stats:FindFirstChild("CityPoints")
 if not points then points=Instance.new("IntValue");points.Name="CityPoints";points.Parent=stats end
 points.Value=points.Value+reward
end
task.spawn(function()
 while true do
  for player,state in pairs(active) do
   local q=lookup[state.id]
   local stop=q and q.stops[state.step]
   local ch=player.Character
   local root=ch and ch:FindFirstChild("HumanoidRootPart")
   local hum=ch and ch:FindFirstChildOfClass("Humanoid")
   if not player.Parent or not stop then active[player]=nil
   elseif root and hum and hum.Health>0 and os.clock()-state.since>=2 then
    local distance=(Vector2.new(root.Position.X,root.Position.Z)-
     Vector2.new(stop[2],stop[3])).Magnitude
    local maxDist=q.id=="AIR" and 75 or 34
    if distance<=maxDist then
     state.step=state.step+1
     state.since=os.clock()
     if state.step>#q.stops then
      active[player]=nil
      award(player,q.reward)
      update:FireClient(player,{status="complete",
       message=q.title.." complete! +"..q.reward.." CityPoints."})
     else
      send(player,state,"Checkpoint reached. Follow the next GPS marker.")
     end
    end
   end
  end
  task.wait(1.2)
 end
end)
Players.PlayerRemoving:Connect(function(player) active[player]=nil;last[player]=nil end)
print("[UAE6] Six longer route missions online")
