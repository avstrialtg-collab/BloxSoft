-- Загружаем библиотеку интерфейса
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создаем окно
local Window = Rayfield:CreateWindow({
   Name = "KATAHA HUB | Blox Fruits",
   LoadingTitle = "Загрузка модулей...",
   ConfigurationSaving = { Enabled = true, FileName = "KatahaConfig" }
})

-- Загружаем функции из твоего GitHub (пример)
local CombatModules = loadstring(game:HttpGet("https://raw.githubusercontent.com/ТВОЙ_НИК/РЕПОЗИТОРИЙ/main/Modules/Combat.lua"))()

-- Создаем вкладку
local MainTab = Window:CreateTab("Фарм", 4483362458) 

MainTab:CreateToggle({
   Name = "Автофарм (Bandits)",
   CurrentValue = false,
   Callback = function(Value)
      _G.FarmActive = Value
      CombatModules.StartFarm() -- Вызов функции из другого файла
   end,
})
