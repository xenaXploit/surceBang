local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- ====== Pengaturan ======
local infJumpEnabled  = true    -- auto ON
local jumpBoostY      = 55      -- kekuatan dorongan ke atas
local slowFallEnabled = true    -- aktifkan slow fall
local maxFallSpeed    = -25     -- kecepatan jatuh maksimum
local antiFallDamage  = true    -- mencegah damage jatuh

-- ====== Helper ======
local function getHumanoidAndHRP()
    local char = lp.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return hum, hrp
end

-- ====== Core ======
local jumpConn, diedConn, fallConn, stateConn

local function attachFeatures()
    -- Infinite Jump
    if jumpConn then jumpConn:Disconnect() end
    jumpConn = UIS.JumpRequest:Connect(function()
        if not infJumpEnabled then return end
        local hum, hrp = getHumanoidAndHRP()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        if hrp then
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, jumpBoostY, v.Z)
        end
    end)

    -- Slow Fall
    if fallConn then fallConn:Disconnect() end
    fallConn = RunService.Heartbeat:Connect(function()
        if not slowFallEnabled then return end
        local _, hrp = getHumanoidAndHRP()
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            if vel.Y < maxFallSpeed then
                hrp.AssemblyLinearVelocity = Vector3.new(vel.X, maxFallSpeed, vel.Z)
            end
        end
    end)

    -- Anti Fall Damage (versi aman respawn)
    if antiFallDamage then
        if stateConn then stateConn:Disconnect() end
        local hum = lp.Character:WaitForChild("Humanoid")
        local lastHealth
        hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Freefall then
                lastHealth = hum.Health -- simpan HP sebelum jatuh
            elseif newState == Enum.HumanoidStateType.Landed and lastHealth then
                if hum.Health < lastHealth then
                    hum.Health = lastHealth -- kembalikan HP kalau berkurang karena jatuh
                end
                lastHealth = nil
            end
        end)
    end
end

local function onCharacterAdded(char)
    if diedConn then diedConn:Disconnect() end
    local hum = char:WaitForChild("Humanoid", 10)
    attachFeatures()
    if hum then
        diedConn = hum.Died:Connect(function()
            if jumpConn then jumpConn:Disconnect() end
            if fallConn then fallConn:Disconnect() end
            if stateConn then stateConn:Disconnect() end
        end)
    end
end

-- Boot
if lp.Character then onCharacterAdded(lp.Character) end
lp.CharacterAdded:Connect(onCharacterAdded)

-- Keybind toggle Infinite Jump (J) dan Slow Fall (K)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.J then
        infJumpEnabled = not infJumpEnabled
        print(("Infinite Jump: %s"):format(infJumpEnabled and "ON" or "OFF"))
    elseif input.KeyCode == Enum.KeyCode.K then
        slowFallEnabled = not slowFallEnabled
        print(("Slow Fall: %s"):format(slowFallEnabled and "ON" or "OFF"))
    end
end)
