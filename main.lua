local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BloxSoft | KATAHA Edition",
    SubTitle = "by Stanislav Burlakov",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460),
    ConfigDefault = 1, CustomName = "BloxSoft"
})

-- Функция переоткрытия меню на RightShift
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        Window:Minimize() -- Переключает видимость
    end
end)

local function GetCode(path)
    local url = "https://raw.githubusercontent.com/avstrialtg-collab/BloxSoft/main/modules/" .. path
    local success, code = pcall(function() return game:HttpGet(url) end)
    
    if success and not code:find("404") then
        local func = loadstring(code)
        if func then
            local s, res = pcall(func)
            if s then return res end
        end
    end
    warn("⚠️ Ошибка загрузки: " .. path)
    return nil
end

local Tabs = {
    Farm = Window:AddTab({ Title = "Auto-Farm", Icon = "swords" }),
    Aim = Window:AddTab({ Title = "Aim", Icon = "target" }),
    TP = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

local SpeedMod = GetCode("Misc/Speed.lua")
local NoClipMod = GetCode("Misc/NoClip.lua")
local InfJumpMod = GetCode("Misc/InfJump.lua")
local FlyMod = GetCode("Misc/Fly.lua")
local GodMod = GetCode("Misc/GodMode.lua")

--- [ Вкладка MISC ] ---
Tabs.Misc:AddSection("Survival")

Tabs.Misc:AddToggle("GodMode", {
    Title = "God Mode (Inf Health)",
    Default = false,
    Callback = function(v) if GodMod then GodMod.Toggle(v) end end
})

Tabs.Misc:AddSection("Movement")

Tabs.Misc:AddToggle("FlyToggle", {
    Title = "Enable Fly",
    Default = false,
    Callback = function(v) if FlyMod then FlyMod.Toggle(v) end end
})

Tabs.Misc:AddSlider("FlySpeed", {
    Title = "Fly Speed", Default = 50, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) _G.FlySpeed = v end
})

Tabs.Misc:AddSlider("WalkSpeed", {
    Title = "WalkSpeed", Default = 16, Min = 16, Max = 300, Rounding = 0,
    Callback = function(v) if SpeedMod then SpeedMod(v) end end
})

Tabs.Misc:AddToggle("NoClip", { Title = "NoClip", Default = false, Callback = function(v) if NoClipMod then NoClipMod(v) end end })
Tabs.Misc:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(v) if InfJumpMod then InfJumpMod(v) end end })

Window:SelectTab(1)

-- Уведомление игроку
Fluent:Notify({
    Title = "BloxSoft Loaded",
    Content = "Нажми RightShift, чтобы скрыть/показать меню",
    Duration = 5
})
