local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BloxSoft Edition",
    SubTitle = "by Enfarse",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    ConfigDefault = 1, CustomName = "BloxSoft"
})

-- Авто-загрузка модулей
local function GetCode(path)
    local url = "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/modules/" .. path
    local success, result = pcall(function() return loadstring(game:HttpGet(url))() end)
    if success then return result else warn("Ошибка загрузки: " .. path) return nil end
end

-- Вкладки
local Tabs = {
    Farm = Window:AddTab({ Title = "Auto-Farm", Icon = "sword" }),
    TP = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- Инициализация модулей
local SpeedMod = GetCode("Misc/Speed.lua")
local NoClipMod = GetCode("Misc/NoClip.lua")
local InfJumpMod = GetCode("Misc/InfJump.lua")
local ESPMod = GetCode("Visuals/ESP.lua")
local ColorMod = GetCode("Visuals/ColorSettings.lua")
local TPSettings = GetCode("TP/Settings.lua")
local EntityTP = GetCode("TP/EntityTP.lua")
local PlayerTP = GetCode("TP/PlayerTP.lua")

--- [ Вкладка MISC ] ---
local SpeedSection = Tabs.Misc:AddSection("Movement Settings")

-- Раскрывающийся список для скорости (как ты просил)
local SpeedGroup = Tabs.Misc:AddCollapsible({
    Title = "Speed Hack",
    Description = "Настройка скорости персонажа",
    Default = false
})

SpeedGroup:AddSlider("WalkSpeedSlider", {
    Title = "Custom Speed",
    Description = "Установите скорость бега",
    Default = 16, Min = 16, Max = 300, Rounding = 0,
    Callback = function(Value) SpeedMod(Value) end
})

Tabs.Misc:AddToggle("NoClip", { Title = "NoClip (Сквозь стены)", Default = false, Callback = function(v) NoClipMod(v) end })
Tabs.Misc:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(v) InfJumpMod(v) end })

--- [ Вкладка TELEPORT ] ---
Tabs.TP:AddSection("TP Offsets")
Tabs.TP:AddSlider("Height", { 
    Title = "Vertical Offset", 
    Description = "Высота над целью (минус = под землю)",
    Default = 7, Min = -20, Max = 20, 
    Callback = function(v) TPSettings.SetHeight(v) end 
})

Tabs.TP:AddSection("Target Teleports")
-- Выбор игрока
local PlayerDropdown = Tabs.TP:AddDropdown("PlayerTP", {
    Title = "Select Player",
    Values = {}, -- Заполнится автоматически
    Callback = function(v) PlayerTP.To(v) end
})

-- Обновление списка игроков при открытии
task.spawn(function()
    while true do
        local names = {}
        for _, p in pairs(game.Players:GetPlayers()) do table.insert(names, p.Name) end
        PlayerDropdown:SetValues(names)
        task.wait(5)
    end
end)

Tabs.TP:AddButton({
    Title = "TP to Nearest Bandit",
    Callback = function() EntityTP.ToNearest("Bandit") end
})

--- [ Вкладка VISUALS ] ---
Tabs.Vis:AddSection("ESP Configuration")

Tabs.Vis:AddToggle("EnableESP", { 
    Title = "Master Switch ESP", 
    Default = false, 
    Callback = function(v) _G.EspActive = v end 
})

Tabs.Vis:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color) ColorMod.UpdateColor(color) end
})

--- [ Вкладка AUTO-FARM ] ---
Tabs.Farm:AddSection("Farm Controls")
Tabs.Farm:AddToggle("AutoBandit", {
    Title = "Farm Bandits",
    Default = false,
    Callback = function(v) _G.FarmActive = v end
})

Window:SelectTab(1)
