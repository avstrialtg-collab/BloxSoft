-- SoftBox by enfarse
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- БИБЛИОТЕКА МЕНЮ (ВСТРОЕННАЯ)
-- ==========================================
local Menu = {}
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SoftBox_UI"

local MainFrame = Instance.new("Frame", ScreenGui)
local TabsIsland = Instance.new("Frame", ScreenGui)
local BottomIsland = Instance.new("Frame", ScreenGui)
local Pages = {}

local Theme = {
    MainColor = Color3.fromRGB(15, 15, 15),
    AccentColor = Color3.fromRGB(30, 30, 30),
    Rounding = UDim.new(0, 12),
    Transparency = 0.1
}

function Menu.CreateMenu(title, author)
    -- Главное окно
    MainFrame.Size = UDim2.new(0, 400, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    MainFrame.BackgroundColor3 = Theme.MainColor
    MainFrame.BackgroundTransparency = Theme.Transparency
    MainFrame.BorderSizePixel = 0
    Instance.new("UICorner", MainFrame).CornerRadius = Theme.Rounding

    -- Текст заголовка
    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Text = title .. " by " .. author
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14

    -- Верхний остров (Вкладки)
    TabsIsland.Size = UDim2.new(0, 350, 0, 40)
    TabsIsland.Position = UDim2.new(0.5, -175, 0.5, -180)
    TabsIsland.BackgroundColor3 = Theme.MainColor
    TabsIsland.BackgroundTransparency = Theme.Transparency
    Instance.new("UICorner", TabsIsland).CornerRadius = Theme.Rounding
    
    local tabLayout = Instance.new("UIListLayout", TabsIsland)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Нижний остров (Кнопки)
    BottomIsland.Size = UDim2.new(0, 150, 0, 45)
    BottomIsland.Position = UDim2.new(0.5, -75, 0.5, 140)
    BottomIsland.BackgroundColor3 = Theme.MainColor
    BottomIsland.BackgroundTransparency = Theme.Transparency
    Instance.new("UICorner", BottomIsland).CornerRadius = Theme.Rounding

    -- Создание вкладок
    local tabs = {"Main", "Farm", "Esp", "Misc"}
    for _, t in pairs(tabs) do
        local btn = Instance.new("TextButton", TabsIsland)
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = t
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14

        local page = Instance.new("ScrollingFrame", MainFrame)
        page.Size = UDim2.new(1, -20, 1, -50)
        page.Position = UDim2.new(0, 10, 0, 40)
        page.BackgroundTransparency = 1
        page.Visible = (t == "Main")
        page.ScrollBarThickness = 0
        Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
        
        Pages[t] = page
        
        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            page.Visible = true
        end)
    end

    -- Кнопки на нижнем острове
    local function CreateIcon(txt, xPos, cb)
        local b = Instance.new("TextButton", BottomIsland)
        b.Size = UDim2.new(0, 30, 0, 30)
        b.Position = UDim2.new(xPos, 0, 0.15, 0)
        b.Text = txt
        b.BackgroundColor3 = Theme.AccentColor
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        b.MouseButton1Click:Connect(cb)
    end

    CreateIcon("X", 0.1, function() ScreenGui:Destroy() end)
    CreateIcon("-", 0.4, function() 
        MainFrame.Visible = not MainFrame.Visible 
        TabsIsland.Visible = MainFrame.Visible
    end)
    CreateIcon("S", 0.7, function() print("Settings opened") end)

    Menu.MakeDraggable(MainFrame, {TabsIsland, BottomIsland})
end

function Menu.AddToggleButton(category, name, callback)
    local page = Pages[category]
    if not page then return end

    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Theme.AccentColor
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 120, 50) or Theme.AccentColor
        callback(enabled)
    end)
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
            helpers[2].Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 125, newPos.Y.Scale, newPos.Y.Offset + 265)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Menu.Toggle()
    local s = not MainFrame.Visible
    MainFrame.Visible = s
    TabsIsland.Visible = s
    BottomIsland.Visible = s
end

-- ==========================================
-- ЗАПУСК И ДОБАВЛЕНИЕ ФУНКЦИЙ
-- ==========================================

-- 1. Создаем меню
Menu.CreateMenu("SoftBox", "enfarse")

-- 2. Добавляем функции вручную (вместо папки Module, так как loadstring её не видит)
Menu.AddToggleButton("Misc", "Speed Hack (100)", function(state)
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = state and 100 or 16 end
end)

Menu.AddToggleButton("Main", "Fly Mode", function(state)
    print("Fly set to:", state)
end)

-- 3. Бинд на открытие/закрытие
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Slash then
        Menu.Toggle()
    end
end)
