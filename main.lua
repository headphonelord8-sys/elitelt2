-- [[ ELITE BUILDER V1: DELA MOBILE EDITION ]]
local DeltaLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = DeltaLib.CreateLib("ELITE BUILDER [DELTA]", "BloodTheme")

-- 🏠 THE BUILD DATABASE
local Builds = {
    ["Starter Hut"] = { {"Floor1", 0,0,0,0}, {"Wall1", 10,5,0,90}, {"WallDoor1", 0,5,10,0} },
    ["Max Sawmill"] = { {"Floor1", 0,0,0,0}, {"Sawmill", 10,2,0,0} }
}

-- [ TAB 1: MAIN MENU ]
local Main = Window:NewTab("Main")
local BuildSection = Main:NewSection("Construction")

BuildSection:NewDropdown("Select Build", "Choose from your 30 designs", {"Starter Hut", "Max Sawmill"}, function(v)
    _G.SelectedBuild = v
end)

BuildSection:NewButton("🚀 Spawn Blueprints", "Places the blue outlines instantly", function()
    local p = game.Players.LocalPlayer.CurrentProperty.Value
    if p and _G.SelectedBuild then
        for _, item in pairs(Builds[_G.SelectedBuild]) do
            game.ReplicatedStorage.PropertyMethods.PlaceStructure:FireServer(item[1], p.Origin.CFrame * CFrame.new(item[2], item[3], item[4]), p)
            wait(0.1) -- Delta likes a slightly slower wait to prevent lag
        end
    end
end)

-- [ TAB 2: LAND & ADMIN ]
local Admin = Window:NewTab("Admin")
local LandSection = Admin:NewSection("Property Tools")

LandSection:NewButton("🌍 Instant Max Land", "Buys all land around you", function()
    local Property = game.Players.LocalPlayer.CurrentProperty.Value
    if Property then
        for x = -2, 2 do
            for z = -2, 2 do
                game.ReplicatedStorage.PropertyMethods.BuyLand:FireServer(Property, Property.Origin.Position + Vector3.new(x*40, 0, z*40))
                wait(0.1)
            end
        end
    end
end)

-- [ HWID CHECK FOR DELTA ]
-- Note: Delta uses a slightly different HWID string. 
-- When testing, this will show your ID in the console.
print("Your Delta HWID is: " .. gethwid())
