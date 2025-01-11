local SelectedTeam = nil
local function vchange(team)
    local args = {
        [1] = tostring(team.TeamColor)
    }
    
  game:GetService("ReplicatedStorage").teamhandler:FireServer(unpack(args))
end
local teamNames = {}
for _, team in ipairs(game.Teams:GetChildren()) do
    if team:IsA("Team") then
        table.insert(teamNames, team.Name)
    end
end
print("{ " .. table.concat(teamNames, ', ') .. " }")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    TeamChange = Window:AddTab({ Title = "Team Change", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do

    local Dropdown = Tabs.TeamChange:AddDropdown("Select Team", {
        Title = "Teams",
        Values = teamNames,
        Multi = false,
        Default = 1,
    })
    Dropdown:OnChanged(function(Value)
        SelectedTeam = Value
    end)
    Tabs.TeamChange:AddButton({
        Title = "Set Team",
        Description = "",
        Callback = function()
                for _, team in ipairs(game.Teams:GetChildren()) do
                    if team:IsA("Team") and team.Name == SelectedTeam then
                        vchange(team)
                    end
                end 
        end
        }) 
end


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
