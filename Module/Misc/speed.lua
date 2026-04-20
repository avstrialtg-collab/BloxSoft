local SpeedModule = {
    Name = "WalkSpeed",
    CurrentValue = 100,
    Enabled = false
}

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- Постоянный цикл для обхода проверок игры
RunService.Stepped:Connect(function()
    if SpeedModule.Enabled then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = SpeedModule.CurrentValue
        end
    end
end)

SpeedModule.Callback = function(state)
    SpeedModule.Enabled = state
    -- Возвращаем стандартную скорость при выключении
    if not state then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end

SpeedModule.SetupSettings = function(settings)
    settings.AddSlider(16, 500, 100, function(val)
        SpeedModule.CurrentValue = val
    end)
end

return SpeedModule
