local Booga = {}




Booga.UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/RealMrQuacks/AuratusX/refs/heads/master/Load"))()



-- Assume Booga.UI is already declared.
local UI = {
    Tabs = {},
    Sections = {},
    Elements = {},
    Pickers = {},
}

-- Core setup
do
    local main = Booga.UI:Load{
        Name = "UI Test | v1.0.0",
        SizeX = 600,
        SizeY = 650,
        Theme = "Midnight",
        Extension = "json",
        Folder = "Auratus",
    }

    UI.Tabs.Main = main:Tab("Main")
    UI.Tabs.AutoFarm = main:Tab("Movement")
    UI.Tabs.Config = main:Tab("Config")
end

-- Main: general controls
do
    local section = UI.Tabs.Main:Section{
        Name = "General",
        Side = "Left",
    }

    UI.Sections.General = section

    UI.Elements.Info = section:Label("Interact with controls to print their values.")
    UI.Elements.GeneralSeparator = section:Separator("Controls")

    -- Buttons do not return a control handle.
    section:Button{
        Name = "Test Button",
        Callback = function()
            print("Test Button clicked")
        end,
    }

    UI.Elements.Enabled = section:Toggle{
        Name = "Enabled",
        Default = false,
        Flag = "Enabled",
        Callback = function(value)
            print("Enabled:", value)
        end,
    }

    UI.Elements.Message = section:Box{
        Default = "",
        Placeholder = "Enter a message",
        Flag = "Message",
        Callback = function(value)
            print("Message:", value)
        end,
    }

    UI.Elements.Target = section:Dropdown{
        Name = "Target",
        Content = {"Trees", "Rocks", "Bushes"},
        Default = "Trees",
        Flag = "Target",
        Callback = function(value)
            print("Target:", value)
        end,
    }

    UI.Elements.Resources = section:Dropdown{
        Name = "Resources",
        Content = {"Wood", "Stone", "Iron", "Gold"},
        Default = {"Wood", "Stone"},
        Max = 2,
        Flag = "Resources",
        Callback = function(values)
            print("Resources:", table.concat(values, ", "))
        end,
    }
end

-- Main: color controls
do
    local section = UI.Tabs.Main:Section{
        Name = "Appearance",
        Side = "Right",
    }

    UI.Sections.Appearance = section

    UI.Pickers.Accent = section:ColorPicker{
        Name = "Accent Color",
        Default = Color3.fromRGB(255, 128, 0),
        DefaultAlpha = 1,
        Flag = "AccentColor",
        Callback = function(color)
            print("Accent Color:", color, "Alpha:", color.A)
        end,
    }

    UI.Elements.Highlight = section:Toggle{
        Name = "Highlight",
        Default = false,
        Flag = "Highlight",
        Callback = function(value)
            print("Highlight:", value)
        end,
    }

    -- Attach a color picker to a toggle.
    UI.Pickers.Highlight = UI.Elements.Highlight:ColorPicker{
        Default = Color3.fromRGB(100, 200, 255),
        DefaultAlpha = 0.75,
        Flag = "HighlightColor",
        Callback = function(color)
            print("Highlight Color:", color, "Alpha:", color.A)
        end,
    }
end

-- Movement: toggles, sliders, and keybinds
do
    local section = UI.Tabs.AutoFarm:Section{
        Name = "Player",
        Side = "Left",
    }

    UI.Sections.Player = section

    UI.Elements.Flight = section:Toggle{
        Name = "Flight",
        Default = false,
        Flag = "Flight",
        Callback = function(value)
            print("Flight:", value)
        end,
    }

    -- Toggle mode also switches the parent toggle when pressed.
    UI.Elements.FlightKeybind = UI.Elements.Flight:Keybind{
        Default = Enum.KeyCode.F,
        Mode = "Toggle",
        Blacklist = {Enum.KeyCode.Unknown, Enum.KeyCode.Escape},
        Flag = "FlightKeybind",
        Callback = function(key, fromSetting)
            print("Flight Keybind:", key, "From setting:", fromSetting)
        end,
    }

    UI.Elements.WalkSpeed = section:Slider{
        Name = "Walk Speed",
        Min = 16,
        Max = 100,
        Default = 16,
        Float = 1,
        Text = "[value] studs/s",
        Flag = "WalkSpeed",
        Callback = function(value)
            print("Walk Speed:", value)
        end,
    }

    UI.Elements.JumpPower = section:Slider{
        Name = "Jump Power",
        Min = 0,
        Max = 150,
        Default = 50,
        Float = 1,
        Text = "[value]",
        Flag = "JumpPower",
        Callback = function(value)
            print("Jump Power:", value)
        end,
    }

    UI.Elements.ActionKeybind = section:Keybind{
        Name = "Action Key",
        Default = Enum.KeyCode.G,
        Blacklist = {Enum.KeyCode.Unknown, Enum.KeyCode.Escape},
        Flag = "ActionKeybind",
        Callback = function(key, fromSetting)
            print("Action Key:", key, "From setting:", fromSetting)
        end,
    }
end

-- Movement: scrollable list
do
    local section = UI.Tabs.AutoFarm:Section{
        Name = "Movement Options",
        Side = "Right",
    }

    UI.Sections.MovementOptions = section

    UI.Elements.MovementModes = section:List{
        Name = "Modes",
        Content = {"Walk", "Sprint", "Jump", "Fly", "Swim", "Climb"},
        Default = {"Walk"},
        Max = 2,
        Scrollable = true,
        ScrollingMax = 4,
        Flag = "MovementModes",
        Callback = function(values)
            print("Movement Modes:", table.concat(values, ", "))
        end,
    }

    section:Button{
        Name = "Test Movement",
        Callback = function()
            print("Test Movement clicked")
        end,
    }
end

-- Config: example actions only print
do
    local section = UI.Tabs.Config:Section{
        Name = "Configuration",
        Side = "Left",
    }

    UI.Sections.Configuration = section

    UI.Elements.ConfigName = section:Box{
        Default = "Default",
        Placeholder = "Config name",
        Flag = "ConfigName",
        Callback = function(value)
            print("Config Name:", value)
        end,
    }

    UI.Elements.UniversalConfig = section:Toggle{
        Name = "Universal Config",
        Default = false,
        Flag = "UniversalConfig",
        Callback = function(value)
            print("Universal Config:", value)
        end,
    }

    section:Button{
        Name = "Save Config",
        Callback = function()
            print("Save Config:", Booga.UI.flags.ConfigName)
        end,
    }

    section:Button{
        Name = "Load Config",
        Callback = function()
            print("Load Config:", Booga.UI.flags.ConfigName)
        end,
    }

    section:Button{
        Name = "Delete Config",
        Callback = function()
            print("Delete Config:", Booga.UI.flags.ConfigName)
        end,
    }
end

-- Config: theme selection
do
    local section = UI.Tabs.Config:Section{
        Name = "Interface",
        Side = "Right",
    }

    UI.Sections.Interface = section

    UI.Elements.Theme = section:Dropdown{
        Name = "Theme",
        Content = {"Default", "Midnight"},
        Default = "Midnight",
        Flag = "SelectedTheme",
        Callback = function(value)
            print("Selected Theme:", value)
        end,
    }

    section:Button{
        Name = "Test Interface",
        Callback = function()
            print("Test Interface clicked")
        end,
    }
end