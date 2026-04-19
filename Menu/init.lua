-- Menu/init.lua
local Menu = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SoftBox_UI"

local MainFrame = Instance.new("Frame", ScreenGui)
local TabsIsland = Instance.new("Frame", ScreenGui)
local BottomIsland = Instance.new("Frame", ScreenGui)

-- Настройки темы
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
    MainFrame.Visible = true

    local UICorner = Instance.new("UICorner", MainFrame)
    UICorner.CornerRadius = Theme.Rounding

    -- Текст заголовка
    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Text = title .. " by " .. author
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold

    -- Верхний остров (Вкладки)
    TabsIsland.Size = UDim2.new(0, 350, 0, 40)
    TabsIsland.Position = UDim2.new(0.5, -175, 0.5, -180) -- Над меню
    TabsIsland.BackgroundColor3 = Theme.MainColor
    TabsIsland.BackgroundTransparency = Theme.Transparency
    local TabCorner = Instance.new("UICorner", TabsIsland)
    TabCorner.CornerRadius = Theme.Rounding

    -- Нижний остров (Управление)
    BottomIsland.Size = UDim2.new(0, 150, 0, 45)
    BottomIsland.Position = UDim2.new(0.5, -75, 0.5, 140) -- Под меню
    BottomIsland.BackgroundColor3 = Theme.MainColor
    BottomIsland.BackgroundTransparency = Theme.Transparency
    local BotCorner = Instance.new("UICorner", BottomIsland)
    BotCorner.CornerRadius = Theme.Rounding

    -- Кнопки на нижнем острове
    local function CreateIconBtn(text, pos, callback)
        local btn = Instance.new("TextButton", BottomIsland)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = pos
        btn.Text = text
        btn.BackgroundColor3 = Theme.AccentColor
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        btn.MouseButton1Click:Connect(callback)
    end

    -- Крестик (Выход)
    CreateIconBtn("X", UDim2.new(0.1, 0, 0.15, 0), function()
        ScreenGui:Destroy()
    end)
    
    -- Сворачивание
    CreateIconBtn("-", UDim2.new(0.4, 0, 0.15, 0), function()
        MainFrame.Visible = not MainFrame.Visible
        TabsIsland.Visible = MainFrame.Visible
    end)

    -- Настройки (Заглушка)
    CreateIconBtn("S", UDim2.new(0.7, 0, 0.15, 0), function()
        print("Settings Opened")
    end)

    Menu.MakeDraggable(MainFrame, {TabsIsland, BottomIsland})
    
    return MainFrame
end

-- Логика передвижения (Drag)
function Menu.MakeDraggable(frame, helpers)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        frame.Position = newPos
        
        -- Двигаем острова вместе с меню
        helpers[1].Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 25, newPos.Y.Scale, newPos.Y.Offset - 55)
        helpers[2].Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 125, newPos.Y.Scale, newPos.Y.Offset + 265)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Menu.Toggle()
    local state = not MainFrame.Visible
    MainFrame.Visible = state
    TabsIsland.Visible = state
    BottomIsland.Visible = state
end
local Pages = {} -- Здесь будут храниться фреймы вкладок

-- Функция для создания кнопок переключения вкладок на верхнем острове
local function CreateTabButton(name)
    local btn = Instance.new("TextButton", TabsIsland) -- TabsIsland из предыдущего кода
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14

    -- Создаем страницу для этой вкладки
    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -40)
    page.Position = UDim2.new(0, 10, 0, 35)
    page.BackgroundTransparency = 1
    page.Visible = (name == "Main") -- По умолчанию видна только Main
    page.ScrollBarThickness = 2
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    Pages[name] = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

-- Инициализируем вкладки
local tabs = {"Main", "Farm", "Esp", "Misc"}
local tabLayout = Instance.new("UIListLayout", TabsIsland)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

for _, t in pairs(tabs) do CreateTabButton(t) end

-- Функция добавления кнопки в меню
function Menu.AddToggleButton(category, name, callback)
    local targetPage = Pages[category]
    if not targetPage then return end

    local btn = Instance.new("TextButton", targetPage)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.Gotham
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.BackgroundColor3 = enabled and Color3.fromRGB(40, 100, 40) or Color3.fromRGB(25, 25, 25)
        callback(enabled)
    end)
end
return Menu
