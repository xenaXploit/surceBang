-- Services
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- Atur kecepatan
local normalWalkSpeed = hum.WalkSpeed
hum.WalkSpeed = normalWalkSpeed * 2  -- 2x speed

print("🏃‍♂️ Speedhack aktif! WalkSpeed 2x normal:", hum.WalkSpeed)
