-- Module/misc/speed.lua
local Module = {}

Module.Name = "Speed Hack" -- Название кнопки в меню
Module.Enabled = false     -- Текущее состояние

Module.Callback = function(state) 
    -- 'state' придет от кнопки (true или false)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        if state then
            player.Character.Humanoid.WalkSpeed = 100 -- Твоя скорость
        else
            player.Character.Humanoid.WalkSpeed = 16  -- Стандарт
        end
    end
end

return Module
