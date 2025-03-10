
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function findCoinContainer()
    local coinsFolder = workspace:FindFirstChild("Coins")
    return coinsFolder
end


local function findNearestCoin(radius)
    local coinContainer = findCoinContainer()
    if not coinContainer then
        print("CoinContainer not found")
        return nil
    end

    local humanoidRootPart = Character:WaitForChild("HumanoidRootPart") -- Использование Character, а не character
    if not humanoidRootPart then
        print("HumanoidRootPart not found")
        return nil
    end
    
    local nearestCoin = nil
    local nearestDistance = radius
    for _, coin in pairs(coinContainer:GetChildren()) do
        if coin:IsA("BasePart") then --Убеждаемся, что это BasePart (например, Part или MeshPart)
            local distance = (coin.Position - humanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestCoin = coin
                nearestDistance = distance
            end
        end
    end
    return nearestCoin
end


local function removeNearestCoin(radius)
    local nearestCoin = findNearestCoin(radius)
    if nearestCoin then
        nearestCoin:Destroy()
        print("Coin removed!")
    else
        print("No coin found within the radius.")
    end
end

local radius = 1  -- Радиус поиска монет
