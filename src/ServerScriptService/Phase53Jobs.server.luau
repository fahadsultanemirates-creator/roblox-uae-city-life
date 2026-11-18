-- UAE CITY LIFE v5.3: server-authoritative, noncombat city roleplay jobs.
-- Players can use a kiosk or JOBS button. Rewards are session-only CityPoints.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local park=world:WaitForChild("Phase53CommunityPark")
local function event(name)
 local obj=RS:FindFirstChild(name)
 if not obj then obj=Instance.new("RemoteEvent");obj.Name=name;obj.Parent=RS end
 return obj
end
local request=event("UAE_V53_JobRequest")
local update=event("UAE_V53_JobUpdate")
local jobs={
 Taxi={
  title="Dubai Taxi Service",
  reward=55,
  steps={
   {label="Pick up a guest at Karak Cafe",pos=Vector3.new(-225,5,-671)},
   {label="Drive to Hotel Al Wasl",pos=Vector3.new(80,5,-671)},
   {label="Return to the residential taxi stand",pos=Vector3.new(5,5,-746)},
  }
 },
 Medic={
  title="Clinic Community Helper",
  reward=55,
  steps={
   {label="Report to Dubai Clinic",pos=Vector3.new(-370,5,-669)},
   {label="Visit the community park",pos=Vector3.new(0,5,-855)},
   {label="Return to the clinic",pos=Vector3.new(-370,5,-669)},
  }
 },
 Tour={
  title="Dubai Sightseeing Guide",
  reward=70,
  steps={
   {label="Start the tour at the community park",pos=Vector3.new(0,5,-855)},
   {label="Visit Sheikh Zayed Road",pos=Vector3.new(107,5,-1200)},
   {label="Arrive near Burj Khalifa",pos=Vector3.new(115,6,-392)},
  }
 },
}
local state={}
local lastStart={}
local function notify(player,payload)
 if player.Parent==Players then update:FireClient(player,payload) end
end
local function sendStep(player,current,phrase)
 local job=jobs[current.kind]
 if not job then return end
 local item=job.steps[current.step]
 notify(player,{
  kind="progress",name=job.title,step=current.step,total=#job.steps,
  label=item.label,position=item.pos,reward=job.reward,message=phrase or ""
 })
end
local function start(player,kind)
 if not jobs[kind] then return end
 if player.Parent~=Players then return end
 local now=os.clock()
 if lastStart[player] and now-lastStart[player]<2 then return end
 lastStart[player]=now
 state[player]={kind=kind,step=1,stageStarted=now}
 sendStep(player,state[player],"New shift: "..jobs[kind].title)
end
request.OnServerEvent:Connect(function(player,command,kind)
 if typeof(command)~="string" or typeof(kind)~="string" then return end
 if command=="Start" then
  start(player,kind)
 elseif command=="Cancel" then
  state[player]=nil
  notify(player,{kind="cancelled",message="Shift ended. Choose another job anytime."})
 elseif command=="Status" then
  local current=state[player]
  if current then sendStep(player,current,"Current shift") end
 end
end)
local boards=park:WaitForChild("JobKiosks")
for _,kiosk in ipairs(boards:GetChildren()) do
 local prompt=kiosk:IsA("BasePart") and kiosk:FindFirstChildOfClass("ProximityPrompt")
 local job=kiosk:GetAttribute("RoleKey")
 if prompt and typeof(job)=="string" and jobs[job] then
  prompt.Triggered:Connect(function(player)
   local char=player.Character
   local root=char and char:FindFirstChild("HumanoidRootPart")
   if root and (root.Position-kiosk.Position).Magnitude<16 then start(player,job) end
  end)
 end
end
task.spawn(function()
 while park.Parent do
  for player,current in pairs(state) do
   local def=jobs[current.kind]
   local step=def and def.steps[current.step]
   local char=player.Character
   local hum=char and char:FindFirstChildOfClass("Humanoid")
   local root=char and char:FindFirstChild("HumanoidRootPart")
   if not player.Parent or not def then
    state[player]=nil
   elseif step and root and hum and hum.Health>0 then
    if os.clock()-current.stageStarted>2 and
     (root.Position-step.pos).Magnitude<=24 then
     current.step=current.step+1
     current.stageStarted=os.clock()
     if current.step>#def.steps then
      state[player]=nil
      local stats=player:FindFirstChild("leaderstats")
      local score=stats and stats:FindFirstChild("CityPoints")
      if not score then
       if not stats then
        stats=Instance.new("Folder")
        stats.Name="leaderstats"
        stats.Parent=player
       end
       score=Instance.new("IntValue")
       score.Name="CityPoints"
       score.Parent=stats
      end
      score.Value=score.Value+def.reward
      notify(player,{kind="completed",name=def.title,
        message="Shift complete! +"..def.reward.." CityPoints"})
     else
      sendStep(player,current,"Checkpoint completed. Next destination:")
     end
    end
   end
  end
  task.wait(1.25)
 end
end)
Players.PlayerRemoving:Connect(function(player)
 state[player]=nil
 lastStart[player]=nil
end)
