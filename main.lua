-- SoftBox Fixed Version
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- УНИЧТОЖАЕМ СТАРУЮ КОПИЮ, ЕСЛИ ОНА ЕСТЬ
if CoreGui:FindFirstChild("SoftBox_UI") then
    CoreGui.SoftBox_UI:Destroy()
end

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
}

-- ГЕНЕРАЦИЯ ИНТЕРФЕЙСА
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Theme.MainColor
Instance.new("UICorner", MainFrame).CornerRadius = Theme.Rounding

TabsIsland.Size = UDim2.new(0, 350, 0, 40)
TabsIsland.Position = UDim2.new(0.5, -175, 0.5, -180)
TabsIsland.BackgroundColor3 = Theme.MainColor
Instance.new("UICorner", TabsIsland).CornerRadius = Theme.Rounding
local tabLayout = Instance.new("UIListLayout", TabsIsland)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

BottomIsland.Size = UDim2.new(0, 150, 0, 45)
BottomIsland.Position = UDim2.new(0.5, -75, 0.5, 140)
BottomIsland.BackgroundColor3 = Theme.MainColor
Instance.new("UICorner", BottomIsland).CornerRadius = Theme.Rounding

-- СОЗДАНИЕ ВКЛАДОК
local function AddTab(name)
    local btn = Instance.new("TextButton", TabsIsland)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham

    local page = Instance.new("ScrollingFrame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -50)
    page.Position = UDim2.new(0, 10, 0, 40)
    page.BackgroundTransparency = 1
    page.Visible = (name == "Main")
    page.ScrollBarThickness = 0
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    
    Pages[name] = page
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
    end)
end

for _, t in pairs({"Main", "Farm", "Esp", "Misc"}) do AddTab(t) end

-- ФУНКЦИЯ ДОБАВЛЕНИЯ КНОПОК
local function AddButton(cat, name, cb)
    local btn = Instance.new("TextButton", Pages[cat])
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Theme.AccentColor
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(60, 150, 60) or Theme.AccentColor
        cb(active)
    end)
end

-- НИЖНИЕ КНОПКИ
local function CreateIcon(txt, x, callback)
    local b = Instance.new("TextButton", BottomIsland)
    b.Size = UDim2.new(0, 30, 0, 30)
    b.Position = UDim2.new(x, 0, 0.15, 0)
    b.Text = txt
    b.BackgroundColor3 = Theme.AccentColor
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(callback)
end

CreateIcon("X", 0.1, function() ScreenGui:Destroy() end)
CreateIcon("-", 0.4, function() 
    MainFrame.Visible = not MainFrame.Visible 
    TabsIsland.Visible = MainFrame.Visible
end)

-- ДВИЖЕНИЕ МЕНЮ
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TabsIsland.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 25, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 55)
        BottomIsland.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 125, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 265)
    end
end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- ТВОИ МОДУЛИ (ПРОСТО ДОБАВЛЯЙ НИЖЕ)
AddButton("Misc", "Speed Hack (100)", function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16
end)

AddButton("Main", "Fly (Placeholder)", function(s) print("Fly:", s) end)

-- ОТКРЫТИЕ НА "/"
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.Slash then
        MainFrame.Visible = not MainFrame.Visible
        TabsIsland.Visible = MainFrame.Visible
        BottomIsland.Visible = MainFrame.Visible
    end
end)
