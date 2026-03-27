-- LT2 Tools v3 - BLUEPRINT MODE + All Previous Fixes
-- Places BLUEPRINTS instead of building (cheaper/faster!)
loadstring(game:HttpGet("YOUR_GITHUB_URL"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Clear existing
pcall(function() playerGui:FindFirstChild("LT2Tools"):Destroy() end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LT2Tools"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 450)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Bar (Draggable)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainFrame.Active = true
        mainFrame.Draggable = true
    end
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔧 LT2 Tools v3 - BLUEPRINTS"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 50)
statusLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
statusLabel.Text = "Status: Ready (Blueprint Mode)"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- Scrolling Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 90)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = scrollFrame

local playerProperty = nil

-- Property Finder (unchanged)
local function findProperty()
    playerProperty = nil
    pcall(function()
        if not workspace:FindFirstChild("Properties") then return nil end
        
        for _, prop in pairs(workspace.Properties:GetChildren()) do
            local owner = prop:FindFirstChild("Owner")
            if owner and owner:IsA("ObjectValue") and owner.Value == player then
                playerProperty = prop
                statusLabel.Text = "✅ Property: " .. prop.Name
                return prop
            end
        end
    end)
    return playerProperty
end

-- Sign Destroyer (unchanged)
local function destroySigns()
    local count = 0
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "PropertySign" or obj.Name == "SoldSign" then
                if obj.Parent and obj.Parent.Parent then
                    local model = obj.Parent.Parent
                    if model:IsA("Model") then
                        local demolish = ReplicatedStorage:FindFirstChild("Demolish")
                        if demolish then
                            demolish:FireServer(model)
                            count = count + 1
                        end
                    end
                end
            end
        end
    end)
    return count
end

-- NEW: Blueprint Placer (Places BLUEPRINTS only!)
local function placeBlueprints()
    local prop = playerProperty or findProperty()
    if prop and prop:FindFirstChild("Origin") then
        local originCFrame = prop.Origin.CFrame
        
        -- LT2 Blueprint Remote (places blueprint, not full build)
        pcall(function()
            -- Floor Blueprint
            ReplicatedStorage.Events["PlaceBlueprint"]:FireServer("Floor", originCFrame)
            wait(0.1)
            
            -- Sawmill Blueprint (offset)
            RepeaterCFrame = originCFrame + Vector3.new(8, 0, 0)
            ReplicatedStorage.Events["PlaceBlueprint"]:FireServer("Sawmill", RepeaterCFrame)
            
            statusLabel.Text = "📐 BLUEPRINTS placed! Floor + Sawmill"
        end)
    else
        statusLabel.Text = "❌ FIND PROPERTY FIRST!"
    end
end

-- Create Button Function
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 55)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamSemibold
    button.BorderSizePixel = 0
    button.Parent = scrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(70, 70, 70)
    btnStroke.Thickness = 1
    btnStroke.Parent = button
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        spawn(function() pcall(callback) end)
    end)
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end

-- BUTTONS:
createButton("🔍 1️⃣ FIND MY PROPERTY", function()
    local prop = findProperty()
    if prop then
        TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(0, 255, 0)}):Play()
        wait(1)
        TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end
end)

createButton("💰 2️⃣ BUY LAND (+40 Studs)", function()
    local prop = playerProperty or findProperty()
    if prop and prop:FindFirstChild("Origin") then
        local offsetCFrame = prop.Origin.CFrame + (prop.Origin.CFrame.LookVector * 40)
        pcall(function()
            ReplicatedStorage.PropertyMethods.BuyLand:FireServer(offsetCFrame)
        end)
        statusLabel.Text = "💰 BuyLand fired!"
    else
        statusLabel.Text = "❌ FIND PROPERTY FIRST!"
    end
end)

createButton("🗑️ 3️⃣ DESTROY ALL SIGNS", function()
    local count = destroySigns()
    statusLabel.Text = "🗑️ Destroyed " .. count .. " signs!"
end)

-- NEW BLUEPRINT BUTTON:
createButton("📐 4️⃣ PLACE BLUEPRINTS (Floor+Saw)", function()
    placeBlueprints()
end)

-- Auto-find
spawn(function() wait(3) findProperty() end)

print("✅ LT2 Tools v3 - BLUEPRINT MODE ACTIVE!")
