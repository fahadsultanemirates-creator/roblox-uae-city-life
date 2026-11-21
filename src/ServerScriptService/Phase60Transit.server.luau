-- UAE6: optional fast travel for PLAYTESTING large map services.
-- Uses a limited whitelist and server-checked cooldown. Not a simulated taxi.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local locations=require(RS:WaitForChild("UAE_V54_Locations"))
local allowed={
 HOTEL6=true,HOSP6=true,DXB6=true,POLICE6=true,FIRE6=true,
 REPAIR6=true,FLIGHT6=true,HELI6=true,
 HOMES=true,PARK=true,DOWNTOWN=false,BURJ=true,MARINA=true,
}
local remote=RS:FindFirstChild("UAE60_FastTravel")
if not remote then
 remote=Instance.new("RemoteEvent")
 remote.Name="UAE60_FastTravel"
 remote.Parent=RS
end
local feedback=RS:WaitForChild("UAE60_Notification",30)
local last={}
remote.OnServerEvent:Connect(function(player,id)
 if typeof(id)~="string" or #id>24 or not allowed[id] then return end
 local target=locations.ById[id]
 if not target then return end
 local now=os.clock()
 if last[player] and now-last[player]<16 then
  if feedback then feedback:FireClient(player,"City transit is ready again shortly.") end
  return
 end
 local ch=player.Character
 local humanoid=ch and ch:FindFirstChildOfClass("Humanoid")
 local root=ch and ch:FindFirstChild("HumanoidRootPart")
 if not ch or not humanoid or humanoid.Health<=0 or not root then return end
 if humanoid.SeatPart then
  if feedback then feedback:FireClient(player,"Exit your vehicle before using transit.") end
  return
 end
 last[player]=now
 local arrival=target.position+Vector3.new(0,4,0)
 ch:PivotTo(CFrame.new(arrival))
 if feedback then feedback:FireClient(player,"CITY TRANSIT: Arrived at "..target.name) end
end)
Players.PlayerRemoving:Connect(function(player) last[player]=nil end)
print("[UAE6] City transit fast-travel available to mapped service entrances")
