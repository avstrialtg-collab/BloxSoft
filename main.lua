local UserInputService = game:GetService("UserInputService")
local MenuSource = game:HttpGet("https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/Menu/init.lua")
local Menu = loadstring(MenuSource)()

Menu.CreateMenu("SoftBox", "enfarse")

-- Список ссылок на модули
local ModuleLinks = {
    ["Main"] = {},
    ["Farm"] = {},
    ["Esp"] = {},
    ["Misc"] = {
        "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/refs/heads/main/Module/Misc/speed.lua"
    }
}

-- НОВАЯ ФУНКЦИЯ ЗАГРУЗКИ (Заменяет старую LoadModules)
local function LoadRemoteModules()
    for catName, links in pairs(ModuleLinks) do
        for _, url in pairs(links) do
            local success, source = pcall(function() return game:HttpGet(url) end)
            
            if success then
                local moduleFunction, loadError = loadstring(source)
                if moduleFunction then
                    local moduleSuccess, moduleData = pcall(moduleFunction)
                    
                    if moduleSuccess and moduleData.Name and moduleData.Callback then
                        -- Добавляем модуль в меню и получаем объект настроек
                        local settings = Menu.AddModule(catName, moduleData.Name, moduleData.Callback)
                        
                        -- Если в speed.lua есть SetupSettings, вызываем её
                        if moduleData.SetupSettings and settings then
                            moduleData.SetupSettings(settings)
                        end
                    else
                        warn("Ошибка в структуре модуля: " .. url)
                    end
                else
                    warn("Ошибка loadstring: " .. tostring(loadError))
                end
            else
                warn("Не удалось скачать файл по ссылке: " .. url)
            end
        end
    end
end

-- Открытие/закрытие меню на слэш (/)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)

-- ЗАПУСК
LoadRemoteModules()
