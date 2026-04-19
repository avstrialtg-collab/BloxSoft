-- main.lua
local UserInputService = game:GetService("UserInputService")
local Menu = require(script.Menu.init)

-- Инициализация главного окна
local MainGui = Menu.CreateMenu("SoftBox", "enfarse")

-- Функция для автоматической загрузки модулей
local function LoadModules()
    local categories = {"Main", "Farm", "Esp", "Misc"}
    
    for _, catName in pairs(categories) do
        local folder = script.Module:FindFirstChild(catName)
        if folder then
            for _, moduleFile in pairs(folder:GetChildren()) do
                if moduleFile:IsA("ModuleScript") or moduleFile:IsA("LuaSourceContainer") then
                    local data = require(moduleFile) -- Каждый модуль должен возвращать {Name = "...", Callback = function}
                    Menu.AddToggleButton(catName, data.Name, data.Callback)
                end
            end
        end
    end
end

-- Управление открытием на клавишу "/"
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)

LoadModules()
