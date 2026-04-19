local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BloxSoft Hub | KATAHA",
   LoadingTitle = "Загрузка системы...",
   LoadingSubtitle = "by Stanislav Burlakov",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "BloxSoftConfig"
   }
})

-- Создаем вкладки
local MainTab = Window:CreateTab("Автофарм", 4483362458) 
local VisualsTab = Window:CreateTab("Визуалы", 4483362458)

-- Переменные состояния
_G.FarmActive = false
_G.EspActive = false

-- Подключаем логику фарма (из твоего же репозитория)
-- Позже ты создашь файл Modules/Combat.lua и пропишешь ссылку на него здесь
local function startCombatLogic()
    -- Сюда мы вставим код нашего последнего оптимизированного фарма
end

MainTab:CreateToggle({
   Name = "Включить фарм (Bandits/Trainee/Snow)",
   CurrentValue = false,
   Flag = "FarmToggle", 
   Callback = function(Value)
      _G.FarmActive = Value
      if Value then
          print("Фарм запущен")
          -- Вызов функции фарма
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Белые хитбоксы (ESP)",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      _G.EspActive = Value
   end,
})

Rayfield:LoadConfiguration()
