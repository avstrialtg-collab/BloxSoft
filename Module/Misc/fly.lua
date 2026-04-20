local FlyModule = {
    Name = "Fly Hack",
    Speed = 50,
    Enabled = false
}

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

FlyModule.Callback = function(state)
    FlyModule.Enabled = state
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not root then return end

    if state then
        -- Создаем силы для полета
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.Parent = root
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 0, 0)

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.Parent = root
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = root.CFrame

        -- Цикл полета
        task.spawn(function()
            while FlyModule.Enabled and root.Parent do
                local camera = workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                
                -- Простая логика: летим вперед относительно камеры
                -- Для полноценного WASD управления нужен UserInputService внутри цикла
                bv.Velocity = camera.CFrame.LookVector * FlyModule.Speed
                bg.CFrame = camera.CFrame
                RunService.RenderStepped:Wait()
            end
            bv:Destroy()
            bg:Destroy()
        end)
    end
end

FlyModule.SetupSettings = function(settings)
    settings.AddSlider(10, 300, 50, function(val)
        FlyModule.Speed = val
    end)
end

return FlyModule
