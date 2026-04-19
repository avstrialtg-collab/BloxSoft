-- main.lua
local UserInputService = game:GetService("UserInputService")
-- Исправляем путь: если Menu лежит в той же папке, что и main
local Menu = require(script:WaitForChild("Menu")) 

-- Создаем меню
Menu.CreateMenu("SoftBox", "enfarse")

-- Функция загрузки
local function LoadModules()
    local moduleFolder = script:WaitForChild("Module")
    local categories = {"Main", "Farm", "Esp", "Misc"}
    
    for _, catName in pairs(categories) do
        local folder = moduleFolder:FindFirstChild(catName)
        if folder then
            for _, file in pairs(folder:GetChildren()) do
                if file:IsA("ModuleScript") then
                    local success, data = pcall(require, file)
                    if success and data.Name and data.Callback then
                        -- Добавляем кнопку в нужную вкладку
                        Menu.AddToggleButton(catName, data.Name, data.Callback)
                    else
                        warn("Ошибка в модуле " .. file.Name .. ": " .. tostring(data))
                    end
                end
            end
        end
    end
end

-- Открытие на "/"
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)

LoadModules()
