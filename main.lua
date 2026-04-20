local UserInputService = game:GetService("UserInputService")

-- 1. Исправленный путь к Menu (ищем рядом со скриптом)
local Menu = require(script.Parent:WaitForChild("Menu"))

Menu.CreateMenu("SoftBox", "enfarse")

-- Автоматическая подгрузка модулей
local function LoadModules()
    -- 2. ИСПРАВЛЕНО: ищем папку Module в script.Parent, а не в самом script
    local moduleFolder = script.Parent:WaitForChild("Module", 5) 
    
    if not moduleFolder then
        warn("Критическая ошибка: Папка 'Module' не найдена рядом с main.lua!")
        return
    end

    local categories = {"Main", "Farm", "Esp", "Misc"}
    
    for _, catName in pairs(categories) do
        local folder = moduleFolder:FindFirstChild(catName)
        if folder then
            for _, file in pairs(folder:GetChildren()) do
                if file:IsA("ModuleScript") then
                    local success, moduleData = pcall(require, file)
                    if success and moduleData.Name and moduleData.Callback then
                        -- Создаем модуль и получаем функции для настроек
                        local settings = Menu.AddModule(catName, moduleData.Name, moduleData.Callback)
                        
                        -- Если в модуле есть функция настроек, вызываем её
                        if moduleData.SetupSettings and settings then
                            moduleData.SetupSettings(settings)
                        end
                    else
                        warn("Ошибка загрузки модуля: " .. file.Name .. " | Ошибка: " .. tostring(moduleData))
                    end
                end
            end
        else
            warn("Категория не найдена в папке Module: " .. catName)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)

-- Запускаем загрузку
task.spawn(LoadModules)
