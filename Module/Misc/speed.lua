-- Module/Misc/speed.lua
local Module = {}

Module.Name = "Super Speed"
Module.Callback = function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

return Module
