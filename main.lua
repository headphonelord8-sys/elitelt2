-- [[ ELITE BUILDER V1: RAYFIELD STABILITY EDITION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ELITE BUILDER V1",
   LoadingTitle = "Loading Elite Systems...",
   LoadingSubtitle = "by Headphonelord8-sys",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- [ TAB 1: LAND & SIGNS ]
local LandTab = Window:CreateTab("Property", 4483362458) -- Property Icon

LandTab:CreateButton({
   Name = "💸 FREE MAX LAND (GLITCH)",
   Callback = function()
       local Property = game.Players.LocalPlayer.CurrentProperty.Value
       if not Property then return end
       
       local Remote = game.ReplicatedStorage.PropertyMethods.BuyLand
       local Origin = Property.Origin.Position
       
       -- The "Kron" Spam Method
       for x = -3, 3 do
           for z = -3, 3 do
               local TargetPos = Origin + Vector3.new(x * 40, 0, z * 40)
               -- Fire 5 times rapidly to bypass server check
               for i = 1, 5 do
                   Remote:FireServer(Property, TargetPos)
               end
               task.wait(0.05)
           end
       end
   end,
})

LandTab:CreateButton({
   Name = "🚫 DELETE SOLD SIGNS",
   Callback = function()
       local Demolish = game.ReplicatedStorage.PropertyMethods.Demolish
       for _, v in pairs(game.Workspace.Properties:GetDescendants()) do
           if v:IsA("Model") and (v.Name:find("Sign") or v.Name:find("Sold")) then
               Demolish:FireServer(v)
           end
       end
   end,
})

-- [ TAB 2: 30 BASES ]
local BaseTab = Window:CreateTab("30 Bases", 4483362458)

BaseTab:CreateButton({
   Name = "🏗️ SPAWN BASE #1 (LUXURY STARTER)",
   Callback = function()
       local Property = game.Players.LocalPlayer.CurrentProperty.Value
       if not Property then return end
       
       local PlaceRemote = game.ReplicatedStorage.PropertyMethods.PlaceStructure
       
       -- Simple starter layout for testing
       local BuildData = {
           {"Floor1", Vector3.new(0, 0, 0), 0},
           {"Floor1", Vector3.new(20, 0, 0), 0},
           {"Wall1", Vector3.new(10, 5, 20), 0},
           {"Sawmill", Vector3.new(15, 2, 10), 90}
       }

       for _, item in pairs(BuildData) do
           local CF = Property.Origin.CFrame * CFrame.new(item[2]) * CFrame.Angles(0, math.radians(item[3]), 0)
           PlaceRemote:FireServer(item[1], CF, Property)
           task.wait(0.1)
       end
   end,
})
