local FlyMod = {}

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.FlyActive = false
_G.FlySpeed = 50

local bv, bg

function FlyMod.Toggle(state)
    _G.FlyActive = state
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if _G.FlyActive then
        -- Создаем физические силы для полета
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = char.HumanoidRootPart
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 15000
        bg.CFrame = char.HumanoidRootPart.CFrame
        bg.Parent = char.HumanoidRootPart
        
        -- Цикл полета
        task.spawn(function()
            while _G.FlyActive do
                RunService.Heartbeat:Wait()
                local cam = workspace.CurrentCamera
                local moveDir = char.Humanoid.MoveDirection
                
                -- Рассчитываем направление относительно камеры
                if moveDir.Magnitude > 0 then
                    bv.Velocity = cam.CFrame.LookVector * _G.FlySpeed * (moveDir.Magnitude)
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0) -- Зависание на месте
                end
                
                -- Поворачиваем персонажа за камерой
                bg.CFrame = cam.CFrame
            end
        end)
    else
        -- Удаляем силы при выключении
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

return FlyMod
