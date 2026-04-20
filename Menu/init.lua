local Menu = {}
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SoftBox_UI"

local MainFrame = Instance.new("Frame", ScreenGui)
local TabsIsland = Instance.new("Frame", ScreenGui)
local BottomIsland = Instance.new("Frame", ScreenGui)
local Pages = {}

local Theme = {
    MainColor = Color3.fromRGB(15, 15, 15),
    AccentColor = Color3.fromRGB(30, 30, 30),
    EnabledColor = Color3.fromRGB(60, 60, 60), -- Светло-серый при включении
    TextColor = Color3.fromRGB(255, 255, 255),
    Rounding = UDim.new(0, 10),
}

function Menu.CreateMenu(title, author)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Theme.MainColor
    Instance.new("UICorner", MainFrame).CornerRadius = Theme.Rounding

    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Text = title .. " by " .. author
    TitleLabel.Size = UDim2.new(1, 0, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Theme.TextColor
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16

    -- Острова
    TabsIsland.Size = UDim2.new(0, 350, 0, 40)
    TabsIsland.Position = UDim2.new(0.5, -175, 0.5, -210)
    TabsIsland.BackgroundColor3 = Theme.MainColor
    Instance.new("UICorner", TabsIsland).CornerRadius = Theme.Rounding
    Instance.new("UIListLayout", TabsIsland).FillDirection = Enum.FillDirection.Horizontal

    BottomIsland.Size = UDim2.new(0, 150, 0, 45)
    BottomIsland.Position = UDim2.new(0.5, -75, 0.5, 160)
    BottomIsland.BackgroundColor3 = Theme.MainColor
    Instance.new("UICorner", BottomIsland).CornerRadius = Theme.Rounding

    local tabs = {"Main", "Farm", "Esp", "Misc"}
    for _, t in pairs(tabs) do
        local btn = Instance.new("TextButton", TabsIsland)
        btn.Size = UDim2.new(0, 87, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = t
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14

        local page = Instance.new("ScrollingFrame", MainFrame)
        page.Size = UDim2.new(1, -20, 1, -60)
        page.Position = UDim2.new(0, 10, 0, 50)
        page.BackgroundTransparency = 1
        page.Visible = (t == "Main")
        page.ScrollBarThickness = 0
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0, 8)
        
        Pages[t] = page
        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            page.Visible = true
        end)
    end

    -- Кнопки управления (X, -)
    local function CreateControl(txt, x, cb)
        local b = Instance.new("TextButton", BottomIsland)
        b.Size = UDim2.new(0, 30, 0, 30)
        b.Position = UDim2.new(x, 0, 0.15, 0)
        b.Text = txt
        b.BackgroundColor3 = Theme.AccentColor
        b.TextColor3 = Theme.TextColor
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        b.MouseButton1Click:Connect(cb)
    end
    CreateControl("X", 0.1, function() ScreenGui:Destroy() end)
    CreateControl("-", 0.4, function() Menu.Toggle() end)

    Menu.MakeDraggable(MainFrame, {TabsIsland, BottomIsland})
end

function Menu.AddModule(category, name, callback)
    local page = Pages[category]
    local container = Instance.new("Frame", page)
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = Theme.AccentColor
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)

    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. name
    btn.TextColor3 = Theme.TextColor
    btn.TextSize = 16 -- Увеличено название модуля
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", container)
    arrow.Text = ">"
    arrow.Size = UDim2.new(0, 30, 0, 40)
    arrow.Position = UDim2.new(1, -35, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextColor3 = Color3.fromRGB(100, 100, 100)
    arrow.Font = Enum.Font.GothamBold

    local settingsFrame = Instance.new("Frame", container)
    settingsFrame.Size = UDim2.new(1, 0, 0, 0)
    settingsFrame.Position = UDim2.new(0, 0, 0, 40)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    settingsFrame.ClipsDescendants = true
    Instance.new("UICorner", settingsFrame)
    local sLayout = Instance.new("UIListLayout", settingsFrame)
    sLayout.Padding = UDim.new(0, 5)

    local enabled = false
    local open = false

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Parent.BackgroundColor3 = enabled and Theme.EnabledColor or Theme.AccentColor
        callback(enabled)
    end)

    -- Открытие настроек по ПКМ или просто клику (зависит от логики, сделаем по клику на стрелочку)
    local toggleBtn = Instance.new("TextButton", container)
    toggleBtn.Size = UDim2.new(0, 40, 0, 40)
    toggleBtn.Position = UDim2.new(1, -40, 0, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""

    toggleBtn.MouseButton1Click:Connect(function()
        open = not open
        settingsFrame:TweenSize(UDim2.new(1, 0, 0, open and 100 or 0), "Out", "Quart", 0.3, true)
        container:TweenSize(UDim2.new(1, 0, 0, open and 140 or 40), "Out", "Quart", 0.3, true)
        arrow.Rotation = open and 90 or 0
    end)

    local functions = {}

    function functions.AddSlider(min, max, default, cb)
        local sliderFrame = Instance.new("Frame", settingsFrame)
        sliderFrame.Size = UDim2.new(1, -20, 0, 30)
        sliderFrame.Position = UDim2.new(0, 10, 0, 0)
        sliderFrame.BackgroundTransparency = 1

        local sLabel = Instance.new("TextLabel", sliderFrame)
        sLabel.Text = "Value: " .. default
        sLabel.Size = UDim2.new(1, 0, 0, 15)
        sLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        sLabel.BackgroundTransparency = 1
        sLabel.Font = Enum.Font.Gotham
        sLabel.TextSize = 12

        local bar = Instance.new("Frame", sliderFrame)
        bar.Size = UDim2.new(1, 0, 0, 4)
        bar.Position = UDim2.new(0, 0, 0.7, 0)
        bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

        local dragging = false
        local function update()
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = bar.AbsolutePosition.X
            local barSize = bar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            local val = math.floor(min + (max - min) * percent)
            sLabel.Text = "Value: " .. val
            cb(val)
        end

        bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
    end

    function functions.AddTextBox(placeholder, cb)
        local box = Instance.new("TextBox", settingsFrame)
        box.Size = UDim2.new(1, -20, 0, 30)
        box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        box.PlaceholderText = placeholder
        box.Text = ""
        box.TextColor3 = Theme.TextColor
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        Instance.new("UICorner", box)
        box.FocusLost:Connect(function() cb(box.Text) end)
    end

    return functions
end

function Menu.MakeDraggable(frame, helpers)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            frame.Position = newPos
            helpers[1].Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 25, newPos.Y.Scale, newPos.Y.Offset - 55)
            helpers[2].Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 125, newPos.Y.Scale, newPos.Y.Offset + 315)
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function Menu.Toggle()
    local s = not MainFrame.Visible
    MainFrame.Visible = s
    TabsIsland.Visible = s
    BottomIsland.Visible = s
end

return Menu
