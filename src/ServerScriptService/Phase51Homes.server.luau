-- UAE CITY LIFE v5.1: server-controlled Brookhaven-style house roleplay.
-- Every user may keep their own Roblox avatar. Claims are per server/session.
-- Neither house ownership nor furnishings are saved across servers yet.
local Players=game:GetService("Players")
local world=workspace:WaitForChild("UAE_City_Life")
local homes=world:WaitForChild("Phase51_RoleplayHomes")
local catalog=homes:WaitForChild("Villas")
local ownedByUser={}
local function getCharacterRoot(player)
 local character=player.Character
 return character and character:FindFirstChild("HumanoidRootPart")
end
local function near(player,p,maxDistance)
 local root=getCharacterRoot(player)
 return root and (root.Position-p.Position).Magnitude <=maxDistance
end
local function setNotice(model,message)
 local status=model:FindFirstChild("StatusSign",true)
 local gui=status and status:FindFirstChildOfClass("SurfaceGui")
 local label=gui and gui:FindFirstChildOfClass("TextLabel")
 if label then label.Text=message end
end
local function resetHome(home)
 home:SetAttribute("OwnerUserId",0)
 home:SetAttribute("OwnerName","")
 home:SetAttribute("Locked",false)
 home:SetAttribute("DoorOpen",false)
 home:SetAttribute("DoorVersion",(home:GetAttribute("DoorVersion") or 0)+1)
 local door=home:FindFirstChild("FrontDoor")
 if door and door:IsA("BasePart") then
  door.CanCollide=true
  door.Transparency=.06
 end
 setNotice(home,home.Name.."\nAVAILABLE")
end
local function canUseDoor(player,home)
 local owner=home:GetAttribute("OwnerUserId") or 0
 local locked=home:GetAttribute("Locked")
 return not locked or owner==player.UserId
end
for _,home in ipairs(catalog:GetChildren()) do
 if home:IsA("Model") then
  resetHome(home)
  local claim=home:FindFirstChild("ClaimPad")
  local door=home:FindFirstChild("FrontDoor")
  local lock=home:FindFirstChild("LockPad")
  local bed=home:FindFirstChild("Bed")
  local claimPrompt=claim and claim:FindFirstChildOfClass("ProximityPrompt")
  local doorPrompt=door and door:FindFirstChildOfClass("ProximityPrompt")
  local lockPrompt=lock and lock:FindFirstChildOfClass("ProximityPrompt")
  local bedPrompt=bed and bed:FindFirstChildOfClass("ProximityPrompt")
  if claimPrompt then
   claimPrompt.Triggered:Connect(function(player)
    if not near(player,claim,15) then return end
    local owner=home:GetAttribute("OwnerUserId") or 0
    if owner==player.UserId then
     ownedByUser[player.UserId]=nil
     resetHome(home)
     return
    end
    if owner~=0 then return end
    local previous=ownedByUser[player.UserId]
    if previous and previous.Parent then resetHome(previous) end
    ownedByUser[player.UserId]=home
    home:SetAttribute("OwnerUserId",player.UserId)
    home:SetAttribute("OwnerName",player.DisplayName)
    home:SetAttribute("Locked",false)
    setNotice(home,home.Name.."\n"..player.DisplayName.."'s home")
   end)
  end
  if doorPrompt then
   doorPrompt.Triggered:Connect(function(player)
    if not near(player,door,15) or not canUseDoor(player,home) then return end
    local newState=not home:GetAttribute("DoorOpen")
    home:SetAttribute("DoorOpen",newState)
    door.CanCollide=not newState
    door.Transparency=newState and .76 or .06
    home:SetAttribute("DoorVersion",(home:GetAttribute("DoorVersion") or 0)+1)
    local version=home:GetAttribute("DoorVersion")
    if newState then
     task.delay(9,function()
      if home.Parent and home:GetAttribute("DoorVersion")==version then
       home:SetAttribute("DoorOpen",false)
       door.CanCollide=true
       door.Transparency=.06
      end
     end)
    end
   end)
  end
  if lockPrompt then
   lockPrompt.Triggered:Connect(function(player)
    if not near(player,lock,15) then return end
    if home:GetAttribute("OwnerUserId")~=player.UserId then return end
    local locked=not home:GetAttribute("Locked")
    home:SetAttribute("Locked",locked)
    setNotice(home,home.Name.."\n"..player.DisplayName..(locked and " • LOCKED" or " • OPEN"))
   end)
  end
  if bedPrompt then
   bedPrompt.Triggered:Connect(function(player)
    if not near(player,bed,15) or not canUseDoor(player,home) then return end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health>0 then
     hum.Health=math.min(hum.MaxHealth,hum.Health+25)
    end
   end)
  end
 end
end
Players.PlayerRemoving:Connect(function(player)
 local home=ownedByUser[player.UserId]
 if home and home.Parent then resetHome(home) end
 ownedByUser[player.UserId]=nil
end)
