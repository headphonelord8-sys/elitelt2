-- [[ ELITE BUILDER V2: NEON STABILITY BUILD ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Holder = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")

-- UI DESIGN
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -160)
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

-- NEON BORDER
local Glow = Instance.new("Frame")
Glow.Parent = MainFrame
Glow.Size = UDim2.new(1, 4, 1, 4)
Glow.Position = UDim2.new(0, -2, 0, -2)
Glow.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Glow.ZIndex = 0

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "ELITE BUILDER V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

Holder.Parent = MainFrame
Holder.Position = UDim2.new(0, 10, 0, 55)
Holder.Size = UDim2.new(0, 210, 0, 250)
Holder.BackgroundTransparency = 1
Holder.ScrollBarThickness = 2
UIList.Parent = Holder
UIList.Padding = UDim.new(0, 8)

-- [ THE BUG FIX: TRIPLE-THREAT PLOT FINDER ]
local function findMyPlot()
    local lp = game.Players.LocalPlayer
    -- Check via Folder first (Fastest)
    if lp:FindFirstChild("CurrentProperty") and lp.CurrentProperty.Value then
        return lp.CurrentProperty.Value
    end
    -- Check via Workspace (Deep Scan)
    for _, folder in pairs(game.Workspace.Properties:GetChildren()) do
        local owner = folder:FindFirstChild("Owner")
        if owner and (owner.Value == lp or tostring(owner.Value) == lp.Name) then
            return folder
        end
    end
    return nil
end

-- [ PRO BUTTON CREATOR ]
local function AddButton(name, color, action)
    local btn = Instance.new("TextButton")
    btn.Parent = Holder
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0

    btn.MouseButton1Click:Connect(function()
        local plot = findMyPlot()
        if not plot then
            btn.Text = "❌ NO PLOT CLAIMED"
            btn.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(1.5)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            return
        end

        btn.Text = "⚡ EXECUTING..."
        btn.TextColor3 = color
        
        -- Run the logic
        local success, err = pcall(function()
            action(plot)
        end)

        if success then
            btn.Text = "✅ SUCCESS"
        else
            btn.Text = "⚠️ ERROR"
            warn("Elite Error: " .. tostring(err))
        end

        task.wait(1.5)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
end

-- [ BUTTONS ]
AddButton("FREE MAX LAND", Color3.fromRGB(0, 255, 100), function(p)
    local remote = game.ReplicatedStorage.PropertyMethods.BuyLand
    for x = -3, 3 do
        for z = -3, 3 do
            local pos = p.Origin.Position + Vector3.new(x*40, 0, z*40)
            remote:FireServer(p, pos)
        end
    end
end)

AddButton("CLEAR SOLD SIGNS", Color3.fromRGB(255, 50, 50), function(p)
    for _, v in pairs(game.Workspace.Properties:GetDescendants()) do
        if v.Name:find("Sign") then
            game.ReplicatedStorage.PropertyMethods.Demolish:FireServer(v)
        end
    end
end)

AddButton("SPAWN BASE #1", Color3.fromRGB(0, 150, 255), function(p)
    local remote = game.ReplicatedStorage.PropertyMethods.PlaceStructure
    local cf = p.Origin.CFrame
    remote:FireServer("Floor1", cf, p)
    remote:FireServer("Sawmill", cf * CFrame.new(0, 2, 0), p)
end)

print("🚀 ELITE V2 LOADED SUCCESSFULLY")
