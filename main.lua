-- [[ ELITE BUILDER V1: BASE TESTING PHASE ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "ELITE TEST [BASES UNLOCKED]", HidePremium = false, SaveConfig = false})

-- [ TAB 1: LAND EXPLOITS ]
local LandTab = Window:MakeTab({
	Name = "Land & Signs",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

LandTab:AddButton({
	Name = "💸 ATTEMPT FREE MAX LAND",
	Callback = function()
        local Property = game.Players.LocalPlayer.CurrentProperty.Value
        if not Property then return end
        local Remote = game.ReplicatedStorage.PropertyMethods.BuyLand
        for x = -3, 3 do
            for z = -3, 3 do
                local TargetPos = Property.Origin.Position + Vector3.new(x * 40, 0, z * 40)
                Remote:FireServer(Property, TargetPos)
                task.wait(0.05)
            end
        end
	end    
})

LandTab:AddButton({
	Name = "🚫 DELETE ALL SIGNS",
	Callback = function()
        for _, v in pairs(game.Workspace.Properties:GetDescendants()) do
            if v:IsA("Model") and (v.Name:find("Sign") or v.Name:find("Sold")) then
                game.ReplicatedStorage.PropertyMethods.Demolish:FireServer(v)
            end
        end
	end    
})

-- [ TAB 2: THE 30 BASES ]
local BuildTab = Window:MakeTab({
	Name = "30 Bases",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- BASE #1 DATA: LUXURY STARTER
local LuxuryStarterData = {
    {"Floor1", Vector3.new(0, 0, 0), 0},
    {"Floor1", Vector3.new(20, 0, 0), 0},
    {"Wall1", Vector3.new(10, 5, 20), 0},
    {"Wall1", Vector3.new(-10, 5, 20), 0},
    {"WallDoor1", Vector3.new(0, 5, -20), 0},
    {"Sawmill", Vector3.new(15, 2, 10), 90} -- Example: Adding a sawmill to the base
}

BuildTab:AddButton({
	Name = "🏗️ SPAWN BASE #1 (LUXURY STARTER)",
	Callback = function()
        local Property = game.Players.LocalPlayer.CurrentProperty.Value
        if not Property then return end
        
        local Remote = game.ReplicatedStorage.PropertyMethods.PlaceStructure
        OrionLib:MakeNotification({Name = "Building", Content = "Spawning Luxury Starter...", Time = 5})

        for _, item in pairs(LuxuryStarterData) do
            -- Aligns the base perfectly to your plot's center
            local TargetCF = Property.Origin.CFrame * CFrame.new(item[2]) * CFrame.Angles(0, math.radians(item[3]), 0)
            Remote:FireServer(item[1], TargetCF, Property)
            task.wait(0.1) -- Delta Stability Delay
        end
        OrionLib:MakeNotification({Name = "Success", Content = "Base #1 Finished!", Time = 5})
	end    
})

OrionLib:Init()
