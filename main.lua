local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BloxSoft | KATAHA Edition",
    SubTitle = "by Stanislav Burlakov",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    ConfigDefault = 1, CustomName = "BloxSoft"
})

local function GetCode(path)
    local url = "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/modules/" .. path
    local success, code = pcall(function() return game:HttpGet(url) end)
    
    if success and not code:find("404") then
        local func = loadstring(code)
        if func then
            local s, res = pcall(func)
            if s then return res end
        end
    end
    warn("⚠️ Ошибка загрузки: " .. path)
    return nil
end

local Tabs = {
    Farm = Window:AddTab({ Title = "Auto-Farm", Icon = "swords" }),
    Aim = Window:AddTab({ Title = "Aim", Icon = "target" }),
    TP = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- Модули
local SpeedMod = GetCode("Misc/Speed.lua")
local NoClipMod = GetCode("Misc/NoClip.lua")
local InfJumpMod = GetCode("Misc/InfJump.lua")
local FlyMod = GetCode("Misc/Fly.lua")
local GodMod = GetCode("Misc/GodMode.lua")
local TPSettings = GetCode("TP/Settings.lua")
local EntityTP = GetCode("TP/EntityTP.lua")

--- [ Вкладка MISC ] ---
Tabs.Misc:AddSection("Safety & Combat")

Tabs.Misc:AddToggle("GodModeToggle", {
    Title = "God Mode (Бессмертие)",
    Default = false,
    Callback = function(v) if GodMod then GodMod.Toggle(v) end end
})

Tabs.Misc:AddSection("Flight Control")

Tabs.Misc:AddToggle("FlyToggle", {
    Title = "Enable Fly",
    Default = false,
    Callback = function(v) if FlyMod then FlyMod.Toggle(v) end end
})

Tabs.Misc:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Default = 50, Min = 10, Max = 300, Rounding = 0, -- Исправлено: добавлен Rounding
    Callback = function(v) _G.FlySpeed = v end
})

Tabs.Misc:AddSection("Movement Settings")

Tabs.Misc:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Default = 16, Min = 16, Max = 300, Rounding = 0, -- Исправлено: добавлен Rounding
    Callback = function(v) if SpeedMod then SpeedMod(v) end end
})

Tabs.Misc:AddToggle("NoClip", { Title = "NoClip", Default = false, Callback = function(v) if NoClipMod then NoClipMod(v) end end })
Tabs.Misc:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(v) if InfJumpMod then InfJumpMod(v) end end })

--- [ Вкладка TELEPORT ] ---
Tabs.TP:AddSection("Config")
Tabs.TP:AddSlider("Height", { 
    Title = "Height Offset", 
    Default = 7, Min = -20, Max = 20, Rounding = 0,
    Callback = function(v) if TPSettings then TPSettings.SetHeight(v) end end 
})

Tabs.TP:AddButton({
    Title = "TP to Nearest Enemy",
    Callback = function() if EntityTP then EntityTP.ToNearest("Bandit") end end
})

--- [ Вкладка AIM ] ---
Tabs.Aim:AddSection("Combat")
Tabs.Aim:AddToggle("AimBot", { Title = "Enable Silent Aim", Default = false, Callback = function(v) _G.AimActive = v end })

Window:SelectTab(1)
