local GodMode = {}

function GodMode.Toggle(state)
    _G.GodModeActive = state
    local player = game.Players.LocalPlayer
    
    task.spawn(function()
        while _G.GodModeActive do
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                -- Метод: отключение состояния падения и некоторых проверок урона
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
            task.wait(1)
        end
        -- Возвращаем стандартное состояние при выключении
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end)
end

return GodMode
