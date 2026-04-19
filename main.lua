local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BloxSoft | KATAHA Edition",
    SubTitle = "by Stanislav Burlakov",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    ConfigDefault = 1, CustomName = "BloxSoft"
})

-- Улучшенный загрузчик (не ломает меню при ошибках 404)
local function GetCode(path)
    local url = "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/modules/" .. path
    local success, code = pcall(function() return game:HttpGet(url) end)
    
    if success and not code:find("404") then
        local func, err = loadstring(code)
        if func then
            local s, res = pcall(func)
            if s then return res end
        end
    end
    
    warn("⚠️ Ошибка загрузки: " .. path)
    return nil
end

-- Вкладки
local Tabs = {
    Farm = Window:AddTab({ Title = "Auto-Farm", Icon = "swords" }),
    Aim = Window:AddTab({ Title = "Aim", Icon = "target" }),
    TP = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- Предзагрузка модулей
local SpeedMod = GetCode("Misc/Speed.lua")
local NoClipMod = GetCode("Misc/NoClip.lua")
local InfJumpMod = GetCode("Misc/InfJump.lua")
local ColorMod = GetCode("Visuals/ColorSettings.lua")
local TPSettings = GetCode("TP/Settings.lua")
local EntityTP = GetCode("TP/EntityTP.lua")
local FlyMod = GetCode("Misc/Fly.lua")

--- [ Вкладка MISC ] ---
-- Используем AddSection вместо AddCollapsible для 100% стабильности
local MoveSection = Tabs.Misc:AddSection("Movement Settings")

local FlyGroup = Tabs.Misc:AddCollapsible({
    Title = "Fly Hack",
    Description = "Полет за камерой",
    Default = false
})

FlyGroup:AddToggle("FlyToggle", {
    Title = "Enable Fly",
    Default = false,
    Callback = function(v) 
        if FlyMod and FlyMod.Toggle then 
            FlyMod.Toggle(v) 
        end 
    end
})

FlyGroup:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Default = 50, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) _G.FlySpeed = v end
})
Tabs.Misc:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed",
    Description = "Настройка скорости",
    Default = 16, Min = 16, Max = 300, Rounding = 0,
    Callback = function(v) 
        if SpeedMod then SpeedMod(v) end 
    end
})

Tabs.Misc:AddToggle("NoClip", { Title = "NoClip", Default = false, Callback = function(v) if NoClipMod then NoClipMod(v) end end })
Tabs.Misc:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(v) if InfJumpMod then InfJumpMod(v) end end })

--- [ Вкладка TELEPORT ] ---
Tabs.TP:AddSection("Teleport Config")
Tabs.TP:AddSlider("Height", { 
    Title = "Height Offset", 
    Default = 7, Min = -20, Max = 20, 
    Callback = function(v) if TPSettings and TPSettings.SetHeight then TPSettings.SetHeight(v) end end 
})

Tabs.TP:AddButton({
    Title = "TP to Nearest Enemy",
    Callback = function() if EntityTP and EntityTP.ToNearest then EntityTP.ToNearest("Bandit") end end
})

--- [ Вкладка VISUALS ] ---
Tabs.Vis:AddSection("Visual Settings")
Tabs.Vis:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color) if ColorMod and ColorMod.UpdateColor then ColorMod.UpdateColor(color) end end
})

--- [ Вкладка AIM ] ---
Tabs.Aim:AddSection("Combat")
Tabs.Aim:AddToggle("AimActive", { Title = "Enable Silent Aim", Default = false, Callback = function(v) _G.AimActive = v end })

--- [ Вкладка AUTO-FARM ] ---
Tabs.Farm:AddSection("Automation")
Tabs.Farm:AddToggle("FarmToggle", { Title = "Start Auto Farm", Default = false, Callback = function(v) _G.FarmActive = v end })

Window:SelectTab(1)
