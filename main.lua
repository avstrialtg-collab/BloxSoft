-- Эмуляция структуры папок для loadstring
local MenuSource = game:HttpGet("https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/Menu/init.lua")
local Menu = loadstring(MenuSource)()

-- Инициализация меню
Menu.CreateMenu("SoftBox", "enfarse")

-- Пример модуля SPEED с настройками
local speedMod = Menu.AddModule("Misc", "WalkSpeed", function(state)
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state and _G.SpeedValue or 16
    end
end)

-- Добавляем слайдер для скорости
_G.SpeedValue = 100
speedMod.AddSlider(16, 500, 100, function(val)
    _G.SpeedValue = val
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

-- Пример модуля с TextBox (например, Fly или телепорт)
local flyMod = Menu.AddModule("Main", "Fly Mode", function(state)
    print("Fly is:", state)
end)

flyMod.AddTextBox("Enter Speed...", function(text)
    print("Fly speed set to:", text)
end)

-- Бинд на "/"
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)
