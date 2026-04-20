local UserInputService = game:GetService("UserInputService")
local MenuSource = game:HttpGet("https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/Menu/init.lua")
local Menu = loadstring(MenuSource)()

Menu.CreateMenu("SoftBox", "enfarse")

-- Твой список модулей. Просто добавляй ссылки в соответствующие категории.
local ModuleLinks = {
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
        -- Сюда можно добавить еще ссылки через запятую
    }
}

local function LoadRemoteModules()
    for catName, links in pairs(ModuleLinks) do
        for _, url in pairs(links) do
            -- Загружаем исходный код модуля по ссылке
            local success, source = pcall(game.HttpGet, game, url)
            
            if success then
                -- Превращаем текст в исполняемый код
                local moduleFunction, loadError = loadstring(source)
                
                if moduleFunction then
                    local moduleSuccess, moduleData = pcall(moduleFunction)
                    
                    if moduleSuccess and moduleData.Name and moduleData.Callback then
                        -- Добавляем в меню
                        local settings = Menu.AddModule(catName, moduleData.Name, moduleData.Callback)
                        
                        -- Настраиваем слайдеры/боксы, если они есть
                        if moduleData.SetupSettings and settings then
                            moduleData.SetupSettings(settings)
                        end
                    else
                        warn("Ошибка выполнения модуля: " .. url .. " | Ошибка: " .. tostring(moduleData))
                    end
                else
                    warn("Ошибка компиляции модуля (loadstring): " .. url .. " | " .. tostring(loadError))
                end
            else
                warn("Не удалось скачать модуль по ссылке: " .. url)
            end
        end
    end
end

-- Управление меню
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)

-- Запуск загрузки
LoadRemoteModules()
