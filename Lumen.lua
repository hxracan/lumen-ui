local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local SoundService = game:GetService("SoundService")

local env = getgenv and getgenv() or _G
if env.Lumen then
	pcall(env.Lumen.Unload, env.Lumen)
end

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local Lumen = {
	Flags = {},
	Options = {},
	Toggles = {},
	Labels = {},
	Buttons = {},
	Tabs = {},
	DependencyBoxes = {},
	Binds = {},
	ThemeControls = {},
	Windows = {},
	UnloadSignals = {},
	Registry = {},
	IsMobile = isMobile,
	Toggled = true,
	Unloaded = false,
	GlobalSearch = false,
	NotifyOnError = false,
	ShowCustomCursor = false,
	ForceCheckbox = false,
	CornerRadius = 12,
	DPIScale = 1,
	NotifySide = "Right",
	ToggleKeybind = Enum.KeyCode.RightShift,
	IgnoreFlags = {
		UIThemePreset = true,
		UICustomThemeList = true,
		UICustomThemeName = true,
		UIThemeJSON = true,
		UIConfigList = true,
		UIConfigName = true,
		UIConfigJSON = true,
	},
	IgnoreThemeInConfig = true,
	Folder = "Lumen",
	Version = "4.5",
	Config = {
		Transparency = 0.16,
		Scale = 1,
		CornerRadius = 12,
		CompactSidebar = false,
		SidebarWidth = 216,
		TopAccentLine = true,
		ToggleStyle = "Switch",
		CustomCursor = false,
		MobileButton = isMobile,
		Snapping = true,
		SnapDistance = 24,
		BackgroundImage = "",
		BackgroundImageAlpha = 0.82,
		BackgroundScale = "Crop",
		Blur = true,
		BlurSize = 14,
		UnlockMouse = false,
		WindowAnimStyle = "Scale & Slide",
		WindowAnimSpeed = 0.38,
		TabAnimStyle = "Slide Bottom",
		TabAnimSpeed = 0.28,
		TabSwipeOffset = 18,
		Animations = {
			["Window Toggle"] = true,
			["Tab Switch"] = true,
			["Section Collapse"] = true,
			["Dropdown Menu"] = true,
			["Popups"] = true,
			["Button Ripple"] = true,
			["Hover Effects"] = true,
		},
		KeybindFilter = "Bound Only",
		KeybindInteractive = true,
		ToastPosition = "BottomRight",
		ToastDuration = 4,
		Sounds = true,
	},
}
env.Lumen = Lumen

local function rgb(r, g, b)
	return Color3.fromRGB(r, g, b)
end

local function hex(str)
	local ok, c = pcall(Color3.fromHex, str)
	return ok and c or Color3.new(1, 1, 1)
end

local function makePalette(back, side, panel, raised, hover, stroke, textCol, muted, accent, success, warning, danger)
	return {
		Back = back,
		Side = side,
		Panel = panel,
		Raised = raised,
		Hover = hover,
		Stroke = stroke,
		Text = textCol,
		Muted = muted,
		Accent = accent,
		Success = success or rgb(52, 211, 153),
		Warning = warning or rgb(251, 191, 36),
		Danger = danger or rgb(248, 81, 99),
	}
end

local function fromObsidian(bgHex, mainHex, accentHex, outlineHex, fontHex)
	local back = hex(bgHex)
	local panel = hex(mainHex)
	local side = back:Lerp(panel, 0.45)
	local raised = panel:Lerp(Color3.new(1, 1, 1), 0.05)
	local hover = panel:Lerp(Color3.new(1, 1, 1), 0.1)
	local stroke = hex(outlineHex)
	local textCol = hex(fontHex)
	local muted = textCol:Lerp(back, 0.46)
	return makePalette(back, side, panel, raised, hover, stroke, textCol, muted, hex(accentHex))
end

local Themes = {
	Midnight = makePalette(
		rgb(11, 11, 15), rgb(14, 14, 19), rgb(18, 18, 24), rgb(26, 26, 35),
		rgb(35, 35, 46), rgb(39, 39, 52), rgb(240, 240, 247), rgb(130, 130, 148),
		rgb(124, 92, 255)
	),
	Neverlose = makePalette(
		rgb(7, 10, 20), rgb(9, 14, 27), rgb(12, 18, 34), rgb(19, 27, 49),
		rgb(27, 37, 65), rgb(29, 41, 72), rgb(235, 241, 255), rgb(115, 132, 174),
		rgb(41, 148, 255)
	),
	Obsidian = makePalette(
		rgb(12, 12, 14), rgb(16, 16, 18), rgb(21, 21, 24), rgb(29, 29, 33),
		rgb(38, 38, 44), rgb(44, 44, 51), rgb(244, 244, 246), rgb(134, 134, 144),
		rgb(125, 85, 255)
	),
	Default = fromObsidian("0f0f0f", "191919", "7d55ff", "282828", "ffffff"),
	BBot = fromObsidian("141414", "1e1e1e", "7e48a3", "2b2b2b", "ffffff"),
	Fatality = fromObsidian("15102c", "1e1842", "c50754", "3c355d", "ffffff"),
	Jester = fromObsidian("161616", "222222", "db4467", "373737", "ffffff"),
	Mint = fromObsidian("151817", "202423", "3db488", "343b39", "ffffff"),
	["Tokyo Night"] = makePalette(
		rgb(15, 16, 26), rgb(20, 22, 35), rgb(26, 27, 44), rgb(36, 40, 62),
		rgb(46, 52, 80), rgb(52, 59, 90), rgb(192, 202, 245), rgb(115, 125, 168),
		rgb(122, 162, 247), rgb(158, 206, 106), rgb(224, 175, 104), rgb(247, 118, 142)
	),
	Ubuntu = fromObsidian("262626", "333333", "e2581e", "474747", "ffffff"),
	Quartz = fromObsidian("17161f", "232330", "426e87", "332e3d", "ffffff"),
	Nord = fromObsidian("242933", "2e3440", "88c0d0", "4c566a", "eceff4"),
	Dracula = fromObsidian("1e1f29", "282a36", "ff79c6", "44475a", "f8f8f2"),
	Monokai = fromObsidian("191a17", "272822", "f92672", "49483e", "f8f8f2"),
	Gruvbox = fromObsidian("1d2021", "282828", "fb4934", "504945", "ebdbb2"),
	Solarized = fromObsidian("00212b", "073642", "cb4b16", "284b54", "93a1a1"),
	Catppuccin = makePalette(
		rgb(17, 17, 27), rgb(24, 24, 37), rgb(30, 30, 46), rgb(49, 50, 68),
		rgb(69, 71, 90), rgb(69, 71, 90), rgb(205, 214, 244), rgb(147, 153, 178),
		rgb(203, 166, 247), rgb(166, 227, 161), rgb(249, 226, 175), rgb(243, 139, 168)
	),
	["One Dark"] = fromObsidian("1b1f23", "282c34", "c678dd", "3e4451", "abb2bf"),
	Cyberpunk = fromObsidian("121224", "1f1c30", "00ff9f", "413c5e", "f9f9f9"),
	["Oceanic Next"] = fromObsidian("121d24", "1b2b34", "6699cc", "343d46", "d8dee9"),
	Material = fromObsidian("121212", "1e1e1e", "82aaff", "373737", "eeffff"),
	Rose = makePalette(
		rgb(13, 10, 12), rgb(17, 13, 16), rgb(22, 17, 21), rgb(31, 24, 30),
		rgb(42, 32, 40), rgb(49, 38, 46), rgb(246, 238, 242), rgb(144, 124, 134),
		rgb(255, 92, 145)
	),
	Emerald = makePalette(
		rgb(8, 12, 11), rgb(11, 16, 14), rgb(15, 21, 19), rgb(22, 31, 28),
		rgb(30, 42, 38), rgb(35, 49, 44), rgb(236, 247, 243), rgb(116, 142, 133),
		rgb(52, 211, 153)
	),
	Crimson = makePalette(
		rgb(13, 9, 10), rgb(18, 12, 14), rgb(24, 16, 18), rgb(34, 22, 25),
		rgb(45, 30, 34), rgb(54, 35, 40), rgb(248, 238, 240), rgb(148, 122, 128),
		rgb(244, 63, 94)
	),
}

local Fonts = {
	Inter = "rbxassetid://12187365364",
	Gotham = "rbxasset://fonts/families/GothamSSm.json",
	BuilderSans = "rbxasset://fonts/families/BuilderSans.json",
	Code = "rbxasset://fonts/families/Inconsolata.json",
	Ubuntu = "rbxasset://fonts/families/Ubuntu.json",
	Roboto = "rbxasset://fonts/families/Roboto.json",
	RobotoMono = "rbxasset://fonts/families/RobotoMono.json",
	Jura = "rbxasset://fonts/families/Jura.json",
	SourceSans = "rbxasset://fonts/families/SourceSansPro.json",
}

local T = {}
for k, v in Themes.Midnight do
	T[k] = v
end
Lumen.Theme = T
Lumen.Themes = Themes
Lumen.Fonts = Fonts

local FONT = Font.new(Fonts.Inter, Enum.FontWeight.Medium)
local FONT_B = Font.new(Fonts.Inter, Enum.FontWeight.SemiBold)
local FONT_X = Font.new(Fonts.Inter, Enum.FontWeight.Bold)

local PILL = UDim.new(1, 0)
local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)

Lumen.Scheme = {
	BackgroundColor = T.Back,
	MainColor = T.Panel,
	AccentColor = T.Accent,
	OutlineColor = T.Stroke,
	FontColor = T.Text,
	Font = FONT,
	RedColor = T.Danger,
	DestructiveColor = T.Danger,
	DarkColor = BLACK,
	WhiteColor = WHITE,
	BackgroundImage = "",
}

local connections = {}
Lumen.Signals = connections
local bindings = {}
local hooks = {}
local fontLabels = {}
local surfaceFrames = {}
local cornerNodes = {}
local toggleNodes = {}

local function link(signal, fn)
	local c = signal:Connect(fn)
	table.insert(connections, c)
	return c
end

local function animEnabled(category)
	if not category then
		return true
	end
	return Lumen.Config.Animations[category] ~= false
end

local function tween(obj, props, time, style, dir, category)
	if category and not animEnabled(category) then
		for k, v in props do
			obj[k] = v
		end
		return
	end
	TS:Create(obj, TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
end

local function apply(obj, props, animate, time, category)
	if animate and animEnabled(category) then
		tween(obj, props, time)
	else
		for k, v in props do
			obj[k] = v
		end
	end
end

local function bindTheme(obj, map)
	for prop, key in map do
		obj[prop] = T[key]
		table.insert(bindings, {obj, prop, key})
	end
end

local function onTheme(fn)
	fn(false)
	table.insert(hooks, fn)
end

local function linearize(c)
	return c <= 0.03928 and (c / 12.92) or (((c + 0.055) / 1.055) ^ 2.4)
end

local function luminance(col)
	return 0.2126 * linearize(col.R) + 0.7152 * linearize(col.G) + 0.0722 * linearize(col.B)
end

function Lumen:GetContrastReport()
	local lText = luminance(T.Text)
	local lBack = luminance(T.Back)
	local lPanel = luminance(T.Panel)
	local r1 = (math.max(lText, lBack) + 0.05) / (math.min(lText, lBack) + 0.05)
	local r2 = (math.max(lText, lPanel) + 0.05) / (math.min(lText, lPanel) + 0.05)
	local ratio = math.min(r1, r2)
	local pair = r1 < r2 and "Text vs Background" or "Text vs Section"
	local grade = ratio >= 7 and "AAA" or (ratio >= 4.5 and "AA" or "Low")
	return {
		Ratio = ratio,
		Pair = pair,
		Grade = grade,
		Passes = ratio >= 4.5,
	}
end

local function refreshTheme(syncControls)
	if Lumen.Scheme then
		Lumen.Scheme.BackgroundColor = T.Back
		Lumen.Scheme.MainColor = T.Panel
		Lumen.Scheme.AccentColor = T.Accent
		Lumen.Scheme.OutlineColor = T.Stroke
		Lumen.Scheme.FontColor = T.Text
		Lumen.Scheme.RedColor = T.Danger
		Lumen.Scheme.DestructiveColor = T.Danger
	end
	local alive = {}
	for _, b in bindings do
		if b[1].Parent then
			tween(b[1], {[b[2]] = T[b[3]]}, 0.26)
			table.insert(alive, b)
		end
	end
	bindings = alive
	for inst, props in Lumen.Registry do
		if inst and inst.Parent then
			for prop, schemeKey in props do
				local val = type(schemeKey) == "function" and schemeKey() or (Lumen.Scheme[schemeKey] or T[schemeKey])
				if val ~= nil then
					pcall(function()
						inst[prop] = val
					end)
				end
			end
		else
			Lumen.Registry[inst] = nil
		end
	end
	for _, fn in hooks do
		fn(true)
	end
	if syncControls then
		for key, ctrl in Lumen.ThemeControls do
			if T[key] then
				ctrl:Set(T[key], true)
			end
		end
	end
	if Lumen._updateContrast then
		Lumen._updateContrast()
	end
end

function Lumen:SetThemeColor(key, color)
	if not T[key] then
		return
	end
	T[key] = color
	refreshTheme(false)
end

function Lumen:SetTheme(theme)
	local source = type(theme) == "string" and Themes[theme] or theme
	if type(source) ~= "table" then
		return
	end
	for k, v in source do
		T[k] = v
	end
	refreshTheme(true)
end

function Lumen:SetAccent(color)
	T.Accent = color
	refreshTheme(true)
end

function Lumen:SetFont(name)
	local family
	if typeof(name) == "Font" then
		family = name.Family
	elseif typeof(name) == "EnumItem" then
		family = Fonts[name.Name] or ("rbxasset://fonts/families/" .. name.Name .. ".json")
	elseif type(name) == "string" then
		family = Fonts[name] or name
	end
	if type(family) ~= "string" then
		return
	end
	Lumen.Config.FontFamily = tostring(name)
	local ok, f1 = pcall(Font.new, family, Enum.FontWeight.Medium)
	if not ok then
		return
	end
	FONT = f1
	FONT_B = Font.new(family, Enum.FontWeight.SemiBold)
	FONT_X = Font.new(family, Enum.FontWeight.Bold)
	if Lumen.Scheme then
		Lumen.Scheme.Font = FONT
	end
	local alive = {}
	for _, entry in fontLabels do
		local obj, weight = entry[1], entry[2]
		if obj.Parent then
			obj.FontFace = weight == "X" and FONT_X or (weight == "B" and FONT_B or FONT)
			table.insert(alive, entry)
		end
	end
	fontLabels = alive
end

local function calcSurfaceAlpha(alpha, factor, offset)
	return math.clamp(alpha * (factor or 1) + (offset or 0), 0, 0.88)
end

function Lumen:SetTransparency(alpha)
	alpha = math.clamp(tonumber(alpha) or 0, 0, 0.78)
	self.Config.Transparency = alpha
	local alive = {}
	for _, entry in surfaceFrames do
		local frame, factor, offset = entry[1], entry[2], entry[3]
		if frame.Parent then
			tween(frame, {BackgroundTransparency = calcSurfaceAlpha(alpha, factor, offset)}, 0.2)
			table.insert(alive, entry)
		end
	end
	surfaceFrames = alive
end

function Lumen:SetCornerRadius(radius)
	radius = math.clamp(tonumber(radius) or 12, 0, 22)
	self.Config.CornerRadius = radius
	local alive = {}
	for _, entry in cornerNodes do
		local c, scale, maxR = entry[1], entry[2], entry[3]
		if c.Parent then
			local px = math.clamp(math.floor(radius * scale + 0.5), 0, maxR or 30)
			c.CornerRadius = UDim.new(0, px)
			table.insert(alive, entry)
		end
	end
	cornerNodes = alive
end

function Lumen:SetToggleStyle(style)
	self.Config.ToggleStyle = style
	local alive = {}
	for _, fn in toggleNodes do
		if fn() ~= false then
			table.insert(alive, fn)
		end
	end
	toggleNodes = alive
end

local function registerSurface(frame, factor, offset)
	factor = factor or 1
	offset = offset or 0
	frame.BackgroundTransparency = calcSurfaceAlpha(Lumen.Config.Transparency or 0.16, factor, offset)
	table.insert(surfaceFrames, {frame, factor, offset})
	return frame
end

local function registerFont(obj, weight)
	table.insert(fontLabels, {obj, weight or "M"})
	return obj
end

local function create(class, props, children)
	local inst = Instance.new(class)
	local theme = props.Theme
	local parent = props.Parent
	for k, v in props do
		if k ~= "Parent" and k ~= "Theme" then
			inst[k] = v
		end
	end
	if theme then
		bindTheme(inst, theme)
	end
	if children then
		for _, c in children do
			c.Parent = inst
		end
	end
	inst.Parent = parent
	return inst
end

local function corner(r, dynamicScale, maxR)
	if typeof(r) == "UDim" then
		return create("UICorner", {CornerRadius = r})
	end
	local base = r or 8
	local scale = dynamicScale or (base / 12)
	local cur = math.clamp(math.floor((Lumen.Config.CornerRadius or 12) * scale + 0.5), 0, maxR or 28)
	local c = create("UICorner", {CornerRadius = UDim.new(0, cur)})
	table.insert(cornerNodes, {c, scale, maxR or 28})
	return c
end

local function stroke(key, thick, trans)
	local isKey = type(key) == "string"
	return create("UIStroke", {
		Thickness = thick or 1,
		Transparency = trans or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = not isKey and (key or T.Stroke) or nil,
		Theme = isKey and {Color = key} or nil,
	})
end

local function pad(t, r, b, l)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, t or 0),
		PaddingRight = UDim.new(0, r or t or 0),
		PaddingBottom = UDim.new(0, b or t or 0),
		PaddingLeft = UDim.new(0, l or r or t or 0),
	})
end

local function list(gap, extra)
	local props = {Padding = UDim.new(0, gap or 6), SortOrder = Enum.SortOrder.LayoutOrder}
	if extra then
		for k, v in extra do
			props[k] = v
		end
	end
	return create("UIListLayout", props)
end

local function text(props)
	local weight = "M"
	if props.FontFace == FONT_X then
		weight = "X"
	elseif props.FontFace == FONT_B then
		weight = "B"
	end
	local defaults = {
		BackgroundTransparency = 1,
		FontFace = FONT,
		Text = "",
		RichText = true,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}
	if not props.TextColor3 and not (props.Theme and props.Theme.TextColor3) then
		props.Theme = props.Theme or {}
		props.Theme.TextColor3 = "Text"
	end
	for k, v in defaults do
		if props[k] == nil then
			props[k] = v
		end
	end
	return registerFont(create("TextLabel", props), weight)
end

local function hit(parent)
	return create("TextButton", {
		Parent = parent,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	})
end

local function center(obj)
	if not obj then
		return nil
	end
	obj.AnchorPoint = Vector2.new(0.5, 0.5)
	obj.Position = UDim2.fromScale(0.5, 0.5)
	return obj
end

local function rim(parent)
	local s = stroke("Stroke", 1, 0.08)
	s.Parent = parent
	return s
end

local function accentGradient(grad)
	onTheme(function()
		grad.Color = ColorSequence.new(T.Accent:Lerp(WHITE, 0.18), T.Accent:Lerp(BLACK, 0.18))
	end)
end

local Core = {
	["activity"] = "rbxassetid://94212016861936",
	["airplay"] = "rbxassetid://115020759309179",
	["alert-triangle"] = "rbxassetid://125920361880643",
	["apple"] = "rbxassetid://104349242902442",
	["arrow-right-left"] = "rbxassetid://77015754304300",
	["audio-lines"] = "rbxassetid://70930641819242",
	["badge"] = "rbxassetid://116620312917084",
	["bell"] = "rbxassetid://97392696311902",
	["bell-off"] = "rbxassetid://78560046118930",
	["bell-ring"] = "rbxassetid://94612128913941",
	["bolt"] = "rbxassetid://102881251417484",
	["boxes"] = "rbxassetid://136372617578355",
	["camera"] = "rbxassetid://79950339943067",
	["check"] = "rbxassetid://93898873302694",
	["check-circle"] = "rbxassetid://85262178816537",
	["chevron-down"] = "rbxassetid://134243273101015",
	["chevron-left"] = "rbxassetid://73780377692148",
	["chevron-right"] = "rbxassetid://92473583511724",
	["chevron-up"] = "rbxassetid://122444883127455",
	["circle-check"] = "rbxassetid://85262178816537",
	["circle-dot"] = "rbxassetid://82947033619201",
	["circle-question-mark"] = "rbxassetid://97516698664325",
	["circle-slash"] = "rbxassetid://125206439913049",
	["circle-user-round"] = "rbxassetid://95489465399880",
	["circle-x"] = "rbxassetid://76821953846248",
	["clipboard-copy"] = "rbxassetid://125851897718493",
	["clock"] = "rbxassetid://121808839832144",
	["cloudy"] = "rbxassetid://105360479023346",
	["code"] = "rbxassetid://107380207681249",
	["columns-2"] = "rbxassetid://113004100221850",
	["compass"] = "rbxassetid://115123411028382",
	["copy"] = "rbxassetid://78979572434545",
	["cpu"] = "rbxassetid://77549309870247",
	["crosshair"] = "rbxassetid://134242818164054",
	["dock"] = "rbxassetid://121997427160252",
	["dollar-sign"] = "rbxassetid://127320961224019",
	["download"] = "rbxassetid://134814648082393",
	["drama"] = "rbxassetid://110297795801577",
	["eye"] = "rbxassetid://100033680381365",
	["eye-off"] = "rbxassetid://135928786788378",
	["files"] = "rbxassetid://102806336233202",
	["flame"] = "rbxassetid://98218034436456",
	["flask-conical"] = "rbxassetid://128406680901165",
	["folder"] = "rbxassetid://80846616596607",
	["funnel"] = "rbxassetid://108829540827529",
	["gamepad-2"] = "rbxassetid://92483947987410",
	["gauge"] = "rbxassetid://110273524101447",
	["globe"] = "rbxassetid://114238209622913",
	["grip-vertical"] = "rbxassetid://137183678565296",
	["hand"] = "rbxassetid://130703864968637",
	["hand-grab"] = "rbxassetid://88867162163985",
	["heart"] = "rbxassetid://116559368303288",
	["home"] = "rbxassetid://98755624629571",
	["house"] = "rbxassetid://98755624629571",
	["image"] = "rbxassetid://112751259236831",
	["info"] = "rbxassetid://124560466474914",
	["keyboard"] = "rbxassetid://121474456068237",
	["layers"] = "rbxassetid://81973586053257",
	["layout-grid"] = "rbxassetid://81344910161871",
	["link"] = "rbxassetid://131607023382430",
	["list"] = "rbxassetid://113179976918783",
	["lock"] = "rbxassetid://134724289526879",
	["lock-open"] = "rbxassetid://93597915325122",
	["magnet"] = "rbxassetid://135162361226972",
	["map-pin"] = "rbxassetid://84279202219901",
	["maximize"] = "rbxassetid://76045941763188",
	["minimize"] = "rbxassetid://121304296213645",
	["minus"] = "rbxassetid://118026365011536",
	["monitor"] = "rbxassetid://72664649203050",
	["moon"] = "rbxassetid://83380517901735",
	["mouse-pointer-click"] = "rbxassetid://107150227368485",
	["move"] = "rbxassetid://116138709011735",
	["move-3d"] = "rbxassetid://103365982054003",
	["move-diagonal"] = "rbxassetid://101433481954184",
	["orbit"] = "rbxassetid://108926136860562",
	["package"] = "rbxassetid://97261141732706",
	["package-plus"] = "rbxassetid://129261988138366",
	["palette"] = "rbxassetid://86350350950064",
	["panel-left"] = "rbxassetid://97419752870313",
	["panels-top-left"] = "rbxassetid://79858853850600",
	["pause"] = "rbxassetid://74873705394436",
	["person-standing"] = "rbxassetid://125020872044147",
	["play"] = "rbxassetid://135609604299893",
	["plus"] = "rbxassetid://111774323017047",
	["power"] = "rbxassetid://96479131758775",
	["radar"] = "rbxassetid://138528222906635",
	["radio"] = "rbxassetid://85611589536956",
	["radio-tower"] = "rbxassetid://93958663130054",
	["refresh-cw"] = "rbxassetid://138133190015277",
	["rotate-ccw"] = "rbxassetid://110116685948665",
	["save"] = "rbxassetid://126116963775616",
	["scan"] = "rbxassetid://123104789658180",
	["scan-line"] = "rbxassetid://126544908146540",
	["scroll"] = "rbxassetid://74072101474951",
	["scroll-text"] = "rbxassetid://97321022666868",
	["search"] = "rbxassetid://121018724060431",
	["settings"] = "rbxassetid://80758916183665",
	["settings-2"] = "rbxassetid://135684703553372",
	["shapes"] = "rbxassetid://129989433311409",
	["shield"] = "rbxassetid://110987169760162",
	["shield-check"] = "rbxassetid://87354736164608",
	["shield-off"] = "rbxassetid://133426959132690",
	["shield-user"] = "rbxassetid://124832775645347",
	["skull"] = "rbxassetid://137726256442333",
	["sliders"] = "rbxassetid://85538382643347",
	["sliders-horizontal"] = "rbxassetid://85538382643347",
	["sliders-vertical"] = "rbxassetid://101190569086853",
	["smartphone"] = "rbxassetid://96623008834511",
	["snowflake"] = "rbxassetid://101235206534566",
	["sparkles"] = "rbxassetid://138635884129147",
	["spline"] = "rbxassetid://129406685807412",
	["star"] = "rbxassetid://136141469398409",
	["sun"] = "rbxassetid://110150589884127",
	["swords"] = "rbxassetid://81872698913435",
	["table"] = "rbxassetid://109109148250737",
	["target"] = "rbxassetid://87563802520297",
	["terminal"] = "rbxassetid://106783148545356",
	["timer-reset"] = "rbxassetid://110052125369932",
	["train-front"] = "rbxassetid://125237934215370",
	["trash"] = "rbxassetid://106723740584310",
	["trash-2"] = "rbxassetid://109843431391323",
	["triangle-alert"] = "rbxassetid://125920361880643",
	["undo-2"] = "rbxassetid://113885292059932",
	["unlock"] = "rbxassetid://93597915325122",
	["upload"] = "rbxassetid://138212042425501",
	["user"] = "rbxassetid://81589895647169",
	["user-round"] = "rbxassetid://136485052187963",
	["users"] = "rbxassetid://115398113982385",
	["users-round"] = "rbxassetid://103005444008339",
	["venetian-mask"] = "rbxassetid://102636443033920",
	["volume-2"] = "rbxassetid://89344380902620",
	["wand-sparkles"] = "rbxassetid://82546429942392",
	["wind"] = "rbxassetid://114551690399915",
	["wrench"] = "rbxassetid://112148279212860",
	["x"] = "rbxassetid://110786993356448",
	["x-circle"] = "rbxassetid://76821953846248",
	["zap"] = "rbxassetid://130551565616516",
}

local RemoteIcons = {}
local pendingIcons = {}
task.spawn(function()
	local ok, raw = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
	if ok and type(raw) == "string" then
		local fn = loadstring(raw)
		if fn then
			local fine, tbl = pcall(fn)
			if fine and type(tbl) == "table" then
				RemoteIcons = tbl.icons or tbl
				for _, item in pendingIcons do
					if item.Img and item.Img.Parent then
						local found = RemoteIcons[item.Key] or RemoteIcons[item.Name]
						if type(found) == "string" then
							item.Img.Image = found
						end
					end
				end
				table.clear(pendingIcons)
			end
		end
	end
end)

local function resolveIcon(name)
	if not name or name == "" then
		return nil
	end
	if type(name) == "number" then
		return "rbxassetid://" .. name
	end
	if type(name) ~= "string" then
		return Core.layers
	end
	if name:find("://") then
		return name
	end
	local k = name:lower()
	local found = Core[k] or RemoteIcons[k] or RemoteIcons[name]
	if type(found) == "string" then
		return found
	end
	return Core["layout-grid"], k
end

local function icon(parent, name, size, colorKey)
	if not name or name == "" then
		return nil
	end
	local id, unresolvedKey = resolveIcon(name)
	if not id then
		return nil
	end
	local s = size or 16
	local isKey = type(colorKey) == "string"
	local img = create("ImageLabel", {
		Parent = parent,
		Size = UDim2.fromOffset(s, s),
		BackgroundTransparency = 1,
		Image = id,
		ScaleType = Enum.ScaleType.Fit,
		ImageColor3 = not isKey and (colorKey or T.Text) or nil,
		Theme = isKey and {ImageColor3 = colorKey} or nil,
	})
	if unresolvedKey then
		table.insert(pendingIcons, {Img = img, Key = unresolvedKey, Name = name})
	end
	return img
end

local function play(id, volume)
	if not id or id == "" or not Lumen.Config.Sounds then
		return
	end
	if type(id) == "number" then
		id = "rbxassetid://" .. id
	end
	local s = create("Sound", {
		Parent = SoundService,
		SoundId = id,
		Volume = volume or 0.45,
	})
	s:Play()
	s.Ended:Once(function()
		s:Destroy()
	end)
end

local parentGui = (gethui and gethui()) or (pcall(function()
	return CoreGui.Name
end) and CoreGui) or Players.LocalPlayer:WaitForChild("PlayerGui")

local Gui = create("ScreenGui", {
	Name = "Lumen",
	Parent = parentGui,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})
Lumen.ScreenGui = Gui

local Layers = {}
for i, name in {"Windows", "Snap", "Dock", "Panels", "Popups", "Toasts", "Hud", "Tip", "Splash"} do
	Layers[name] = create("Frame", {
		Name = name,
		Parent = Gui,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = i * 100,
	})
end

local lastTouchPos = nil

local function mouse(input)
	if input and input.UserInputType == Enum.UserInputType.Touch then
		local inset = GuiService:GetGuiInset()
		lastTouchPos = Vector2.new(input.Position.X + inset.X, input.Position.Y + inset.Y)
		return lastTouchPos
	end
	local loc = UIS:GetMouseLocation()
	if loc.X == 0 and loc.Y == 0 and lastTouchPos then
		return lastTouchPos
	end
	return loc
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function inside(frame, pos)
	if not frame or not frame.Visible then
		return false
	end
	local p, s = frame.AbsolutePosition, frame.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local snapV = create("Frame", {
	Parent = Layers.Snap,
	AnchorPoint = Vector2.new(0.5, 0),
	Size = UDim2.new(0, 1, 1, 0),
	BorderSizePixel = 0,
	BackgroundTransparency = 0.35,
	Visible = false,
	Theme = {BackgroundColor3 = "Accent"},
})
local snapH = create("Frame", {
	Parent = Layers.Snap,
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.new(1, 0, 0, 1),
	BorderSizePixel = 0,
	BackgroundTransparency = 0.35,
	Visible = false,
	Theme = {BackgroundColor3 = "Accent"},
})

local cursorFrame = create("Frame", {
	Parent = Layers.Tip,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.fromOffset(16, 16),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 950,
})
create("Frame", {
	Parent = cursorFrame,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(4, 4),
	BorderSizePixel = 0,
	Theme = {BackgroundColor3 = "Accent"},
}, {corner(PILL), stroke("Back", 1)})
create("Frame", {
	Parent = cursorFrame,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(14, 14),
	BackgroundTransparency = 1,
}, {corner(PILL), stroke("Accent", 1, 0.35)})

local popup

local function closePopup()
	if not popup then
		return
	end
	local p = popup
	popup = nil
	if p.Close then
		p.Close()
	end
end

local function openPopup(frames, closeFn, owner)
	closePopup()
	popup = {Frames = frames, Close = closeFn, Owner = owner}
end

local function popupOpenFor(owner)
	return popup ~= nil and popup.Owner == owner
end

link(UIS.InputBegan, function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		mouse(input)
	end
	if not popup then
		return
	end
	local t = input.UserInputType
	if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 or t == Enum.UserInputType.Touch then
		local pos = mouse(input)
		for _, f in popup.Frames do
			if inside(f, pos) then
				return
			end
		end
		closePopup()
	end
end)

local function drag(handle, target, onEnd, snapEnabled)
	local active, startMouse, startPos = false, nil, nil
	local moved = false

	handle.InputBegan:Connect(function(input)
		if isPress(input) then
			active = true
			moved = false
			startMouse = mouse(input)
			startPos = target.Position
			closePopup()
		end
	end)
	link(UIS.InputChanged, function(input)
		if active and isMove(input) then
			local cur = mouse(input)
			local d = cur - startMouse
			if d.Magnitude > 4 then
				moved = true
			end
			local view = Gui.AbsoluteSize
			local s = target.AbsoluteSize
			local a = target.AnchorPoint
			local x = startPos.X.Scale * view.X + startPos.X.Offset + d.X
			local y = startPos.Y.Scale * view.Y + startPos.Y.Offset + d.Y
			local showV, showH = false, false
			if snapEnabled and Lumen.Config.Snapping then
				local dist = Lumen.Config.SnapDistance or 24
				local cx, cy = view.X * 0.5, view.Y * 0.5
				local curCx = x + (0.5 - a.X) * s.X
				local curCy = y + (0.5 - a.Y) * s.Y
				if math.abs(curCx - cx) <= dist then
					x = cx - (0.5 - a.X) * s.X
					snapV.Position = UDim2.fromOffset(cx, 0)
					showV = true
				elseif math.abs((x - s.X * a.X) - 12) <= dist then
					x = 12 + s.X * a.X
					snapV.Position = UDim2.fromOffset(12, 0)
					showV = true
				elseif math.abs((x + s.X * (1 - a.X)) - (view.X - 12)) <= dist then
					x = view.X - 12 - s.X * (1 - a.X)
					snapV.Position = UDim2.fromOffset(view.X - 12, 0)
					showV = true
				end
				if math.abs(curCy - cy) <= dist then
					y = cy - (0.5 - a.Y) * s.Y
					snapH.Position = UDim2.fromOffset(0, cy)
					showH = true
				elseif math.abs((y - s.Y * a.Y) - 12) <= dist then
					y = 12 + s.Y * a.Y
					snapH.Position = UDim2.fromOffset(0, 12)
					showH = true
				end
			end
			snapV.Visible = showV
			snapH.Visible = showH
			x = math.clamp(x, s.X * a.X + 8 - s.X * 0.5, view.X - s.X * (1 - a.X) - 8 + s.X * 0.5)
			y = math.clamp(y, s.Y * a.Y + 8, view.Y - s.Y * (1 - a.Y) - 8)
			target.Position = UDim2.fromOffset(math.round(x), math.round(y))
		end
	end)
	link(UIS.InputEnded, function(input)
		if active and isPress(input) then
			active = false
			snapV.Visible = false
			snapH.Visible = false
			if onEnd then
				onEnd(moved)
			end
		end
	end)
	return function()
		return moved
	end
end

local tipFrame = create("CanvasGroup", {
	Parent = Layers.Tip,
	AutomaticSize = Enum.AutomaticSize.XY,
	GroupTransparency = 1,
	Visible = false,
	Theme = {BackgroundColor3 = "Raised"},
}, {corner(7), stroke("Stroke"), pad(5, 9)})
local tipScale = create("UIScale", {Parent = tipFrame, Scale = 0.92})
local tipLabel = text({
	Parent = tipFrame,
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.new(),
	TextSize = 12,
	TextTruncate = Enum.TextTruncate.None,
})
local tipOwner, tipToken = nil, 0

local function tooltip(target, content)
	target.MouseEnter:Connect(function()
		tipOwner = target
		tipToken += 1
		local id = tipToken
		local str = type(content) == "function" and content() or content
		if not str or str == "" then
			return
		end
		tipLabel.Text = str
		tipFrame.Visible = true
		tipScale.Scale = 0.92
		tween(tipFrame, {GroupTransparency = 0}, 0.14)
		tween(tipScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back)
		local _ = id
	end)
	target.MouseLeave:Connect(function()
		if tipOwner ~= target then
			return
		end
		tipOwner = nil
		tipToken += 1
		local id = tipToken
		tween(tipFrame, {GroupTransparency = 1}, 0.12)
		tween(tipScale, {Scale = 0.92}, 0.12)
		task.delay(0.14, function()
			if tipToken == id then
				tipFrame.Visible = false
			end
		end)
	end)
end

link(RS.RenderStepped, function()
	local m = mouse()
	if tipFrame.Visible then
		local view = Gui.AbsoluteSize
		local s = tipFrame.AbsoluteSize
		local x = math.clamp(m.X + 14, 8, view.X - s.X - 8)
		local y = math.clamp(m.Y + 18, 8, view.Y - s.Y - 8)
		tipFrame.Position = UDim2.fromOffset(x, y)
	end
	if Lumen.Config.CustomCursor and Lumen.Hub and Lumen.Hub.Visible then
		local over = false
		for _, w in Lumen.Hub.Windows do
			if w.Shown and inside(w.Root, m) then
				over = true
				break
			end
		end
		cursorFrame.Visible = over
		if over then
			cursorFrame.Position = UDim2.fromOffset(m.X, m.Y)
		end
	else
		cursorFrame.Visible = false
	end
end)

local function ripple(parent)
	if not animEnabled("Button Ripple") then
		return
	end
	local m = mouse()
	local p = parent.AbsolutePosition
	local d = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.2
	local circle = create("Frame", {
		Parent = parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(m.X - p.X, m.Y - p.Y),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.84,
		BorderSizePixel = 0,
	}, {corner(PILL)})
	tween(circle, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, 0.45, Enum.EasingStyle.Quad)
	task.delay(0.46, function()
		circle:Destroy()
	end)
end

local function placePopup(card, anchor, width, alignRight, gap)
	local view = Gui.AbsoluteSize
	local p, s = anchor.AbsolutePosition, anchor.AbsoluteSize
	local h = card.AbsoluteSize.Y
	local g = gap or 6
	local x = alignRight and (p.X + s.X - width) or p.X
	x = math.clamp(x, 8, view.X - width - 8)
	local y = p.Y + s.Y + g
	if y + h > view.Y - 12 and p.Y - g - h > 12 then
		y = p.Y - g - h
	end
	card.Position = UDim2.fromOffset(x, math.clamp(y, 8, view.Y - h - 8))
end

local function openMenu(anchor, opts)
	local width = math.max(opts.Width or anchor.AbsoluteSize.X, 152)
	local values = opts.Values or {}
	local searchable = opts.Search
	if searchable == nil then
		searchable = #values > 6
	end
	local card = create("CanvasGroup", {
		Parent = Layers.Popups,
		Size = UDim2.fromOffset(width, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(10), stroke("Stroke"), pad(5), list(2)})
	local scale = create("UIScale", {Parent = card, Scale = 0.95})

	local searchBox
	if searchable then
		local holder = create("Frame", {
			Parent = card,
			Size = UDim2.new(1, 0, 0, 28),
			LayoutOrder = 1,
			Theme = {BackgroundColor3 = "Panel"},
		}, {corner(7), stroke("Stroke")})
		local sIcon = icon(holder, "search", 13, "Muted")
		sIcon.AnchorPoint = Vector2.new(0, 0.5)
		sIcon.Position = UDim2.new(0, 9, 0.5, 0)
		searchBox = registerFont(create("TextBox", {
			Parent = holder,
			Position = UDim2.fromOffset(27, 0),
			Size = UDim2.new(1, -33, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			PlaceholderText = "Filter...",
			FontFace = FONT,
			TextSize = 12,
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			Theme = {TextColor3 = "Text", PlaceholderColor3 = "Muted"},
		}), "M")
	end

	local scroll = create("ScrollingFrame", {
		Parent = card,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
		Theme = {ScrollBarImageColor3 = "Stroke"},
	}, {list(2)})

	local rows = {}
	local function syncHeight()
		local visible = 0
		for _, r in rows do
			if r.Button.Visible then
				visible += 1
			end
		end
		scroll.Size = UDim2.new(1, 0, 0, math.min(visible * 30 - math.max(0, visible - 1) * 2, 196))
	end

	local function refreshRows(animate)
		for _, r in rows do
			local disabled = opts.DisabledValues and (opts.DisabledValues[r.Value] == true or table.find(opts.DisabledValues, r.Value) ~= nil)
			local on = not disabled and opts.Selected(r.Value)
			apply(r.Label, {
				Position = UDim2.fromOffset(on and 28 or 10, 0),
				TextColor3 = disabled and T.Stroke or (on and T.Text or T.Muted),
			}, animate, 0.16, "Dropdown Menu")
			apply(r.Check, {ImageTransparency = on and 0 or 1}, animate, 0.16, "Dropdown Menu")
			apply(r.Button, {BackgroundTransparency = on and 0.88 or (r.Hover and not disabled and 0.45 or 1)}, animate, 0.16, "Dropdown Menu")
			r.Button.BackgroundColor3 = on and T.Accent or T.Hover
		end
	end

	for idx, v in values do
		local display = opts.Format and opts.Format(v) or tostring(v)
		local btn = create("TextButton", {
			Parent = scroll,
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = idx,
		}, {corner(7)})
		local chk = icon(btn, "check", 13, "Accent")
		chk.AnchorPoint = Vector2.new(0, 0.5)
		chk.Position = UDim2.new(0, 9, 0.5, 0)
		chk.ImageTransparency = 1
		local lbl = text({
			Parent = btn,
			Text = display,
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -18, 1, 0),
			TextSize = 12,
		})
		local row = {Value = v, Name = display:lower(), Button = btn, Check = chk, Label = lbl, Hover = false}
		table.insert(rows, row)
		btn.MouseEnter:Connect(function()
			local disabled = opts.DisabledValues and (opts.DisabledValues[v] == true or table.find(opts.DisabledValues, v) ~= nil)
			if disabled then
				return
			end
			row.Hover = true
			if not opts.Selected(v) then
				apply(btn, {BackgroundColor3 = T.Hover, BackgroundTransparency = 0.45}, true, 0.14, "Hover Effects")
				apply(lbl, {TextColor3 = T.Text}, true, 0.14, "Hover Effects")
			end
		end)
		btn.MouseLeave:Connect(function()
			row.Hover = false
			local disabled = opts.DisabledValues and (opts.DisabledValues[v] == true or table.find(opts.DisabledValues, v) ~= nil)
			if not disabled and not opts.Selected(v) then
				apply(btn, {BackgroundTransparency = 1}, true, 0.14, "Hover Effects")
				apply(lbl, {TextColor3 = T.Muted}, true, 0.14, "Hover Effects")
			end
		end)
		btn.Activated:Connect(function()
			local disabled = opts.DisabledValues and (opts.DisabledValues[v] == true or table.find(opts.DisabledValues, v) ~= nil)
			if disabled then
				return
			end
			opts.OnPick(v)
			refreshRows(true)
			if not opts.Multi then
				closePopup()
			end
		end)
	end

	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local q = searchBox.Text:lower()
			for _, r in rows do
				r.Button.Visible = q == "" or r.Name:find(q, 1, true) ~= nil
			end
			syncHeight()
		end)
	end

	syncHeight()
	refreshRows(false)
	placePopup(card, anchor, width, opts.Right, 6)
	card:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		placePopup(card, anchor, width, opts.Right, 6)
	end)

	tween(card, {GroupTransparency = 0}, 0.18, nil, nil, "Dropdown Menu")
	tween(scale, {Scale = 1}, 0.22, Enum.EasingStyle.Back, nil, "Dropdown Menu")

	openPopup({card, anchor}, function()
		if opts.OnClose then
			opts.OnClose()
		end
		if animEnabled("Dropdown Menu") then
			tween(card, {GroupTransparency = 1}, 0.14)
			tween(scale, {Scale = 0.95}, 0.14)
			task.delay(0.15, function()
				card:Destroy()
			end)
		else
			card:Destroy()
		end
	end, opts.Owner or anchor)
end

local KeyNames = {
	RightShift = "RShift", LeftShift = "LShift", RightControl = "RCtrl", LeftControl = "LCtrl",
	RightAlt = "RAlt", LeftAlt = "LAlt", Return = "Enter", Backspace = "Back", Space = "Space",
	Insert = "Ins", Delete = "Del", PageUp = "PgUp", PageDown = "PgDn",
	MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3", Unknown = "None",
	Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
}

local function keyName(k)
	if not k or k == "" or k == "None" or k == "Unknown" then
		return "None"
	end
	local n = typeof(k) == "EnumItem" and k.Name or tostring(k)
	return KeyNames[n] or n
end

local function parseKey(v)
	if typeof(v) == "EnumItem" then
		return v
	elseif type(v) == "string" then
		if v == "" or v == "None" or v == "Unknown" then
			return Enum.KeyCode.Unknown
		elseif v == "MB1" or v == "MouseButton1" then
			return Enum.UserInputType.MouseButton1
		elseif v == "MB2" or v == "MouseButton2" then
			return Enum.UserInputType.MouseButton2
		elseif v == "MB3" or v == "MouseButton3" then
			return Enum.UserInputType.MouseButton3
		elseif Enum.KeyCode[v] then
			return Enum.KeyCode[v]
		end
	end
	return Enum.KeyCode.Unknown
end

local function keyString(k)
	if not k or k == Enum.KeyCode.Unknown or k == "None" or k == "Unknown" or k == "" then
		return "None"
	end
	if k == Enum.UserInputType.MouseButton1 or k == "MB1" or k == "MouseButton1" then
		return "MB1"
	elseif k == Enum.UserInputType.MouseButton2 or k == "MB2" or k == "MouseButton2" then
		return "MB2"
	elseif k == Enum.UserInputType.MouseButton3 or k == "MB3" or k == "MouseButton3" then
		return "MB3"
	elseif typeof(k) == "EnumItem" then
		return k.Name
	end
	return tostring(k)
end

local function registerFlag(flag, obj, isToggle)
	if flag then
		Lumen.Options[flag] = obj
		Lumen.Flags[flag] = obj.Value
		if isToggle then
			Lumen.Toggles[flag] = obj
		end
	end
end

local function component(o, default, callback, isToggle)
	local cb = callback or o.Func
	local obj = {
		Value = default,
		Flag = o.Flag,
		Text = o.Text or o.Name or "",
		Func = cb,
		Listeners = {},
		ClickListeners = {},
	}
	if cb then
		table.insert(obj.Listeners, cb)
	end
	if o.ChangedCallback then
		table.insert(obj.Listeners, o.ChangedCallback)
	end
	function obj:OnChanged(fn)
		table.insert(self.Listeners, fn)
		return self
	end
	function obj:OnClick(fn)
		table.insert(self.ClickListeners, fn)
		return self
	end
	function obj:Fire(silent, ...)
		if self.Flag then
			Lumen.Flags[self.Flag] = self.Value
		end
		if not silent then
			for _, fn in self.Listeners do
				task.spawn(fn, self.Value, ...)
			end
		end
	end
	function obj:RunChanged()
		self:Fire(false)
	end
	function obj:SetValue(v, silent, ...)
		if self.Set then
			self:Set(v, silent, ...)
		end
	end
	registerFlag(o.Flag, obj, isToggle)
	return obj
end

local UNKNOWN = Enum.KeyCode.Unknown

local function makeBind(parent, o, trigger, labelText, activeFn, toggleTarget)
	local isObsidian = o.ObsidianMode == true
	local rawDefault = o.Default ~= nil and parseKey(o.Default) or UNKNOWN
	local initVal = isObsidian and keyString(rawDefault) or rawDefault
	local kb = component(o, initVal)
	kb.Type = "KeyPicker"
	kb.EnumValue = rawDefault
	kb.Mode = o.Mode or "Toggle"
	kb.State = kb.Mode == "Always"
	kb.Toggled = kb.State
	kb.Modifiers = type(o.DefaultModifiers) == "table" and table.clone(o.DefaultModifiers) or {}
	kb.Text = o.Text or labelText or o.Name or ""
	kb.MenuVisible = o.NoUI ~= true
	kb.SyncToggleState = o.SyncToggleState == true
	kb.Listening = false
	if o.Callback and isObsidian then
		kb.Listeners = {}
		if o.ChangedCallback then
			table.insert(kb.Listeners, o.ChangedCallback)
		end
		table.insert(kb.ClickListeners, o.Callback)
	end
	local ring = stroke("Stroke")
	local chip = registerFont(create("TextButton", {
		Parent = parent,
		LayoutOrder = o.Order or 20,
		Size = UDim2.fromOffset(0, 22),
		AutomaticSize = Enum.AutomaticSize.X,
		AutoButtonColor = false,
		FontFace = FONT_B,
		TextSize = 11,
		Theme = {BackgroundColor3 = "Raised", TextColor3 = "Muted"},
	}, {corner(6), ring, pad(0, 8)}), "B")
	kb.DisplayFrame = chip

	local function refresh()
		if kb.Listening then
			chip.Text = "..."
			chip.TextColor3 = T.Accent
			ring.Color = T.Accent
		else
			chip.Text = kb.Mode == "Always" and "Always" or keyName(kb.EnumValue)
			chip.TextColor3 = T.Muted
			ring.Color = T.Stroke
		end
	end
	onTheme(refresh)

	function kb:Update()
		refresh()
	end

	function kb:SetMenuVisibility(vis)
		self.MenuVisible = vis == true
	end

	function kb:DoClick()
		for _, fn in self.ClickListeners do
			task.spawn(fn, self.Toggled)
		end
		if self.SyncToggleState and toggleTarget and toggleTarget.Set then
			toggleTarget:Set(self.Toggled)
		elseif trigger then
			trigger(true, self.Mode, self.State)
		end
	end

	function kb:Set(k, silent, newMode)
		local mods
		if type(k) == "table" then
			newMode = k[2] or newMode
			mods = k[3]
			k = k[1]
		end
		if type(mods) == "table" then
			self.Modifiers = table.clone(mods)
		end
		if newMode then
			self.Mode = newMode
			if newMode == "Always" then
				self.State = true
				self.Toggled = true
			end
		end
		local parsed = k ~= nil and parseKey(k) or UNKNOWN
		self.EnumValue = parsed
		self.Value = isObsidian and keyString(parsed) or parsed
		self.Listening = false
		Lumen.Listening = false
		refresh()
		self:Fire(silent, self.Mode)
	end

	function kb:GetState()
		if self.Mode == "Always" then
			return true
		end
		if self.EnumValue == UNKNOWN then
			return false
		end
		if self.Mode == "Hold" or self.Mode == "Press" then
			if self.EnumValue == Enum.UserInputType.MouseButton1 or self.EnumValue == Enum.UserInputType.MouseButton2 or self.EnumValue == Enum.UserInputType.MouseButton3 then
				return UIS:IsMouseButtonPressed(self.EnumValue)
			elseif typeof(self.EnumValue) == "EnumItem" and self.EnumValue.EnumType == Enum.KeyCode then
				return UIS:IsKeyDown(self.EnumValue)
			end
		end
		if activeFn and not isObsidian then
			return activeFn()
		end
		return self.Toggled or self.State
	end

	if toggleTarget and toggleTarget.OnChanged then
		toggleTarget:OnChanged(function(val)
			if kb.SyncToggleState then
				kb.State = val == true
				kb.Toggled = kb.State
			end
		end)
	end

	local function showModeMenu()
		if o.Modes == false then
			return
		end
		kb.Listening = false
		Lumen.Listening = false
		refresh()
		openMenu(chip, {
			Values = type(o.Modes) == "table" and o.Modes or {"Toggle", "Hold", "Always", "Press"},
			Width = 108,
			Right = true,
			Search = false,
			Selected = function(m)
				return kb.Mode == m
			end,
			OnPick = function(m)
				kb.Mode = m
				if m == "Always" then
					kb.State = true
					kb.Toggled = true
					if trigger then
						trigger(true, "Always", true)
					end
				end
				refresh()
			end,
		})
	end

	local holdToken = 0
	local longPressed = false
	chip.InputBegan:Connect(function(input)
		if isPress(input) and o.Modes ~= false then
			holdToken += 1
			local myToken = holdToken
			longPressed = false
			task.delay(0.45, function()
				if holdToken == myToken then
					longPressed = true
					showModeMenu()
				end
			end)
		end
	end)
	chip.InputEnded:Connect(function(input)
		if isPress(input) then
			holdToken += 1
		end
	end)

	chip.Activated:Connect(function()
		if longPressed then
			longPressed = false
			return
		end
		kb.Listening = true
		Lumen.Listening = true
		refresh()
	end)

	if o.Modes ~= false then
		chip.MouseButton2Click:Connect(showModeMenu)
	end

	link(UIS.InputBegan, function(input, processed)
		if kb.Listening then
			local t = input.UserInputType
			if t == Enum.UserInputType.Keyboard then
				local k = input.KeyCode
				Lumen.LastBind = tick()
				kb:Set((k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace) and UNKNOWN or k)
			elseif t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.MouseButton2 or t == Enum.UserInputType.MouseButton3 then
				if not inside(chip, mouse(input)) then
					Lumen.LastBind = tick()
					kb:Set(t)
				end
			end
			return
		end
		if processed or kb.EnumValue == UNKNOWN or kb.Mode == "Always" then
			return
		end
		if input.KeyCode == kb.EnumValue or input.UserInputType == kb.EnumValue then
			if kb.Mode == "Hold" or kb.Mode == "Press" then
				kb.State = true
				kb.Toggled = true
			else
				kb.State = not kb.State
				kb.Toggled = kb.State
			end
			kb:DoClick()
		end
	end)

	link(UIS.InputEnded, function(input)
		if kb.EnumValue ~= UNKNOWN and (input.KeyCode == kb.EnumValue or input.UserInputType == kb.EnumValue) then
			if kb.Mode == "Hold" or kb.Mode == "Press" then
				kb.State = false
				kb.Toggled = false
				if kb.Mode == "Hold" then
					if kb.SyncToggleState and toggleTarget and toggleTarget.Set then
						toggleTarget:Set(false)
					elseif trigger then
						trigger(false, kb.Mode, false)
					end
				end
			end
		end
	end)

	local entryLabel = kb.Text ~= "" and kb.Text or labelText
	if entryLabel and entryLabel ~= "" then
		table.insert(Lumen.Binds, {
			Name = entryLabel,
			Bind = kb,
			Active = function()
				if not kb.MenuVisible then
					return false
				end
				if kb.Mode == "Always" then
					return true
				end
				return activeFn and activeFn() or kb.Toggled or kb.State
			end,
			Toggle = function()
				if toggleTarget and toggleTarget.Set then
					toggleTarget:Set(not toggleTarget.Value)
				elseif kb.Mode == "Toggle" then
					kb.State = not kb.State
					kb.Toggled = kb.State
					kb:DoClick()
				end
			end,
		})
	end

	refresh()
	return kb
end

local Presets = {
	rgb(124, 92, 255),
	rgb(56, 189, 248),
	rgb(52, 211, 153),
	rgb(251, 191, 36),
	rgb(248, 81, 99),
	rgb(244, 114, 182),
	rgb(167, 139, 250),
	rgb(240, 240, 247),
}

local function makeColor(parent, o)
	local default = o.Default or T.Accent
	local h, s, v = default:ToHSV()
	local alpha = o.Alpha or o.Transparency or 0
	local cp = component(o, default, o.Callback)
	cp.Type = "ColorPicker"
	cp.Title = o.Title or o.Text or o.Name or ""
	cp.Alpha = alpha
	cp.Transparency = alpha

	local swatch = create("TextButton", {
		Parent = parent,
		LayoutOrder = o.Order or 10,
		Size = UDim2.fromOffset(30, 18),
		BackgroundColor3 = default,
		AutoButtonColor = false,
		Text = "",
	}, {corner(6), stroke("Stroke")})
	cp.DisplayFrame = swatch

	local syncPopover

	local function commit(silent)
		cp.Value = Color3.fromHSV(h, s, v)
		cp.Alpha = alpha
		cp.Transparency = alpha
		swatch.BackgroundColor3 = cp.Value
		if syncPopover then
			syncPopover()
		end
		cp:Fire(silent, alpha)
	end

	function cp:Update()
		swatch.BackgroundColor3 = self.Value
		if syncPopover then
			syncPopover()
		end
	end

	function cp:Set(color, silent, newAlpha)
		if typeof(color) == "Color3" then
			h, s, v = color:ToHSV()
		end
		if newAlpha ~= nil then
			alpha = math.clamp(newAlpha, 0, 1)
		elseif self.Transparency ~= alpha then
			alpha = math.clamp(tonumber(self.Transparency) or 0, 0, 1)
		end
		commit(silent)
	end

	function cp:SetValueRGB(color, newAlpha)
		self:Set(color, false, newAlpha)
	end

	swatch.Activated:Connect(function()
		if popupOpenFor(swatch) then
			closePopup()
			return
		end
		local width = 236
		local card = create("CanvasGroup", {
			Parent = Layers.Popups,
			Size = UDim2.fromOffset(width, 294),
			GroupTransparency = 1,
			Theme = {BackgroundColor3 = "Raised"},
		}, {corner(12), stroke("Stroke"), pad(10)})
		local scale = create("UIScale", {Parent = card, Scale = 0.94})

		local sat = create("TextButton", {
			Parent = card,
			Size = UDim2.new(1, 0, 0, 132),
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			AutoButtonColor = false,
			Text = "",
		}, {corner(8), stroke("Stroke")})
		local wLayer = create("Frame", {Parent = sat, Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0}, {
			corner(8),
			create("UIGradient", {Transparency = NumberSequence.new(0, 1)}),
		})
		create("Frame", {Parent = wLayer, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK, BorderSizePixel = 0}, {
			corner(8),
			create("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}),
		})
		local cursor = create("Frame", {
			Parent = sat,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(12, 12),
			BackgroundTransparency = 1,
			ZIndex = 3,
		}, {corner(PILL), create("UIStroke", {Color = WHITE, Thickness = 2})})

		local hueSeq = {}
		for i = 0, 6 do
			table.insert(hueSeq, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
		end
		local hueBar = create("TextButton", {
			Parent = card,
			Position = UDim2.fromOffset(0, 142),
			Size = UDim2.new(1, 0, 0, 11),
			BackgroundColor3 = WHITE,
			AutoButtonColor = false,
			Text = "",
		}, {corner(PILL), create("UIGradient", {Color = ColorSequence.new(hueSeq)})})
		local hueKnob = create("Frame", {
			Parent = hueBar,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(13, 13),
			BackgroundColor3 = WHITE,
		}, {corner(PILL), stroke("Back", 2)})

		local alphaBar = create("TextButton", {
			Parent = card,
			Position = UDim2.fromOffset(0, 161),
			Size = UDim2.new(1, 0, 0, 11),
			AutoButtonColor = false,
			Text = "",
			Theme = {BackgroundColor3 = "Panel"},
		}, {corner(PILL), stroke("Stroke")})
		local alphaFill = create("Frame", {
			Parent = alphaBar,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = cp.Value,
			BorderSizePixel = 0,
		}, {corner(PILL), create("UIGradient", {Transparency = NumberSequence.new(0, 1)})})
		local alphaKnob = create("Frame", {
			Parent = alphaBar,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(13, 13),
			BackgroundColor3 = WHITE,
		}, {corner(PILL), stroke("Back", 2)})

		local hexBox = registerFont(create("TextBox", {
			Parent = card,
			Position = UDim2.fromOffset(0, 180),
			Size = UDim2.new(1, -64, 0, 26),
			Text = "",
			FontFace = FONT_B,
			TextSize = 12,
			ClearTextOnFocus = false,
			Theme = {BackgroundColor3 = "Panel", TextColor3 = "Text"},
		}, {corner(7), stroke("Stroke")}), "B")

		local alphaText = text({
			Parent = card,
			Position = UDim2.new(1, -58, 0, 180),
			Size = UDim2.fromOffset(58, 26),
			TextXAlignment = Enum.TextXAlignment.Center,
			FontFace = FONT_B,
			TextSize = 12,
			Theme = {BackgroundColor3 = "Panel", TextColor3 = "Muted"},
		})
		alphaText.BackgroundTransparency = 0
		corner(7).Parent = alphaText
		stroke("Stroke").Parent = alphaText

		local rgbRow = create("Frame", {
			Parent = card,
			Position = UDim2.fromOffset(0, 212),
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundTransparency = 1,
		}, {list(6, {FillDirection = Enum.FillDirection.Horizontal})})

		local rgbBoxes = {}
		for idx, ch in {"R", "G", "B"} do
			local wrap = create("Frame", {
				Parent = rgbRow,
				LayoutOrder = idx,
				Size = UDim2.new(0.333, -4, 1, 0),
				Theme = {BackgroundColor3 = "Panel"},
			}, {corner(7), stroke("Stroke")})
			text({
				Parent = wrap,
				Text = ch,
				Position = UDim2.fromOffset(7, 0),
				Size = UDim2.fromOffset(14, 26),
				FontFace = FONT_B,
				TextSize = 11,
				Theme = {TextColor3 = "Muted"},
			})
			local box = registerFont(create("TextBox", {
				Parent = wrap,
				Position = UDim2.fromOffset(21, 0),
				Size = UDim2.new(1, -26, 1, 0),
				BackgroundTransparency = 1,
				Text = "0",
				FontFace = FONT_B,
				TextSize = 12,
				ClearTextOnFocus = false,
				TextXAlignment = Enum.TextXAlignment.Right,
				Theme = {TextColor3 = "Text"},
			}), "B")
			rgbBoxes[idx] = box
			box.FocusLost:Connect(function()
				local r = math.clamp(tonumber(rgbBoxes[1].Text) or 0, 0, 255)
				local g = math.clamp(tonumber(rgbBoxes[2].Text) or 0, 0, 255)
				local b = math.clamp(tonumber(rgbBoxes[3].Text) or 0, 0, 255)
				h, s, v = Color3.fromRGB(r, g, b):ToHSV()
				commit()
			end)
		end

		local pal = create("Frame", {
			Parent = card,
			Position = UDim2.fromOffset(0, 246),
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 1,
		}, {list(5, {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})})
		for idx, col in Presets do
			local p = create("TextButton", {
				Parent = pal,
				Size = UDim2.fromOffset(22, 22),
				BackgroundColor3 = col,
				AutoButtonColor = false,
				Text = "",
				LayoutOrder = idx,
			}, {corner(6), stroke("Stroke")})
			p.Activated:Connect(function()
				h, s, v = col:ToHSV()
				commit()
			end)
		end

		syncPopover = function()
			sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			cursor.Position = UDim2.fromScale(s, 1 - v)
			hueKnob.Position = UDim2.fromScale(h, 0.5)
			alphaFill.BackgroundColor3 = cp.Value
			alphaKnob.Position = UDim2.fromScale(alpha, 0.5)
			if not hexBox:IsFocused() then
				hexBox.Text = "#" .. cp.Value:ToHex():upper()
			end
			if not rgbBoxes[1]:IsFocused() then
				rgbBoxes[1].Text = tostring(math.floor(cp.Value.R * 255 + 0.5))
			end
			if not rgbBoxes[2]:IsFocused() then
				rgbBoxes[2].Text = tostring(math.floor(cp.Value.G * 255 + 0.5))
			end
			if not rgbBoxes[3]:IsFocused() then
				rgbBoxes[3].Text = tostring(math.floor(cp.Value.B * 255 + 0.5))
			end
			alphaText.Text = math.floor((1 - alpha) * 100 + 0.5) .. "%"
		end
		syncPopover()

		local mode
		local function updateDrag(input)
			local m = mouse(input)
			if mode == "sat" then
				local p, sz = sat.AbsolutePosition, sat.AbsoluteSize
				s = math.clamp((m.X - p.X) / sz.X, 0, 1)
				v = 1 - math.clamp((m.Y - p.Y) / sz.Y, 0, 1)
			elseif mode == "hue" then
				h = math.clamp((m.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
			elseif mode == "alpha" then
				alpha = math.clamp((m.X - alphaBar.AbsolutePosition.X) / alphaBar.AbsoluteSize.X, 0, 1)
			end
			commit()
		end

		sat.InputBegan:Connect(function(i)
			if isPress(i) then
				mode = "sat"
				updateDrag(i)
			end
		end)
		hueBar.InputBegan:Connect(function(i)
			if isPress(i) then
				mode = "hue"
				updateDrag(i)
			end
		end)
		alphaBar.InputBegan:Connect(function(i)
			if isPress(i) then
				mode = "alpha"
				updateDrag(i)
			end
		end)
		local c1 = UIS.InputChanged:Connect(function(i)
			if mode and isMove(i) then
				updateDrag(i)
			end
		end)
		local c2 = UIS.InputEnded:Connect(function(i)
			if isPress(i) then
				mode = nil
			end
		end)

		hexBox.FocusLost:Connect(function()
			local clean = hexBox.Text:gsub("#", "")
			local ok, col = pcall(Color3.fromHex, clean)
			if ok then
				h, s, v = col:ToHSV()
				commit()
			else
				syncPopover()
			end
		end)

		placePopup(card, swatch, width, true, 6)
		tween(card, {GroupTransparency = 0}, 0.18, nil, nil, "Popups")
		tween(scale, {Scale = 1}, 0.22, Enum.EasingStyle.Back, nil, "Popups")

		openPopup({card, swatch}, function()
			syncPopover = nil
			c1:Disconnect()
			c2:Disconnect()
			if animEnabled("Popups") then
				tween(card, {GroupTransparency = 1}, 0.14)
				tween(scale, {Scale = 0.94}, 0.14)
				task.delay(0.15, function()
					card:Destroy()
				end)
			else
				card:Destroy()
			end
		end, swatch)
	end)

	return cp
end

local Elements = {}
local ElementMeta = {__index = Elements}

local function attachCommon(obj, row, title, desc, o, section)
	obj.Row = row
	obj.Holder = row
	obj.TextLabel = obj.TextLabel or title
	obj.Text = o.Text or o.Name or ""
	obj.Visible = row.Visible
	obj.Destroyed = false
	obj.Disabled = o.Disabled == true
	obj.FavoriteInfo = type(o) == "table" and table.clone(o) or {Text = obj.Text}
	if section and section.Elements then
		table.insert(section.Elements, obj)
	end
	local overlay
	local function updateDisabled()
		if obj.Disabled then
			if not overlay then
				overlay = create("TextButton", {
					Parent = row,
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = T.Panel,
					BackgroundTransparency = 0.42,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 15,
				}, {corner(8)})
				if o.DisabledTooltip then
					tooltip(overlay, o.DisabledTooltip)
				end
			end
			overlay.Visible = true
		elseif overlay then
			overlay.Visible = false
		end
	end
	updateDisabled()

	function obj:SetDisabled(state)
		self.Disabled = state == true
		updateDisabled()
	end

	function obj:SetVisible(state)
		self.Visible = state ~= false
		row.Visible = self.Visible
	end

	function obj:Destroy()
		if self.Destroyed then
			return
		end
		self.Destroyed = true
		self.Visible = false
		if row and row.Parent then
			row:Destroy()
		end
	end

	function obj:SetText(newTitle, newDesc)
		if newTitle ~= nil then
			self.Text = tostring(newTitle)
			if title then
				title.Text = self.Text
			end
		end
		if desc and newDesc then
			desc.Text = newDesc
		end
	end

	function obj:Depend(source, expected)
		if expected == nil then
			expected = true
		end
		local function check(val)
			local match
			if type(expected) == "function" then
				match = expected(val)
			elseif type(val) == "table" then
				match = val[expected] == true or table.find(val, expected) ~= nil
			else
				match = val == expected
			end
			self:SetVisible(match)
		end
		check(source.Value)
		source:OnChanged(check)
		return self
	end

	function obj:Bind(bOpts)
		bOpts = bOpts or {}
		self._bindCount = (self._bindCount or 0) + 1
		bOpts.Order = 20 + self._bindCount
		local kb = makeBind(self._right, bOpts, self._fire, self._label, self._active, self)
		self.BindObject = kb
		self.Addons = self.Addons or {}
		table.insert(self.Addons, kb)
		return kb, self
	end
	obj.Keybind = obj.Bind

	function obj:Color(cOpts)
		cOpts = cOpts or {}
		self._colorCount = (self._colorCount or 0) + 1
		cOpts.Order = 5 + self._colorCount
		local cp = makeColor(self._right, cOpts)
		self.ColorPicker = cp
		self.Addons = self.Addons or {}
		table.insert(self.Addons, cp)
		return cp, self
	end
	obj.ColorPickerMethod = obj.Color

	obj.AddKeyPicker = function(self, flag, bOpts)
		if type(flag) == "table" then
			bOpts = table.clone(flag)
		else
			bOpts = type(bOpts) == "table" and table.clone(bOpts) or {}
			bOpts.Flag = bOpts.Flag or flag
		end
		bOpts.ObsidianMode = true
		self:Bind(bOpts)
		return self
	end

	obj.AddColorPicker = function(self, flag, cOpts)
		if type(flag) == "table" then
			cOpts = table.clone(flag)
		else
			cOpts = type(cOpts) == "table" and table.clone(cOpts) or {}
			cOpts.Flag = cOpts.Flag or flag
		end
		self:Color(cOpts)
		return self
	end
end

local function build(section, o, height, topAnchored)
	section.Order += 1
	local hasDesc = o.Description ~= nil and o.Description ~= ""
	local pinTop = hasDesc or topAnchored == true
	local h = height or (hasDesc and 50 or 38)
	local row = create("Frame", {
		Parent = section.Body,
		Size = UDim2.new(1, 0, 0, h),
		BackgroundTransparency = 1,
		LayoutOrder = section.Order,
		Visible = o.Visible ~= false,
		Theme = {BackgroundColor3 = "Hover"},
	}, {corner(8)})

	if o.Hover ~= false then
		row.MouseEnter:Connect(function()
			apply(row, {BackgroundTransparency = 0.55}, true, 0.15, "Hover Effects")
		end)
		row.MouseLeave:Connect(function()
			apply(row, {BackgroundTransparency = 1}, true, 0.2, "Hover Effects")
		end)
	end

	local titleKey = o.Risky and "Danger" or "Text"
	local title = text({
		Parent = row,
		Text = o.Name or o.Text or "",
		Position = pinTop and UDim2.fromOffset(10, 7) or UDim2.fromOffset(10, 0),
		Size = pinTop and UDim2.new(1, -20, 0, 18) or UDim2.new(1, -20, 1, 0),
		Theme = {TextColor3 = titleKey},
	})

	local desc
	if hasDesc then
		desc = text({
			Parent = row,
			Text = o.Description,
			Position = UDim2.fromOffset(10, 25),
			Size = UDim2.new(1, -20, 0, 16),
			TextSize = 11,
			Theme = {TextColor3 = "Muted"},
		})
	end

	local right = create("Frame", {
		Parent = row,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ZIndex = 2,
	}, {list(6, {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})})

	local function fit()
		local padX = right.Visible and (right.AbsoluteSize.X + 30) or (topAnchored and 100 or 20)
		title.Size = pinTop and UDim2.new(1, -padX, 0, 18) or UDim2.new(1, -padX, 1, 0)
		if desc then
			desc.Size = UDim2.new(1, -padX, 0, 16)
		end
	end
	right:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
	fit()

	if o.Tooltip then
		tooltip(row, o.Tooltip)
	end
	table.insert(section.Items, {
		Row = row,
		Name = ((o.Name or o.Text or "") .. " " .. (o.Description or "")):lower(),
	})
	return row, title, right, desc
end

function Elements:Divider(labelText)
	self.Order += 1
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, labelText and 22 or 12),
		BackgroundTransparency = 1,
		LayoutOrder = self.Order,
	})
	if labelText and labelText ~= "" then
		local lbl = text({
			Parent = row,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = string.upper(labelText),
			FontFace = FONT_X,
			TextSize = 10,
			Theme = {TextColor3 = "Muted"},
		})
		create("Frame", {
			Parent = row,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			Size = UDim2.new(0.5, -52, 0, 1),
			BorderSizePixel = 0,
			Theme = {BackgroundColor3 = "Stroke"},
		})
		create("Frame", {
			Parent = row,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			Size = UDim2.new(0.5, -52, 0, 1),
			BorderSizePixel = 0,
			Theme = {BackgroundColor3 = "Stroke"},
		})
		local _ = lbl
	else
		create("Frame", {
			Parent = row,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -16, 0, 1),
			BorderSizePixel = 0,
			Theme = {BackgroundColor3 = "Stroke"},
		})
	end
	table.insert(self.Items, {Row = row, Name = false})
	local divObj = {
		Type = "Divider",
		Row = row,
		Holder = row,
		Visible = true,
		Destroyed = false,
		SetVisible = function(s, v)
			s.Visible = v ~= false
			row.Visible = s.Visible
		end,
		Destroy = function(s)
			s.Destroyed = true
			if row.Parent then
				row:Destroy()
			end
		end,
	}
	if self.Elements then
		table.insert(self.Elements, divObj)
	end
	return divObj
end

function Elements:Label(o, doesWrap, idx)
	if type(o) == "string" then
		o = {Name = o, Text = o, DoesWrap = doesWrap == true, Flag = idx}
	else
		o = o or {}
		if doesWrap ~= nil and o.DoesWrap == nil then
			o.DoesWrap = doesWrap == true
		end
		if idx and not o.Flag then
			o.Flag = idx
		end
	end
	o.Hover = false
	local row, title, right, desc = build(self, o, o.DoesWrap and 46 or 30)
	if o.DoesWrap then
		title.TextWrapped = true
		title.TextTruncate = Enum.TextTruncate.None
		row.AutomaticSize = Enum.AutomaticSize.Y
		title.AutomaticSize = Enum.AutomaticSize.Y
		title.Size = UDim2.new(1, -20, 0, 18)
	end
	local obj = component(o, o.Name or o.Text)
	obj.Type = "Label"
	obj.DoesWrap = o.DoesWrap == true
	obj._right = right
	obj._label = o.Name or o.Text
	obj.TextLabel = title
	attachCommon(obj, row, title, desc, o, self)
	if o.Flag then
		Lumen.Labels[o.Flag] = obj
	end
	return obj
end

function Elements:Paragraph(o)
	o = type(o) == "string" and {Content = o} or (o or {})
	self.Order += 1
	local hasHead = (o.Name or o.Title or "") ~= ""
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0.45,
		LayoutOrder = self.Order,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(8), stroke("Stroke", 1, 0.35), pad(10, 12), list(4)})
	local head = text({
		Parent = row,
		Text = o.Name or o.Title or "",
		Size = UDim2.new(1, 0, 0, 16),
		FontFace = FONT_B,
		Visible = hasHead,
		LayoutOrder = 1,
	})
	local body = text({
		Parent = row,
		Text = o.Content or o.Text or "",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.None,
		TextSize = 12,
		LayoutOrder = 2,
		Theme = {TextColor3 = "Muted"},
	})
	table.insert(self.Items, {Row = row, Name = ((o.Name or "") .. " " .. (o.Content or "")):lower()})
	return {
		Type = "Paragraph",
		Row = row,
		Holder = row,
		SetTitle = function(_, v)
			head.Text = v
		end,
		SetContent = function(_, v)
			body.Text = v
		end,
		SetVisible = function(_, v)
			row.Visible = v
		end,
	}
end

function Elements:Banner(o)
	o = o or {}
	self.Order += 1
	local kindMap = {
		Info = {Key = "Accent", Icon = "info"},
		Success = {Key = "Success", Icon = "circle-check"},
		Warning = {Key = "Warning", Icon = "triangle-alert"},
		Error = {Key = "Danger", Icon = "circle-x"},
	}
	local k = kindMap[o.Type or "Info"] or kindMap.Info
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0.88,
		LayoutOrder = self.Order,
		Theme = {BackgroundColor3 = k.Key},
	}, {corner(9), stroke(k.Key, 1, 0.45), pad(10, 12)})
	local ic = icon(row, o.Icon or k.Icon, 16, k.Key)
	if ic then
		ic.Position = UDim2.fromOffset(0, 1)
	end
	local col = create("Frame", {
		Parent = row,
		Position = UDim2.fromOffset(26, 0),
		Size = UDim2.new(1, -26, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {list(2)})
	local head = text({
		Parent = col,
		Text = o.Title or o.Name or "Notice",
		Size = UDim2.new(1, 0, 0, 16),
		FontFace = FONT_B,
		LayoutOrder = 1,
		Theme = {TextColor3 = k.Key},
	})
	local body = text({
		Parent = col,
		Text = o.Content or o.Text or "",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.None,
		TextSize = 12,
		LayoutOrder = 2,
		Theme = {TextColor3 = "Text"},
	})
	table.insert(self.Items, {Row = row, Name = ((o.Title or "") .. " " .. (o.Content or "")):lower()})
	return {
		Row = row,
		Holder = row,
		SetTitle = function(_, v)
			head.Text = v
		end,
		SetContent = function(_, v)
			body.Text = v
		end,
		SetVisible = function(_, v)
			row.Visible = v
		end,
	}
end

local function makeSingleButton(holder, o)
	local primary = o.Style == "Primary"
	local danger = o.Style == "Danger" or o.Risky == true
	local b = create("TextButton", {
		Parent = holder,
		Size = UDim2.fromScale(1, 1),
		AutoButtonColor = false,
		Text = "",
		ClipsDescendants = true,
		BackgroundColor3 = primary and T.Accent or T.Raised,
	}, {corner(8), stroke(primary and "Accent" or (danger and "Danger" or "Stroke"), 1, primary and 0.25 or 0)})
	local scale = create("UIScale", {Parent = b})
	local right = create("Frame", {
		Parent = b,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(0, 22),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ZIndex = 2,
	}, {list(6, {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})})

	local contentBox = create("Frame", {
		Parent = b,
		Size = UDim2.new(1, -12, 1, 0),
		Position = UDim2.fromOffset(6, 0),
		BackgroundTransparency = 1,
	}, {list(6, {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})})

	local ico
	if o.Icon then
		ico = icon(contentBox, o.Icon, 14, primary and WHITE or (danger and "Danger" or "Text"))
		if ico then
			ico.LayoutOrder = 1
		end
	end
	local name = o.Name or o.Text or "Button"
	local label = text({
		Parent = contentBox,
		LayoutOrder = 2,
		Text = name,
		Size = UDim2.fromOffset(0, 32),
		AutomaticSize = Enum.AutomaticSize.X,
		TextTruncate = Enum.TextTruncate.None,
		FontFace = FONT_B,
		TextSize = 12,
		TextColor3 = primary and WHITE or (danger and T.Danger or T.Text),
	})

	local hovered = false
	local function render(animate)
		local base = primary and T.Accent or T.Raised
		local over = primary and T.Accent:Lerp(WHITE, 0.14) or T.Hover
		apply(b, {BackgroundColor3 = hovered and over or base}, animate, 0.15, "Hover Effects")
		label.TextColor3 = primary and WHITE or (danger and T.Danger or T.Text)
		if ico and not primary then
			ico.ImageColor3 = danger and T.Danger or T.Text
		end
	end
	onTheme(render)

	b.MouseEnter:Connect(function()
		hovered = true
		render(true)
	end)
	b.MouseLeave:Connect(function()
		hovered = false
		render(true)
		tween(scale, {Scale = 1}, 0.18)
	end)
	b.MouseButton1Down:Connect(function()
		tween(scale, {Scale = 0.98}, 0.08)
	end)
	b.MouseButton1Up:Connect(function()
		tween(scale, {Scale = 1}, 0.3, Enum.EasingStyle.Back)
	end)

	local armed = false
	local function restore()
		label.Text = name
		tween(label, {TextColor3 = primary and WHITE or (danger and T.Danger or T.Text)}, 0.15)
	end
	local obj = component(o, nil)
	obj.Type = "Button"
	obj.Base = b
	obj.Button = b
	obj.TextLabel = label
	obj._right = right
	obj._label = name
	obj._modes = false

	local function trigger()
		if obj.Disabled then
			return
		end
		if (o.DoubleTap or o.DoubleClick) and not armed then
			armed = true
			label.Text = "Confirm?"
			tween(label, {TextColor3 = primary and WHITE or T.Warning}, 0.15)
			task.delay(1.6, function()
				if armed then
					armed = false
					restore()
				end
			end)
			return
		end
		if armed then
			armed = false
			restore()
		end
		local cb = obj.Func or o.Callback or o.Func
		if cb then
			task.spawn(cb)
		end
	end
	b.Activated:Connect(function()
		ripple(b)
		trigger()
	end)
	if o.Tooltip then
		tooltip(b, o.Tooltip)
	end

	obj._fire = function(down)
		if down then
			trigger()
		end
	end
	function obj:SetText(v)
		name = tostring(v or "")
		self.Text = name
		label.Text = name
	end
	function obj:SetIcon(iconName)
		if ico then
			ico:Destroy()
			ico = nil
		end
		if iconName and iconName ~= "" then
			ico = icon(contentBox, iconName, 14, primary and WHITE or (danger and "Danger" or "Text"))
			if ico then
				ico.LayoutOrder = 1
			end
		end
	end
	if o.Idx or o.Flag then
		Lumen.Buttons[o.Idx or o.Flag] = obj
	end
	return obj
end

function Elements:Button(o, fn)
	if type(o) == "string" then
		o = {Name = o, Text = o, Callback = fn, Func = fn}
	else
		o = o or {}
		if fn and not o.Callback and not o.Func then
			o.Callback = fn
			o.Func = fn
		end
	end
	self.Order += 1
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = self.Order,
		Visible = o.Visible ~= false,
	})
	local container = create("Frame", {
		Parent = row,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -12, 0, 32),
		BackgroundTransparency = 1,
	})
	local buttons = {}
	local function relayout()
		local n = #buttons
		local gap = 6
		for idx, btnObj in buttons do
			btnObj.Button.Size = UDim2.new(1 / n, -(gap * (n - 1)) / n, 1, 0)
			btnObj.Button.Position = UDim2.new((idx - 1) / n, (idx - 1) * (gap / n), 0, 0)
		end
	end

	local mainObj = makeSingleButton(container, o)
	mainObj.SubButtons = buttons
	table.insert(buttons, mainObj)
	relayout()
	attachCommon(mainObj, row, mainObj.TextLabel, nil, o, self)
	table.insert(self.Items, {Row = row, Name = (o.Name or o.Text or "button"):lower()})

	function mainObj:SubButton(subOpts, subFn)
		if type(subOpts) == "string" then
			subOpts = {Name = subOpts, Text = subOpts, Callback = subFn, Func = subFn}
		else
			subOpts = subOpts or {}
			if subFn and not subOpts.Callback and not subOpts.Func then
				subOpts.Callback = subFn
				subOpts.Func = subFn
			end
		end
		local subObj = makeSingleButton(container, subOpts)
		subObj.Row = row
		subObj.Holder = row
		subObj.SetDisabled = function(s, st)
			s.Disabled = st == true
		end
		table.insert(buttons, subObj)
		relayout()
		return subObj
	end
	mainObj.AddButton = mainObj.SubButton

	if o.SubName or o.SubCallback then
		mainObj:SubButton({
			Name = o.SubName or "Action",
			Icon = o.SubIcon,
			Callback = o.SubCallback,
		})
	end

	return mainObj
end

function Elements:Toggle(o)
	o = o or {}
	local obj = component(o, o.Default == true, o.Callback, true)
	obj.Type = "Toggle"
	local row, title, right, desc = build(self, o)
	local click = hit(row)
	click.ZIndex = 1

	local forceCheck = o.Checkbox == true
	local track = create("Frame", {
		Parent = right,
		LayoutOrder = 100,
		Size = UDim2.fromOffset(38, 20),
		BackgroundColor3 = T.Hover,
	}, {corner(PILL), stroke("Stroke", 1, 0.35)})
	local knob = create("Frame", {
		Parent = track,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = T.Muted,
	}, {corner(PILL)})
	local checkIcon = icon(track, "check", 13, WHITE)
	checkIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	checkIcon.Position = UDim2.fromScale(0.5, 0.5)
	checkIcon.ImageTransparency = 1
	local trackCorner = track:FindFirstChildOfClass("UICorner")

	local function isCheckStyle()
		return forceCheck or Lumen.ForceCheckbox or Lumen.Config.ToggleStyle == "Checkbox"
	end

	local function place_(on, w)
		return UDim2.new(0, on and (38 - 3 - w) or 3, 0.5, 0)
	end

	local function render(animate)
		if not track.Parent then
			return false
		end
		local on = obj.Value
		local checkMode = isCheckStyle()
		if checkMode then
			trackCorner.CornerRadius = UDim.new(0, 6)
			knob.Visible = false
			checkIcon.Visible = true
			apply(track, {
				Size = UDim2.fromOffset(20, 20),
				BackgroundColor3 = on and T.Accent or T.Raised,
			}, animate, 0.18)
			apply(checkIcon, {ImageTransparency = on and 0 or 1}, animate, 0.16)
		else
			trackCorner.CornerRadius = PILL
			knob.Visible = true
			checkIcon.Visible = false
			apply(track, {
				Size = UDim2.fromOffset(38, 20),
				BackgroundColor3 = on and T.Accent or T.Hover,
			}, animate, 0.18)
			apply(knob, {
				Position = place_(on, 14),
				Size = UDim2.fromOffset(14, 14),
				BackgroundColor3 = on and WHITE or T.Muted,
			}, animate, 0.24)
		end
		return true
	end
	onTheme(render)
	table.insert(toggleNodes, function()
		return render(true)
	end)

	click.MouseButton1Down:Connect(function()
		if not isCheckStyle() then
			tween(knob, {Size = UDim2.fromOffset(18, 14), Position = place_(obj.Value, 18)}, 0.1)
		end
	end)
	click.MouseLeave:Connect(function()
		render(true)
	end)

	function obj:Set(v, silent)
		self.Value = v == true
		render(true)
		self:Fire(silent)
	end

	click.Activated:Connect(function()
		if not obj.Disabled then
			obj:Set(not obj.Value)
		end
	end)

	obj._right = right
	obj._label = o.Name or o.Text
	obj._active = function()
		return obj.Value
	end
	obj._fire = function(down, mode)
		if obj.Disabled then
			return
		end
		if mode == "Hold" then
			obj:Set(down)
		elseif down then
			obj:Set(not obj.Value)
		end
	end
	attachCommon(obj, row, title, desc, o, self)
	return obj
end

function Elements:Checkbox(o)
	o = o or {}
	o.Checkbox = true
	return self:Toggle(o)
end

function Elements:Slider(o)
	o = o or {}
	local min, max, inc = o.Min or 0, o.Max or 100, o.Increment or o.Step or (o.Rounding and (10 ^ -o.Rounding)) or 1
	local dec = #(tostring(inc):match("%.(%d+)") or "")
	local fmt = "%." .. dec .. "f"
	local prefix, suffix = o.Prefix or "", o.Suffix or ""
	local obj = component(o, math.clamp(o.Default or min, min, max), o.Callback)
	obj.Type = "Slider"
	obj.Min, obj.Max, obj.Rounding = min, max, dec
	local hasDesc = o.Description ~= nil and o.Description ~= ""
	local totalH = hasDesc and 66 or 52
	local trackY = hasDesc and 48 or 34
	local row, title, right, desc = build(self, o, totalH, true)
	right.Visible = false

	local box = registerFont(create("TextBox", {
		Parent = row,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 6),
		Size = UDim2.fromOffset(82, 20),
		BackgroundTransparency = 1,
		FontFace = FONT_B,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Right,
		Theme = {BackgroundColor3 = "Raised", TextColor3 = "Muted"},
	}, {corner(6), pad(0, 6)}), "B")

	local track = create("Frame", {
		Parent = row,
		Position = UDim2.fromOffset(10, trackY),
		Size = UDim2.new(1, -20, 0, 6),
		Theme = {BackgroundColor3 = "Hover"},
	}, {corner(PILL)})
	local fill = create("Frame", {
		Parent = track,
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = T.Accent,
	}, {corner(PILL)})
	onTheme(function()
		fill.BackgroundColor3 = T.Accent
	end)
	local knob = create("Frame", {
		Parent = fill,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = WHITE,
	}, {corner(PILL), stroke("Accent", 2, 0.35)})
	local area = create("TextButton", {
		Parent = row,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Position = UDim2.fromOffset(0, trackY - 8),
		Size = UDim2.new(1, 0, 0, 22),
		ZIndex = 3,
	})

	local dragging, hovering = false, false
	local function display()
		local fn = o.FormatDisplayValue or o.Format
		if fn then
			return tostring(fn(obj.Value))
		end
		return prefix .. string.format(fmt, obj.Value) .. suffix
	end
	local function render(instant)
		local span = math.max(max - min, 1e-6)
		local goal = UDim2.fromScale(math.clamp((obj.Value - min) / span, 0, 1), 1)
		if instant then
			fill.Size = goal
		else
			tween(fill, {Size = goal}, 0.08, Enum.EasingStyle.Quad)
		end
		if not box:IsFocused() then
			box.Text = display()
		end
	end

	local function set(v, silent)
		v = tonumber(v) or min
		v = math.clamp(math.floor((v - min) / inc + 0.5) * inc + min, min, max)
		v = tonumber(string.format(fmt, v))
		local changed = v ~= obj.Value
		obj.Value = v
		render(false)
		if changed or silent then
			obj:Fire(silent)
		end
	end

	function obj:Set(v, silent)
		set(v, silent)
	end
	function obj:SetMin(newMin)
		min = newMin
		self.Min = newMin
		set(self.Value, true)
	end
	function obj:SetMax(newMax)
		max = newMax
		self.Max = newMax
		set(self.Value, true)
	end
	function obj:SetPrefix(p)
		prefix = p or ""
		render(true)
	end
	function obj:SetSuffix(s)
		suffix = s or ""
		render(true)
	end
	function obj:Display()
		min = self.Min or min
		max = self.Max or max
		render(true)
	end

	local function grow()
		tween(knob, {Size = (dragging or hovering) and UDim2.fromOffset(15, 15) or UDim2.fromOffset(12, 12)}, 0.16, Enum.EasingStyle.Back)
	end

	local function fromMouse(input)
		if obj.Disabled then
			return
		end
		local a = math.clamp((mouse(input).X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		set(min + (max - min) * a)
	end

	area.MouseEnter:Connect(function()
		hovering = true
		grow()
	end)
	area.MouseLeave:Connect(function()
		hovering = false
		grow()
	end)
	area.InputBegan:Connect(function(i)
		if isPress(i) and not obj.Disabled then
			dragging = true
			grow()
			fromMouse(i)
		end
	end)
	link(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			fromMouse(i)
		end
	end)
	link(UIS.InputEnded, function(i)
		if dragging and isPress(i) then
			dragging = false
			grow()
		end
	end)

	box.Focused:Connect(function()
		box.Text = tostring(obj.Value)
		tween(box, {BackgroundTransparency = 0, TextColor3 = T.Text}, 0.14)
	end)
	box.FocusLost:Connect(function()
		tween(box, {BackgroundTransparency = 1, TextColor3 = T.Muted}, 0.14)
		local n = tonumber(box.Text:match("-?%d+%.?%d*"))
		if n and not obj.Disabled then
			set(n)
		end
		render(true)
	end)

	attachCommon(obj, row, title, desc, o, self)
	render(true)
	return obj
end

function Elements:Dropdown(o)
	o = o or {}
	local multi = o.Multi == true
	local dictMode = o.DictMulti == true
	local allowNull = o.AllowNull == true
	local specialType = o.SpecialType
	local excludeLocal = o.ExcludeLocalPlayer == true
	local values = type(o.Values or o.Items) == "table" and table.clone(o.Values or o.Items) or {}

	local function buildSpecialValues()
		if specialType == "Player" then
			local list_ = {}
			local lp = Players.LocalPlayer
			for _, p in Players:GetPlayers() do
				if not (excludeLocal and p == lp) then
					table.insert(list_, p)
				end
			end
			values = list_
		elseif specialType == "Team" then
			local Teams = game:GetService("Teams")
			values = Teams:GetTeams()
		end
	end
	if specialType then
		buildSpecialValues()
	end

	local function normalizeMulti(val)
		if not multi then
			if type(val) == "number" and values[val] ~= nil and not table.find(values, val) then
				return values[val]
			end
			return val
		end
		if dictMode then
			local out = {}
			if type(val) == "table" then
				local isArr = #val > 0
				if isArr then
					for _, item in val do
						local resolved = (type(item) == "number" and values[item] ~= nil and not table.find(values, item)) and values[item] or item
						if resolved ~= nil then
							out[resolved] = true
						end
					end
				else
					for k, v in val do
						if v then
							out[k] = true
						end
					end
				end
			elseif val ~= nil and val ~= "" then
				local resolved = (type(val) == "number" and values[val] ~= nil and not table.find(values, val)) and values[val] or val
				if resolved ~= nil then
					out[resolved] = true
				end
			end
			return out
		else
			local out = {}
			if type(val) == "table" then
				if #val > 0 then
					for _, item in val do
						table.insert(out, item)
					end
				else
					for k, v in val do
						if v then
							table.insert(out, k)
						end
					end
				end
			elseif val ~= nil then
				table.insert(out, val)
			end
			return out
		end
	end

	local default = normalizeMulti(o.Default)
	local obj = component(o, default, o.Callback)
	obj.Type = "Dropdown"
	obj.Multi = multi
	obj.SpecialType = specialType
	obj.ExcludeLocalPlayer = excludeLocal
	obj.Values = values
	obj.DisabledValues = type(o.DisabledValues) == "table" and table.clone(o.DisabledValues) or {}

	local row, title, right, desc = build(self, o)
	local ring = stroke("Stroke")
	local field = create("TextButton", {
		Parent = right,
		LayoutOrder = 100,
		Size = UDim2.fromOffset(o.Width or 162, 28),
		AutoButtonColor = false,
		Text = "",
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(8), ring})
	local shown = text({Parent = field, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -32, 1, 0), TextSize = 12})
	local chevron = icon(field, "chevron-down", 13, "Muted")
	chevron.AnchorPoint = Vector2.new(0.5, 0.5)
	chevron.Position = UDim2.new(1, -14, 0.5, 0)

	local function fmtItem(v)
		local fn = o.FormatListValue or o.FormatDisplayValue or o.Format
		if fn then
			local ok, res = pcall(fn, v)
			if ok and res ~= nil then
				return tostring(res)
			end
		end
		if typeof(v) == "Instance" then
			if v:IsA("Player") and v.DisplayName and v.DisplayName ~= v.Name then
				return string.format("%s (@%s)", v.DisplayName, v.Name)
			end
			return v.Name
		end
		return tostring(v)
	end

	local function selectedList()
		if not multi then
			return obj.Value ~= nil and {obj.Value} or {}
		end
		if dictMode then
			local arr = {}
			for _, item in values do
				if obj.Value[item] then
					table.insert(arr, item)
				end
			end
			for k, v in obj.Value do
				if v and not table.find(arr, k) then
					table.insert(arr, k)
				end
			end
			return arr
		end
		return obj.Value
	end

	local function selected(name)
		if multi then
			if dictMode then
				return obj.Value[name] == true
			end
			return table.find(obj.Value, name) ~= nil
		end
		return obj.Value == name
	end

	local function render()
		local sel = selectedList()
		local empty = (multi and #sel == 0) or (not multi and (obj.Value == nil or obj.Value == ""))
		if empty then
			shown.Text = o.NullText or o.Placeholder or "None"
		elseif o.FormatDisplayValue then
			local ok, custom = pcall(o.FormatDisplayValue, multi and sel or obj.Value)
			shown.Text = (ok and custom ~= nil and tostring(custom) ~= "") and tostring(custom) or fmtItem(sel[1])
		elseif multi then
			local n = #sel
			if n <= 2 then
				local parts = {}
				for _, item in sel do
					table.insert(parts, fmtItem(item))
				end
				shown.Text = table.concat(parts, ", ")
			else
				shown.Text = fmtItem(sel[1]) .. " +" .. (n - 1)
			end
		else
			shown.Text = fmtItem(obj.Value)
		end
		shown.TextColor3 = empty and T.Muted or T.Text
	end
	onTheme(render)

	function obj:Set(v, silent)
		self.Value = normalizeMulti(v)
		render()
		self:Fire(silent)
	end

	function obj:Refresh()
		if specialType then
			buildSpecialValues()
			self.Values = values
		end
		render()
	end

	function obj:SetValues(new)
		values = type(new) == "table" and table.clone(new) or {}
		self.Values = values
		closePopup()
		if not multi and self.Value ~= nil and not table.find(values, self.Value) then
			self:Set(nil, true)
		else
			render()
		end
	end

	function obj:AddValues(extra)
		if type(extra) == "table" then
			for _, item in extra do
				if not table.find(values, item) then
					table.insert(values, item)
				end
			end
		elseif extra ~= nil and not table.find(values, extra) then
			table.insert(values, extra)
		end
		self.Values = values
		render()
	end

	function obj:SetDisabledValues(tbl)
		self.DisabledValues = type(tbl) == "table" and table.clone(tbl) or {}
		render()
	end

	if specialType == "Player" then
		link(Players.PlayerAdded, function()
			buildSpecialValues()
			obj.Values = values
			render()
		end)
		link(Players.PlayerRemoving, function(plr)
			buildSpecialValues()
			obj.Values = values
			if multi and dictMode and obj.Value[plr] then
				obj.Value[plr] = nil
				obj:Fire()
			elseif not multi and obj.Value == plr then
				obj.Value = nil
				obj:Fire()
			end
			render()
		end)
	end

	field.MouseEnter:Connect(function()
		if not popupOpenFor(field) then
			apply(ring, {Color = T.Muted}, true, 0.14, "Hover Effects")
		end
	end)
	field.MouseLeave:Connect(function()
		if not popupOpenFor(field) then
			apply(ring, {Color = T.Stroke}, true, 0.14, "Hover Effects")
		end
	end)
	field.Activated:Connect(function()
		if obj.Disabled then
			return
		end
		if popupOpenFor(field) then
			closePopup()
			return
		end
		if specialType then
			buildSpecialValues()
			obj.Values = values
		end
		tween(chevron, {Rotation = 180}, 0.22, nil, nil, "Dropdown Menu")
		tween(ring, {Color = T.Accent}, 0.18, nil, nil, "Dropdown Menu")
		openMenu(field, {
			Values = values,
			DisabledValues = obj.DisabledValues,
			Multi = multi,
			Search = o.Searchable ~= nil and o.Searchable or o.Search,
			Format = fmtItem,
			Width = math.max(field.AbsoluteSize.X, 176),
			Right = true,
			OnClose = function()
				tween(chevron, {Rotation = 0}, 0.22, nil, nil, "Dropdown Menu")
				tween(ring, {Color = T.Stroke}, 0.18, nil, nil, "Dropdown Menu")
			end,
			Selected = selected,
			OnPick = function(name)
				if multi then
					if dictMode then
						if obj.Value[name] then
							obj.Value[name] = nil
						else
							obj.Value[name] = true
						end
					else
						local i = table.find(obj.Value, name)
						if i then
							table.remove(obj.Value, i)
						else
							table.insert(obj.Value, name)
						end
					end
					render()
					obj:Fire()
				elseif allowNull and obj.Value == name then
					obj:Set(nil)
				else
					obj:Set(name)
				end
			end,
		})
	end)

	attachCommon(obj, row, title, desc, o, self)
	render()
	return obj
end

function Elements:Input(o)
	o = o or {}
	local obj = component(o, o.Default or "", o.Callback)
	obj.Type = "Input"
	local row, title, right, desc = build(self, o)
	local ring = stroke("Stroke")
	local box = registerFont(create("TextBox", {
		Parent = right,
		LayoutOrder = 100,
		Size = UDim2.fromOffset(o.Width or 162, 28),
		Text = obj.Value,
		PlaceholderText = o.Placeholder or "",
		FontFace = FONT,
		TextSize = 12,
		ClearTextOnFocus = (o.ClearOnFocus == true) or (o.ClearTextOnFocus == true),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Theme = {BackgroundColor3 = "Raised", TextColor3 = "Text", PlaceholderColor3 = "Muted"},
	}, {corner(8), ring, pad(0, 10)}), "M")
	box.Focused:Connect(function()
		tween(ring, {Color = T.Accent}, 0.18)
	end)
	box.FocusLost:Connect(function(enterPressed)
		tween(ring, {Color = T.Stroke}, 0.18)
		if o.Finished and not enterPressed then
			return
		end
		obj.Value = box.Text
		obj:Fire()
	end)
	box:GetPropertyChangedSignal("Text"):Connect(function()
		if o.Numeric then
			local clean = box.Text:gsub("[^%d%.%-]", "")
			if clean ~= box.Text then
				box.Text = clean
			end
		end
		if o.Live or (o.Finished == false) then
			obj.Value = box.Text
			obj:Fire()
		end
	end)
	function obj:Set(v, silent)
		self.Value = tostring(v or "")
		box.Text = self.Value
		self:Fire(silent)
	end
	attachCommon(obj, row, title, desc, o, self)
	return obj
end

function Elements:Keybind(o)
	o = o or {}
	local row, title, right, desc = build(self, o)
	local kb
	kb = makeBind(right, o, function(_, _, active)
		if o.Callback then
			task.spawn(o.Callback, active, kb.Value)
		end
	end, o.Name or o.Text)
	if o.OnChange then
		kb:OnChanged(o.OnChange)
	end
	attachCommon(kb, row, title, desc, o, self)
	return kb
end

function Elements:ColorPicker(o)
	o = o or {}
	local row, title, right, desc = build(self, o)
	local cp = makeColor(right, o)
	attachCommon(cp, row, title, desc, o, self)
	return cp
end

function Elements:Viewport(o)
	o = o or {}
	self.Order += 1
	local h = o.Height or 180
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, h),
		BackgroundTransparency = 0.25,
		LayoutOrder = self.Order,
		Visible = o.Visible ~= false,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(10), stroke("Stroke")})
	local vp = create("ViewportFrame", {
		Parent = row,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LightColor = WHITE,
		Ambient = rgb(190, 190, 205),
	}, {corner(10)})
	local cam = o.Camera or create("Camera", {Parent = vp})
	vp.CurrentCamera = cam
	local obj = component(o, o.Object)
	obj.Type = "Viewport"
	obj.Viewport = vp
	obj.Camera = cam
	obj.Height = h
	function obj:SetHeight(newH)
		h = tonumber(newH) or 180
		self.Height = h
		row.Size = UDim2.new(1, 0, 0, h)
	end
	function obj:SetObject(inst, cloneObj)
		for _, c in vp:GetChildren() do
			if not c:IsA("Camera") and not c:IsA("UICorner") then
				c:Destroy()
			end
		end
		if inst then
			local target = cloneObj ~= false and inst:Clone() or inst
			target.Parent = vp
			self.Object = target
			return target
		end
		return nil
	end
	if o.Object then
		obj:SetObject(o.Object, o.Clone)
	end
	attachCommon(obj, row, nil, nil, o, self)
	return obj
end

function Elements:Image(o)
	o = o or {}
	self.Order += 1
	local h = o.Height or 140
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, h),
		BackgroundTransparency = o.BackgroundTransparency or 0.35,
		LayoutOrder = self.Order,
		Visible = o.Visible ~= false,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(10), stroke("Stroke")})
	local img = create("ImageLabel", {
		Parent = row,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = resolveIcon(o.Image or o.Url or "") or (o.Image or ""),
		ImageColor3 = o.Color or WHITE,
		ImageRectOffset = o.RectOffset or Vector2.zero,
		ImageRectSize = o.RectSize or Vector2.zero,
		ScaleType = o.ScaleType or Enum.ScaleType.Fit,
	}, {corner(10)})
	local obj = component(o, img.Image)
	obj.Type = "Image"
	obj.ImageLabel = img
	obj.Image = img.Image
	obj.Height = h
	function obj:SetHeight(newH)
		h = tonumber(newH) or 140
		self.Height = h
		row.Size = UDim2.new(1, 0, 0, h)
	end
	function obj:SetImage(val)
		img.Image = resolveIcon(val) or tostring(val or "")
		self.Value = img.Image
		self.Image = img.Image
	end
	attachCommon(obj, row, nil, nil, o, self)
	return obj
end

local function makeObsidianDepBox(parentContainer, parentObj, isGroupbox)
	if parentObj.Order then
		parentObj.Order += 1
	end
	local holder = create("Frame", {
		Parent = parentContainer,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = parentObj.Order or 99,
		Visible = true,
	})
	local body = create("Frame", {
		Parent = holder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = isGroupbox and 0.15 or 1,
		Theme = isGroupbox and {BackgroundColor3 = "Panel"} or nil,
	}, isGroupbox and {corner(12), stroke("Stroke"), pad(8, 10, 10, 10), list(3)} or {list(3)})

	local sub = setmetatable({
		Type = isGroupbox and "DependencyGroupbox" or "DependencyBox",
		Frame = holder,
		BoxHolder = holder,
		Body = body,
		Holder = body,
		Container = body,
		Tab = parentObj.Tab or parentObj,
		Items = parentObj.Items or {},
		Elements = {},
		DependencyBoxes = {},
		Dependencies = {},
		Order = 0,
		Visible = true,
		Destroyed = false,
	}, ElementMeta)

	function sub:Resize()
	end

	function sub:SetVisible(state)
		self.Visible = state ~= false
		holder.Visible = self.Visible
	end

	function sub:Update()
		if self.Destroyed then
			return
		end
		if not self.Dependencies or #self.Dependencies == 0 then
			self:SetVisible(true)
			return
		end
		local pass = true
		for _, pair in self.Dependencies do
			local ctrl, expected = pair[1], pair[2]
			if ctrl then
				local val = ctrl.Value
				local match = false
				if type(expected) == "function" then
					match = expected(val)
				elseif type(val) == "table" then
					if val[expected] ~= nil then
						match = val[expected] == true
					else
						match = table.find(val, expected) ~= nil
					end
				else
					match = val == expected
				end
				if not match then
					pass = false
					break
				end
			end
		end
		self:SetVisible(pass)
	end

	function sub:SetupDependencies(deps)
		self.Dependencies = type(deps) == "table" and deps or {}
		for _, pair in self.Dependencies do
			local ctrl = pair[1]
			if ctrl and ctrl.OnChanged then
				ctrl:OnChanged(function()
					self:Update()
				end)
			end
		end
		self:Update()
	end

	function sub:Destroy()
		if self.Destroyed then
			return
		end
		self.Destroyed = true
		self.Visible = false
		if holder.Parent then
			holder:Destroy()
		end
	end

	if parentObj.DependencyBoxes then
		table.insert(parentObj.DependencyBoxes, sub)
	end
	if parentObj.DependencyGroupboxes then
		table.insert(parentObj.DependencyGroupboxes, sub)
	end
	table.insert(Lumen.DependencyBoxes, sub)
	return sub
end

function Elements:DependencyBox(source, expected)
	if source == nil then
		return makeObsidianDepBox(self.Body, self, false)
	end
	local sub = makeObsidianDepBox(self.Body, self, false)
	sub:SetupDependencies({{source, expected == nil and true or expected}})
	return sub
end
Elements.AddDependencyBox = function(self)
	return makeObsidianDepBox(self.Body, self, false)
end

local function normalizeObsidianArgs(idx, info)
	if type(idx) == "table" and info == nil then
		local o = table.clone(idx)
		o.Name = o.Name or o.Text or o.Title or ""
		return o
	end
	local o = type(info) == "table" and table.clone(info) or {Text = tostring(info or idx or "")}
	o.Flag = o.Flag or idx
	o.Idx = idx
	o.Name = o.Name or o.Text or o.Title or tostring(idx or "")
	return o
end

function Elements:AddToggle(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	return self:Toggle(o)
end

function Elements:AddCheckbox(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	o.Checkbox = true
	return self:Toggle(o)
end

function Elements:AddSlider(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	return self:Slider(o)
end

function Elements:AddDropdown(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	o.DictMulti = true
	return self:Dropdown(o)
end

function Elements:AddInput(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	return self:Input(o)
end

function Elements:AddButton(infoOrText, func)
	if type(infoOrText) == "string" then
		return self:Button({Name = infoOrText, Text = infoOrText, Callback = func, Func = func})
	end
	local o = type(infoOrText) == "table" and table.clone(infoOrText) or {}
	o.Name = o.Name or o.Text or "Button"
	o.Callback = o.Callback or o.Func or func
	o.Func = o.Callback
	return self:Button(o)
end

function Elements:AddLabel(infoOrText, doesWrap, idx)
	return self:Label(infoOrText, doesWrap, idx)
end

function Elements:AddDivider(labelText)
	return self:Divider(labelText)
end

function Elements:AddViewport(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	return self:Viewport(o)
end

function Elements:AddImage(idx, info)
	local o = normalizeObsidianArgs(idx, info)
	return self:Image(o)
end

local Tab = {}
local TabMeta = {__index = Tab}

local function pickColumn(tab, side)
	if side == "Right" then
		return 2
	elseif side == "Left" then
		return 1
	end
	return tab.Counts[1] <= tab.Counts[2] and 1 or 2
end

function Tab:Banner(o)
	o = o or {}
	local kindMap = {
		Info = {Key = "Accent", Icon = "info"},
		Success = {Key = "Success", Icon = "circle-check"},
		Warning = {Key = "Warning", Icon = "triangle-alert"},
		Error = {Key = "Danger", Icon = "circle-x"},
	}
	local k = kindMap[o.Type or "Warning"] or kindMap.Warning
	if self.BannerFrame then
		self.BannerFrame:Destroy()
	end
	local row = create("Frame", {
		Parent = self.Scroll,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 0.88,
		LayoutOrder = 1,
		Visible = o.Visible ~= false,
		Theme = {BackgroundColor3 = k.Key},
	}, {corner(11), stroke(k.Key, 1, 0.4), pad(11, 14)})
	self.BannerFrame = row
	local ic = icon(row, o.Icon or k.Icon, 17, k.Key)
	if ic then
		ic.Position = UDim2.fromOffset(0, 1)
	end
	local col = create("Frame", {
		Parent = row,
		Position = UDim2.fromOffset(28, 0),
		Size = UDim2.new(1, -28, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {list(2)})
	local head = text({
		Parent = col,
		Text = o.Title or o.Name or "Notice",
		Size = UDim2.new(1, 0, 0, 16),
		FontFace = FONT_B,
		LayoutOrder = 1,
		Theme = {TextColor3 = k.Key},
	})
	local body = text({
		Parent = col,
		Text = o.Content or o.Text or "",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.None,
		TextSize = 12,
		LayoutOrder = 2,
		Theme = {TextColor3 = "Text"},
	})
	return {
		SetTitle = function(_, v)
			head.Text = v
		end,
		SetContent = function(_, v)
			body.Text = v
		end,
		SetVisible = function(_, v)
			row.Visible = v
		end,
	}
end
Tab.UpdateWarningBox = Tab.Banner

function Tab:Section(o)
	o = type(o) == "string" and {Name = o} or (o or {})
	local col = pickColumn(self, o.Side)
	self.Counts[col] += 1

	local frame = registerSurface(create("Frame", {
		Parent = self.Columns[col],
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		LayoutOrder = self.Counts[col],
		Visible = o.Visible ~= false,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(12), stroke("Stroke"), list(0)}), 0.85, 0.04)

	local hasSub = o.Description ~= nil and o.Description ~= ""
	local header = create("TextButton", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, hasSub and 48 or 40),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = 1,
	})
	local x = 16
	if o.Icon then
		local ico = icon(header, o.Icon, 15, "Accent")
		if ico then
			ico.AnchorPoint = Vector2.new(0, 0.5)
			ico.Position = UDim2.new(0, 16, 0.5, 0)
			x = 40
		end
	end
	local titleLabel = text({
		Parent = header,
		Text = o.Name or "Section",
		Position = hasSub and UDim2.fromOffset(x, 8) or UDim2.fromOffset(x, 0),
		Size = hasSub and UDim2.new(1, -x - 40, 0, 16) or UDim2.new(1, -x - 40, 1, 0),
		FontFace = FONT_B,
	})
	if hasSub then
		text({
			Parent = header,
			Text = o.Description,
			Position = UDim2.fromOffset(x, 24),
			Size = UDim2.new(1, -x - 40, 0, 14),
			TextSize = 11,
			Theme = {TextColor3 = "Muted"},
		})
	end
	local chevron = icon(header, "chevron-down", 14, "Muted")
	chevron.AnchorPoint = Vector2.new(0.5, 0.5)
	chevron.Position = UDim2.new(1, -18, 0.5, 0)
	local line = create("Frame", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Theme = {BackgroundColor3 = "Stroke"},
	})
	local holder = create("Frame", {
		Parent = frame,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = 3,
	})
	local body = create("Frame", {
		Parent = holder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {pad(8, 10, 10, 10), list(3)})

	local section = setmetatable({
		Type = "Groupbox",
		Frame = frame,
		BoxHolder = frame,
		Body = body,
		Holder = body,
		Container = body,
		Tab = self,
		Items = {},
		Elements = {},
		DependencyBoxes = {},
		Order = 0,
		Name = o.Name or "Section",
		Collapsed = false,
		Visible = o.Visible ~= false,
		Destroyed = false,
	}, ElementMeta)

	function section:Resize()
	end

	function section:SetTitle(newTitle)
		self.Name = tostring(newTitle or "")
		titleLabel.Text = self.Name
	end

	function section:SetVisible(state)
		self.Visible = state ~= false
		frame.Visible = self.Visible
	end

	function section:SetPoppedOut(b, pos)
		self.PoppedOut = b == true
		if b and pos then
			self.PopoutPosition = pos
		end
	end

	function section:Destroy()
		if self.Destroyed then
			return
		end
		self.Destroyed = true
		self.Visible = false
		if frame.Parent then
			frame:Destroy()
		end
	end

	function section:SetCollapsed(state)
		if state == self.Collapsed then
			return
		end
		self.Collapsed = state
		local useAnim = animEnabled("Section Collapse")
		if state then
			holder.AutomaticSize = Enum.AutomaticSize.None
			holder.Size = UDim2.new(1, 0, 0, holder.AbsoluteSize.Y)
			apply(holder, {Size = UDim2.new(1, 0, 0, 0)}, useAnim, 0.26)
			apply(chevron, {Rotation = -90}, useAnim, 0.22)
			apply(line, {BackgroundTransparency = 1}, useAnim, 0.22)
		else
			if useAnim then
				tween(holder, {Size = UDim2.new(1, 0, 0, body.AbsoluteSize.Y)}, 0.26)
				tween(chevron, {Rotation = 0}, 0.22)
				tween(line, {BackgroundTransparency = 0}, 0.22)
				task.delay(0.28, function()
					if not self.Collapsed then
						holder.AutomaticSize = Enum.AutomaticSize.Y
					end
				end)
			else
				holder.AutomaticSize = Enum.AutomaticSize.Y
				chevron.Rotation = 0
				line.BackgroundTransparency = 0
			end
		end
	end

	if o.Collapsible ~= false and o.DisableCollapsing ~= true then
		header.Activated:Connect(function()
			section:SetCollapsed(not section.Collapsed)
		end)
	else
		chevron.Visible = false
	end
	if o.Collapsed then
		section:SetCollapsed(true)
	end

	table.insert(self.Sections, section)
	if self.Groupboxes then
		self.Groupboxes[section.Name] = section
	end
	return section
end

function Tab:AddGroupbox(info)
	local o = type(info) == "table" and table.clone(info) or {Name = tostring(info or "Groupbox")}
	if o.Side == 1 then
		o.Side = "Left"
	elseif o.Side == 2 then
		o.Side = "Right"
	end
	return self:Section(o)
end

function Tab:AddLeftGroupbox(name, iconName, visible, collapsed, disableCollapsing)
	if type(name) == "table" then
		local o = table.clone(name)
		o.Side = "Left"
		return self:Section(o)
	end
	return self:Section({
		Name = name,
		Icon = iconName,
		Side = "Left",
		Visible = visible,
		Collapsed = collapsed,
		DisableCollapsing = disableCollapsing,
	})
end

function Tab:AddRightGroupbox(name, iconName, visible, collapsed, disableCollapsing)
	if type(name) == "table" then
		local o = table.clone(name)
		o.Side = "Right"
		return self:Section(o)
	end
	return self:Section({
		Name = name,
		Icon = iconName,
		Side = "Right",
		Visible = visible,
		Collapsed = collapsed,
		DisableCollapsing = disableCollapsing,
	})
end

function Tab:AddDependencyGroupbox()
	local col = pickColumn(self, nil)
	self.Counts[col] += 1
	local sub = makeObsidianDepBox(self.Columns[col], self, true)
	sub.Frame.LayoutOrder = self.Counts[col]
	return sub
end

function Tab:Tabbox(o)
	o = type(o) == "string" and {Name = o} or (o or {})
	local parentTab = self
	local col = pickColumn(self, o.Side)
	self.Counts[col] += 1

	local frame = registerSurface(create("Frame", {
		Parent = self.Columns[col],
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		LayoutOrder = self.Counts[col],
		Visible = o.Visible ~= false,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(12), stroke("Stroke"), list(0)}), 0.85, 0.04)

	local tabBar = create("Frame", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
	}, {pad(6, 8), list(6, {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})})

	create("Frame", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		LayoutOrder = 2,
		Theme = {BackgroundColor3 = "Stroke"},
	})

	local bodyHolder = create("Frame", {
		Parent = frame,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 3,
	})

	local subTabs = {}
	local subTabsMap = {}
	local activeSub = nil
	local box = {
		Type = "Tabbox",
		Name = o.Name or "Tabbox",
		Frame = frame,
		BoxHolder = frame,
		Tab = parentTab,
		Tabs = subTabsMap,
		SubTabs = subTabs,
		Visible = o.Visible ~= false,
		Destroyed = false,
	}

	function box:Resize()
	end

	function box:SetVisible(state)
		self.Visible = state ~= false
		frame.Visible = self.Visible
	end

	function box:SetPoppedOut(b, pos)
		self.PoppedOut = b == true
		if b and pos then
			self.PopoutPosition = pos
		end
	end

	local function relayoutBar()
		local n = #subTabs
		local gap = 6
		for _, st in subTabs do
			st.TabButton.Size = UDim2.new(1 / n, -(gap * (n - 1)) / n, 1, 0)
		end
	end

	function box:Select(st)
		if type(st) == "string" then
			st = subTabsMap[st]
		end
		if not st then
			return
		end
		activeSub = st
		self.ActiveTab = st
		for _, item in subTabs do
			local on = item == st
			item.Body.Visible = on
			item:_render(on, true)
		end
	end

	function box:Tab(subOpts, iconName)
		if type(subOpts) == "string" then
			subOpts = {Name = subOpts, Icon = iconName}
		else
			subOpts = subOpts or {}
		end
		local btn = create("TextButton", {
			Parent = tabBar,
			LayoutOrder = #subTabs + 1,
			Size = UDim2.fromScale(0.5, 1),
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = T.Raised,
		}, {corner(8)})

		local innerRow = create("Frame", {
			Parent = btn,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {list(6, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})})

		local ic
		if subOpts.Icon then
			ic = icon(innerRow, subOpts.Icon, 13, T.Muted)
			if ic then
				ic.LayoutOrder = 1
			end
		end
		local tName = subOpts.Name or "Tab"
		local lbl = text({
			Parent = innerRow,
			LayoutOrder = 2,
			Text = tName,
			Size = UDim2.fromOffset(0, 28),
			AutomaticSize = Enum.AutomaticSize.X,
			TextTruncate = Enum.TextTruncate.None,
			FontFace = FONT_B,
			TextSize = 12,
			TextColor3 = T.Muted,
		})

		local body = create("Frame", {
			Parent = bodyHolder,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Visible = false,
		}, {pad(8, 10, 10, 10), list(3)})

		local subSec = setmetatable({
			Type = "SubTab",
			Frame = frame,
			BoxHolder = frame,
			Body = body,
			Holder = body,
			Container = body,
			Tab = parentTab,
			TabButton = btn,
			Items = {},
			Elements = {},
			DependencyBoxes = {},
			Order = 0,
			Name = tName,
		}, ElementMeta)

		function subSec:Resize()
		end

		function subSec:_render(on, animate)
			apply(btn, {
				BackgroundColor3 = on and T.Accent or T.Raised,
				BackgroundTransparency = on and 0.82 or 0.35,
			}, animate, 0.18)
			apply(lbl, {TextColor3 = on and T.Text or T.Muted}, animate, 0.18)
			if ic then
				apply(ic, {ImageColor3 = on and T.Accent or T.Muted}, animate, 0.18)
			end
		end
		onTheme(function(animate)
			subSec:_render(activeSub == subSec, animate)
		end)

		btn.Activated:Connect(function()
			box:Select(subSec)
		end)

		table.insert(subTabs, subSec)
		subTabsMap[#subTabs] = subSec
		subTabsMap[tName] = subSec
		table.insert(parentTab.Sections, subSec)
		relayoutBar()
		if #subTabs == 1 then
			box:Select(subSec)
		end
		return subSec
	end
	box.AddTab = box.Tab

	if self.Tabboxes then
		self.Tabboxes[box.Name] = box
		table.insert(self.Tabboxes, box)
	end
	return box
end

function Tab:AddTabbox(info)
	local o = type(info) == "table" and table.clone(info) or {Name = tostring(info or "Tabbox")}
	if o.Side == 1 then
		o.Side = "Left"
	elseif o.Side == 2 then
		o.Side = "Right"
	end
	return self:Tabbox(o)
end

function Tab:AddLeftTabbox(name, iconName)
	local o = type(name) == "table" and table.clone(name) or {Name = name or "Tabbox", Icon = iconName}
	o.Side = "Left"
	return self:Tabbox(o)
end

function Tab:AddRightTabbox(name, iconName)
	local o = type(name) == "table" and table.clone(name) or {Name = name or "Tabbox", Icon = iconName}
	o.Side = "Right"
	return self:Tabbox(o)
end

function Tab:Show()
	self.Window:Select(self)
end

function Tab:Filter(query)
	for _, section in self.Sections do
		local any = false
		for _, item in section.Items do
			local show = query == "" or (item.Name ~= false and item.Name:find(query, 1, true) ~= nil)
			item.Row.Visible = show
			any = any or show
		end
		section.Frame.Visible = (query == "" and section.Visible ~= false) or any
	end
end

local Window = {}
Window.__index = Window

local Hub = {}
Hub.__index = Hub

function Window:_apply()
	local hub = self.Hub
	local want = hub.Ready and hub.Visible and self.Opened and not self.Minimized
	local targetScale = Lumen.Config.Scale or 1
	if want == self.Shown then
		return
	end
	self.Shown = want
	self.Token += 1
	local token = self.Token
	local root, scale, body = self.Root, self.Scale, self.Body
	local style = Lumen.Config.WindowAnimStyle or "Scale & Slide"
	local dur = Lumen.Config.WindowAnimSpeed or 0.38
	local useAnim = animEnabled("Window Toggle") and style ~= "Instant"

	if want then
		root.Visible = true
		body.Rotation = 0
		if not useAnim then
			root.Position = self.Rest
			scale.Scale = targetScale
			body.GroupTransparency = 0
			self.AtDock = false
		else
			if not self.AtDock then
				local slideOff = (style == "Scale & Slide" or style == "Slide") and 24 or 0
				local startScale = (style == "Scale & Slide" or style == "Scale" or style == "Bounce") and (targetScale * 0.92) or targetScale
				root.Position = self.Rest + UDim2.fromOffset(0, slideOff)
				scale.Scale = startScale
				body.GroupTransparency = 1
			end
			self.AtDock = false
			local ease = style == "Bounce" and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
			tween(root, {Position = self.Rest}, dur, ease)
			tween(scale, {Scale = targetScale}, dur, ease)
			tween(body, {GroupTransparency = 0}, dur * 0.72)
		end
	else
		if not useAnim then
			self.AtDock = false
			body.GroupTransparency = 1
			root.Visible = false
		else
			local closeDur = math.max(0.14, dur * 0.65)
			if self.Minimized and self.Opened and hub.Visible then
				self.AtDock = true
				tween(root, {Position = hub:_iconCenter(self)}, closeDur)
				tween(scale, {Scale = 0.18}, closeDur)
			else
				self.AtDock = false
				local slideOff = (style == "Scale & Slide" or style == "Slide") and 14 or 0
				local endScale = (style == "Scale & Slide" or style == "Scale" or style == "Bounce") and (targetScale * 0.95) or targetScale
				tween(root, {Position = self.Rest + UDim2.fromOffset(0, slideOff)}, closeDur)
				tween(scale, {Scale = endScale}, closeDur)
			end
			tween(body, {GroupTransparency = 1}, closeDur * 0.85)
			task.delay(closeDur + 0.04, function()
				if self.Token == token then
					root.Visible = false
				end
			end)
		end
	end
	hub:_refreshDock()
	hub:_refreshBlur()
	hub:_refreshMouse()
end

function Window:Focus()
	self.Hub:_focus(self)
end

function Window:Open()
	self.Opened = true
	self.Minimized = false
	self.Hub:_focus(self)
	self:_apply()
end

function Window:Close()
	self.Opened = false
	self.Minimized = false
	self:_apply()
end

function Window:Minimize()
	self.Minimized = true
	self:_apply()
end

function Window:Restore()
	self.Minimized = false
	self.Hub:_focus(self)
	self:_apply()
end

function Window:Toggle()
	if self.Opened and not self.Minimized then
		self:Close()
	else
		self:Open()
	end
end

function Window:Notify(o)
	return self.Hub:Notify(o)
end

function Window:Dialog(idxOrOpts, opts)
	local o = type(idxOrOpts) == "table" and idxOrOpts or (opts or {})
	if self.DialogBackdrop then
		self.DialogBackdrop:Destroy()
	end
	local backdrop = create("TextButton", {
		Parent = self.Body,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = BLACK,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 60,
	})
	self.DialogBackdrop = backdrop
	local card = create("CanvasGroup", {
		Parent = backdrop,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(360, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(14), stroke("Stroke"), pad(18), list(12)})
	local sc = create("UIScale", {Parent = card, Scale = 0.92})

	text({
		Parent = card,
		Text = o.Title or "Confirm Action",
		Size = UDim2.new(1, 0, 0, 20),
		FontFace = FONT_X,
		TextSize = 15,
		LayoutOrder = 1,
	})
	text({
		Parent = card,
		Text = o.Content or o.Description or "Are you sure you want to continue?",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.None,
		TextSize = 12,
		LayoutOrder = 2,
		Theme = {TextColor3 = "Muted"},
	})

	local actions = create("Frame", {
		Parent = card,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
	}, {list(8, {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right})})

	local function closeDialog()
		if not backdrop.Parent then
			return
		end
		tween(backdrop, {BackgroundTransparency = 1}, 0.16)
		tween(card, {GroupTransparency = 1}, 0.15)
		tween(sc, {Scale = 0.92}, 0.15)
		task.delay(0.17, function()
			if backdrop.Parent then
				backdrop:Destroy()
			end
		end)
	end

	if type(o.FooterButtons) == "table" then
		for name, info in o.FooterButtons do
			local btnTitle = type(info) == "table" and (info.Title or name) or tostring(name)
			local variant = type(info) == "table" and info.Variant or "Ghost"
			local isPrimary = variant == "Primary" or variant == "Destructive"
			local isDanger = variant == "Destructive" or (type(info) == "table" and info.Risky)
			local b = registerFont(create("TextButton", {
				Parent = actions,
				LayoutOrder = type(info) == "table" and (info.Order or 1) or 1,
				Size = UDim2.fromOffset(102, 32),
				AutoButtonColor = false,
				Text = btnTitle,
				FontFace = FONT_B,
				TextSize = 12,
				TextColor3 = isPrimary and WHITE or T.Text,
				Theme = {BackgroundColor3 = isDanger and "Danger" or (isPrimary and "Accent" or "Raised")},
			}, {corner(8), not isPrimary and stroke("Stroke") or nil}), "B")
			b.Activated:Connect(function()
				local cb = type(info) == "table" and (info.Callback or info.Func) or (type(info) == "function" and info or nil)
				if cb then
					task.spawn(cb)
				end
				if not (type(info) == "table" and info.Wait) then
					closeDialog()
				end
			end)
		end
	else
		local cancelBtn = registerFont(create("TextButton", {
			Parent = actions,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(96, 32),
			AutoButtonColor = false,
			Text = o.CancelText or "Cancel",
			FontFace = FONT_B,
			TextSize = 12,
			Theme = {BackgroundColor3 = "Raised", TextColor3 = "Text"},
		}, {corner(8), stroke("Stroke")}), "B")

		local confirmColor = o.Risky and "Danger" or "Accent"
		local confirmBtn = registerFont(create("TextButton", {
			Parent = actions,
			LayoutOrder = 2,
			Size = UDim2.fromOffset(108, 32),
			AutoButtonColor = false,
			Text = o.ConfirmText or "Confirm",
			FontFace = FONT_B,
			TextSize = 12,
			TextColor3 = WHITE,
			Theme = {BackgroundColor3 = confirmColor},
		}, {corner(8)}), "B")

		cancelBtn.Activated:Connect(function()
			closeDialog()
			if o.OnCancel then
				task.spawn(o.OnCancel)
			end
		end)
		confirmBtn.Activated:Connect(function()
			closeDialog()
			if o.Callback then
				task.spawn(o.Callback)
			end
		end)
	end

	if o.ClickOutsideToClose ~= false then
		backdrop.Activated:Connect(function()
			if not inside(card, mouse()) then
				closeDialog()
			end
		end)
	end

	tween(backdrop, {BackgroundTransparency = 0.45}, 0.18)
	tween(card, {GroupTransparency = 0}, 0.18)
	tween(sc, {Scale = 1}, 0.22, Enum.EasingStyle.Back)
	return {Dismiss = closeDialog, Destroy = closeDialog}
end
Window.AddDialog = Window.Dialog

function Window:SetCompact(state)
	self.Compact = state == true
	local w = self.Compact and 62 or (self.ExpandedWidth or Lumen.Config.SidebarWidth or 216)
	self:_applySidebarWidth(w, true)
end

function Window:SetSidebarWidth(width)
	width = math.clamp(tonumber(width) or 216, 150, 320)
	self.ExpandedWidth = width
	if not self.Compact then
		self:_applySidebarWidth(width, true)
	end
end

function Window:GetSidebarWidth()
	return self.Compact and 62 or (self.ExpandedWidth or Lumen.Config.SidebarWidth or 216)
end

function Window:SetAlwaysOnTop(state)
	self.AlwaysOnTop = state == true
	Gui.DisplayOrder = self.AlwaysOnTop and 2147483647 or 999
end

function Window:SetSnapping(enabled, dist, margin, avoid)
	Lumen.Config.Snapping = enabled ~= false
	if dist then
		Lumen.Config.SnapDistance = tonumber(dist) or 24
	end
	self.SnapMargin = margin
	self.AvoidTaskbar = avoid
end

function Window:SetAnimations(animTable, transitionTime, swipeOffset, swipeDirection)
	if type(animTable) == "table" then
		local map = {
			ToggleWindow = "Window Toggle",
			TabSwitch = "Tab Switch",
			Groupbox = "Section Collapse",
			Dropdown = "Dropdown Menu",
			KeyPicker = "Popups",
			ColorPicker = "Popups",
			SubButton = "Button Ripple",
		}
		for k, v in animTable do
			local mapped = map[k] or k
			Lumen.Config.Animations[mapped] = v == true
		end
	end
	if transitionTime then
		Lumen.Config.TabAnimSpeed = tonumber(transitionTime) or 0.28
	end
	if swipeOffset then
		Lumen.Config.TabSwipeOffset = tonumber(swipeOffset) or 18
	end
	if swipeDirection then
		local dirMap = {
			Bottom = "Slide Bottom",
			Top = "Slide Top",
			Right = "Slide Right",
			Left = "Slide Left",
		}
		Lumen.Config.TabAnimStyle = dirMap[swipeDirection] or swipeDirection
	end
end

function Window:SetCornerRadius(r)
	Lumen:SetCornerRadius(r)
end

function Window:_applySidebarWidth(w, animate)
	local compact = self.Compact
	apply(self.Side, {Size = UDim2.new(0, w, 1, 0)}, animate, 0.24)
	apply(self.Content, {Position = UDim2.fromOffset(w, 0), Size = UDim2.new(1, -w, 1, 0)}, animate, 0.24)
	self.BrandTitle.Visible = not compact
	self.BrandDesc.Visible = not compact
	self.FooterName.Visible = not compact
	self.FooterUser.Visible = not compact
	self.CollapseBtn.Position = compact and UDim2.new(0.5, 0, 0, 56) or UDim2.new(1, -12, 0, 24)
	self.CollapseBtn.AnchorPoint = compact and Vector2.new(0.5, 0) or Vector2.new(1, 0)
	self.CollapseIcon.Rotation = compact and 180 or 0
	for _, cat in self.Categories do
		cat.Visible = not compact
	end
	for _, t in self.Tabs do
		t.Label.Visible = not compact
		t.Icon.Position = compact and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 14, 0.5, 0)
		t.Icon.AnchorPoint = compact and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
	end
end

function Window:SetBackgroundImage(imageId, alpha, scaleMode)
	if imageId ~= nil then
		local id = tostring(imageId)
		if id ~= "" and not id:find("://") and tonumber(id) then
			id = "rbxassetid://" .. id
		end
		self.BgImage.Image = id
		self.BgImage.Visible = id ~= ""
	end
	if alpha ~= nil then
		self.BgImage.ImageTransparency = math.clamp(tonumber(alpha) or 0.82, 0, 1)
	end
	if scaleMode then
		local map = {
			Crop = Enum.ScaleType.Crop,
			Stretch = Enum.ScaleType.Stretch,
			Fit = Enum.ScaleType.Fit,
			Tile = Enum.ScaleType.Tile,
		}
		self.BgImage.ScaleType = map[scaleMode] or Enum.ScaleType.Crop
		if scaleMode == "Tile" then
			self.BgImage.TileSize = UDim2.fromOffset(256, 256)
		end
	end
end

function Window:SetTopAccent(enabled)
	if self.TopAccent then
		self.TopAccent.Visible = enabled ~= false
	end
end

function Window:Destroy()
	self.Hub:_dockRemove(self)
	local list_ = self.Hub.Windows
	local i = table.find(list_, self)
	if i then
		table.remove(list_, i)
	end
	self.Root:Destroy()
end

function Window:Category(name)
	local label = text({
		Parent = self.TabsScroll,
		Text = string.upper(name),
		Position = UDim2.fromOffset(20, self.Cursor + 6),
		Size = UDim2.new(1, -40, 0, 16),
		FontFace = FONT_X,
		TextSize = 10,
		Visible = not self.Compact,
		Theme = {TextColor3 = "Muted"},
	})
	label.TextTransparency = 0.15
	table.insert(self.Categories, label)
	self.Cursor += 30
	self.TabsScroll.CanvasSize = UDim2.fromOffset(0, self.Cursor + 8)
end

function Window:Select(tab)
	if self.Active == tab then
		return
	end
	local prev = self.Active
	self.Active = tab
	Lumen.ActiveTab = tab
	self.PageToken += 1
	if prev then
		prev:Filter("")
	end
	for _, t in self.Tabs do
		t:_style(t == tab, true)
		t.Page.Visible = (t == tab)
	end
	self.Indicator.Visible = true
	local useAnim = animEnabled("Tab Switch") and Lumen.Config.TabAnimStyle ~= "Instant"
	local dur = Lumen.Config.TabAnimSpeed or 0.24
	local offset = Lumen.Config.TabSwipeOffset or 14
	local style = Lumen.Config.TabAnimStyle or "Slide Bottom"

	if prev and useAnim then
		tween(self.Indicator, {Position = UDim2.fromOffset(10, tab.Y)}, dur)
	else
		self.Indicator.Position = UDim2.fromOffset(10, tab.Y)
	end
	self.Heading.Text = tab.Name
	self.Search.Text = ""

	local page = tab.Page
	local scroll = tab.Scroll
	page.Visible = true
	if useAnim and scroll then
		local startPos = UDim2.fromOffset(0, 0)
		if style == "Slide Bottom" or style == "Auto" or style == "auto" then
			startPos = UDim2.fromOffset(0, offset)
		elseif style == "Slide Top" then
			startPos = UDim2.fromOffset(0, -offset)
		elseif style == "Slide Right" then
			startPos = UDim2.fromOffset(offset, 0)
		elseif style == "Slide Left" then
			startPos = UDim2.fromOffset(-offset, 0)
		end
		scroll.Position = startPos
		tween(scroll, {Position = UDim2.fromOffset(0, 0)}, dur, Enum.EasingStyle.Quint)
	elseif scroll then
		scroll.Position = UDim2.fromOffset(0, 0)
	end
	if self.Hub then
		self.Hub:_refreshDock()
	end
end

local TabLucideMap = {
	home = "house",
	info = "info",
	favourites = "star",
	favorites = "star",
	attack = "swords",
	combat = "swords",
	target = "crosshair",
	blobman = "venetian-mask",
	defense = "shield",
	invincibility = "shield",
	clicker = "mouse-pointer-click",
	["auto clicker"] = "mouse-pointer-click",
	["auto-clicker"] = "mouse-pointer-click",
	grab = "hand-grab",
	props = "boxes",
	player = "person-standing",
	visuals = "eye",
	visual = "eye",
	misc = "shapes",
	testing = "flask-conical",
	keybinds = "keyboard",
	lists = "scroll-text",
	settings = "settings",
	["ui settings"] = "settings",
	configs = "folder",
}

local function pickTabLucideIcon(tabName, passedIcon)
	local clean = tostring(tabName or ""):gsub("<[^>]+>", ""):lower():gsub("^2%s+", ""):match("^%s*(.-)%s*$")
	if TabLucideMap[clean] then
		return TabLucideMap[clean]
	end
	if type(passedIcon) == "string" and passedIcon ~= "" and not passedIcon:find("^%d+$") and not passedIcon:find("://") then
		return passedIcon
	end
	return passedIcon or "layout-grid"
end

function Window:Tab(o, iconName, description)
	if type(o) == "string" then
		o = {Name = o, Icon = iconName, Description = description, Tooltip = description}
	else
		o = o or {}
		o.Name = o.Name or o.Title or "Tab"
		o.Icon = o.Icon or iconName
		o.Tooltip = o.Tooltip or o.Description or description
	end
	local resolvedIcon = pickTabLucideIcon(o.Name, o.Icon)
	local win = self
	local tab = setmetatable({
		Window = self,
		Name = o.Name or "Tab",
		IconName = resolvedIcon,
		Sections = {},
		Groupboxes = {},
		Tabboxes = {},
		DependencyGroupboxes = {},
		Counts = {0, 0},
		Y = self.Cursor,
	}, TabMeta)
	self.Cursor += 40
	self.TabsScroll.CanvasSize = UDim2.fromOffset(0, self.Cursor + 8)

	local btn = create("TextButton", {
		Parent = self.TabsScroll,
		Position = UDim2.fromOffset(10, tab.Y),
		Size = UDim2.new(1, -20, 0, 36),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 2,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(10)})
	local ico = icon(btn, resolvedIcon, 16, T.Muted)
	ico.AnchorPoint = self.Compact and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
	ico.Position = self.Compact and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 14, 0.5, 0)
	local label = text({
		Parent = btn,
		Text = tab.Name,
		Position = UDim2.fromOffset(42, 0),
		Size = UDim2.new(1, -50, 1, 0),
		FontFace = FONT_B,
		Visible = not self.Compact,
		TextColor3 = T.Muted,
	})
	tooltip(btn, function()
		return win.Compact and tab.Name or (o.Tooltip or "")
	end)

	function tab:_style(on, animate)
		local labelColor = on and T.Text or T.Muted
		local iconColor = on and T.Accent or T.Muted
		apply(label, {TextColor3 = labelColor}, animate, 0.22)
		apply(ico, {ImageColor3 = iconColor}, animate, 0.22)
	end
	onTheme(function(animate)
		tab:_style(win.Active == tab, animate)
	end)

	btn.MouseEnter:Connect(function()
		if win.Active ~= tab then
			apply(btn, {BackgroundTransparency = 0.5}, true, 0.14, "Hover Effects")
			apply(label, {TextColor3 = T.Text}, true, 0.14, "Hover Effects")
		end
	end)
	btn.MouseLeave:Connect(function()
		apply(btn, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
		if win.Active ~= tab then
			apply(label, {TextColor3 = T.Muted}, true, 0.18, "Hover Effects")
		end
	end)
	btn.Activated:Connect(function()
		closePopup()
		win:Select(tab)
	end)

	local page = create("Frame", {
		Parent = self.Pages,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
	})
	local scroll = create("ScrollingFrame", {
		Parent = page,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Theme = {ScrollBarImageColor3 = "Stroke"},
	}, {pad(18, 20, 22, 20), list(14)})
	local layout = list(14, {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Top})
	local holder = create("Frame", {
		Parent = scroll,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 10,
	}, {layout})
	local columns = {}
	for i = 1, 2 do
		columns[i] = create("Frame", {
			Parent = holder,
			Size = UDim2.new(0.5, -7, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = i,
		}, {list(14)})
	end
	local function relayout()
		local wide = scroll.AbsoluteSize.X >= 500
		layout.FillDirection = wide and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
		for _, c in columns do
			c.Size = wide and UDim2.new(0.5, -7, 0, 0) or UDim2.fromScale(1, 0)
		end
	end
	scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(relayout)
	relayout()

	tab.Page = page
	tab.Scroll = scroll
	tab.Sides = {scroll}
	tab.Columns = columns
	tab.Button = btn
	tab.Icon = ico
	tab.Label = label

	table.insert(self.Tabs, tab)
	Lumen.Tabs[tab.Name] = tab
	if self.Hub then
		self.Hub:_dockAddTab(self, tab)
	end
	if #self.Tabs == 1 then
		self:Select(tab)
	end
	return tab
end
Window.AddTab = Window.Tab

function Hub:Window(o)
	o = o or {}
	local view = Gui.AbsoluteSize
	local autoCompact = view.X > 0 and view.X < 680
	local isCompact = o.Compact ~= nil and o.Compact or (Lumen.Config.CompactSidebar or autoCompact)
	local SW = isCompact and 62 or (Lumen.Config.SidebarWidth or 216)

	local reqSize = o.Size or UDim2.fromOffset(920, 600)
	local initW = reqSize.X.Offset
	local initH = reqSize.Y.Offset
	if view.X > 0 and view.Y > 0 then
		initW = math.min(initW, math.max(500, view.X - 24))
		initH = math.min(initH, math.max(360, view.Y - 92))
	end

	local win = setmetatable({
		Hub = self,
		Name = o.Name or o.Title or "Window",
		Description = o.Description or o.Sub or o.Footer or "",
		IconName = o.Icon or "layers",
		Settings = o,
		MobileButtons = {},
		Tabs = {},
		Categories = {},
		Compact = isCompact,
		ExpandedWidth = Lumen.Config.SidebarWidth or 216,
		Opened = (o.Open ~= false) and (o.Visible ~= false) and (o.AutoShow ~= false),
		Minimized = false,
		Shown = false,
		AtDock = false,
		Token = 0,
		PageToken = 0,
		Cursor = 8,
	}, Window)
	local index = #self.Windows + 1
	self.Z += 1
	local minW, minH = 480, 340

	local defaultPos = UDim2.new(0.5, (index - 1) * 28, 0.5, (index - 1) * 28 - 18)
	local initPos = (o.Center == false and o.Position) and o.Position or (o.Position or defaultPos)

	local root = create("Frame", {
		Name = win.Name,
		Parent = Layers.Windows,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = initPos,
		Size = UDim2.fromOffset(initW, initH),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = self.Z,
	})
	local scale = create("UIScale", {Parent = root, Scale = (Lumen.Config.Scale or 1) * 0.94})
	local body = registerSurface(create("CanvasGroup", {
		Parent = root,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Back"},
	}, {corner(16)}), 1, 0)
	rim(body)

	local bgImage = create("ImageLabel", {
		Parent = body,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = "",
		ImageTransparency = Lumen.Config.BackgroundImageAlpha or 0.82,
		ScaleType = Enum.ScaleType.Crop,
		Visible = false,
		ZIndex = 0,
	})
	win.BgImage = bgImage
	if Lumen.Config.BackgroundImage and Lumen.Config.BackgroundImage ~= "" then
		win:SetBackgroundImage(Lumen.Config.BackgroundImage, Lumen.Config.BackgroundImageAlpha, Lumen.Config.BackgroundScale)
	end

	local topAccent = create("Frame", {
		Parent = body,
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = WHITE,
		Visible = Lumen.Config.TopAccentLine ~= false,
		ZIndex = 20,
	})
	local topGrad = create("UIGradient", {
		Parent = topAccent,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.65),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.65),
		}),
	})
	accentGradient(topGrad)
	win.TopAccent = topAccent

	win.Root, win.MainFrame, win.Rest, win.Scale, win.Body = root, root, root.Position, scale, body

	local side = registerSurface(create("Frame", {
		Parent = body,
		Size = UDim2.new(0, SW, 1, 0),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Side"},
	}), 0.9, 0.04)
	create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Stroke"},
	})
	win.Side = side

	local brand = create("Frame", {Parent = side, Size = UDim2.new(1, 0, 0, 74), BackgroundTransparency = 1})
	local brandHit = hit(brand)
	brandHit.ZIndex = 0
	local bubble = create("Frame", {
		Parent = brand,
		Position = UDim2.fromOffset(14, 18),
		Size = UDim2.fromOffset(36, 36),
		BackgroundColor3 = WHITE,
	}, {corner(11), create("UIGradient", {Rotation = 45})})
	accentGradient(bubble:FindFirstChildOfClass("UIGradient"))
	center(icon(bubble, win.IconName, 18, WHITE))
	local brandTitle = text({
		Parent = brand,
		Text = win.Name,
		Position = UDim2.fromOffset(60, 18),
		Size = UDim2.new(1, -96, 0, 18),
		FontFace = FONT_X,
		TextSize = 14,
	})
	local brandDesc = text({
		Parent = brand,
		Text = win.Description,
		Position = UDim2.fromOffset(60, 37),
		Size = UDim2.new(1, -96, 0, 14),
		TextSize = 11,
		Theme = {TextColor3 = "Muted"},
	})
	local collapseBtn = create("TextButton", {
		Parent = brand,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 24),
		Size = UDim2.fromOffset(26, 26),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 3,
		Theme = {BackgroundColor3 = "Hover"},
	}, {corner(7)})
	local collapseIcon = center(icon(collapseBtn, "chevron-left", 14, "Muted"))
	collapseBtn.MouseEnter:Connect(function()
		apply(collapseBtn, {BackgroundTransparency = 0.25}, true, 0.14, "Hover Effects")
		apply(collapseIcon, {ImageColor3 = T.Text}, true, 0.14, "Hover Effects")
	end)
	collapseBtn.MouseLeave:Connect(function()
		apply(collapseBtn, {BackgroundTransparency = 1}, true, 0.16, "Hover Effects")
		apply(collapseIcon, {ImageColor3 = T.Muted}, true, 0.16, "Hover Effects")
	end)
	collapseBtn.Activated:Connect(function()
		win:SetCompact(not win.Compact)
	end)
	tooltip(collapseBtn, "Toggle compact sidebar")
	win.BrandTitle, win.BrandDesc, win.CollapseBtn, win.CollapseIcon = brandTitle, brandDesc, collapseBtn, collapseIcon

	local tabsScroll = create("ScrollingFrame", {
		Parent = side,
		Position = UDim2.fromOffset(0, 78),
		Size = UDim2.new(1, 0, 1, -146),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
	})
	local indicator = create("Frame", {
		Parent = tabsScroll,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -20, 0, 36),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 1,
		Theme = {BackgroundColor3 = "Accent"},
	}, {corner(10)})
	create("Frame", {
		Parent = indicator,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(3, 16),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Accent"},
	}, {corner(2)})

	local footer = create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 68),
		BackgroundTransparency = 1,
	})
	create("Frame", {
		Parent = footer,
		Size = UDim2.new(1, -1, 0, 1),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Stroke"},
	})
	local player = Players.LocalPlayer
	create("ImageLabel", {
		Parent = footer,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 14, 0.5, 0),
		Size = UDim2.fromOffset(34, 34),
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=60&h=60",
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(PILL)})
	local footerName = text({
		Parent = footer,
		Text = player.DisplayName,
		Position = UDim2.fromOffset(58, 18),
		Size = UDim2.new(1, -68, 0, 16),
		FontFace = FONT_B,
		TextSize = 12,
	})
	local footerUser = text({
		Parent = footer,
		Text = "@" .. player.Name,
		Position = UDim2.fromOffset(58, 35),
		Size = UDim2.new(1, -68, 0, 14),
		TextSize = 11,
		Theme = {TextColor3 = "Muted"},
	})
	win.FooterName, win.FooterUser = footerName, footerUser

	local content = create("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(SW, 0),
		Size = UDim2.new(1, -SW, 1, 0),
		BackgroundTransparency = 1,
	})
	win.Content = content

	local top = create("Frame", {Parent = content, Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1})
	local topHit = hit(top)
	topHit.ZIndex = 0
	local heading = text({
		Parent = top,
		Text = win.Name,
		Position = UDim2.fromOffset(22, 0),
		Size = UDim2.new(1, -350, 1, 0),
		FontFace = FONT_X,
		TextSize = 16,
	})
	create("Frame", {
		Parent = content,
		Position = UDim2.fromOffset(0, 56),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Stroke"},
	})

	local controls = create("Frame", {
		Parent = top,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Size = UDim2.fromOffset(0, 32),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
	}, {list(4, {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})})

	local function control(name, order, danger, action)
		local b = create("TextButton", {
			Parent = controls,
			Size = UDim2.fromOffset(32, 32),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = order,
			BackgroundColor3 = T.Hover,
		}, {corner(9)})
		local ic = center(icon(b, name, 16, T.Muted))
		b.MouseEnter:Connect(function()
			apply(b, {BackgroundTransparency = danger and 0.8 or 0.2, BackgroundColor3 = danger and T.Danger or T.Hover}, true, 0.14, "Hover Effects")
			apply(ic, {ImageColor3 = danger and T.Danger or T.Text}, true, 0.14, "Hover Effects")
		end)
		b.MouseLeave:Connect(function()
			apply(b, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
			apply(ic, {ImageColor3 = T.Muted}, true, 0.18, "Hover Effects")
		end)
		b.Activated:Connect(action)
	end
	control("minus", 1, false, function()
		win:Minimize()
	end)
	control("x", 2, true, function()
		win:Close()
	end)

	local searchBox = create("Frame", {
		Parent = top,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -94, 0.5, 0),
		Size = UDim2.fromOffset(184, 32),
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(9)})
	local searchRing = stroke("Stroke")
	searchRing.Parent = searchBox
	local glass = icon(searchBox, "search", 14, "Muted")
	glass.AnchorPoint = Vector2.new(0, 0.5)
	glass.Position = UDim2.new(0, 11, 0.5, 0)
	local search = registerFont(create("TextBox", {
		Parent = searchBox,
		Position = UDim2.fromOffset(32, 0),
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Search features...",
		FontFace = FONT,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		Theme = {TextColor3 = "Text", PlaceholderColor3 = "Muted"},
	}), "M")
	search.Focused:Connect(function()
		tween(searchBox, {Size = UDim2.fromOffset(236, 32)}, 0.3)
		tween(searchRing, {Color = T.Accent}, 0.18)
	end)
	search.FocusLost:Connect(function()
		tween(searchBox, {Size = UDim2.fromOffset(184, 32)}, 0.3)
		tween(searchRing, {Color = T.Stroke}, 0.18)
	end)
	search:GetPropertyChangedSignal("Text"):Connect(function()
		local q = search.Text:lower()
		if Lumen.GlobalSearch and q ~= "" then
			for _, t in win.Tabs do
				t:Filter(q)
			end
		elseif win.Active then
			win.Active:Filter(q)
		end
	end)

	local pages = create("Frame", {
		Parent = content,
		Position = UDim2.fromOffset(0, 57),
		Size = UDim2.new(1, 0, 1, -57),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	local function saveRest()
		win.Rest = root.Position
	end
	drag(brandHit, root, saveRest, true)
	drag(topHit, root, saveRest, true)

	local grip = create("TextButton", {
		Parent = body,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		Size = UDim2.fromOffset(24, 24),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Visible = o.Resizable ~= false,
		ZIndex = 5,
	})
	win.ResizeButton = grip
	for i = 0, 1 do
		create("Frame", {
			Parent = grip,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -7 - i * 4, 1, -7 - i * 4),
			Size = UDim2.fromOffset(2, 2),
			BorderSizePixel = 0,
			BackgroundTransparency = 0.35,
			Theme = {BackgroundColor3 = "Muted"},
		}, {corner(PILL)})
	end
	local resizing, startMouse, startSize, startPos
	grip.InputBegan:Connect(function(i)
		if isPress(i) and grip.Visible then
			resizing = true
			startMouse = mouse(i)
			startSize = root.Size
			startPos = root.Position
		end
	end)
	link(UIS.InputChanged, function(i)
		if resizing and isMove(i) then
			local sc = Lumen.Config.Scale or 1
			local d = (mouse(i) - startMouse) / sc
			local curView = Gui.AbsoluteSize
			local w = math.clamp(startSize.X.Offset + d.X, minW, (curView.X - 16) / sc)
			local h = math.clamp(startSize.Y.Offset + d.Y, minH, (curView.Y - 16) / sc)
			root.Size = UDim2.fromOffset(w, h)
			root.Position = startPos + UDim2.fromOffset((w - startSize.X.Offset) * sc / 2, (h - startSize.Y.Offset) * sc / 2)
		end
	end)
	link(UIS.InputEnded, function(i)
		if resizing and isPress(i) then
			resizing = false
			saveRest()
		end
	end)

	win.Heading, win.Search, win.Indicator, win.TabsScroll, win.Pages = heading, search, indicator, tabsScroll, pages
	if win.Compact then
		win:_applySidebarWidth(62, false)
	end

	table.insert(self.Windows, win)
	table.insert(Lumen.Windows, win)
	self:_dockAdd(win)
	task.defer(function()
		win:_apply()
	end)
	return win
end

local Kinds = {
	Info = {Key = "Accent", Icon = "info"},
	Success = {Key = "Success", Icon = "circle-check"},
	Warning = {Key = "Warning", Icon = "triangle-alert"},
	Error = {Key = "Danger", Icon = "circle-x"},
}

local function kindOf(t)
	t = tostring(t or "Info")
	t = t:sub(1, 1):upper() .. t:sub(2):lower()
	return Kinds[t] or Kinds.Info
end

local function ago(t)
	local d = os.time() - t
	if d < 60 then
		return "now"
	elseif d < 3600 then
		return math.floor(d / 60) .. "m"
	elseif d < 86400 then
		return math.floor(d / 3600) .. "h"
	end
	return math.floor(d / 86400) .. "d"
end

local function bounce(ic)
	tween(ic, {Position = UDim2.new(0.5, 0, 0.5, -8)}, 0.12)
	task.delay(0.12, function()
		tween(ic, {Position = UDim2.fromScale(0.5, 0.5)}, 0.45, Enum.EasingStyle.Bounce)
	end)
end

local function pressable(btn, scaleObj, over, down)
	btn.MouseEnter:Connect(function()
		tween(scaleObj, {Scale = over}, 0.26, Enum.EasingStyle.Back)
	end)
	btn.MouseLeave:Connect(function()
		tween(scaleObj, {Scale = 1}, 0.22)
	end)
	btn.MouseButton1Down:Connect(function()
		tween(scaleObj, {Scale = down}, 0.08)
	end)
	btn.MouseButton1Up:Connect(function()
		tween(scaleObj, {Scale = over}, 0.3, Enum.EasingStyle.Back)
	end)
end

function Hub:_iconCenter(win)
	local e = self.Entries[win]
	if not e then
		return win.Rest
	end
	local p, s = e.Button.AbsolutePosition, e.Button.AbsoluteSize
	return UDim2.fromOffset(p.X + s.X / 2, p.Y + s.Y / 2)
end

function Hub:_focus(win)
	self.Z += 1
	win.Root.ZIndex = self.Z
	self.Focused = win
	self:_refreshDock()
end

function Hub:_refreshDock()
	local singleWin = #self.Windows == 1 and self.Windows[1] or nil
	if singleWin and #singleWin.Tabs > 0 then
		for win, e in self.Entries do
			e.Button.Visible = false
		end
		if self.TabEntries then
			for tab, e in self.TabEntries do
				e.Button.Visible = true
				local active = singleWin.Opened and not singleWin.Minimized and singleWin.Active == tab
				tween(e.Indicator, {
					Size = UDim2.fromOffset(active and 16 or 0, 3),
					BackgroundColor3 = active and T.Accent or T.Muted,
				}, 0.22)
				tween(e.Icon, {ImageColor3 = active and T.Accent or T.Muted}, 0.2)
				tween(e.Button, {BackgroundTransparency = active and 0.82 or 1}, 0.2)
			end
		end
	else
		if self.TabEntries then
			for _, e in self.TabEntries do
				e.Button.Visible = false
			end
		end
		for win, e in self.Entries do
			e.Button.Visible = true
			local opened = win.Opened
			local focused = opened and not win.Minimized and self.Focused == win
			tween(e.Indicator, {
				Size = UDim2.fromOffset(opened and (focused and 16 or 6) or 0, 3),
				BackgroundColor3 = focused and T.Accent or T.Muted,
			}, 0.26)
			tween(e.Icon, {ImageColor3 = opened and T.Text or T.Muted}, 0.22)
		end
	end
end

function Hub:_dockAddTab(win, tab)
	self.TabEntries = self.TabEntries or {}
	if self.TabEntries[tab] or not self.DockWindows then
		return
	end
	local btn = create("TextButton", {
		Parent = self.DockWindows,
		LayoutOrder = 100 + #win.Tabs,
		Size = UDim2.fromOffset(38, 38),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Theme = {BackgroundColor3 = "Accent"},
	}, {corner(11)})
	local scale = create("UIScale", {Parent = btn})
	local ic = center(icon(btn, tab.IconName or "layout-grid", 18, T.Muted))
	local ind = create("Frame", {
		Parent = btn,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -2),
		Size = UDim2.fromOffset(0, 3),
		BorderSizePixel = 0,
		BackgroundColor3 = T.Accent,
	}, {corner(PILL)})
	self.TabEntries[tab] = {Button = btn, Indicator = ind, Icon = ic, Window = win}

	btn.MouseEnter:Connect(function()
		if win.Active ~= tab then
			apply(btn, {BackgroundTransparency = 0.55}, true, 0.14, "Hover Effects")
			apply(ic, {ImageColor3 = T.Text}, true, 0.14, "Hover Effects")
		end
	end)
	btn.MouseLeave:Connect(function()
		local active = win.Opened and not win.Minimized and win.Active == tab
		apply(btn, {BackgroundTransparency = active and 0.82 or 1}, true, 0.18, "Hover Effects")
		apply(ic, {ImageColor3 = active and T.Accent or T.Muted}, true, 0.18, "Hover Effects")
	end)
	pressable(btn, scale, 1.08, 0.92)
	tooltip(btn, function()
		return tab.Name
	end)

	btn.Activated:Connect(function()
		closePopup()
		if not win.Opened then
			win:Open()
		elseif win.Minimized then
			win:Restore()
		end
		win:Select(tab)
		bounce(ic)
	end)
	self:_refreshDock()
end

function Hub:_refreshBlur()
	if not self.BlurEffect then
		self.BlurEffect = create("BlurEffect", {Parent = Lighting, Size = 0})
	end
	local any = false
	for _, w in self.Windows do
		any = any or w.Shown
	end
	local want = Lumen.Config.Blur and (any or self.SplashActive)
	tween(self.BlurEffect, {Size = want and (Lumen.Config.BlurSize or 14) or 0}, 0.32)
end

function Hub:_refreshMouse()
	if not self.ModalButton then
		self.ModalButton = create("TextButton", {
			Parent = Layers.Windows,
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			Text = "",
			Modal = false,
			Visible = false,
		})
	end
	local any = false
	for _, w in self.Windows do
		any = any or w.Shown
	end
	local unlock = Lumen.Config.UnlockMouse and any
	self.ModalButton.Visible = unlock
	self.ModalButton.Modal = unlock
end

function Hub:SetScale(scale)
	scale = math.clamp(tonumber(scale) or 1, 0.75, 1.35)
	Lumen.Config.Scale = scale
	for _, w in self.Windows do
		if w.Shown then
			tween(w.Scale, {Scale = scale}, 0.22)
		end
	end
end

function Hub:SetBlur(enabled, size)
	if enabled ~= nil then
		Lumen.Config.Blur = enabled == true
	end
	if size ~= nil then
		Lumen.Config.BlurSize = tonumber(size) or 14
	end
	self:_refreshBlur()
end

function Hub:SetBackgroundImage(imageId, alpha, scaleMode)
	if imageId ~= nil then
		Lumen.Config.BackgroundImage = tostring(imageId)
	end
	if alpha ~= nil then
		Lumen.Config.BackgroundImageAlpha = tonumber(alpha) or 0.82
	end
	if scaleMode ~= nil then
		Lumen.Config.BackgroundScale = scaleMode
	end
	for _, w in self.Windows do
		w:SetBackgroundImage(Lumen.Config.BackgroundImage, Lumen.Config.BackgroundImageAlpha, Lumen.Config.BackgroundScale)
	end
end

function Hub:_refreshBadge()
	local show = self.Unread > 0 and not self.DND
	if show then
		self.Badge.Visible = true
		self.BadgeScale.Scale = 0
		tween(self.BadgeScale, {Scale = 1}, 0.35, Enum.EasingStyle.Back)
	else
		self.Badge.Visible = false
	end
end

function Hub:SetVisible(state)
	self.Visible = state
	closePopup()
	if self.Ready then
		tween(self.Dock, {Position = UDim2.new(0.5, 0, 1, state and -16 or 110)}, 0.48, Enum.EasingStyle.Quint)
	end
	if self.MobilePillStroke then
		tween(self.MobilePillStroke, {Color = state and T.Accent or T.Stroke}, 0.2)
	end
	for _, w in self.Windows do
		w:_apply()
	end
end

function Hub:_launch(win, tab)
	closePopup()
	win:Open()
	if tab then
		win:Select(tab)
	end
end

function Hub:_dockAdd(win)
	local btn = create("TextButton", {
		Parent = self.DockWindows,
		LayoutOrder = #self.Windows,
		Size = UDim2.fromOffset(42, 42),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(13)})
	local scale = create("UIScale", {Parent = btn})
	local ic = center(icon(btn, win.IconName, 20, T.Muted))
	local ind = create("Frame", {
		Parent = btn,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -3),
		Size = UDim2.fromOffset(0, 3),
		BorderSizePixel = 0,
		BackgroundColor3 = T.Accent,
	}, {corner(PILL)})
	self.Entries[win] = {Button = btn, Indicator = ind, Icon = ic}

	btn.MouseEnter:Connect(function()
		apply(btn, {BackgroundTransparency = 0.45}, true, 0.14, "Hover Effects")
	end)
	btn.MouseLeave:Connect(function()
		apply(btn, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
	end)
	pressable(btn, scale, 1.08, 0.92)
	tooltip(btn, function()
		return win.Name
	end)

	btn.Activated:Connect(function()
		closePopup()
		if not win.Opened then
			win:Open()
			bounce(ic)
		elseif win.Minimized then
			win:Restore()
		elseif self.Focused == win then
			win:Minimize()
		else
			self:_focus(win)
		end
	end)
	self:_refreshDock()
end

function Hub:_dockRemove(win)
	local e = self.Entries[win]
	if e then
		e.Button:Destroy()
		self.Entries[win] = nil
	end
end

function Hub:_buildMobileButton()
	local pill = registerSurface(create("TextButton", {
		Parent = Layers.Hud,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 14),
		Size = UDim2.fromOffset(0, 34),
		AutomaticSize = Enum.AutomaticSize.X,
		AutoButtonColor = false,
		Text = "",
		Visible = Lumen.Config.MobileButton == true,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(PILL), pad(0, 14, 0, 10), list(8, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})}), 0.85, 0.04)
	local pStroke = stroke("Accent", 1, 0.25)
	pStroke.Parent = pill
	self.MobilePill = pill
	self.MobilePillStroke = pStroke

	local dot = create("Frame", {
		Parent = pill,
		LayoutOrder = 1,
		Size = UDim2.fromOffset(20, 20),
		BackgroundColor3 = WHITE,
	}, {corner(PILL), create("UIGradient", {Rotation = 45})})
	accentGradient(dot:FindFirstChildOfClass("UIGradient"))
	center(icon(dot, self.IconName, 11, WHITE))

	text({
		Parent = pill,
		LayoutOrder = 2,
		Text = self.Name,
		Size = UDim2.fromOffset(0, 34),
		AutomaticSize = Enum.AutomaticSize.X,
		TextTruncate = Enum.TextTruncate.None,
		FontFace = FONT_B,
		TextSize = 12,
	})

	local wasMoved = drag(pill, pill)
	pill.Activated:Connect(function()
		if not wasMoved() then
			self:SetVisible(not self.Visible)
		end
	end)
end

function Hub:_buildDock()
	local dock = registerSurface(create("Frame", {
		Parent = Layers.Dock,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 110),
		Size = UDim2.fromOffset(0, 56),
		AutomaticSize = Enum.AutomaticSize.X,
		ZIndex = 2,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(18), pad(0, 10), list(6, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})}), 0.85, 0.04)
	rim(dock)
	self.Dock = dock

	local function sep(order)
		create("Frame", {
			Parent = dock,
			Size = UDim2.fromOffset(1, 24),
			BorderSizePixel = 0,
			LayoutOrder = order,
			Theme = {BackgroundColor3 = "Stroke"},
		})
	end

	local hubBtn = create("TextButton", {
		Parent = dock,
		LayoutOrder = 1,
		Size = UDim2.fromOffset(40, 40),
		BackgroundColor3 = WHITE,
		Text = "",
		AutoButtonColor = false,
	}, {corner(12), create("UIGradient", {Rotation = 45})})
	accentGradient(hubBtn:FindFirstChildOfClass("UIGradient"))
	center(icon(hubBtn, self.IconName, 19, WHITE))
	local hs = create("UIScale", {Parent = hubBtn})
	pressable(hubBtn, hs, 1.07, 0.93)
	tooltip(hubBtn, self.Name)
	self.HubButton = hubBtn

	sep(2)
	self.DockWindows = create("Frame", {
		Parent = dock,
		LayoutOrder = 3,
		Size = UDim2.fromOffset(0, 56),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
	}, {list(6, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})})
	sep(4)

	local clock = text({
		Parent = dock,
		LayoutOrder = 5,
		Size = UDim2.fromOffset(48, 56),
		Text = os.date("%H:%M"),
		TextXAlignment = Enum.TextXAlignment.Center,
		FontFace = FONT_B,
		TextSize = 13,
	})
	task.spawn(function()
		while clock.Parent do
			clock.Text = os.date("%H:%M")
			task.wait(5)
		end
	end)

	local bell = create("TextButton", {
		Parent = dock,
		LayoutOrder = 6,
		Size = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(12)})
	center(icon(bell, "bell", 18, "Text"))
	local bs = create("UIScale", {Parent = bell})
	bell.MouseEnter:Connect(function()
		apply(bell, {BackgroundTransparency = 0.45}, true, 0.14, "Hover Effects")
	end)
	bell.MouseLeave:Connect(function()
		apply(bell, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
	end)
	pressable(bell, bs, 1.08, 0.92)
	tooltip(bell, "Notifications")
	self.Bell = bell
	self.Badge = create("Frame", {
		Parent = bell,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -9, 0, 9),
		Size = UDim2.fromOffset(8, 8),
		BorderSizePixel = 0,
		Visible = false,
		Theme = {BackgroundColor3 = "Danger"},
	}, {corner(PILL), stroke("Panel", 2)})
	self.BadgeScale = create("UIScale", {Parent = self.Badge})

	bell.Activated:Connect(function()
		if popupOpenFor(self.NotifPanel) then
			closePopup()
		else
			self:_openNotifs()
		end
	end)
	hubBtn.Activated:Connect(function()
		if popupOpenFor(self.StartPanel) then
			closePopup()
		else
			self:_openStart()
		end
	end)

	onTheme(function()
		self:_refreshDock()
	end)
end

function Hub:_panel(width, height)
	local panel = registerSurface(create("CanvasGroup", {
		Parent = Layers.Panels,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -84),
		Size = UDim2.fromOffset(width, height),
		GroupTransparency = 1,
		Visible = false,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(18)}), 0.9, 0.02)
	rim(panel)
	return panel
end

function Hub:_reveal(panel, _, frames, owner, onClose, x)
	panel.Visible = true
	panel.GroupTransparency = 1
	local rest = x and UDim2.new(0, x, 1, -84) or UDim2.new(0.5, 0, 1, -84)
	panel.Position = rest + UDim2.fromOffset(0, 22)
	tween(panel, {Position = rest, GroupTransparency = 0}, 0.34, nil, nil, "Popups")
	openPopup(frames, function()
		if onClose then
			onClose()
		end
		if animEnabled("Popups") then
			tween(panel, {Position = rest + UDim2.fromOffset(0, 18), GroupTransparency = 1}, 0.2)
			task.delay(0.22, function()
				if popup == nil or popup.Owner ~= owner then
					panel.Visible = false
				end
			end)
		else
			panel.Visible = false
		end
	end, owner)
end

function Hub:_buildStart()
	local panel = self:_panel(390, 450)
	self.StartPanel = panel
	local box = create("Frame", {
		Parent = panel,
		Position = UDim2.fromOffset(16, 16),
		Size = UDim2.new(1, -32, 0, 40),
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(12)})
	local ring = stroke("Stroke")
	ring.Parent = box
	local glass = icon(box, "search", 15, "Muted")
	glass.AnchorPoint = Vector2.new(0, 0.5)
	glass.Position = UDim2.new(0, 14, 0.5, 0)
	local input = registerFont(create("TextBox", {
		Parent = box,
		Position = UDim2.fromOffset(38, 0),
		Size = UDim2.new(1, -48, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		PlaceholderText = "Search windows and tabs...",
		FontFace = FONT,
		TextSize = 13,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		Theme = {TextColor3 = "Text", PlaceholderColor3 = "Muted"},
	}), "M")
	input.Focused:Connect(function()
		tween(ring, {Color = T.Accent}, 0.18)
	end)
	input.FocusLost:Connect(function()
		tween(ring, {Color = T.Stroke}, 0.18)
	end)

	local scroll = create("ScrollingFrame", {
		Parent = panel,
		Position = UDim2.fromOffset(0, 66),
		Size = UDim2.new(1, 0, 1, -138),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Theme = {ScrollBarImageColor3 = "Stroke"},
	}, {pad(0, 12, 8, 12), list(4)})

	local function populate()
		for _, c in scroll:GetChildren() do
			if c:IsA("GuiButton") or c:IsA("TextLabel") then
				c:Destroy()
			end
		end
		local q = input.Text:lower()
		local order = 0
		local function entry(iconName, title, sub, action)
			order += 1
			local b = create("TextButton", {
				Parent = scroll,
				Size = UDim2.new(1, 0, 0, 52),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = order,
				Theme = {BackgroundColor3 = "Hover"},
			}, {corner(12)})
			local bub = create("Frame", {
				Parent = b,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 10, 0.5, 0),
				Size = UDim2.fromOffset(34, 34),
				Theme = {BackgroundColor3 = "Raised"},
			}, {corner(10)})
			center(icon(bub, iconName, 17, "Accent"))
			text({Parent = b, Text = title, Position = UDim2.fromOffset(54, 8), Size = UDim2.new(1, -64, 0, 18), FontFace = FONT_B})
			text({Parent = b, Text = sub, Position = UDim2.fromOffset(54, 27), Size = UDim2.new(1, -64, 0, 16), TextSize = 11, Theme = {TextColor3 = "Muted"}})
			b.MouseEnter:Connect(function()
				apply(b, {BackgroundTransparency = 0.4}, true, 0.14, "Hover Effects")
			end)
			b.MouseLeave:Connect(function()
				apply(b, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
			end)
			b.Activated:Connect(action)
		end
		for _, win in self.Windows do
			if q == "" or win.Name:lower():find(q, 1, true) then
				entry(win.IconName, win.Name, win.Description ~= "" and win.Description or "Window", function()
					self:_launch(win)
				end)
			end
			if q ~= "" then
				for _, tab in win.Tabs do
					if tab.Name:lower():find(q, 1, true) then
						entry("layout-grid", tab.Name, "in " .. win.Name, function()
							self:_launch(win, tab)
						end)
					end
				end
			end
		end
		if order == 0 then
			text({
				Parent = scroll,
				Text = "No matching results",
				Size = UDim2.new(1, 0, 0, 60),
				TextXAlignment = Enum.TextXAlignment.Center,
				Theme = {TextColor3 = "Muted"},
			})
		end
	end
	input:GetPropertyChangedSignal("Text"):Connect(populate)
	self._populateStart = function()
		input.Text = ""
		populate()
	end

	local footer = create("Frame", {
		Parent = panel,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 64),
		BackgroundTransparency = 1,
	})
	create("Frame", {Parent = footer, Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Theme = {BackgroundColor3 = "Stroke"}})
	local player = Players.LocalPlayer
	create("ImageLabel", {
		Parent = footer,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.fromOffset(34, 34),
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=60&h=60",
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(PILL)})
	text({Parent = footer, Text = player.DisplayName, Position = UDim2.fromOffset(62, 15), Size = UDim2.new(1, -180, 0, 18), FontFace = FONT_B})
	text({Parent = footer, Text = self.Name .. " " .. self.Description, Position = UDim2.fromOffset(62, 33), Size = UDim2.new(1, -180, 0, 16), TextSize = 11, Theme = {TextColor3 = "Muted"}})

	local function round(iconName, offset, danger, action)
		local b = create("TextButton", {
			Parent = footer,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, offset, 0.5, 0),
			Size = UDim2.fromOffset(34, 34),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = T.Hover,
		}, {corner(10)})
		local ic = center(icon(b, iconName, 16, T.Muted))
		b.MouseEnter:Connect(function()
			apply(b, {BackgroundTransparency = danger and 0.82 or 0.2, BackgroundColor3 = danger and T.Danger or T.Hover}, true, 0.14, "Hover Effects")
			apply(ic, {ImageColor3 = danger and T.Danger or T.Text}, true, 0.14, "Hover Effects")
		end)
		b.MouseLeave:Connect(function()
			apply(b, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
			apply(ic, {ImageColor3 = T.Muted}, true, 0.18, "Hover Effects")
		end)
		b.Activated:Connect(action)
		return b
	end
	local armed = false
	local power = round("power", -16, true, function()
		if armed then
			Lumen:Unload()
			return
		end
		armed = true
		self:Notify({Title = "Unload", Content = "Click power again to unload.", Type = "Warning", Duration = 2})
		task.delay(2, function()
			armed = false
		end)
	end)
	tooltip(power, "Unload")
	local gear = round("settings", -56, false, function()
		for _, win in self.Windows do
			if win.Name == "Settings" then
				self:_launch(win)
				return
			end
			for _, tab in win.Tabs do
				if tab.Name == "UI Settings" then
					self:_launch(win, tab)
					return
				end
			end
		end
	end)
	tooltip(gear, "Settings")
end

function Hub:_openStart()
	self._populateStart()
	self:_reveal(self.StartPanel, nil, {self.StartPanel, self.HubButton}, self.StartPanel)
end

function Hub:SetToastPosition(pos)
	Lumen.Config.ToastPosition = pos
	local holder = self.ToastHolder
	if not holder then
		return
	end
	local layout = holder:FindFirstChildOfClass("UIListLayout")
	if pos == "TopRight" then
		holder.AnchorPoint = Vector2.new(1, 0)
		holder.Position = UDim2.new(1, -24, 0, 24)
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
	elseif pos == "TopLeft" then
		holder.AnchorPoint = Vector2.new(0, 0)
		holder.Position = UDim2.new(0, 24, 0, 24)
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
	elseif pos == "BottomLeft" then
		holder.AnchorPoint = Vector2.new(0, 1)
		holder.Position = UDim2.new(0, 24, 1, -24)
		layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	else
		holder.AnchorPoint = Vector2.new(1, 1)
		holder.Position = UDim2.new(1, -24, 1, -24)
		layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	end
end

function Hub:_buildNotifications()
	self.ToastHolder = create("Frame", {
		Parent = Layers.Toasts,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -24, 1, -24),
		Size = UDim2.fromOffset(330, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {list(10, {VerticalAlignment = Enum.VerticalAlignment.Bottom})})
	self.ToastCounter = 0

	local panel = self:_panel(370, 470)
	self.NotifPanel = panel
	text({Parent = panel, Text = "Notifications", Position = UDim2.fromOffset(22, 0), Size = UDim2.new(1, -160, 0, 56), FontFace = FONT_X, TextSize = 15})

	local function action(label, offset, iconName)
		local b = registerFont(create("TextButton", {
			Parent = panel,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, offset, 0, 13),
			Size = UDim2.fromOffset(label and 56 or 30, 30),
			BackgroundTransparency = 1,
			Text = label or "",
			FontFace = FONT_B,
			TextSize = 12,
			AutoButtonColor = false,
			BackgroundColor3 = T.Hover,
			TextColor3 = T.Muted,
		}, {corner(9)}), "B")
		local ic
		if iconName then
			ic = center(icon(b, iconName, 16, T.Muted))
		end
		b.MouseEnter:Connect(function()
			apply(b, {BackgroundTransparency = 0.2}, true, 0.14, "Hover Effects")
			if ic then
				apply(ic, {ImageColor3 = T.Text}, true, 0.14, "Hover Effects")
			else
				apply(b, {TextColor3 = T.Text}, true, 0.14, "Hover Effects")
			end
		end)
		b.MouseLeave:Connect(function()
			apply(b, {BackgroundTransparency = 1}, true, 0.18, "Hover Effects")
			if ic then
				apply(ic, {ImageColor3 = self.DND and T.Warning or T.Muted}, true, 0.18, "Hover Effects")
			else
				apply(b, {TextColor3 = T.Muted}, true, 0.18, "Hover Effects")
			end
		end)
		return b, ic
	end

	local clear = action("Clear", -16)
	local dnd, dndIcon = action(nil, -78, "bell-off")
	tooltip(dnd, "Do not disturb")

	create("Frame", {Parent = panel, Position = UDim2.fromOffset(0, 56), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Theme = {BackgroundColor3 = "Stroke"}})
	local scroll = create("ScrollingFrame", {
		Parent = panel,
		Position = UDim2.fromOffset(0, 57),
		Size = UDim2.new(1, 0, 1, -57),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Theme = {ScrollBarImageColor3 = "Stroke"},
	}, {pad(12), list(8)})
	local empty = create("Frame", {Parent = panel, Position = UDim2.fromOffset(0, 57), Size = UDim2.new(1, 0, 1, -57), BackgroundTransparency = 1})
	local eico = icon(empty, "bell-off", 28, "Muted")
	eico.AnchorPoint = Vector2.new(0.5, 0.5)
	eico.Position = UDim2.new(0.5, 0, 0.5, -14)
	eico.ImageTransparency = 0.5
	text({Parent = empty, Text = "You're all caught up", Position = UDim2.new(0, 0, 0.5, 14), Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Center, Theme = {TextColor3 = "Muted"}})

	function self:_renderHistory()
		for _, c in scroll:GetChildren() do
			if c:IsA("GuiObject") then
				c:Destroy()
			end
		end
		empty.Visible = #self.History == 0
		for idx, n in self.History do
			local kind = kindOf(n.Type)
			local item = create("TextButton", {
				Parent = scroll,
				Size = UDim2.new(1, 0, 0, 54),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = 0.45,
				LayoutOrder = idx,
				Theme = {BackgroundColor3 = "Raised"},
			}, {corner(12), pad(11, 13, 11, 11)})
			local bub = create("Frame", {
				Parent = item,
				Size = UDim2.fromOffset(30, 30),
				BackgroundTransparency = 0.82,
				Theme = {BackgroundColor3 = kind.Key},
			}, {corner(9)})
			center(icon(bub, kind.Icon, 15, kind.Key))
			local col = create("Frame", {
				Parent = item,
				Position = UDim2.fromOffset(42, 0),
				Size = UDim2.new(1, -42, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			}, {list(2)})
			local head = create("Frame", {Parent = col, Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = 1})
			text({Parent = head, Text = n.Title, Size = UDim2.new(1, -40, 1, 0), FontFace = FONT_B})
			text({Parent = head, Text = ago(n.Time), Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Right, TextSize = 11, Theme = {TextColor3 = "Muted"}})
			if n.Content then
				text({
					Parent = col,
					Text = n.Content,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					TextTruncate = Enum.TextTruncate.None,
					TextSize = 12,
					LayoutOrder = 2,
					Theme = {TextColor3 = "Muted"},
				})
			end
			item.Activated:Connect(function()
				table.remove(self.History, table.find(self.History, n))
				self:_renderHistory()
			end)
		end
	end

	clear.Activated:Connect(function()
		table.clear(self.History)
		self:_renderHistory()
	end)
	dnd.Activated:Connect(function()
		self.DND = not self.DND
		tween(dndIcon, {ImageColor3 = self.DND and T.Warning or T.Muted}, 0.18)
		self:_refreshBadge()
		if self.DND then
			for _, t in table.clone(self.Toasts) do
				t.Dismiss()
			end
		end
	end)
end

function Hub:_openNotifs()
	self.Unread = 0
	self:_refreshBadge()
	self:_renderHistory()
	local x = math.clamp(self.Bell.AbsolutePosition.X + self.Bell.AbsoluteSize.X - 370, 12, Gui.AbsoluteSize.X - 382)
	self.NotifPanel.AnchorPoint = Vector2.new(0, 1)
	self.PanelOpen = true
	self:_reveal(self.NotifPanel, nil, {self.NotifPanel, self.Bell}, self.NotifPanel, function()
		self.PanelOpen = false
	end, x)
end

function Hub:SetDND(state)
	self.DND = state
	self:_refreshBadge()
end

function Hub:Notify(o)
	if type(o) == "string" then
		o = {Title = o}
	end
	o = o or {}
	local kind = kindOf(o.Type)
	local title = o.Title or o.Name or "Notification"
	local content = o.Content or o.Description or o.Text
	local duration = o.Duration or o.Time or Lumen.Config.ToastDuration or 4

	table.insert(self.History, 1, {Title = title, Content = content, Type = o.Type or "Info", Time = os.time()})
	if #self.History > 50 then
		table.remove(self.History)
	end
	if self.PanelOpen then
		self:_renderHistory()
	else
		self.Unread += 1
		self:_refreshBadge()
	end
	if self.DND then
		return
	end
	play(o.Sound or self.Sound, o.Volume)

	local leftSide = Lumen.Config.ToastPosition == "TopLeft" or Lumen.Config.ToastPosition == "BottomLeft"
	local offsetX = leftSide and -50 or 50

	self.ToastCounter += 1
	local wrap = create("Frame", {
		Parent = self.ToastHolder,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = self.ToastCounter,
	})
	local card = registerSurface(create("CanvasGroup", {
		Parent = wrap,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, offsetX, 1, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(14)}), 0.9, 0.02)
	rim(card)
	local inner = create("Frame", {
		Parent = card,
		Size = UDim2.new(1, 0, 0, 34),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {pad(13, 15, 16, 13)})
	local bub = create("Frame", {
		Parent = inner,
		Size = UDim2.fromOffset(32, 32),
		BackgroundTransparency = 0.82,
		Theme = {BackgroundColor3 = kind.Key},
	}, {corner(10)})
	center(icon(bub, kind.Icon, 16, kind.Key))
	local col = create("Frame", {
		Parent = inner,
		Position = UDim2.fromOffset(44, 0),
		Size = UDim2.new(1, -44, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {list(2)})
	text({Parent = col, Text = title, Size = UDim2.new(1, 0, 0, 16), FontFace = FONT_B, LayoutOrder = 1})
	if content then
		text({
			Parent = col,
			Text = content,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			TextSize = 12,
			LayoutOrder = 2,
			Theme = {TextColor3 = "Muted"},
		})
	end
	local bar = create("Frame", {
		Parent = card,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundTransparency = 0.2,
		Theme = {BackgroundColor3 = kind.Key},
	})
	local click = hit(card)
	click.ZIndex = 5

	local toast = {}
	local hovered, dismissed, elapsed = false, false, 0
	function toast.Dismiss()
		if dismissed then
			return
		end
		dismissed = true
		toast.Conn:Disconnect()
		local i = table.find(self.Toasts, toast)
		if i then
			table.remove(self.Toasts, i)
		end
		tween(card, {Position = UDim2.new(0, leftSide and -65 or 65, 1, 0), GroupTransparency = 1}, 0.34)
		task.delay(0.24, function()
			tween(wrap, {Size = UDim2.new(1, 0, 0, 0)}, 0.34)
		end)
		task.delay(0.65, function()
			wrap:Destroy()
		end)
	end
	toast.Conn = RS.Heartbeat:Connect(function(dt)
		if hovered or dismissed then
			return
		end
		elapsed += dt
		bar.Size = UDim2.new(math.max(0, 1 - elapsed / duration), 0, 0, 2)
		if elapsed >= duration then
			toast.Dismiss()
		end
	end)
	click.MouseEnter:Connect(function()
		hovered = true
	end)
	click.MouseLeave:Connect(function()
		hovered = false
	end)
	click.Activated:Connect(toast.Dismiss)

	table.insert(self.Toasts, toast)
	if #self.Toasts > 5 then
		self.Toasts[1].Dismiss()
	end

	task.spawn(function()
		RS.Heartbeat:Wait()
		RS.Heartbeat:Wait()
		if dismissed then
			return
		end
		tween(wrap, {Size = UDim2.new(1, 0, 0, card.AbsoluteSize.Y)}, 0.38)
		tween(card, {Position = UDim2.new(0, 0, 1, 0), GroupTransparency = 0}, 0.45)
	end)
end

function Hub:Watermark(o)
	o = o or {}
	if self.WatermarkFrame then
		self.WatermarkFrame:Destroy()
	end
	local frame = registerSurface(create("Frame", {
		Parent = Layers.Hud,
		Position = UDim2.fromOffset(18, 18),
		Size = UDim2.fromOffset(0, 36),
		AutomaticSize = Enum.AutomaticSize.X,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(11), stroke("Stroke"), pad(0, 14, 0, 8), list(10, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})}), 0.85, 0.04)
	self.WatermarkFrame = frame
	local mark = create("Frame", {
		Parent = frame,
		Size = UDim2.fromOffset(22, 22),
		BackgroundColor3 = WHITE,
		LayoutOrder = 1,
	}, {corner(7), create("UIGradient", {Rotation = 45})})
	accentGradient(mark:FindFirstChildOfClass("UIGradient"))
	center(icon(mark, self.IconName, 12, WHITE))
	local label = text({
		Parent = frame,
		Size = UDim2.fromOffset(0, 36),
		AutomaticSize = Enum.AutomaticSize.X,
		TextTruncate = Enum.TextTruncate.None,
		TextSize = 12,
		FontFace = FONT_B,
		LayoutOrder = 2,
	})
	drag(frame, frame)
	local frames, acc = 0, 0
	local text_ = o.Text or self.Name
	link(RS.Heartbeat, function(dt)
		frames += 1
		acc += dt
		if acc >= 0.5 and frame.Parent then
			local ping = 0
			pcall(function()
				ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			label.Text = string.format("%s  |  %d FPS  |  %d ms  |  %s", text_, math.floor(frames / acc + 0.5), ping, os.date("%H:%M:%S"))
			frames, acc = 0, 0
		end
	end)
	return {
		SetText = function(_, v)
			text_ = v
		end,
		SetVisible = function(_, v)
			frame.Visible = v
		end,
	}
end

function Hub:KeybindList(o)
	o = o or {}
	if self.BindFrame then
		self.BindFrame:Destroy()
	end
	local frame = registerSurface(create("CanvasGroup", {
		Parent = Layers.Hud,
		Position = o.Position or UDim2.fromOffset(18, 64),
		Size = UDim2.fromOffset(226, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(12), stroke("Stroke"), list(0)}), 0.85, 0.04)
	self.BindFrame = frame
	local head = create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 1})
	local headHit = hit(head)
	headHit.ZIndex = 0
	local ic = icon(head, "keyboard", 14, "Accent")
	ic.AnchorPoint = Vector2.new(0, 0.5)
	ic.Position = UDim2.new(0, 13, 0.5, 0)
	text({Parent = head, Text = "Keybinds", Position = UDim2.fromOffset(35, 0), Size = UDim2.new(1, -68, 1, 0), FontFace = FONT_B, TextSize = 12})
	local collapseBtn = create("TextButton", {
		Parent = head,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 2,
	})
	local chev = center(icon(collapseBtn, "chevron-down", 13, "Muted"))
	local dividerLine = create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, LayoutOrder = 2, Theme = {BackgroundColor3 = "Stroke"}})
	drag(headHit, frame)
	local rows = create("Frame", {
		Parent = frame,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 3,
	}, {pad(6, 8, 8, 8), list(2)})

	local collapsed = false
	collapseBtn.Activated:Connect(function()
		collapsed = not collapsed
		rows.Visible = not collapsed
		dividerLine.Visible = not collapsed
		tween(chev, {Rotation = collapsed and -90 or 0}, 0.2)
	end)

	local made = {}
	local acc = 0
	link(RS.Heartbeat, function(dt)
		acc += dt
		if acc < 0.1 or not frame.Parent or collapsed then
			return
		end
		acc = 0
		local activeOnly = Lumen.Config.KeybindFilter == "Active Only"
		for idx, entry in Lumen.Binds do
			local r = made[entry]
			if not r then
				local row = create("TextButton", {
					Parent = rows,
					Size = UDim2.new(1, 0, 0, 24),
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Text = "",
					LayoutOrder = idx,
				}, {corner(6)})
				local dot = create("Frame", {
					Parent = row,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 7, 0.5, 0),
					Size = UDim2.fromOffset(6, 6),
					BorderSizePixel = 0,
					Theme = {BackgroundColor3 = "Muted"},
				}, {corner(PILL)})
				local name = text({Parent = row, Text = entry.Name, Position = UDim2.fromOffset(19, 0), Size = UDim2.new(1, -86, 1, 0), TextSize = 12, TextColor3 = T.Muted})
				local key = text({Parent = row, Text = "", Position = UDim2.fromScale(0, 0), Size = UDim2.new(1, -8, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, TextSize = 11, FontFace = FONT_B, TextColor3 = T.Muted})
				row.Activated:Connect(function()
					if Lumen.Config.KeybindInteractive and entry.Toggle then
						entry.Toggle()
					end
				end)
				r = {Row = row, Dot = dot, Name = name, Key = key}
				made[entry] = r
			end
			local bound = entry.Bind.Value ~= UNKNOWN or entry.Bind.Mode == "Always"
			local on = bound and entry.Active()
			local show = bound and (not activeOnly or on)
			r.Row.Visible = show
			if show then
				local modeTag = entry.Bind.Mode == "Always" and "Always" or keyName(entry.Bind.Value)
				r.Key.Text = "[" .. modeTag .. "]"
				r.Dot.BackgroundColor3 = on and T.Accent or T.Muted
				r.Name.TextColor3 = on and T.Text or T.Muted
				r.Key.TextColor3 = on and T.Accent or T.Muted
				r.Row.BackgroundColor3 = T.Accent
				r.Row.BackgroundTransparency = on and 0.88 or 1
			end
		end
	end)
	return {
		SetVisible = function(_, v)
			frame.Visible = v
		end,
	}
end

function Hub:_inputs()
	link(UIS.InputBegan, function(i, processed)
		if isPress(i) then
			local m = mouse(i)
			local best
			for _, win in self.Windows do
				if win.Shown and inside(win.Root, m) and (not best or win.Root.ZIndex > best.Root.ZIndex) then
					best = win
				end
			end
			if best and self.Focused ~= best then
				self:_focus(best)
			end
		end
		if processed or Lumen.Listening or tick() - (Lumen.LastBind or 0) < 0.25 then
			return
		end
		if i.KeyCode == self.Key then
			self:SetVisible(not self.Visible)
		end
	end)
end

function Hub:_splash(o)
	local function finish()
		self.SplashActive = false
		self.Ready = true
		tween(self.Dock, {Position = UDim2.new(0.5, 0, 1, -16)}, 0.65, Enum.EasingStyle.Back)
		for i, win in self.Windows do
			task.delay(0.06 + (i - 1) * 0.12, function()
				win:_apply()
			end)
		end
		self:_refreshBlur()
	end
	if o.Splash == false then
		task.defer(finish)
		return
	end
	task.spawn(function()
		self.SplashActive = true
		self:_refreshBlur()

		local holder = center(create("Frame", {
			Parent = Layers.Splash,
			Size = UDim2.fromOffset(500, 120),
			BackgroundTransparency = 1,
		}))

		local wordRow = create("Frame", {
			Parent = holder,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 12),
			Size = UDim2.fromOffset(0, 44),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
		}, {list(4, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		})})

		local titleStr = string.upper(self.Name or "LUMEN")
		local letters = {}
		for idx = 1, #titleStr do
			local ch = titleStr:sub(idx, idx)
			local slot = create("Frame", {
				Parent = wordRow,
				LayoutOrder = idx,
				Size = UDim2.fromOffset(ch == " " and 12 or 24, 44),
				BackgroundTransparency = 1,
			})
			local lbl = registerFont(create("TextLabel", {
				Parent = slot,
				Position = UDim2.fromOffset(0, 22),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = ch,
				FontFace = FONT_X,
				TextSize = 32,
				TextColor3 = WHITE,
				TextTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
			}), "X")
			local sc = create("UIScale", {Parent = lbl, Scale = 0.84})
			table.insert(letters, {Label = lbl, Scale = sc})
		end

		local line = create("Frame", {
			Parent = holder,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 62),
			Size = UDim2.fromOffset(0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = WHITE,
			BackgroundTransparency = 0.35,
		})
		create("UIGradient", {
			Parent = line,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(1, 1),
			}),
		})

		local subText = self.Description ~= "" and string.upper(self.Description) or "UNIVERSAL INTERFACE"
		local subLbl = registerFont(create("TextLabel", {
			Parent = holder,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 86),
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = subText,
			FontFace = FONT_B,
			TextSize = 12,
			TextColor3 = WHITE,
			TextTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Center,
		}), "B")

		play(o.LoadedSound)

		for idx, item in letters do
			task.delay((idx - 1) * 0.038, function()
				tween(item.Label, {Position = UDim2.fromOffset(0, 0), TextTransparency = 0}, 0.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
				tween(item.Scale, {Scale = 1}, 0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end)
		end

		task.delay(0.16, function()
			tween(line, {Size = UDim2.fromOffset(148, 1)}, 0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			tween(subLbl, {Position = UDim2.new(0.5, 0, 0, 70), TextTransparency = 0.28}, 0.52, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		end)

		local totalWait = #letters * 0.038 + 0.82
		task.wait(totalWait)

		for idx, item in letters do
			task.delay((idx - 1) * 0.022, function()
				tween(item.Label, {Position = UDim2.fromOffset(0, -18), TextTransparency = 1}, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
				tween(item.Scale, {Scale = 0.92}, 0.34)
			end)
		end
		tween(line, {Size = UDim2.fromOffset(0, 1), BackgroundTransparency = 1}, 0.32)
		tween(subLbl, {Position = UDim2.new(0.5, 0, 0, 56), TextTransparency = 1}, 0.32)

		task.wait(0.36)
		holder:Destroy()
		finish()
	end)
end

local function ensureFolders()
	if not makefolder or not isfolder then
		return
	end
	pcall(function()
		if not isfolder(Lumen.Folder) then
			makefolder(Lumen.Folder)
		end
		if not isfolder(Lumen.Folder .. "/themes") then
			makefolder(Lumen.Folder .. "/themes")
		end
		if not isfolder(Lumen.Folder .. "/configs") then
			makefolder(Lumen.Folder .. "/configs")
		end
	end)
end

local ThemeKeys = {"Accent", "Back", "Side", "Panel", "Raised", "Hover", "Stroke", "Text", "Muted"}

function Lumen:ExportThemeJSON()
	local data = {
		Font = self.Config.FontFamily or "Inter",
		BackgroundImage = self.Config.BackgroundImage or "",
	}
	for _, k in ThemeKeys do
		data[k] = "#" .. T[k]:ToHex():upper()
	end
	return HttpService:JSONEncode(data)
end

function Lumen:ImportThemeJSON(raw)
	if type(raw) ~= "string" or raw == "" then
		return false
	end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
	if not ok or type(data) ~= "table" then
		return false
	end
	for _, k in ThemeKeys do
		if type(data[k]) == "string" then
			local fine, col = pcall(Color3.fromHex, data[k]:gsub("#", ""))
			if fine then
				T[k] = col
			end
		end
	end
	if type(data.Font) == "string" and Fonts[data.Font] then
		self:SetFont(data.Font)
		if self.Options.UIFontFamily then
			self.Options.UIFontFamily:Set(data.Font, true)
		end
	end
	if type(data.BackgroundImage) == "string" and self.Hub then
		self.Hub:SetBackgroundImage(data.BackgroundImage)
		if self.Options.UIBackgroundImage then
			self.Options.UIBackgroundImage:Set(data.BackgroundImage, true)
		end
	end
	refreshTheme(true)
	return true
end

function Lumen:ListCustomThemes()
	ensureFolders()
	local names = {}
	local dir = self.Folder .. "/themes"
	if listfiles and isfolder and isfolder(dir) then
		local ok, files = pcall(listfiles, dir)
		if ok and type(files) == "table" then
			for _, path in files do
				local name = path:match("([^/\\]+)%.json$")
				if name then
					table.insert(names, name)
				end
			end
		end
	end
	table.sort(names)
	return names
end

function Lumen:SaveCustomTheme(name)
	if not writefile or not name or name == "" then
		return false
	end
	ensureFolders()
	return pcall(writefile, self.Folder .. "/themes/" .. name .. ".json", self:ExportThemeJSON())
end

function Lumen:LoadCustomTheme(name)
	if not name or name == "" then
		return false
	end
	if Themes[name] then
		self:SetTheme(name)
		return true
	end
	local path = self.Folder .. "/themes/" .. tostring(name) .. ".json"
	if not (readfile and isfile and isfile(path)) then
		return false
	end
	local ok, raw = pcall(readfile, path)
	if not ok then
		return false
	end
	return self:ImportThemeJSON(raw)
end

function Lumen:DeleteCustomTheme(name)
	local path = self.Folder .. "/themes/" .. tostring(name) .. ".json"
	if delfile and isfile and isfile(path) then
		pcall(delfile, path)
		return true
	end
	return false
end

function Lumen:SetDefaultTheme(name)
	if not writefile or not name or name == "" then
		return false
	end
	ensureFolders()
	return pcall(writefile, self.Folder .. "/themes/default.txt", name)
end

function Lumen:GetDefaultTheme()
	local path = self.Folder .. "/themes/default.txt"
	if readfile and isfile and isfile(path) then
		local ok, txt = pcall(readfile, path)
		if ok and type(txt) == "string" and txt ~= "" then
			return txt
		end
	end
	return "Midnight"
end

function Lumen:ResetDefaultTheme()
	local path = self.Folder .. "/themes/default.txt"
	if delfile and isfile and isfile(path) then
		pcall(delfile, path)
		return true
	end
	return false
end

local function encode(v, alpha)
	if typeof(v) == "Color3" then
		return {__c = {v.R, v.G, v.B, alpha or 0}}
	elseif typeof(v) == "EnumItem" then
		return {__e = tostring(v)}
	end
	return v
end

local function decode(v)
	if type(v) == "table" then
		if v.__c then
			return Color3.new(v.__c[1], v.__c[2], v.__c[3]), v.__c[4]
		elseif v.__e then
			local kind, name = v.__e:match("^Enum%.(%w+)%.(%w+)$")
			if kind and Enum[kind] then
				return Enum[kind][name]
			end
		end
	end
	return v
end

function Lumen:ExportJSON()
	local data = {}
	for flag, option in self.Options do
		local isThemeFlag = flag:find("^UIColor_") ~= nil or flag == "UIThemePreset" or flag == "UIFontFamily"
		if not self.IgnoreFlags[flag] and not (self.IgnoreThemeInConfig and isThemeFlag) then
			data[flag] = encode(option.Value, option.Alpha)
		end
	end
	return HttpService:JSONEncode(data)
end

function Lumen:ImportJSON(raw)
	if type(raw) ~= "string" or raw == "" then
		return false
	end
	local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
	if not ok or type(data) ~= "table" then
		return false
	end
	for flag, val in data do
		local option = self.Options[flag]
		if option and option.Set then
			local decoded, alpha = decode(val)
			option:Set(decoded, false, alpha)
		end
	end
	return true
end

function Lumen:ListConfigs()
	ensureFolders()
	local names = {}
	local dir = self.Folder .. "/configs"
	if listfiles and isfolder and isfolder(dir) then
		local ok, files = pcall(listfiles, dir)
		if ok and type(files) == "table" then
			for _, path in files do
				local name = path:match("([^/\\]+)%.json$")
				if name then
					table.insert(names, name)
				end
			end
		end
	end
	table.sort(names)
	return names
end

function Lumen:SaveConfig(name)
	if not writefile or not name or name == "" then
		return false
	end
	ensureFolders()
	return pcall(writefile, self.Folder .. "/configs/" .. name .. ".json", self:ExportJSON())
end

function Lumen:LoadConfig(name)
	local path = self.Folder .. "/configs/" .. tostring(name) .. ".json"
	if not (readfile and isfile and isfile(path)) then
		return false
	end
	local ok, raw = pcall(readfile, path)
	if not ok then
		return false
	end
	return self:ImportJSON(raw)
end

function Lumen:DeleteConfig(name)
	local path = self.Folder .. "/configs/" .. tostring(name) .. ".json"
	if delfile and isfile and isfile(path) then
		pcall(delfile, path)
		if self:GetAutoloadConfig() == name then
			self:ResetAutoloadConfig()
		end
		return true
	end
	return false
end

function Lumen:SetAutoloadConfig(name)
	if not writefile or not name or name == "" then
		return false
	end
	ensureFolders()
	return pcall(writefile, self.Folder .. "/configs/autoload.txt", name)
end

function Lumen:GetAutoloadConfig()
	local path = self.Folder .. "/configs/autoload.txt"
	if readfile and isfile and isfile(path) then
		local ok, txt = pcall(readfile, path)
		if ok and type(txt) == "string" and txt ~= "" then
			return txt
		end
	end
	return nil
end

function Lumen:ResetAutoloadConfig()
	local path = self.Folder .. "/configs/autoload.txt"
	if delfile and isfile and isfile(path) then
		pcall(delfile, path)
		return true
	end
	return false
end

function Lumen:LoadAutoloadConfig()
	local name = self:GetAutoloadConfig()
	if name and self:LoadConfig(name) then
		if self.Hub then
			self.Hub:Notify({Title = "Autoload", Content = "Loaded profile '" .. name .. "'.", Type = "Info", Duration = 3})
		end
		return true
	end
	return false
end

function Hub:Settings(window)
	window:Category("Customization")
	local tab = window:Tab({Name = "UI Settings", Icon = "palette"})

	local themeSec = tab:Section({
		Name = "Theme & Colors",
		Description = "Live palette editor & custom theme manager",
		Icon = "palette",
		Side = "Left",
	})

	local themeNames = {}
	for name in Themes do
		table.insert(themeNames, name)
	end
	table.sort(themeNames)

	local presetDrop
	presetDrop = themeSec:Dropdown({
		Name = "Preset Theme",
		Description = "22 built-in Obsidian & Neverlose palettes",
		Values = themeNames,
		Default = "Midnight",
		Flag = "UIThemePreset",
		Format = function(v)
			return v == Lumen:GetDefaultTheme() and (v .. " (default)") or v
		end,
		Callback = function(name)
			if name then
				Lumen:SetTheme(name)
			end
		end,
	})

	local fontNames = {}
	for name in Fonts do
		table.insert(fontNames, name)
	end
	table.sort(fontNames)

	themeSec:Dropdown({
		Name = "Font Family",
		Values = fontNames,
		Default = "Inter",
		Flag = "UIFontFamily",
		Callback = function(name)
			Lumen:SetFont(name)
		end,
	})

	themeSec:Divider("PALETTE COLORS")

	local colorDefs = {
		{"Accent", "Accent Color", "Primary highlight & active state"},
		{"Back", "Menu Background", "Main window background color"},
		{"Side", "Sidebar Color", "Navigation sidebar surface"},
		{"Panel", "Section Color", "Card & container background"},
		{"Raised", "Button & Element Color", "Buttons, inputs, and dropdowns"},
		{"Hover", "Hover Color", "Row and button hover highlight"},
		{"Stroke", "Outline Color", "1px borders and dividers"},
		{"Text", "Main Text Color", "Primary label text"},
		{"Muted", "Muted Text Color", "Descriptions and inactive icons"},
	}

	for _, def in colorDefs do
		local key, label, desc = def[1], def[2], def[3]
		local picker = themeSec:ColorPicker({
			Name = label,
			Description = desc,
			Default = T[key],
			Flag = "UIColor_" .. key,
			Callback = function(c)
				Lumen:SetThemeColor(key, c)
			end,
		})
		Lumen.ThemeControls[key] = picker
	end

	local contrastBanner = themeSec:Banner({
		Title = "Contrast Check: Good",
		Content = "WCAG readability check passes.",
		Type = "Success",
	})

	Lumen._updateContrast = function()
		local rep = Lumen:GetContrastReport()
		if rep.Passes then
			contrastBanner:SetTitle(string.format("Contrast Check: %s (%.1f:1)", rep.Grade, rep.Ratio))
			contrastBanner:SetContent("Text contrast against surfaces is sharp and readable.")
		else
			contrastBanner:SetTitle(string.format("Low Contrast Warning (%.1f:1)", rep.Ratio))
			contrastBanner:SetContent("Low contrast between " .. rep.Pair .. ". Aim for 4.5:1+.")
		end
	end
	Lumen._updateContrast()

	local resetRow = themeSec:Button({
		Name = "Reset Palette",
		Icon = "rotate-ccw",
		Callback = function()
			local preset = Lumen.Flags.UIThemePreset or "Midnight"
			Lumen:SetTheme(preset)
			self:Notify({Title = "Theme Reset", Content = "Restored " .. preset .. " palette.", Type = "Info"})
		end,
	})
	resetRow:SubButton({
		Name = "Set Preset Default",
		Icon = "check",
		Callback = function()
			local preset = Lumen.Flags.UIThemePreset or "Midnight"
			Lumen:SetDefaultTheme(preset)
			presetDrop:Refresh()
			self:Notify({Title = "Default Theme", Content = "Set '" .. preset .. "' as startup default.", Type = "Success"})
		end,
	})

	themeSec:Divider("CUSTOM THEMES")

	local customName = themeSec:Input({
		Name = "Custom Theme Name",
		Placeholder = "my_theme...",
		Flag = "UICustomThemeName",
	})

	local customDrop
	customDrop = themeSec:Dropdown({
		Name = "Custom Themes",
		Values = Lumen:ListCustomThemes(),
		AllowNull = true,
		Flag = "UICustomThemeList",
		Format = function(v)
			return v == Lumen:GetDefaultTheme() and (v .. " (default)") or v
		end,
		Callback = function(v)
			if v then
				customName:Set(v, true)
			end
		end,
	})

	local function refreshCustomThemes()
		customDrop:SetValues(Lumen:ListCustomThemes())
		presetDrop:Refresh()
	end

	local saveCustomBtn = themeSec:Button({
		Name = "Save Custom",
		Style = "Primary",
		Icon = "save",
		Callback = function()
			local name = customName.Value
			if not name or name == "" then
				self:Notify({Title = "Theme Manager", Content = "Enter a theme name first.", Type = "Warning"})
				return
			end
			local ok = Lumen:SaveCustomTheme(name)
			refreshCustomThemes()
			self:Notify({Title = ok and "Theme Saved" or "Save Failed", Content = name, Type = ok and "Success" or "Error"})
		end,
	})
	saveCustomBtn:SubButton({
		Name = "Load Custom",
		Icon = "download",
		Callback = function()
			local name = customDrop.Value or customName.Value
			local ok = Lumen:LoadCustomTheme(name)
			self:Notify({Title = ok and "Theme Loaded" or "Load Failed", Content = tostring(name), Type = ok and "Success" or "Error"})
		end,
	})

	local overCustomBtn = themeSec:Button({
		Name = "Overwrite",
		Icon = "save",
		Callback = function()
			local name = customDrop.Value or customName.Value
			if not name or name == "" then
				return
			end
			window:Dialog({
				Title = "Overwrite Theme",
				Content = "Overwrite custom theme '" .. name .. "' with current colors?",
				ConfirmText = "Overwrite",
				Callback = function()
					Lumen:SaveCustomTheme(name)
					refreshCustomThemes()
					self:Notify({Title = "Overwritten", Content = "Updated theme '" .. name .. "'.", Type = "Success"})
				end,
			})
		end,
	})
	overCustomBtn:SubButton({
		Name = "Delete Theme",
		Icon = "trash-2",
		Risky = true,
		Callback = function()
			local name = customDrop.Value or customName.Value
			if not name or name == "" then
				return
			end
			window:Dialog({
				Title = "Delete Theme",
				Content = "Delete custom theme '" .. name .. "' permanently?",
				ConfirmText = "Delete",
				Risky = true,
				Callback = function()
					Lumen:DeleteCustomTheme(name)
					refreshCustomThemes()
					self:Notify({Title = "Deleted", Content = "Removed theme '" .. name .. "'.", Type = "Info"})
				end,
			})
		end,
	})

	local defThemeBtn = themeSec:Button({
		Name = "Set Custom Default",
		Callback = function()
			local name = customDrop.Value or customName.Value
			if name and name ~= "" then
				Lumen:SetDefaultTheme(name)
				refreshCustomThemes()
				self:Notify({Title = "Default Theme", Content = "Set '" .. name .. "' as startup theme.", Type = "Success"})
			end
		end,
	})
	defThemeBtn:SubButton({
		Name = "Reset Default",
		Callback = function()
			Lumen:ResetDefaultTheme()
			refreshCustomThemes()
			self:Notify({Title = "Default Reset", Content = "Reverted startup theme to Midnight.", Type = "Info"})
		end,
	})

	local themeJsonInput = themeSec:Input({
		Name = "Theme JSON",
		Placeholder = "Paste theme JSON...",
		Flag = "UIThemeJSON",
	})
	local impThemeBtn = themeSec:Button({
		Name = "Import Theme",
		Icon = "download",
		Callback = function()
			local ok = Lumen:ImportThemeJSON(themeJsonInput.Value)
			self:Notify({Title = ok and "Theme Imported" or "Import Failed", Content = ok and "Applied JSON palette." or "Invalid JSON.", Type = ok and "Success" or "Error"})
		end,
	})
	impThemeBtn:SubButton({
		Name = "Export Theme",
		Icon = "copy",
		Callback = function()
			local raw = Lumen:ExportThemeJSON()
			themeJsonInput:Set(raw, true)
			if setclipboard then
				setclipboard(raw)
			end
			self:Notify({Title = "Theme Exported", Content = "Copied theme JSON to clipboard.", Type = "Success"})
		end,
	})

	local winSec = tab:Section({
		Name = "Window & Layout",
		Description = "Dimensions, geometry, snapping & wallpaper",
		Icon = "sliders-horizontal",
		Side = "Right",
	})

	local menuBind = winSec:Keybind({
		Name = "Menu Toggle Key",
		Description = "Show or hide the entire hub",
		Default = self.Key,
		Modes = false,
		NoUI = true,
		Flag = "UIMenuKey",
	})
	menuBind:OnChanged(function(k)
		if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode and k ~= UNKNOWN then
			self.Key = k
		end
	end)

	winSec:Slider({
		Name = "UI Scale",
		Description = "DPI scale factor for all windows",
		Min = 75,
		Max = 135,
		Increment = 5,
		Default = math.floor((Lumen.Config.Scale or 1) * 100 + 0.5),
		Suffix = "%",
		Flag = "UIScale",
		Callback = function(v)
			self:SetScale(v / 100)
		end,
	})

	winSec:Slider({
		Name = "UI Transparency",
		Description = "Acrylic surface glass opacity",
		Min = 0,
		Max = 75,
		Increment = 2,
		Default = math.floor((Lumen.Config.Transparency or 0.16) * 100 + 0.5),
		Suffix = "%",
		Flag = "UITransparency",
		Callback = function(v)
			Lumen:SetTransparency(v / 100)
		end,
	})

	winSec:Slider({
		Name = "Corner Radius",
		Description = "0px sharp (Obsidian) to 20px rounded",
		Min = 0,
		Max = 20,
		Increment = 1,
		Default = Lumen.Config.CornerRadius or 12,
		Suffix = "px",
		Flag = "UICornerRadius",
		Callback = function(v)
			Lumen:SetCornerRadius(v)
		end,
	})

	winSec:Slider({
		Name = "Sidebar Width",
		Min = 170,
		Max = 270,
		Increment = 4,
		Default = Lumen.Config.SidebarWidth or 216,
		Suffix = "px",
		Flag = "UISidebarWidth",
		Callback = function(v)
			Lumen.Config.SidebarWidth = v
			for _, w in self.Windows do
				w:SetSidebarWidth(v)
			end
		end,
	})

	winSec:Toggle({
		Name = "Compact Sidebar",
		Description = "Collapse sidebar into an icon rail",
		Default = Lumen.Config.CompactSidebar,
		Flag = "UICompactSidebar",
		Callback = function(v)
			Lumen.Config.CompactSidebar = v
			for _, w in self.Windows do
				w:SetCompact(v)
			end
		end,
	})

	winSec:Dropdown({
		Name = "Toggle Style",
		Description = "Pill switches or Obsidian checkboxes",
		Values = {"Switch", "Checkbox"},
		Default = Lumen.Config.ToggleStyle or "Switch",
		Flag = "UIToggleStyle",
		Callback = function(v)
			Lumen:SetToggleStyle(v)
		end,
	})

	winSec:Toggle({
		Name = "Top Accent Line",
		Description = "Glowing gradient bar along top edge",
		Default = Lumen.Config.TopAccentLine,
		Flag = "UITopAccent",
		Callback = function(v)
			Lumen.Config.TopAccentLine = v
			for _, w in self.Windows do
				w:SetTopAccent(v)
			end
		end,
	})

	winSec:Toggle({
		Name = "Floating Toggle Button",
		Description = "Draggable top pill for mobile / quick toggle",
		Default = Lumen.Config.MobileButton,
		Flag = "UIMobileButton",
		Callback = function(v)
			Lumen.Config.MobileButton = v
			if self.MobilePill then
				self.MobilePill.Visible = v
			end
		end,
	})

	winSec:Toggle({
		Name = "Custom Cursor",
		Description = "Precision crosshair cursor over UI",
		Default = Lumen.Config.CustomCursor,
		Flag = "UICustomCursor",
		Callback = function(v)
			Lumen.Config.CustomCursor = v
		end,
	})

	local snapToggle = winSec:Toggle({
		Name = "Window Snapping",
		Description = "Snap windows to screen center & edges",
		Default = Lumen.Config.Snapping,
		Flag = "UISnapping",
		Callback = function(v)
			Lumen.Config.Snapping = v
		end,
	})

	winSec:Slider({
		Name = "Snap Distance",
		Min = 8,
		Max = 48,
		Increment = 2,
		Default = Lumen.Config.SnapDistance or 24,
		Suffix = "px",
		Flag = "UISnapDist",
		Callback = function(v)
			Lumen.Config.SnapDistance = v
		end,
	}):Depend(snapToggle, true)

	winSec:Toggle({
		Name = "Unlock Mouse",
		Description = "Free cursor in first-person games",
		Default = Lumen.Config.UnlockMouse,
		Flag = "UIUnlockMouse",
		Callback = function(v)
			Lumen.Config.UnlockMouse = v
			self:_refreshMouse()
		end,
	})

	winSec:Toggle({
		Name = "Show Taskbar Dock",
		Default = true,
		Flag = "UIDockVisible",
		Callback = function(v)
			self.Dock.Visible = v
		end,
	})

	winSec:Divider("BACKGROUND & BLUR")

	local blurToggle = winSec:Toggle({
		Name = "Background Blur",
		Description = "Blur world when a window is open",
		Default = Lumen.Config.Blur,
		Flag = "UIBlurEnabled",
		Callback = function(v)
			self:SetBlur(v, nil)
		end,
	})

	winSec:Slider({
		Name = "Blur Intensity",
		Min = 2,
		Max = 32,
		Increment = 1,
		Default = Lumen.Config.BlurSize or 14,
		Flag = "UIBlurSize",
		Callback = function(v)
			self:SetBlur(nil, v)
		end,
	}):Depend(blurToggle, true)

	winSec:Input({
		Name = "Background Image",
		Description = "Asset ID or rbxassetid:// wallpaper",
		Placeholder = "rbxassetid://...",
		Default = Lumen.Config.BackgroundImage or "",
		Flag = "UIBackgroundImage",
		Callback = function(v)
			self:SetBackgroundImage(v, nil, nil)
		end,
	})

	winSec:Slider({
		Name = "Wallpaper Opacity",
		Min = 5,
		Max = 80,
		Increment = 5,
		Default = math.floor((1 - (Lumen.Config.BackgroundImageAlpha or 0.82)) * 100 + 0.5),
		Suffix = "%",
		Flag = "UIBackgroundAlpha",
		Callback = function(v)
			self:SetBackgroundImage(nil, 1 - (v / 100), nil)
		end,
	})

	winSec:Dropdown({
		Name = "Wallpaper Scale Mode",
		Values = {"Crop", "Tile", "Fit", "Stretch"},
		Default = Lumen.Config.BackgroundScale or "Crop",
		Flag = "UIBackgroundScale",
		Callback = function(v)
			self:SetBackgroundImage(nil, nil, v)
		end,
	})

	local animSec = tab:Section({
		Name = "Animations & HUD",
		Description = "Motion curves, transitions & HUD overlays",
		Icon = "sparkles",
		Side = "Right",
	})

	local animKeys = {"Window Toggle", "Tab Switch", "Section Collapse", "Dropdown Menu", "Popups", "Button Ripple", "Hover Effects"}
	animSec:Dropdown({
		Name = "Enabled Animations",
		Description = "Toggle motion per UI subsystem",
		Values = animKeys,
		Default = table.clone(animKeys),
		Multi = true,
		Flag = "UIEnabledAnims",
		Callback = function(selectedList)
			for _, k in animKeys do
				Lumen.Config.Animations[k] = table.find(selectedList, k) ~= nil
			end
		end,
	})

	animSec:Dropdown({
		Name = "Window Open Style",
		Values = {"Scale & Slide", "Scale", "Slide", "Fade", "Bounce", "Instant"},
		Default = Lumen.Config.WindowAnimStyle or "Scale & Slide",
		Flag = "UIWinAnimStyle",
		Callback = function(v)
			Lumen.Config.WindowAnimStyle = v
		end,
	})

	animSec:Slider({
		Name = "Window Transition Speed",
		Min = 0.1,
		Max = 0.8,
		Increment = 0.02,
		Default = Lumen.Config.WindowAnimSpeed or 0.38,
		Suffix = "s",
		Flag = "UIWinAnimSpeed",
		Callback = function(v)
			Lumen.Config.WindowAnimSpeed = v
		end,
	})

	animSec:Dropdown({
		Name = "Tab Switch Style",
		Values = {"Slide Bottom", "Slide Top", "Slide Right", "Slide Left", "Crossfade", "Instant"},
		Default = Lumen.Config.TabAnimStyle or "Slide Bottom",
		Flag = "UITabAnimStyle",
		Callback = function(v)
			Lumen.Config.TabAnimStyle = v
		end,
	})

	animSec:Slider({
		Name = "Tab Transition Speed",
		Min = 0.08,
		Max = 0.6,
		Increment = 0.02,
		Default = Lumen.Config.TabAnimSpeed or 0.28,
		Suffix = "s",
		Flag = "UITabAnimSpeed",
		Callback = function(v)
			Lumen.Config.TabAnimSpeed = v
		end,
	})

	animSec:Slider({
		Name = "Tab Swipe Offset",
		Min = 6,
		Max = 48,
		Increment = 2,
		Default = Lumen.Config.TabSwipeOffset or 18,
		Suffix = "px",
		Flag = "UITabSwipeOffset",
		Callback = function(v)
			Lumen.Config.TabSwipeOffset = v
		end,
	})

	animSec:Divider("HUD & NOTIFICATIONS")

	local watermark, binds
	animSec:Toggle({
		Name = "Watermark Overlay",
		Description = "Draggable FPS, ping & time bar",
		Default = self.WatermarkFrame ~= nil and self.WatermarkFrame.Visible,
		Flag = "UIWatermark",
		Callback = function(v)
			if self.WatermarkFrame then
				self.WatermarkFrame.Visible = v
			elseif v then
				watermark = watermark or self:Watermark()
				watermark:SetVisible(v)
			end
		end,
	})

	local kbToggle = animSec:Toggle({
		Name = "Keybind List Overlay",
		Description = "Draggable active keybinds panel",
		Default = self.BindFrame ~= nil and self.BindFrame.Visible,
		Flag = "UIKeybindList",
		Callback = function(v)
			if self.BindFrame then
				self.BindFrame.Visible = v
			elseif v then
				binds = binds or self:KeybindList()
				binds:SetVisible(v)
			end
		end,
	})

	animSec:Dropdown({
		Name = "Keybind List Mode",
		Values = {"Bound Only", "Active Only"},
		Default = Lumen.Config.KeybindFilter or "Bound Only",
		Flag = "UIKeybindFilter",
		Callback = function(v)
			Lumen.Config.KeybindFilter = v
		end,
	}):Depend(kbToggle, true)

	animSec:Toggle({
		Name = "Interactive Keybind List",
		Description = "Tap rows in keybind list to toggle",
		Default = Lumen.Config.KeybindInteractive,
		Flag = "UIKeybindInteractive",
		Callback = function(v)
			Lumen.Config.KeybindInteractive = v
		end,
	}):Depend(kbToggle, true)

	animSec:Dropdown({
		Name = "Notification Corner",
		Values = {"BottomRight", "TopRight", "BottomLeft", "TopLeft"},
		Default = "BottomRight",
		Flag = "UIToastPos",
		Callback = function(v)
			self:SetToastPosition(v)
		end,
	})

	animSec:Slider({
		Name = "Notification Duration",
		Min = 2,
		Max = 10,
		Increment = 0.5,
		Default = Lumen.Config.ToastDuration or 4,
		Suffix = "s",
		Flag = "UIToastDuration",
		Callback = function(v)
			Lumen.Config.ToastDuration = v
		end,
	})

	animSec:Toggle({
		Name = "Notification Sounds",
		Default = true,
		Flag = "UISounds",
		Callback = function(v)
			Lumen.Config.Sounds = v
		end,
	})

	animSec:Toggle({
		Name = "Do Not Disturb",
		Description = "Silence popups and badge alerts",
		Default = false,
		Flag = "UIDND",
		Callback = function(v)
			self:SetDND(v)
		end,
	})

	local cfgTab = window:Tab({Name = "Configs", Icon = "folder"})
	local cfgSec = cfgTab:Section({
		Name = "Configuration Manager",
		Description = "Save, load, autoload & share profiles",
		Icon = "folder",
		Side = "Left",
	})

	local nameInput = cfgSec:Input({
		Name = "Config Name",
		Default = "default",
		Placeholder = "profile_name...",
		Flag = "UIConfigName",
	})

	local picker
	picker = cfgSec:Dropdown({
		Name = "Saved Profiles",
		Values = Lumen:ListConfigs(),
		AllowNull = true,
		Flag = "UIConfigList",
		Format = function(v)
			return v == Lumen:GetAutoloadConfig() and (v .. " (autoload)") or v
		end,
		Callback = function(v)
			if v then
				nameInput:Set(v, true)
			end
		end,
	})

	local autoLabel = cfgSec:Label("Current autoload config: " .. (Lumen:GetAutoloadConfig() or "none"))

	local function refreshConfigs()
		picker:SetValues(Lumen:ListConfigs())
		picker:Refresh()
		autoLabel:SetText("Current autoload config: " .. (Lumen:GetAutoloadConfig() or "none"))
	end

	local saveBtn = cfgSec:Button({
		Name = "Create / Save",
		Style = "Primary",
		Icon = "save",
		Callback = function()
			local name = nameInput.Value
			local ok = Lumen:SaveConfig(name)
			refreshConfigs()
			self:Notify({Title = ok and "Config Saved" or "Save Failed", Content = tostring(name), Type = ok and "Success" or "Error"})
		end,
	})
	saveBtn:SubButton({
		Name = "Load Config",
		Icon = "download",
		Callback = function()
			local name = picker.Value or nameInput.Value
			local ok = Lumen:LoadConfig(name)
			self:Notify({Title = ok and "Config Loaded" or "Load Failed", Content = tostring(name), Type = ok and "Success" or "Error"})
		end,
	})

	local overBtn = cfgSec:Button({
		Name = "Overwrite",
		Icon = "save",
		Callback = function()
			local name = picker.Value or nameInput.Value
			if not name or name == "" then
				return
			end
			window:Dialog({
				Title = "Overwrite Config",
				Content = "Overwrite profile '" .. name .. "' with your current settings?",
				ConfirmText = "Overwrite",
				Callback = function()
					local ok = Lumen:SaveConfig(name)
					refreshConfigs()
					self:Notify({Title = ok and "Overwritten" or "Failed", Content = tostring(name), Type = ok and "Success" or "Error"})
				end,
			})
		end,
	})
	overBtn:SubButton({
		Name = "Delete Config",
		Icon = "trash-2",
		Risky = true,
		Callback = function()
			local name = picker.Value or nameInput.Value
			if not name or name == "" then
				return
			end
			window:Dialog({
				Title = "Delete Config",
				Content = "Delete profile '" .. name .. "' permanently?",
				ConfirmText = "Delete",
				Risky = true,
				Callback = function()
					Lumen:DeleteConfig(name)
					refreshConfigs()
					self:Notify({Title = "Deleted", Content = "Removed profile '" .. name .. "'.", Type = "Info"})
				end,
			})
		end,
	})

	local autoBtn = cfgSec:Button({
		Name = "Set as Autoload",
		Icon = "check",
		Callback = function()
			local name = picker.Value or nameInput.Value
			if not name or name == "" then
				self:Notify({Title = "Autoload", Content = "Select or enter a profile first.", Type = "Warning"})
				return
			end
			Lumen:SetAutoloadConfig(name)
			refreshConfigs()
			self:Notify({Title = "Autoload Set", Content = "Profile '" .. name .. "' will load on startup.", Type = "Success"})
		end,
	})
	autoBtn:SubButton({
		Name = "Reset Autoload",
		Icon = "rotate-ccw",
		Callback = function()
			Lumen:ResetAutoloadConfig()
			refreshConfigs()
			self:Notify({Title = "Autoload Reset", Content = "Cleared startup autoload profile.", Type = "Info"})
		end,
	})

	cfgSec:Button({
		Name = "Refresh Profile List",
		Icon = "rotate-ccw",
		Callback = refreshConfigs,
	})

	cfgSec:Toggle({
		Name = "Ignore Theme Settings",
		Description = "Keep theme colors separate from feature configs",
		Default = Lumen.IgnoreThemeInConfig,
		Callback = function(v)
			Lumen.IgnoreThemeInConfig = v
		end,
	})

	cfgSec:Divider("IMPORT & EXPORT")

	local cfgJsonInput = cfgSec:Input({
		Name = "Config JSON",
		Placeholder = "Paste config JSON...",
		Flag = "UIConfigJSON",
	})
	local impCfgBtn = cfgSec:Button({
		Name = "Import Config",
		Icon = "download",
		Callback = function()
			local ok = Lumen:ImportJSON(cfgJsonInput.Value)
			self:Notify({Title = ok and "Config Imported" or "Import Failed", Content = ok and "Applied configuration JSON." or "Invalid JSON.", Type = ok and "Success" or "Error"})
		end,
	})
	impCfgBtn:SubButton({
		Name = "Export Config",
		Icon = "copy",
		Callback = function()
			local raw = Lumen:ExportJSON()
			cfgJsonInput:Set(raw, true)
			if setclipboard then
				setclipboard(raw)
			end
			self:Notify({Title = "Config Exported", Content = "Copied config JSON to clipboard.", Type = "Success"})
		end,
	})

	local sysSec = cfgTab:Section({
		Name = "Session & Info",
		Description = "Runtime controls & diagnostics",
		Icon = "cpu",
		Side = "Right",
	})
	sysSec:Paragraph({
		Name = "Lumen UI v" .. Lumen.Version,
		Content = "Includes 22 built-in themes, custom theme manager with WCAG contrast verification, mobile support, window snapping, compact sidebar, sub-buttons, tabboxes, dependency boxes, and autoload profiles.",
	})
	sysSec:Button({
		Name = "Unload Interface",
		Icon = "power",
		Risky = true,
		Callback = function()
			window:Dialog({
				Title = "Unload Interface",
				Content = "Are you sure you want to unload Lumen UI and disconnect all listeners?",
				ConfirmText = "Unload",
				Risky = true,
				Callback = function()
					Lumen:Unload()
				end,
			})
		end,
	})

	local defaultTheme = Lumen:GetDefaultTheme()
	if defaultTheme and defaultTheme ~= "Midnight" then
		Lumen:LoadCustomTheme(defaultTheme)
		if Themes[defaultTheme] then
			presetDrop:Set(defaultTheme, true)
		end
	end

	return tab
end

function Lumen:GiveSignal(conn)
	if conn then
		table.insert(connections, conn)
	end
	return conn
end

function Lumen:OnUnload(fn)
	if type(fn) == "function" then
		table.insert(self.UnloadSignals, fn)
	end
end

function Lumen:SafeCallback(fn, ...)
	if type(fn) ~= "function" then
		return
	end
	local ok, res = pcall(fn, ...)
	if not ok and self.NotifyOnError and self.Hub then
		self.Hub:Notify({Title = "Callback Error", Content = tostring(res), Type = "Error"})
	end
	return res
end

function Lumen:MouseIsOverFrame(frame, pos)
	local p = pos and Vector2.new(pos.X, pos.Y) or mouse()
	return inside(frame, p)
end

function Lumen:GetCustomIcon(value)
	if not value or value == "" then
		return nil
	end
	local url = resolveIcon(value) or tostring(value)
	return {
		Url = url,
		Id = 0,
		IconName = tostring(value),
		ImageRectOffset = Vector2.zero,
		ImageRectSize = Vector2.zero,
	}
end

function Lumen:ApplyLucideIcon(img, data)
	if not img or type(data) ~= "table" then
		return
	end
	img.Image = data.Url or ""
	img.ImageRectOffset = data.ImageRectOffset or Vector2.zero
	img.ImageRectSize = data.ImageRectSize or Vector2.zero
end

function Lumen:AddToRegistry(inst, props)
	if inst and type(props) == "table" then
		self.Registry[inst] = props
		for prop, schemeKey in props do
			local val = type(schemeKey) == "function" and schemeKey() or (self.Scheme[schemeKey] or T[schemeKey])
			if val ~= nil then
				pcall(function()
					inst[prop] = val
				end)
			end
		end
	end
end

function Lumen:UpdateColorsUsingRegistry()
	if self.Scheme then
		local bg = self.Scheme.BackgroundColor or T.Back
		local main = self.Scheme.MainColor or T.Panel
		local accent = self.Scheme.AccentColor or T.Accent
		local outline = self.Scheme.OutlineColor or T.Stroke
		local fontCol = self.Scheme.FontColor or T.Text
		T.Back = bg
		T.Panel = main
		T.Side = bg:Lerp(main, 0.45)
		T.Raised = main:Lerp(WHITE, 0.05)
		T.Hover = main:Lerp(WHITE, 0.1)
		T.Stroke = outline
		T.Text = fontCol
		T.Muted = fontCol:Lerp(bg, 0.46)
		T.Accent = accent
		if self.Scheme.RedColor then
			T.Danger = self.Scheme.RedColor
		end
	end
	refreshTheme(true)
end

function Lumen:SetDPIScale(val)
	local n = tonumber(val) or 1
	if n > 5 then
		n = n / 100
	end
	self.DPIScale = math.clamp(n, 0.65, 1.6)
	self.Config.Scale = self.DPIScale
	if self.Hub then
		self.Hub:SetScale(self.DPIScale)
	end
end

function Lumen:SetNotifySide(side)
	self.NotifySide = tostring(side or "Right")
	local s = self.NotifySide:lower()
	local pos = s == "left" and "BottomLeft" or "BottomRight"
	if self.Hub then
		self.Hub:SetToastPosition(pos)
	else
		self.Config.ToastPosition = pos
	end
end

function Lumen:SetBackgroundImage(img)
	self.Scheme.BackgroundImage = tostring(img or "")
	if self.Hub then
		self.Hub:SetBackgroundImage(self.Scheme.BackgroundImage)
	else
		self.Config.BackgroundImage = self.Scheme.BackgroundImage
	end
end

function Lumen:UpdateSearch(q)
	q = tostring(q or ""):lower()
	if self.Window then
		if self.GlobalSearch and q ~= "" then
			for _, t in self.Window.Tabs do
				t:Filter(q)
			end
		elseif self.Window.Active then
			self.Window.Active:Filter(q)
		end
	end
end

function Lumen:ChangeCursorIcon(url)
	self.CustomCursorUrl = url
end

function Lumen:ChangeCursorIconSize(size)
	self.CustomCursorSize = size
end

function Lumen:ResetCursorIcon()
	self.CustomCursorUrl = nil
end

function Lumen:AddDraggableLabel(textStr, iconUri)
	local pill = registerSurface(create("TextButton", {
		Parent = Layers.Hud,
		Position = UDim2.fromOffset(18, 18),
		Size = UDim2.fromOffset(0, 34),
		AutomaticSize = Enum.AutomaticSize.X,
		AutoButtonColor = false,
		FontFace = FONT_B,
		TextSize = 12,
		Text = "      " .. tostring(textStr or ""),
		TextXAlignment = Enum.TextXAlignment.Left,
		Theme = {BackgroundColor3 = "Panel", TextColor3 = "Text"},
	}, {corner(10), stroke("Stroke"), pad(0, 14, 0, 12)}), 0.85, 0.04)

	local iconImg = create("ImageLabel", {
		Parent = pill,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		Image = resolveIcon(iconUri) or tostring(iconUri or ""),
		ScaleType = Enum.ScaleType.Fit,
		Visible = iconUri ~= nil and iconUri ~= "",
	})
	drag(pill, pill)

	local curText = tostring(textStr or "")
	local iconPos = "Left"
	local function updateLayout()
		if iconImg.Visible then
			if iconPos == "Right" then
				iconImg.AnchorPoint = Vector2.new(1, 0.5)
				iconImg.Position = UDim2.new(1, 0, 0.5, 0)
				pill.Text = curText .. "      "
			else
				iconImg.AnchorPoint = Vector2.new(0, 0.5)
				iconImg.Position = UDim2.new(0, 0, 0.5, 0)
				pill.Text = "      " .. curText
			end
		else
			pill.Text = curText
		end
	end
	updateLayout()

	local holder = {
		Label = pill,
		Frame = pill,
		SetText = function(_, t)
			curText = tostring(t or "")
			updateLayout()
		end,
		SetVisible = function(_, v)
			pill.Visible = v ~= false
		end,
		SetIcon = function(_, uri)
			iconImg.Image = resolveIcon(uri) or tostring(uri or "")
			iconImg.Visible = uri ~= nil and uri ~= ""
			updateLayout()
		end,
		SetIconPosition = function(_, pos)
			iconPos = pos or "Left"
			updateLayout()
		end,
		Destroy = function()
			if pill.Parent then
				pill:Destroy()
			end
		end,
	}
	return holder
end

function Lumen:AddDraggableButton(textStr, func, isToggle)
	local btn = registerSurface(create("TextButton", {
		Parent = Layers.Hud,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 56),
		Size = UDim2.fromOffset(0, 32),
		AutomaticSize = Enum.AutomaticSize.X,
		AutoButtonColor = false,
		FontFace = FONT_B,
		TextSize = 12,
		Text = tostring(textStr or "Button"),
		Theme = {BackgroundColor3 = "Panel", TextColor3 = "Text"},
	}, {corner(9), stroke("Stroke"), pad(0, 14, 0, 14)}), 0.85, 0.04)

	local wasMoved = drag(btn, btn)
	local state = false
	btn.Activated:Connect(function()
		if wasMoved() then
			return
		end
		if isToggle then
			state = not state
		end
		if type(func) == "function" then
			task.spawn(func, state)
		end
	end)

	local obj = {
		Button = btn,
		SetText = function(_, t)
			btn.Text = tostring(t or "")
		end,
		SetVisible = function(_, v)
			btn.Visible = v ~= false
		end,
		Destroy = function()
			if btn.Parent then
				btn:Destroy()
			end
		end,
	}
	if self.Window and self.Window.MobileButtons then
		table.insert(self.Window.MobileButtons, obj)
	end
	return obj
end

function Lumen:Notify(info, duration, sound, volume)
	if not self.Hub then
		return
	end
	local data = type(info) == "table" and table.clone(info) or {Title = tostring(info or "Notification")}
	data.Duration = data.Duration or data.Time or duration
	data.Sound = data.Sound or data.SoundId or sound
	data.Volume = data.Volume or volume
	return self.Hub:Notify(data)
end

function Lumen:Toggle(state)
	if state == nil then
		state = not self.Toggled
	end
	self.Toggled = state == true
	if self.Hub then
		self.Hub:SetVisible(self.Toggled)
	end
end

function Lumen:CreateWindow(o)
	o = o or {}
	local key = o.ToggleKeybind or o.Key or Enum.KeyCode.RightShift
	self.ToggleKeybind = key
	self.GlobalSearch = o.GlobalSearch == true
	if o.NotifySide then
		self:SetNotifySide(o.NotifySide)
	end
	if o.CornerRadius then
		self.CornerRadius = o.CornerRadius
		self.Config.CornerRadius = o.CornerRadius
	end
	if o.DPIScale then
		self:SetDPIScale(o.DPIScale)
	end
	local hub = self.Hub or self:Taskbar({
		Name = o.Title or o.Name or "Lumen",
		Description = o.Footer or o.SubTitle or o.Description or "Universal Suite",
		Icon = o.Icon or "layers",
		Key = key,
		CornerRadius = o.CornerRadius or 12,
		KeybindList = true,
	})
	if hub.BindFrame then
		self.KeybindFrame = hub.BindFrame
		if not o.ShowKeybindList then
			hub.BindFrame.Visible = false
		end
	end
	local win = hub:Window({
		Name = o.Title or o.Name or "Lumen",
		Description = o.Footer or o.SubTitle or o.Description or "",
		Icon = o.Icon or "layers",
		Size = o.Size or UDim2.fromOffset(880, 640),
		Position = o.Position,
		Center = o.Center,
		AutoShow = o.AutoShow,
		Compact = o.Compact,
		Resizable = o.Resizable,
	})
	if o.Animations then
		win:SetAnimations(o.Animations)
	end
	self.Window = win
	task.defer(function()
		for _, t in win.Tabs do
			local clean = tostring(t.Name or ""):gsub("<[^>]+>", ""):lower():gsub("^2%s+", ""):match("^%s*(.-)%s*$")
			if clean == "ui settings" or clean == "settings" then
				local glassSec = t:Section({
					Name = "Lumen Glass, Blur & Dock",
					Description = "World blur, acrylic glass transparency & bottom dock",
					Icon = "sparkles",
					Side = "Right",
				})
				local bToggle = glassSec:Toggle({
					Name = "Background Blur",
					Description = "Blur 3D world when UI is open",
					Default = Lumen.Config.Blur,
					Flag = "UIBlurEnabled",
					Callback = function(v)
						hub:SetBlur(v, nil)
					end,
				})
				glassSec:Slider({
					Name = "Blur Intensity",
					Min = 2,
					Max = 32,
					Increment = 1,
					Default = Lumen.Config.BlurSize or 14,
					Suffix = " px",
					Flag = "UIBlurSize",
					Callback = function(v)
						hub:SetBlur(nil, v)
					end,
				}):Depend(bToggle, true)
				glassSec:Slider({
					Name = "UI Glass Transparency",
					Min = 0,
					Max = 65,
					Increment = 1,
					Default = math.floor((Lumen.Config.Transparency or 0.16) * 100 + 0.5),
					Suffix = "%",
					Flag = "UITransparency",
					Callback = function(v)
						Lumen:SetTransparency(v / 100)
					end,
				})
				glassSec:Slider({
					Name = "Corner Radius",
					Min = 0,
					Max = 22,
					Increment = 1,
					Default = Lumen.Config.CornerRadius or 12,
					Suffix = " px",
					Flag = "UICornerRadius",
					Callback = function(v)
						Lumen:SetCornerRadius(v)
					end,
				})
				glassSec:Dropdown({
					Name = "Toggle Style",
					Values = {"Switch", "Checkbox"},
					Default = Lumen.Config.ToggleStyle or "Switch",
					Flag = "UIToggleStyle",
					Callback = function(v)
						Lumen:SetToggleStyle(v)
					end,
				})
				glassSec:Toggle({
					Name = "Top Accent Line",
					Default = Lumen.Config.TopAccentLine ~= false,
					Flag = "UITopAccent",
					Callback = function(v)
						Lumen.Config.TopAccentLine = v
						win:SetTopAccent(v)
					end,
				})
				glassSec:Toggle({
					Name = "Bottom Taskbar Dock",
					Default = hub.Dock ~= nil and hub.Dock.Visible,
					Flag = "UIDockVisible",
					Callback = function(v)
						if hub.Dock then
							hub.Dock.Visible = v
						end
					end,
				})
				glassSec:Toggle({
					Name = "Floating Toggle Pill",
					Default = Lumen.Config.MobileButton == true,
					Flag = "UIMobileButton",
					Callback = function(v)
						Lumen.Config.MobileButton = v
						if hub.MobilePill then
							hub.MobilePill.Visible = v
						end
					end,
				})
				break
			end
		end
	end)
	return win
end

function Lumen:Taskbar(o)
	if self ~= Lumen and type(self) == "table" and o == nil then
		o = self
		self = Lumen
	end
	o = o or {}
	if o.ConfigFolder then
		self.Folder = o.ConfigFolder
	end
	if o.Theme and Themes[o.Theme] then
		self:SetTheme(o.Theme)
	end
	if o.Blur ~= nil then
		if type(o.Blur) == "boolean" then
			self.Config.Blur = o.Blur
		elseif type(o.Blur) == "number" then
			self.Config.Blur = o.Blur > 0
			self.Config.BlurSize = o.Blur
		end
	end
	if o.Transparency ~= nil then
		self.Config.Transparency = o.Transparency
	end
	if o.Scale then
		self.Config.Scale = o.Scale
	end
	if o.CornerRadius then
		self.Config.CornerRadius = o.CornerRadius
	end
	if o.CustomCursor ~= nil then
		self.Config.CustomCursor = o.CustomCursor
	end
	if o.MobileButton ~= nil then
		self.Config.MobileButton = o.MobileButton
	elseif o.MobileFriendly ~= nil then
		self.Config.MobileButton = o.MobileFriendly
	end
	local hub = setmetatable({
		Name = o.Name or "Lumen",
		Description = o.Description or o.Sub or "Universal Suite",
		IconName = o.Icon or "layers",
		Windows = {},
		Entries = {},
		History = {},
		Toasts = {},
		Unread = 0,
		Visible = true,
		Ready = false,
		SplashActive = false,
		DND = false,
		Z = 10,
		Key = o.Key or Enum.KeyCode.RightShift,
		Sound = o.NotifySound,
	}, Hub)
	Lumen.Hub = hub
	hub:_buildDock()
	hub:_buildMobileButton()
	hub:_buildStart()
	hub:_buildNotifications()
	if o.Watermark then
		hub:Watermark()
	end
	if o.KeybindList then
		hub:KeybindList()
		self.KeybindFrame = hub.BindFrame
	end
	hub:_inputs()
	hub:_splash(o)
	return hub
end
Lumen.new = Lumen.Taskbar

function Lumen:Unload()
	if self.Unloaded then
		return
	end
	self.Unloaded = true
	for _, fn in self.UnloadSignals do
		pcall(fn)
	end
	table.clear(self.UnloadSignals)
	for _, c in connections do
		pcall(function()
			c:Disconnect()
		end)
	end
	table.clear(connections)
	table.clear(bindings)
	table.clear(hooks)
	table.clear(fontLabels)
	table.clear(surfaceFrames)
	table.clear(cornerNodes)
	table.clear(toggleNodes)
	table.clear(self.Registry)
	if self.Hub then
		for _, t in self.Hub.Toasts do
			pcall(function()
				t.Conn:Disconnect()
			end)
		end
		if self.Hub.BlurEffect then
			pcall(function()
				self.Hub.BlurEffect:Destroy()
			end)
		end
	end
	pcall(function()
		Gui:Destroy()
	end)
	env.Lumen = nil
end

return Lumen
