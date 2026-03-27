-- [[ ELITE LT2 BUILDER V4: REMOTES FIXED ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Holder = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")

-- UI DESIGN (Neon Red)
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -160)
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local Glow = Instance.new("Frame", MainFrame)
Glow.Size = UDim2.new(1, 4, 1, 4)
Glow.Position = UDim2.new(0, -2, 0, -2)
Glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Glow.ZIndex = 0

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "LT2 ELITE [V4]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Font = Enum.Font.GothamBold

Holder.Parent = MainFrame
Holder.Position = UDim2.new(0, 10, 0, 55)
Holder.Size = UDim2.new(0, 210, 0, 250)
Holder.BackgroundTransparency = 1
UIList.Parent = Holder
UIList.Padding = UDim.new(0, 8)

-- [ LT2 SPECIFIC LOGIC ]
local function getMyProperty()
    for _, v in pairs(game.Workspace.Properties:GetChildren()) do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            return v
        end
    end
    return nil
end

local function AddButton(name, color, action)
    local btn = Instance.new("TextButton", Holder)
    btn.Size = UDim2.new(1, -5, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(function()
        local p = getMyProperty()
        btn.BackgroundColor3 = color
        action(p)
        task.wait(0.3)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
end

-- [ BUTTONS ]

-- 1. Buy the first square (Must have $ in-game)
AddButton("1. BUY START SQUARE", Color3.fromRGB(0, 200, 0), function(p)
    if p then
        local pos = p.Origin.Position + Vector3.new(40, 0, 0)
        game.ReplicatedStorage.PropertyMethods.BuyLand:FireServer(p, pos)
    end
end)

-- 2. Expand all at once
AddButton("2. MAX ALL LAND", Color3.fromRGB(0, 150, 255), function(p)
    if p then
        for x = -3, 3 do
            for z = -3, 3 do
                local pos = p.Origin.Position + Vector3.new(x*40, 0, z*40)
                game.ReplicatedStorage.PropertyMethods.BuyLand:FireServer(p, pos)
                task.wait(0.05)
            end
        end
    end
end)

-- 3. LT2 Sign Removal (Targeting the actual Sign Model)
AddButton("3. CLEAR SIGNS", Color3.fromRGB(255, 50, 50), function()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == "PropertySign" or v.Name == "SoldSign" then
            game.ReplicatedStorage.PropertyMethods.Demolish:FireServer(v)
        end
    end
end)

-- 4. Spawn Basic Blueprint (Sawmill & Floor)
AddButton("4. SPAWN BASE #1", Color3.fromRGB(200, 0, 200), function(p)
    if p then
        local remote = game.ReplicatedStorage.PropertyMethods.PlaceStructure
        -- Using standard LT2 internal names
        remote:FireServer("Floor", p.Origin.CFrame, p)
        remote:FireServer("Sawmill", p.Origin.CFrame * CFrame.new(0, 2, 10), p)
    end
end)

print("🚀 LT2 ELITE V4 LOADED")
