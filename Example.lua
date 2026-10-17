local Lumen = loadstring(readfile("Lumen.lua"))()

local Hub = Lumen:Taskbar({
	Name = "Lumen Hub",
	Description = "v3.0",
	Icon = "layers",
	Key = Enum.KeyCode.RightShift,
	Blur = 14,
	Splash = true,
	LoadedSound = "rbxassetid://6647897822",
	NotifySound = "rbxassetid://9120371540",
})

local Main = Hub:Window({
	Name = "Lumen",
	Description = "Universal Suite",
	Icon = "layers",
	Size = UDim2.fromOffset(880, 580),
})

Main:Category("Combat")

local Combat = Main:Tab({Name = "Aimbot", Icon = "crosshair"})

local Aim = Combat:Section({Name = "Silent Aim", Icon = "target", Side = "Left"})

local AimToggle = Aim:Toggle({
	Name = "Silent Aim",
	Description = "Redirects projectiles toward the closest target",
	Default = true,
	Flag = "SilentAim",
	Tooltip = "Hold or toggle your keybind to lock onto players",
	Callback = function(v)
		print("Silent Aim:", v)
	end,
})
AimToggle:Bind({Default = Enum.KeyCode.E, Mode = "Toggle", Flag = "SilentAimBind"})
AimToggle:Color({Default = Color3.fromRGB(124, 92, 255), Flag = "SilentAimColor"})

Aim:Slider({
	Name = "Field of View",
	Description = "Maximum radius around cursor",
	Min = 10,
	Max = 360,
	Default = 140,
	Suffix = "°",
	Flag = "AimFOV",
})

Aim:Slider({
	Name = "Smoothing",
	Description = "Camera interpolation factor",
	Min = 0,
	Max = 1,
	Increment = 0.05,
	Default = 0.25,
	Flag = "AimSmooth",
})

Aim:Dropdown({
	Name = "Hitbox",
	Values = {"Head", "UpperTorso", "HumanoidRootPart", "Closest"},
	Default = "Head",
	Flag = "AimHitbox",
})

local Checks = Combat:Section({Name = "Checks & Trigger", Icon = "shield", Side = "Right"})

Checks:Dropdown({
	Name = "Validation",
	Description = "Conditions required before locking",
	Values = {"Team Check", "Wall Check", "Alive Check", "ForceField Check", "Friend Check"},
	Default = {"Team Check", "Alive Check"},
	Multi = true,
	Flag = "AimChecks",
})

Checks:Input({
	Name = "Target Priority",
	Placeholder = "Username...",
	Flag = "PriorityUser",
})

Checks:Divider()

local SnapBtn = Checks:Button({
	Name = "Snap to Target",
	Icon = "zap",
	Style = "Primary",
	Callback = function()
		Hub:Notify({
			Title = "Locked On",
			Content = "Snapped camera to nearest target.",
			Type = "Success",
			Duration = 3,
		})
	end,
})
SnapBtn:Bind({Default = Enum.KeyCode.R, Flag = "SnapBind"})

Checks:Button({
	Name = "Test Notifications",
	Icon = "bell",
	Callback = function()
		Hub:Notify({Title = "Information", Content = "Target configuration updated.", Type = "Info", Duration = 3})
		task.delay(0.25, function()
			Hub:Notify({Title = "Warning", Content = "High smoothing detected.", Type = "Warning", Duration = 4})
		end)
		task.delay(0.5, function()
			Hub:Notify({Title = "Danger", Content = "Anti-cheat check triggered.", Type = "Error", Duration = 5})
		end)
	end,
})

Main:Category("Visuals")

local Visuals = Main:Tab({Name = "ESP", Icon = "eye"})

local PlayerESP = Visuals:Section({Name = "Players", Icon = "user", Side = "Left"})

local BoxESP = PlayerESP:Toggle({
	Name = "Bounding Box",
	Description = "2D corner box around players",
	Default = true,
	Flag = "ESPBox",
})
BoxESP:Color({Default = Color3.fromRGB(124, 92, 255), Flag = "ESPBoxColor"})

local NameESP = PlayerESP:Toggle({
	Name = "Display Names",
	Default = true,
	Flag = "ESPName",
})
NameESP:Color({Default = Color3.fromRGB(255, 255, 255), Flag = "ESPNameColor"})

local Chams = PlayerESP:Toggle({
	Name = "Highlight Chams",
	Description = "Filled mesh highlight with transparency",
	Flag = "ESPChams",
})
Chams:Color({Default = Color3.fromRGB(52, 211, 153), Alpha = 0.45, Flag = "ESPChamsColor"})

PlayerESP:Slider({
	Name = "Max Distance",
	Min = 100,
	Max = 5000,
	Increment = 50,
	Default = 1500,
	Suffix = "m",
	Flag = "ESPDistance",
})

local World = Visuals:Section({Name = "World", Icon = "globe", Side = "Right"})

World:Paragraph({
	Name = "Environment Modulation",
	Content = "Override client lighting, fog, and post-processing effects in real time.",
})

local Ambient = World:Toggle({Name = "Custom Ambient", Flag = "WorldAmbient"})
Ambient:Color({Default = Color3.fromRGB(90, 110, 255), Flag = "WorldAmbientColor"})

World:Slider({
	Name = "Time of Day",
	Min = 0,
	Max = 24,
	Increment = 0.5,
	Default = 14,
	Suffix = "h",
	Flag = "WorldClock",
})

Hub:Settings(Main)
