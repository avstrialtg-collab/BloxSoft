local SpeedModule = {
    Name = "WalkSpeed",
    CurrentValue = 100
}

-- Главная функция включения/выключения
SpeedModule.Callback = function(state)
    local player = game.Players.LocalPlayer
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state and SpeedModule.CurrentValue or 16
    end
end

-- Функция настройки слайдеров и боксов
SpeedModule.SetupSettings = function(settings)
    settings.AddSlider(16, 500, 100, function(val)
        SpeedModule.CurrentValue = val
        -- Если чит включен, сразу обновляем скорость
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= 16 then
            hum.WalkSpeed = val
        end
    end)
    
    settings.AddTextBox("Custom Value...", function(text)
        local num = tonumber(text)
        if num then
            SpeedModule.CurrentValue = num
            print("Speed set to:", num)
        end
    end)
end

return SpeedModule
