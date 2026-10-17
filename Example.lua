local Lumen = loadstring(game:HttpGet("https://raw.githubusercontent.com/hxracan/lumen-ui/refs/heads/main/Lumen.lua"))()

local Hub = Lumen.new({
	Name = "Jupiter",
	Sub = "v 4 million",
	Key = Enum.KeyCode.RightShift,
	Theme = "Carbon",
	Watermark = true,
	KeybindList = true,
	Dock = true,
	Splash = true,
	Blur = false,
	Transparency = 0.16,
	WindowSize = "Medium (760x540)",
	AnimationType = "Scale + Fade",
	JigglyDrag = true,
	JiggleIntensity = 1.15,
	MobileFriendly = true,
	ConfigFolder = "LumenConfigs",
})

local Main = Hub:Window({
	Name = "Combat & Visuals",
	Sub = "Primary Module Suite",
	Icon = "shield",
	Size = UDim2.fromOffset(760, 540),
	Position = UDim2.fromOffset(100, 80),
	Visible = true,
})

local RadarWin = Hub:Window({
	Name = "Entity Inspector",
	Sub = "Live Telemetry",
	Icon = "radar",
	Size = UDim2.fromOffset(500, 380),
	Position = UDim2.fromOffset(880, 110),
	Visible = false,
})

Main:Category("COMBAT")

local Combat = Main:Tab({
	Name = "Aimbot",
	Icon = "crosshair",
})

local AimSec = Combat:Section({
	Name = "Silent Aim",
	Icon = "target",
	Side = "Left",
})

local MasterAim = AimSec:Toggle({
	Name = "Enable Silent Aim",
	Description = "Redirects projectiles toward the optimal target bone",
	Default = true,
	Flag = "SilentAim_Enabled",
	Risky = true,
	Callback = function(state)
		Hub:Notify({
			Title = "Silent Aim",
			Text = state and "Silent Aim is now active" or "Silent Aim disabled",
			Type = state and "Success" or "Info",
			Time = 2.5,
		})
	end,
})

MasterAim:Keybind({
	Default = Enum.KeyCode.Q,
	Mode = "Toggle",
	Flag = "SilentAim_Bind",
})

MasterAim:Color({
	Default = Color3.fromRGB(130, 145, 255),
	Alpha = 0.2,
	Flag = "SilentAim_Color",
})

AimSec:Slider({
	Name = "Field of View",
	Description = "Maximum angular radius for target acquisition",
	Min = 10,
	Max = 360,
	Default = 140,
	Step = 1,
	Suffix = "°",
	Flag = "SilentAim_FOV",
})

AimSec:Slider({
	Name = "Hit Chance",
	Min = 0,
	Max = 100,
	Default = 88,
	Step = 1,
	Suffix = "%",
	Flag = "SilentAim_HitChance",
})

AimSec:Dropdown({
	Name = "Target Hitbox",
	Description = "Prioritized bones during target evaluation",
	Items = {"Head", "UpperTorso", "HumanoidRootPart", "LeftArm", "RightArm"},
	Multi = true,
	Default = {"Head", "UpperTorso"},
	Flag = "SilentAim_Bones",
})

AimSec:Dropdown({
	Name = "Target Priority",
	Items = {"Closest to Crosshair", "Lowest Health", "Shortest Distance", "Threat Level"},
	Default = "Closest to Crosshair",
	Flag = "SilentAim_Priority",
})

local SubBox = Combat:Tabbox({
	Side = "Right",
})

local TrigTab = SubBox:Tab({
	Name = "Triggerbot",
	Icon = "zap",
})

local TrigToggle = TrigTab:Toggle({
	Name = "Auto Fire",
	Description = "Automatically fires when crosshair intersects target",
	Default = false,
	Flag = "Trigger_Enabled",
	Risky = true,
})

TrigToggle:Keybind({
	Default = Enum.KeyCode.T,
	Mode = "Hold",
	Flag = "Trigger_Bind",
})

TrigTab:Slider({
	Name = "Reaction Delay",
	Min = 0,
	Max = 250,
	Default = 35,
	Step = 5,
	Suffix = "ms",
	Flag = "Trigger_Delay",
})

local PredTab = SubBox:Tab({
	Name = "Prediction",
	Icon = "activity",
})

PredTab:Toggle({
	Name = "Velocity Compensation",
	Description = "Predicts target trajectory using ping and velocity",
	Default = true,
	Flag = "Pred_Enabled",
})

PredTab:Slider({
	Name = "Prediction Factor",
	Min = 0.05,
	Max = 0.35,
	Default = 0.142,
	Step = 0.001,
	Suffix = "s",
	Flag = "Pred_Factor",
})

local UtilSec = Combat:Section({
	Name = "Quick Actions",
	Icon = "sliders",
	Side = "Right",
})

UtilSec:Button({
	Name = "Snap to Nearest",
	Icon = "crosshair",
	Callback = function()
		Hub:Notify({
			Title = "Target Locked",
			Text = "Snapped camera to closest visible enemy",
			Type = "Info",
			Time = 2.5,
		})
	end,
	SubName = "Test Notification",
	SubIcon = "bell",
	SubCallback = function()
		Hub:Notify({
			Title = "Lumen Notification",
			Text = "Acrylic toast with smooth spring transitions",
			Type = "Success",
			Time = 3.5,
		})
	end,
})

local MoveTab = Main:Tab({
	Name = "Movement",
	Icon = "zap",
})

local MoveSec = MoveTab:Section({
	Name = "Character Physics",
	Icon = "activity",
	Side = "Left",
})

local SpeedToggle = MoveSec:Toggle({
	Name = "Speed Modification",
	Description = "Overrides humanoid walk velocity smoothly",
	Default = false,
	Flag = "Move_SpeedEnabled",
	Risky = true,
})

SpeedToggle:Keybind({
	Default = Enum.KeyCode.V,
	Mode = "Toggle",
	Flag = "Move_SpeedBind",
})

MoveSec:Slider({
	Name = "WalkSpeed Multiplier",
	Min = 16,
	Max = 150,
	Default = 32,
	Step = 1,
	Suffix = " stud/s",
	Flag = "Move_SpeedVal",
})

local FlightSec = MoveTab:Section({
	Name = "Aerial Control",
	Icon = "wind",
	Side = "Right",
})

local FlyToggle = FlightSec:Toggle({
	Name = "CFrame Flight",
	Description = "Smooth directional flight bypassing gravity",
	Default = false,
	Flag = "Move_FlyEnabled",
	Risky = true,
})

FlyToggle:Keybind({
	Default = Enum.KeyCode.F,
	Mode = "Toggle",
	Flag = "Move_FlyBind",
})

FlightSec:Slider({
	Name = "Flight Velocity",
	Min = 20,
	Max = 200,
	Default = 65,
	Step = 5,
	Suffix = " stud/s",
	Flag = "Move_FlySpeed",
})

Main:Category("RENDER")

local Visuals = Main:Tab({
	Name = "ESP",
	Icon = "eye",
})

local EspSec = Visuals:Section({
	Name = "Player Overlay",
	Icon = "users",
	Side = "Left",
})

local BoxToggle = EspSec:Toggle({
	Name = "Bounding Box",
	Description = "Renders 2D corner or full boxes around entities",
	Default = true,
	Flag = "ESP_Box",
})

BoxToggle:Color({
	Default = Color3.fromRGB(130, 145, 255),
	Alpha = 0,
	Flag = "ESP_BoxColor",
})

local ChamsToggle = EspSec:Toggle({
	Name = "Highlight Chams",
	Description = "Applies depth-aware surface highlights to models",
	Default = true,
	Flag = "ESP_Chams",
})

ChamsToggle:Color({
	Default = Color3.fromRGB(65, 215, 145),
	Alpha = 0.35,
	Flag = "ESP_ChamsColor",
})

EspSec:Slider({
	Name = "Max Render Distance",
	Min = 100,
	Max = 5000,
	Default = 1500,
	Step = 50,
	Suffix = "m",
	Flag = "ESP_MaxDist",
})

local WorldSec = Visuals:Section({
	Name = "Atmosphere",
	Icon = "sun",
	Side = "Right",
})

local AmbToggle = WorldSec:Toggle({
	Name = "Custom Ambient",
	Description = "Overrides world lighting and outdoor tint",
	Default = false,
	Flag = "World_Ambient",
})

AmbToggle:Color({
	Default = Color3.fromRGB(150, 130, 255),
	Alpha = 0,
	Flag = "World_AmbientColor",
})

WorldSec:Slider({
	Name = "Clock Time",
	Min = 0,
	Max = 24,
	Default = 14.5,
	Step = 0.5,
	Suffix = "h",
	Flag = "World_Time",
})

local RadarTab = RadarWin:Tab({
	Name = "Overview",
	Icon = "activity",
})

local RadarSec = RadarTab:Section({
	Name = "Scanner",
	Icon = "radio",
	Side = "Left",
})

RadarSec:Toggle({
	Name = "Show Dormant",
	Default = true,
	Flag = "Radar_Dormant",
})

RadarSec:Slider({
	Name = "Update Rate",
	Min = 10,
	Max = 144,
	Default = 60,
	Step = 1,
	Suffix = "Hz",
	Flag = "Radar_Rate",
})

local RadarInfo = RadarTab:Section({
	Name = "Session Info",
	Icon = "terminal",
	Side = "Right",
})

RadarInfo:Label("Status: Active & Synchronized")
RadarInfo:Divider("Telemetry")
RadarInfo:Paragraph("Lumen v4.5 uses zero-dependency spring physics, velocity-tilted jiggly drag, full touch & mobile responsiveness, and Obsidian-grade customization.")

Hub:Settings(Main)
Hub:Notify({
	Title = "Lumen v4.5 Ready",
	Text = "Press RightShift or tap the top pill on mobile to toggle.",
	Type = "Success",
	Time = 4,
})
