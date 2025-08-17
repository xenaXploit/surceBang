local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- ===== GUI Setup =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerCountGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = lp:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 120, 0, 30)
label.Position = UDim2.new(0.02, 0, 0.02, 0)
label.BackgroundColor3 = Color3.fromRGB(25,25,25)
label.BackgroundTransparency = 0.3
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Text = "Players: 0"
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.Active = true
label.Parent = screenGui

-- ===== Update Player Count =====
local function updatePlayerCount()
    label.Text = "Players: "..#Players:GetPlayers()
end

Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)
updatePlayerCount()

-- ===== Drag Functionality Mobile =====
local dragging = false
local dragStart, startPos

label.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = label.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

label.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        label.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
