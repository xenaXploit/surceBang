local plr = game:GetService("Players").LocalPlayer
local suspiciousKeywords = {"anti","cheat","ac","check","security","ban","kick","detect","handler"}

-- 🔹 Whitelist supaya script penting nggak kehapus
local whitelist = {"Chat", "ChatMain", "ChatHandler", "Leaderboard", "CoreGui", "PlayerList"}

local function isWhitelisted(name)
    for _, allowed in ipairs(whitelist) do
        if name:lower():find(allowed:lower()) then
            return true
        end
    end
    return false
end

-- 🔍 Deteksi script mencurigakan
local function isSuspicious(name)
    local lower = name:lower()
    for _, keyword in ipairs(suspiciousKeywords) do
        if lower:find(keyword) and not isWhitelisted(name) then
            return true
        end
    end
    return false
end

-- 💣 Destroy semua LocalScript/ModuleScript yang nyerempet keyword
local function nukeScripts(folder)
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            if isSuspicious(obj.Name) then
                obj:Destroy()
                warn("[✅ Destroyed AC] " .. obj:GetFullName())
            end
        end
    end
end

-- 🎯 Target folder buat di-scan
local targets = {
    plr.PlayerScripts,
    plr:WaitForChild("PlayerGui"),
    plr:WaitForChild("Backpack"),
    game:GetService("ReplicatedFirst"),
    game:GetService("ReplicatedStorage"),
    game:GetService("StarterPlayer"):WaitForChild("StarterCharacterScripts"),
}

for _, folder in ipairs(targets) do
    pcall(nukeScripts, folder)
end

-- 🪝 Hook require() biar ModuleScript AC gak jalan
local oldRequire
oldRequire = hookfunction(require, function(module)
    if module:IsA("ModuleScript") and isSuspicious(module.Name) then
        warn("[🚫 Bypassed Module AC] " .. module:GetFullName())
        return {} -- return kosong
    end
    return oldRequire(module)
end)

-- 🛡️ Proteksi Fling & Speed biar aman
local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
if hum then
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if hum.WalkSpeed > 50 then
            hum.WalkSpeed = 16
        end
    end)
    hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if hum.JumpPower > 100 then
            hum.JumpPower = 50
        end
    end)
end

print("🔥 Safe Anti-Cheat Bypass Loaded (Chat & UI Aman) 🔥")
