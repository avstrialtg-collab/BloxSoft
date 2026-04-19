local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BloxSoft | KATAHA Edition",
    SubTitle = "by Stanislav Burlakov",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    ConfigDefault = 1, CustomName = "BloxSoft"
})

-- Улучшенная функция загрузки
local function GetCode(path)
    local url = "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/modules/" .. path
    local success, result = pcall(function() 
        local code = game:HttpGet(url)
        return loadstring(code)() 
    end)
    if success and result then 
        return result 
    else 
        warn("⚠️ Модуль не найден или ошибка в коде: " .. path)
        return function() print("Модуль " .. path .. " пока не готов") end -- Заглушка, чтобы не ломать меню
    end
end

-- Вкладки
local Tabs = {
    Farm = Window:AddTab({ Title = "Auto-Farm", Icon = "swords" }),
    Aim = Window:AddTab({ Title = "Aim", Icon = "target" }),
    TP = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- Ленивая загрузка (загружаем только когда нужно, чтобы не вешать меню)
local SpeedMod = GetCode("Misc/Speed.lua")
local NoClipMod = GetCode("Misc/NoClip.lua")
local InfJumpMod = GetCode("Misc/InfJump.lua")
local ColorMod = GetCode("Visuals/ColorSettings.lua")
local TPSettings = GetCode("TP/Settings.lua")
local EntityTP = GetCode("TP/EntityTP.lua")

--- [ Вкладка MISC ] ---
local MiscGroup = Tabs.Misc:AddCollapsible({
    Title = "Speed & Movement",
    Description = "Настройки передвижения",
    Default = true
})

MiscGroup:AddSlider("WalkSpeedSlider", {
    Title = "Custom Speed",
    Default = 16, Min = 16, Max = 300, Rounding = 0,
    Callback = function(Value) 
        pcall(function() SpeedMod(Value) end)
    end
})

MiscGroup:AddToggle("NoClip", { Title = "NoClip", Default = false, Callback = function(v) NoClipMod(v) end })
MiscGroup:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(v) InfJumpMod(v) end })

--- [ Вкладка TELEPORT ] ---
Tabs.TP:AddSlider("Height", { 
    Title = "Vertical Offset", 
    Default = 7, Min = -20, Max = 20, 
    Callback = function(v) if TPSettings.SetHeight then TPSettings.SetHeight(v) end end 
})

Tabs.TP:AddButton({
    Title = "TP to Nearest Enemy",
    Callback = function() if EntityTP.ToNearest then EntityTP.ToNearest("Bandit") end end
})

--- [ Вкладка VISUALS ] ---
Tabs.Vis:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color) if ColorMod.UpdateColor then ColorMod.UpdateColor(color) end end
})

--- [ Вкладка AIM ] ---
Tabs.Aim:AddSection("Silent Aim")
Tabs.Aim:AddToggle("AimBot", { Title = "Enable Aim", Default = false, Callback = function(v) _G.AimActive = v end })

--- [ Вкладка AUTO-FARM ] ---
Tabs.Farm:AddToggle("AutoBandit", { Title = "Farm Bandits", Default = false, Callback = function(v) _G.FarmActive = v end })

Window:SelectTab(1)
