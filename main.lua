local UserInputService = game:GetService("UserInputService")
local Menu = require(script.Parent:WaitForChild("Menu"))

Menu.CreateMenu("SoftBox", "enfarse")

-- Автоматическая подгрузка модулей
local function LoadModules()
    local moduleFolder = script:WaitForChild("Module")
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
                        warn("Ошибка загрузки модуля: " .. file.Name)
                    end
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)

LoadModules()
