local EntityTP = {}
function EntityTP.ToNearest(name)
    local target = nil
    local dist = math.huge
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:find(name) and v:FindFirstChild("HumanoidRootPart") then
            local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d target = v end
        end
    end
    if target then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.TP_Height, 0)
    end
end
return EntityTP
