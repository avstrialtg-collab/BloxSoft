local MenuSource = game:HttpGet("https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/Menu/init.lua")
local Menu = loadstring(MenuSource)()

Menu.CreateMenu("SoftBox", "enfarse")

-- Автоматическая подгрузка модулей по твоим ссылкам
local function LoadModules()
    local categories = {"Main", "Farm", "Esp", "Misc"}
    
    -- СЮДА ДОБАВЛЯЙ СВОИ ССЫЛКИ
    local moduleLinks = {
        ["Main"] = {
            -- "ссылка",
        },
        ["Farm"] = {
            -- "ссылка",
        },
        ["Esp"] = {
            -- "ссылка",
        },
        ["Misc"] = {
            "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/refs/heads/main/Module/Misc/speed.lua",
            -- Можешь добавлять еще ссылки через запятую
        }
    }

    for _, catName in pairs(categories) do
        local links = moduleLinks[catName]
        if links then
            for _, url in pairs(links) do
                local success, moduleSource = pcall(game.HttpGet, game, url)
                if success then
                    local moduleData = loadstring(moduleSource)()
                    if moduleData and moduleData.Name and moduleData.Callback then
                        -- Создаем модуль в меню
                        local settings = Menu.AddModule(catName, moduleData.Name, moduleData.Callback)
                        
                        -- Если в модуле есть функция настроек, вызываем её
                        if moduleData.SetupSettings and settings then
                            moduleData.SetupSettings(settings)
                        end
                    else
                        warn("Ошибка формата модуля по ссылке: " .. url)
                    end
                else
                    warn("Не удалось загрузить модуль: " .. url)
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
