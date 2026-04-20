local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Пытаемся найти папку, где лежит проект (обычно она называется так же, как папка в VS Code)
-- Если ты не знаешь название папки, поищи её в CoreGui через Explorer
local root = script.Parent 

if not root or root == CoreGui then
    -- Если скрипт "одинокий", пробуем найти папку проекта в CoreGui по имени
    -- ЗАМЕНИ "SoftBox" на название твоей корневой папки из VS Code, если оно другое
    root = CoreGui:FindFirstChild("SoftBox") or CoreGui:FindFirstChild("Folder")
end

if not root then
    warn("Критическая ошибка: Не удалось найти корневую папку проекта в CoreGui!")
    return
end

-- Теперь ищем Menu и Module внутри найденного корня
local Menu = require(root:WaitForChild("Menu"))
