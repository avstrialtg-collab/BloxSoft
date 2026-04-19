local ESP = {}
function ESP.Add(obj, color)
    if obj:FindFirstChild("BloxVisual") then return end
    local bgui = Instance.new("BillboardGui", obj)
    bgui.Name = "BloxVisual"
    bgui.Size = UDim2.new(4, 0, 5.5, 0)
    bgui.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", bgui)
    nameLabel.Text = obj.Name .. " | " .. math.floor(obj.Humanoid.Health) .. " HP"
    nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    nameLabel.TextColor3 = color
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextScaled = true

    -- Оптимизированная рамка через UIStroke
    local frame = Instance.new("Frame", bgui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.Color = color
end
return ESP
