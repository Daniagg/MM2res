local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local playerBackpack = player.Backpack

local function findCoinContainer()
  local potentialContainers = {
    workspace:FindFirstChild("Office3") and workspace.Office3:FindFirstChild("CoinContainer"),
    workspace:FindFirstChild("Factory") and workspace.Factory:FindFirstChild("CoinContainer"),
    workspace:FindFirstChild("Hotel") and workspace.Hotel:FindFirstChild("CoinContainer"),
    workspace:FindFirstChild("MilBase") and workspace.MilBase:FindFirstChild("CoinContainer"),
    workspace:FindFirstChild("House2") and workspace.House2:FindFirstChild("CoinContainer"),
  }

  for _, container in pairs(potentialContainers) do
    if container then
      return container
    end
  end
  return nil
end

local coinContainer = findCoinContainer()
local coins = {}
local collectedCoins = {}

local function updateCoins()
  if coinContainer then
    coins = coinContainer.Coin_Server.CoinVisual:GetChildren()
  else
    coins = {}
  end
end

local function findNearestCoin()
  local closestCoin = nil
  local minDistance = math.huge

  for _, coin in pairs(coins) do
    if coin:IsA("BasePart") and not collectedCoins[coin] then
      local distance = (humanoidRootPart.Position - coin.Position).Magnitude
      if distance < minDistance then
        minDistance = distance
        closestCoin = coin
      end
    end
  end
  return closestCoin
end

local function teleportToCoin(coin)
  if coin then
    humanoidRootPart.CFrame = CFrame.new(coin.Position)
    collectedCoins[coin] = true
    coin:Destroy()

    game:GetService("Debris"):AddItem(coroutine.wrap(function()
      wait(0.5)
      local currentPos = humanoidRootPart.Position
      humanoidRootPart.CFrame = CFrame.new(currentPos + Vector3.new(0, 30, 0))
    end)(), 0)
  end
end

local function pickupGun()
  local gun = workspace:FindFirstChild("GunDrop")
  if gun then
    gun.Parent = playerBackpack
    print("Gun picked up!")
  else
    print("Gun not found!")
  end
end


local function onCharacterAdded(newCharacter)
  humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
  updateCoins()
  pickupGun() -- Pick up the gun when the character loads
end

player.CharacterAdded:Connect(onCharacterAdded)

updateCoins()
pickupGun() -- Attempt to pick up the gun initially

while true do
  local nearestCoin = findNearestCoin()
  if nearestCoin then
    teleportToCoin(nearestCoin)
  else
    wait(1)
    updateCoins()
  end
end
