local Lumen = loadstring(readfile("Lumen.lua"))()

local window = Lumen:Window({
	Title = "Hub",
	Subtitle = "v1.0",
	Icon = "layers",
	Key = Enum.KeyCode.RightShift,
})

window:Category("Main")

local combat = window:Tab({Name = "Combat", Icon = "crosshair"})

local aim = combat:Section({Name = "Aimbot", Side = "Left"})
aim:Toggle({Name = "Enabled", Flag = "aim", Callback = function(v) print(v) end})
aim:Keybind({Name = "Hold key", Default = Enum.KeyCode.E, Flag = "aimKey", Callback = function() print("pressed") end})
aim:Slider({Name = "Smoothing", Min = 0, Max = 1, Increment = 0.05, Default = 0.3, Flag = "smooth"})
aim:Slider({Name = "FOV", Min = 10, Max = 360, Default = 90, Suffix = "°", Flag = "fov"})
aim:Dropdown({Name = "Target", Values = {"Head", "Torso", "Closest"}, Default = "Head", Flag = "target"})

local misc = combat:Section({Name = "Extras", Side = "Right"})
misc:Dropdown({Name = "Checks", Values = {"Team", "Wall", "Alive"}, Multi = true, Flag = "checks"})
misc:Input({Name = "Whitelist", Placeholder = "username", Flag = "whitelist"})
misc:Divider()
misc:Label("Hold the keybind to lock on.")
misc:Button({Name = "Test notification", Callback = function()
	Lumen:Notify({Title = "Hub", Content = "Everything is working.", Duration = 4})
end})

local visuals = window:Tab({Name = "Visuals", Icon = "eye"})
local esp = visuals:Section({Name = "ESP"})
esp:Toggle({Name = "Boxes", Flag = "boxes"})
esp:ColorPicker({Name = "Box color", Default = Color3.fromRGB(138, 108, 255), Flag = "boxColor"})

window:Category("Config")

local settings = window:Tab({Name = "Settings", Icon = "settings"})
local ui = settings:Section({Name = "Interface"})
ui:ColorPicker({Name = "Accent", Default = Lumen.Theme.Accent, Callback = function(c) Lumen:SetAccent(c) end})
ui:Keybind({Name = "Menu key", Default = window.Key, OnChange = function(k) window.Key = k end})

local cfg = settings:Section({Name = "Configs", Side = "Right"})
local name = cfg:Input({Name = "Name", Default = "default"})
cfg:Button({Name = "Save", Callback = function() Lumen:SaveConfig(name.Value) end})
cfg:Button({Name = "Load", Callback = function() Lumen:LoadConfig(name.Value) end})
cfg:Button({Name = "Unload", Callback = function() Lumen:Unload() end})
