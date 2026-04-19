return function(state)
    _G.NoClip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NoClip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end
