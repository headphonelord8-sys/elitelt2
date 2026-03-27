-- Roblox Lumber Tycoon 2 Script for Delta Executor
-- Property Finder, Buy Land, Sign Destroyer, Base Spawner
-- Host on GitHub and use: loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LT2Tools"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "LT2 Tools"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Scrolling Frame for buttons
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = scrollFrame

-- Function to create styled button
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.BorderSizePixel = 0
    button.LayoutOrder = #scrollFrame:GetChildren()
    button.Parent = scrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(70, 70, 70)
    btnStroke.Thickness = 1
    btnStroke.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    -- Safe callback with pcall
    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    -- Update canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    
    return button
end

-- Find Player's Property
local playerProperty = nil
local function findProperty()
    playerProperty = nil
    pcall(function()
        for _, prop in pairs(workspace.Properties:GetChildren()) do
            if prop:FindFirstChild("Owner") and prop.Owner.Value == player then
                playerProperty = prop
                break
            end
        end
    end)
    return playerProperty
end

-- 1. Find Property Button
createButton("🔍 Find My Property", function()
    local prop = findProperty()
    if prop then
        titleLabel.Text = "LT2 Tools - Property Found!"
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        titleLabel.Text = "LT2 Tools"
    else
        titleLabel.Text = "LT2 Tools - No Property Found!"
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        titleLabel.Text = "LT2 Tools"
    end
end)

-- 2. Buy Land Button (40 stud offset)
createButton("💰 Buy Land (+40 Studs)", function()
    local prop = playerProperty or findProperty()
    if prop then
        local offsetCFrame = prop.Origin.CFrame + (prop.Origin.CFrame.LookVector * 40)
        pcall(function()
            ReplicatedStorage.PropertyMethods.BuyLand:FireServer(offsetCFrame)
        end)
        titleLabel.Text = "LT2 Tools - Buy Land Fired!"
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        titleLabel.Text = "LT2 Tools"
    else
        titleLabel.Text = "LT2 Tools - Find Property First!"
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        titleLabel.Text = "LT2 Tools"
    end
end)

-- 3. Sign Destroyer Button
createButton("🗑️ Destroy All Signs", function()
    local count = 0
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name == "PropertySign" or obj.Name == "SoldSign") and obj:IsA("Model") then
                local demolishRemote = ReplicatedStorage:FindFirstChild("Demolish")
                if demolishRemote then
                    demolishRemote:FireServer(obj)
                    count = count + 1
                end
            end
        end
    end)
    titleLabel.Text = string.format("LT2 Tools - Destroyed %d Signs!", count)
    TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
    wait(1.5)
    TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    titleLabel.Text = "LT2 Tools"
end)

-- 4. Base Spawner Button (Floor + Sawmill)
createButton("🏠 Spawn Base (Floor + Sawmill)", function()
    local prop = playerProperty or findProperty()
    if prop and prop:FindFirstChild("Origin") then
        local originCFrame = prop.Origin.CFrame
        pcall(function()
            -- Spawn Floor
            ReplicatedStorage.PlaceStructure:FireServer("Floor", originCFrame)
            -- Spawn Sawmill (slight offset to avoid overlap)
            ReplicatedStorage.PlaceStructure:FireServer("Sawmill", originCFrame + Vector3.new(8, 0, 0))
        end)
        titleLabel.Text = "LT2 Tools - Base Spawned!"
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        titleLabel.Text = "LT2 Tools"
    else
        titleLabel.Text = "LT2 Tools - Find Property First!"
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        titleLabel.Text = "LT2 Tools"
    end
end)

-- Auto-find property on script load
spawn(function()
    wait(2)
    findProperty()
end)

-- Update canvas size when layout changes
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

print("LT2 Tools loaded successfully! Draggable UI with all features enabled.")
