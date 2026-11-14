-- Owner marker. Other players use their own Roblox avatars.
-- Replace this username check with the verified numeric UserId when available.
local Players = game:GetService("Players")
local OWNER_USERNAME = "Muhammadsultan59966"

local function addTag(player, character)
    if string.lower(player.Name) ~= string.lower(OWNER_USERNAME) then return end
    local head = character:WaitForChild("Head", 10)
    if not head then return end
    local tag = Instance.new("BillboardGui")
    tag.Name = "UAEGameOwnerTag"
    tag.Size = UDim2.new(0, 190, 0, 48)
    tag.StudsOffset = Vector3.new(0, 3.2, 0)
    tag.AlwaysOnTop = true
    tag.Adornee = head
    tag.Parent = head
    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Size = UDim2.fromScale(1, 1)
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
    text.TextColor3 = Color3.fromRGB(255, 235, 125)
    text.TextStrokeTransparency = 0.25
    text.Text = "👑 GAME OWNER"
    text.Parent = tag
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        addTag(player, character)
    end)
end)
