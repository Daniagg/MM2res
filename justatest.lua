-- Локальный скрипт (разместите в PlayerScripts или Character Scripts)

-- Получаем объект игрока
local player = game:GetService("Players").LocalPlayer
-- Получаем объект персонажа игрока
local character = player.Character or player.CharacterAdded:Wait()

-- Функция поиска контейнера с монетами (тот же код)
local function findCoinContainer()
    for _, child in pairs(workspace:GetChildren()) do
        local coinContainer = child:FindFirstChild("CoinContainer")
        if coinContainer then
            return coinContainer
        end
    end
    return nil
end

-- Функция поиска ближайшей монеты в радиусе (тот же код)
local function findNearestCoin(radius)
    local coinContainer = findCoinContainer()
    if not coinContainer then
        print("CoinContainer not found")
        return nil
    end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local nearestCoin = nil
    local nearestDistance = radius
    for _, coin in pairs(coinContainer:GetChildren()) do
        local distance = (coin.Position - humanoidRootPart.Position).Magnitude
        if distance < nearestDistance then
            nearestCoin = coin
            nearestDistance = distance
        end
    end
    return nearestCoin
end


-- Функция для удаления монеты (то, что нужно добавить)
local function deleteCoin(coin)
    if coin then
        coin:Destroy() -- Destroy() удаляет объект.  Эквивалентно .Parent = nil
        print("Монета уничтожена!")
    else
        print("Нечего удалять.  Монета nil.")
    end
end


-- Пример использования:  Поиск монеты и удаление ее, если она найдена
local radiusToSearch = 2  -- Радиус поиска монеты (измените по необходимости)

local coinToRemove = findNearestCoin(radiusToSearch)

if coinToRemove then
    deleteCoin(coinToRemove)
else
    print("Нет монет в радиусе " .. radiusToSearch .. " studs.")
end



--  Опционально:  Можно добавить событие Touched на HumanoidRootPart для автоматического удаления монет при касании

local function onTouch(hit)
    if hit:IsA("BasePart") and hit.Name == "Coin" then --Проверяем что это part и её имя "Coin"
        local coinContainer = findCoinContainer()
        if coinContainer and hit.Parent == coinContainer then -- Удостоверимся что монета находится в контейнере
            deleteCoin(hit)
        end
    end
end

character:WaitForChild("HumanoidRootPart").Touched:Connect(onTouch)
