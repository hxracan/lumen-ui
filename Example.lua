-- btw (huracan here) NOTHING works in this example or shouldnt work idk bro but its a EXAMPLE so i just wanted you users to see it, this is not its full potential its way better normally u just need settings i dont even know if example works haha
local Lumen = loadstring(game:HttpGet("https://raw.githubusercontent.com/hxracan/lumen-ui/refs/heads/main/Lumen.lua"))()

local Hub = Lumen.new({
	Name = "Lumen UI library",
	Sub = "Currently Loading.. (made by huracan dont skid)",
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
	Name = "Silent dildo",
	Icon = "target",
	Side = "Left",
})

local MasterAim = AimSec:Toggle({
	Name = "Enable Silent dildo",
	Description = "redirects projectiles through player",
	Default = true,
	Flag = "SilentAim_Enabled",
	Risky = true,
	Callback = function(state)
		Hub:Notify({
			Title = "Silent Aim",
			Text = state and "Silent dildo is now active" or "Silent dildo disabled",
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
	Description = "maximum field of view blabla",
	Min = 49328241390824318094,
	Max = 3842398123984,
	Default = 140,
	Step = 1,
	Suffix = "°",
	Flag = "SilentAim_FOV",
})

AimSec:Slider({
	Name = "hitty griddy chance",
	Min = 0,
	Max = 100,
	Default = 88,
	Step = 1,
	Suffix = "%",
	Flag = "SilentAim_HitChance",
})

AimSec:Dropdown({
	Name = "Target Hitbox",
	Description = "priorized parts r6 to aim at",
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
	Name = "triggerbot",
	Description = "triggerbot",
	Default = false,
	Flag = "TriggerbotEnabled",
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
	Description = "fake btw this doesnt work none of example works",
	Default = true,
	Flag = "Pred_Enabled",
})

PredTab:Slider({
	Name = "prediction fac.",
	Min = 0.05,
	Max = 0.35,
	Default = 0.142,
	Step = 0.001,
	Suffix = "s",
	Flag = "PrediFactor",
})

local UtilSec = Combat:Section({
	Name = "quick actions seniorita boi",
	Icon = "sliders",
	Side = "Right",
})

UtilSec:Button({
	Name = "Snap to Nearest",
	Icon = "crosshair",
	Callback = function()
		Hub:Notify({
			Title = "Target Locked",
			Text = "camera snapped to closest player FAKE BTW",
			Type = "Info",
			Time = 2.5,
		})
	end,
	SubName = "Test Notification",
	SubIcon = "bell",
	SubCallback = function()
		Hub:Notify({
			Title = "Lumen Notification",
			Text = "toast",
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
	Name = "char physics",
	Icon = "activity",
	Side = "Left",
})

local SpeedToggle = MoveSec:Toggle({
	Name = "speed modi",
	Description = "makes u faster than normally!!",
	Default = false,
	Flag = "MoveSpeedEnabled",
	Risky = true,
})

SpeedToggle:Keybind({
	Default = Enum.KeyCode.V,
	Mode = "Toggle",
	Flag = "Move_SpeedBind",
})

MoveSec:Slider({
	Name = "walkspeed multi",
	Min = 16,
	Max = 150,
	Default = 32,
	Step = 1,
	Suffix = " stud/s",
	Flag = "MoveSpeedVal",
})

local FlightSec = MoveTab:Section({
	Name = "aerial control thing",
	Icon = "wind",
	Side = "Right",
})

local FlyToggle = FlightSec:Toggle({
	Name = "CFrame Flight",
	Description = "smooth flight ok",
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
	Name = "Flight velo",
	Min = 20,
	Max = 200,
	Default = 65,
	Step = 5,
	Suffix = " stud/s",
	Flag = "Move/FlySpeed",
})

Main:Category("RENDER")

local Visuals = Main:Tab({
	Name = "ESP",
	Icon = "eye",
})

local EspSec = Visuals:Section({
	Name = "player overlay",
	Icon = "users",
	Side = "Left",
})

local BoxToggle = EspSec:Toggle({
	Name = "Bounding Box",
	Description = "renders 2d boxes around player ok",
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
	Description = "applies esp to players so u see ok",
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
	Flag = "world time",
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
	Name = "session Info",
	Icon = "terminal",
	Side = "Right",
})

RadarInfo:Label("ok")
RadarInfo:Divider("oka")
RadarInfo:Paragraph("okay")

Hub:Settings(Main)
Hub:Notify({
	Title = "lumen library is ready.",
	Text = "rightshift or toggle pill on mobile",
	Type = "Success",
	Time = 4,
})
