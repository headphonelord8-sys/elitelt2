```lua
--!nolint

-- ScreenGui Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LT2ExploitUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10 -- Ensure it's on top
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Make it Draggable
ScreenGui.Draggable = true

-- Function to handle errors using pcall
local function safeCall(func)
    return function(...)
        local success, result = pcall(func, ...)
        if not success then
            warn("Error during callback:", result)
        end
        return result
    end
end

-- Helper Function: Find Player's Property
local function FindPlayerProperty()
    for _, property in pairs(game.Workspace.Properties:GetChildren()) do
        if property:IsA("Model") and property:FindFirstChild("Owner") and property.Owner.Value == game.Players.LocalPlayer then
            return property
        end
    end
    return nil
end

-- Buy Land Button
local BuyLandButton = Instance.new("TextButton")
BuyLandButton.Name = "BuyLandButton"
BuyLandButton.Size = UDim2.new(0, 200, 0, 30)
BuyLandButton.Position = UDim2.new(0, 10, 0, 10)
BuyLandButton.Text = "Buy Land"
BuyLandButton.BackgroundColor3 = Color3.new(0, 0.5, 1)
BuyLandButton.TextColor3 = Color3.new(1, 1, 1)
BuyLandButton.Parent = ScreenGui

BuyLandButton.MouseButton1Click:Connect(safeCall(function()
    local property = FindPlayerProperty()
    if property then
        local buyLandOffset = CFrame.new(40, 0, 0) -- Adjust as needed
        game.ReplicatedStorage.PropertyMethods.BuyLand:FireServer(property, buyLandOffset)
        print("Buy Land Attempted")
    else
        warn("No property found for the player.")
    end
end))

-- Sign Destroyer Function
local function DestroySigns()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "PropertySign" or obj.Name == "SoldSign") then
            local property = FindPlayerProperty()
            if property then
                game.ReplicatedStorage.PropertyMethods.Demolish:FireServer(property, obj)
                print("Sign Demolished")
            else
                warn("No property found for the player.")
            end

        end
    end
end

-- Sign Destroyer Button
local SignDestroyerButton = Instance.new("TextButton")
SignDestroyerButton.Name = "SignDestroyerButton"
SignDestroyerButton.Size = UDim2.new(0, 200, 0, 30)
SignDestroyerButton.Position = UDim2.new(0, 10, 0, 50)
SignDestroyerButton.Text = "Destroy Signs"
SignDestroyerButton.BackgroundColor3 = Color3.new(1, 0.5, 0)
SignDestroyerButton.TextColor3 = Color3.new(1, 1, 1)
SignDestroyerButton.Parent = ScreenGui

SignDestroyerButton.MouseButton1Click:Connect(safeCall(DestroySigns))

-- Base Spawner Button
local BaseSpawnerButton = Instance.new("TextButton")
BaseSpawnerButton.Name = "BaseSpawnerButton"
BaseSpawnerButton.Size = UDim2.new(0, 200, 0, 30)
BaseSpawnerButton.Position = UDim2.new(0, 10, 0, 90)
BaseSpawnerButton.Text = "Spawn Base"
BaseSpawnerButton.BackgroundColor3 = Color3.new(0, 1, 0.5)
BaseSpawnerButton.TextColor3 = Color3.new(1, 1, 1)
BaseSpawnerButton.Parent = ScreenGui

BaseSpawnerButton.MouseButton1Click:Connect(safeCall(function()
    local property = FindPlayerProperty()
    if property then
        local origin = property.Origin.CFrame
        game.ReplicatedStorage.PropertyMethods.PlaceStructure:FireServer(property, "Floor", origin)
        game.ReplicatedStorage.PropertyMethods.PlaceStructure:FireServer(property, "Sawmill", origin)
        print("Base Spawned")
    else
        warn("No property found for the player.")
    end
end))
```
