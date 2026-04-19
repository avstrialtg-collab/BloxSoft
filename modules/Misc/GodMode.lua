local GodMode = {}
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

_G.GodModeActive = false

function GodMode.Toggle(state)
    _G.GodModeActive = state
    
    if _G.GodModeActive then
        -- Создаем цикл восстановления
        task.spawn(function()
            while _G.GodModeActive do
                runService.Heartbeat:Wait()
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                
                if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end
        end)
    end
end

return GodMode
