-- [[ ELITE BUILDER V1: VISUAL FEEDBACK & FIX ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local LandTab = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")

-- GUI SETUP 
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ELITE BUILDER V1"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0

LandTab.Parent = MainFrame
LandTab.Position = UDim2.new(0, 10, 0, 50)
LandTab.Size = UDim2.new(0, 200, 0, 240)
LandTab.BackgroundTransparency = 1
LandTab.ScrollBarThickness = 4

UIList.Parent = LandTab
UIList.Padding = UDim.new(0, 8)

-- [ BULLETPROOF PROPERTY FINDER ]
local function getProp()
    -- This scans the actual map to find the land with your name on it
    for _, prop in pairs(game.Workspace.Properties:GetChildren()) do
        if prop:FindFirstChild("Owner") and prop.Owner.Value == game.Players.LocalPlayer then
            return prop
        end
    end
    return nil
end

-- [ ADVANCED BUTTON CREATOR WITH VISUALS ]
local function CreateButton(text, color, func)
    local btn = Instance.new("TextButton")
    btn.Parent = LandTab
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        local originalText = btn.Text
        local originalColor = btn.BackgroundColor3
        
        btn.Text = "⏳ PROCESSING..."
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        -- Run the actual function
        local success = func(btn)
        
        if success == false then
            btn.Text = "❌ NO PLOT FOUND!"
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        else
            btn.Text = "✅ SENT TO SERVER!"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        end
        
        -- Reset the button after 2 seconds
        task.wait(2)
        btn.Text = originalText
        btn.BackgroundColor3 = originalColor
    end)
    return btn
end

-- [ BUTTON 1: FREE LAND ]
CreateButton("💸 FREE MAX LAND", Color3.fromRGB(60, 120, 60), function()
    local p = getProp()
    if not p then return false end
    
    for x = -3, 3 do
        for z = -3, 3 do
            local pos = p.Origin.Position + Vector3.new(x*40, 0, z*40)
            game.ReplicatedStorage.PropertyMethods.BuyLand:FireServer(p, pos)
            task.wait(0.05)
        end
    end
    return true
end)

-- [ BUTTON 2: DELETE SIGNS ]
CreateButton("🚫 DELETE SIGNS", Color3.fromRGB(120, 60, 60), function()
    for _, v in pairs(game.Workspace.Properties:GetDescendants()) do
        if v.Name:find("Sign") or v.Name:find("Sold") then
            game.ReplicatedStorage.PropertyMethods.Demolish:FireServer(v)
        end
    end
    return true
end)

-- [ BUTTON 3: BASE #1 - LUXURY STARTER ]
CreateButton("🏗️ BASE #1: LUXURY", Color3.fromRGB(60, 60, 120), function()
    local p = getProp()
    if not p then return false end
    
    local remote = game.ReplicatedStorage.PropertyMethods.PlaceStructure
    local data = {
        {"Floor1", Vector3.new(0, 0, 0), 0},
        {"Floor1", Vector3.new(20, 0, 0), 0},
        {"Wall1", Vector3.new(10, 5, 20), 0}
    }
    for _, item in pairs(data) do
        local cf = p.Origin.CFrame * CFrame.new(item[2]) * CFrame.Angles(0, math.radians(item[3]), 0)
        remote:FireServer(item[1], cf, p)
        task.wait(0.1)
    end
    return true
end)

-- [ BUTTON 4: BASE #2 - AUTO-WOOD PROCESSOR ]
CreateButton("🪓 BASE #2: PROCESSOR", Color3.fromRGB(100, 60, 150), function()
    local p = getProp()
    if not p then return false end
    
    local remote = game.ReplicatedStorage.PropertyMethods.PlaceStructure
    local data = {
        {"Floor1", Vector3.new(0, 0, 40), 0},
        {"Sawmill", Vector3.new(0, 2, 40), 90},
        {"Sawmill", Vector3.new(20, 2, 40), 90},
        {"Wall1", Vector3.new(0, 5, 60), 0}
    }
    for _, item in pairs(data) do
        local cf = p.Origin.CFrame * CFrame.new(item[2]) * CFrame.Angles(0, math.radians(item[3]), 0)
        remote:FireServer(item[1], cf, p)
        task.wait(0.1)
    end
    return true
end)
