local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BloxSoft | KATAHA Edition",
    SubTitle = "by Stanislav Burlakov",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    ConfigDefault = 1, CustomName = "BloxSoft"
})

-- Функция авто-загрузки (Замени 'avstrialtg-collab' на свой ник)
local function GetCode(path)
    local url = "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/modules/" .. path
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if success then return result else warn("Ошибка загрузки модуля: " .. path) return nil end
end

-- Вкладки
local Tabs = {
    Farm = Window:AddTab({ Title = "Auto-Farm", Icon = "swords" }),
    TP = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- ПОДКЛЮЧЕНИЕ МОДУЛЕЙ
-- 1. Misc
local SpeedMod = GetCode("Misc/Speed.lua")
local JumpMod = GetCode("Misc/Jump.lua")
local NoClipMod = GetCode("Misc/NoClip.lua")
local InfJumpMod = GetCode("Misc/InfJump.lua")

-- 2. Visuals
local ESPMod = GetCode("Visuals/ESP.lua")
local ColorMod = GetCode("Visuals/ColorSettings.lua")

-- 3. TP
local TPSettings = GetCode("TP/Settings.lua")
local EntityTP = GetCode("TP/EntityTP.lua")

-- Отрисовка интерфейса (Пример для Misc)
Tabs.Misc:AddSlider("WalkSpeed", { Title = "Speed", Default = 16, Min = 16, Max = 300, Rounding = 0, Callback = function(v) SpeedMod(v) end })
Tabs.Misc:AddToggle("NoClip", { Title = "NoClip", Default = false, Callback = function(v) NoClipMod(v) end })
Tabs.Misc:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(v) InfJumpMod(v) end })

-- Отрисовка TP
Tabs.TP:AddSection("Offsets")
Tabs.TP:AddSlider("Height", { Title = "TP Height", Default = 7, Min = -20, Max = 20, Callback = function(v) TPSettings.SetHeight(v) end })

Tabs.TP:AddButton({ Title = "TP to Nearest Entity", Callback = function() EntityTP.ToNearest("Bandit") end })

Window:SelectTab(1)
