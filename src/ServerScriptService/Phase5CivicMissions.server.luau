-- Phase 5: server-validated civic missions with temporary CityPoints.
-- Mission rewards and progress are SESSION ONLY. No datastore, unsafe rewards or combat.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local world=workspace:WaitForChild("UAE_City_Life")
local content=world:WaitForChild("Phase5_DubaiModern")
local prompts=content:WaitForChild("MissionBoards")
local updates=RS:FindFirstChild("UAE_MissionUpdate")
if not updates then
 updates=Instance.new("RemoteEvent")
 updates.Name="UAE_MissionUpdate"
 updates.Parent=RS
end
local missionDefinitions={
 Explorer={
  label="UAE Explorer",
  points={
   {name="Burj Khalifa",pos=Vector3.new(-84,0,-392)},
   {name="Dubai Mall",pos=Vector3.new(100,0,-399)},
   {name="Museum of the Future",pos=Vector3.new(315,0,-1180)},
  },
  reward=70,
 },
 Police={
  label="Police Community Patrol",
  points={
   {name="Dubai Mall crosswalk",pos=Vector3.new(120,0,-360)},
   {name="Sheikh Zayed Road",pos=Vector3.new(0,0,-1200)},
   {name="Museum district",pos=Vector3.new(315,0,-1180)},
  },
  reward=120,
 },
 Ambulance={
  label="Ambulance Assistance",
  points={
   {name="UAE Family Park",pos=Vector3.new(220,0,360)},
   {name="Dubai Medical Centre",pos=Vector3.new(-235,0,-1175)},
  },
  reward=120,
 },
 Fire={
  label="Civil Defence Safety Exercise",
  points={
   {name="Sheikh Zayed Road fire drill",pos=Vector3.new(-260,0,-1190)},
   {name="Safe community assembly",pos=Vector3.new(220,0,360)},
  },
  reward=120,
 },
}
local states={}
local function send(player,msg)
 if player.Parent==Players then updates:FireClient(player,msg) end
end
local function begin(player,kind)
 local mission=missionDefinitions[kind]
 if not mission then return end
 states[player]={kind=kind,stage=1,lastTick=0}
 send(player,"📍 "..mission.label..": "..mission.points[1].name)
end
local function setup(player)
 local leaderboard=player:FindFirstChild("leaderstats")
 if not leaderboard then
  leaderboard=Instance.new("Folder")
  leaderboard.Name="leaderstats"
  leaderboard.Parent=player
 end
 local points=leaderboard:FindFirstChild("CityPoints")
 if not points then
  points=Instance.new("IntValue")
  points.Name="CityPoints"
  points.Value=0
  points.Parent=leaderboard
 end
 begin(player,"Explorer")
end
Players.PlayerAdded:Connect(setup)
for _,p in ipairs(Players:GetPlayers()) do setup(p) end
Players.PlayerRemoving:Connect(function(player) states[player]=nil end)
for _,board in ipairs(prompts:GetChildren()) do
 local prompt=board:FindFirstChildOfClass("ProximityPrompt")
 local kind=board:GetAttribute("MissionType")
 if prompt and missionDefinitions[kind] then
  prompt.Triggered:Connect(function(player)
   -- Roblox ProximityPrompt handles nearby activation; validate range server-side.
   local char=player.Character
   local rootPart=char and char:FindFirstChild("HumanoidRootPart")
   if not rootPart or (rootPart.Position-board.Position).Magnitude>22 then return end
   begin(player,kind)
  end)
 end
end
task.spawn(function()
 while content.Parent do
  task.wait(.6)
  for player,state in pairs(states) do
   if player.Parent~=Players then
    states[player]=nil
   else
    local mission=missionDefinitions[state.kind]
    local target=mission.points[state.stage]
    if target then
     local char=player.Character
     local rootPart=char and char:FindFirstChild("HumanoidRootPart")
     if rootPart then
      local a=rootPart.Position
      local delta=Vector3.new(a.X-target.pos.X,0,a.Z-target.pos.Z)
      if delta.Magnitude<55 then
       state.stage=state.stage+1
       if state.stage>#mission.points then
        local ls=player:FindFirstChild("leaderstats")
        local city=ls and ls:FindFirstChild("CityPoints")
        if city then city.Value=city.Value+mission.reward end
        send(player,"✅ "..mission.label.." complete! +"..mission.reward.." CityPoints")
        states[player]=nil
       else
        send(player,"✅ Checkpoint! Next: "..mission.points[state.stage].name)
       end
      end
     end
    end
   end
  end
 end
end)
