local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local SoundService = game:GetService("SoundService")

local env = getgenv and getgenv() or _G
if env.Lumen then
	pcall(env.Lumen.Unload, env.Lumen)
end

local Lumen = {
	Flags = {},
	Options = {},
	Binds = {},
	ThemeControls = {},
	Folder = "Lumen",
	Version = "3.0",
	Config = {
		Transparency = 0,
		Scale = 1,
		Blur = true,
		BlurSize = 14,
		UnlockMouse = false,
		ToastPosition = "BottomRight",
		ToastDuration = 4,
		Sounds = true,
	},
}
env.Lumen = Lumen

local function rgb(r, g, b)
	return Color3.fromRGB(r, g, b)
end

local Themes = {
	Midnight = {
		Back = rgb(11, 11, 15), Side = rgb(14, 14, 19), Panel = rgb(18, 18, 24), Raised = rgb(26, 26, 35),
		Hover = rgb(35, 35, 46), Stroke = rgb(39, 39, 52), Text = rgb(240, 240, 247), Muted = rgb(130, 130, 148),
		Accent = rgb(124, 92, 255), Success = rgb(52, 211, 153), Warning = rgb(251, 191, 36), Danger = rgb(248, 81, 99),
	},
	Neverlose = {
		Back = rgb(7, 10, 20), Side = rgb(9, 14, 27), Panel = rgb(12, 18, 34), Raised = rgb(19, 27, 49),
		Hover = rgb(27, 37, 65), Stroke = rgb(29, 41, 72), Text = rgb(235, 241, 255), Muted = rgb(115, 132, 174),
		Accent = rgb(41, 148, 255), Success = rgb(52, 211, 153), Warning = rgb(251, 191, 36), Danger = rgb(248, 81, 99),
	},
	Obsidian = {
		Back = rgb(14, 14, 15), Side = rgb(17, 17, 19), Panel = rgb(22, 22, 25), Raised = rgb(30, 30, 34),
		Hover = rgb(39, 39, 44), Stroke = rgb(44, 44, 50), Text = rgb(242, 242, 244), Muted = rgb(132, 132, 140),
		Accent = rgb(135, 95, 255), Success = rgb(52, 211, 153), Warning = rgb(251, 191, 36), Danger = rgb(248, 81, 99),
	},
	Catppuccin = {
		Back = rgb(17, 17, 27), Side = rgb(24, 24, 37), Panel = rgb(30, 30, 46), Raised = rgb(49, 50, 68),
		Hover = rgb(69, 71, 90), Stroke = rgb(69, 71, 90), Text = rgb(205, 214, 244), Muted = rgb(147, 153, 178),
		Accent = rgb(203, 166, 247), Success = rgb(166, 227, 161), Warning = rgb(249, 226, 175), Danger = rgb(243, 139, 168),
	},
	TokyoNight = {
		Back = rgb(15, 16, 26), Side = rgb(20, 22, 35), Panel = rgb(26, 27, 44), Raised = rgb(36, 40, 62),
		Hover = rgb(46, 52, 80), Stroke = rgb(52, 59, 90), Text = rgb(192, 202, 245), Muted = rgb(115, 125, 168),
		Accent = rgb(122, 162, 247), Success = rgb(158, 206, 106), Warning = rgb(224, 175, 104), Danger = rgb(247, 118, 142),
	},
	Rose = {
		Back = rgb(13, 10, 12), Side = rgb(17, 13, 16), Panel = rgb(22, 17, 21), Raised = rgb(31, 24, 30),
		Hover = rgb(42, 32, 40), Stroke = rgb(49, 38, 46), Text = rgb(246, 238, 242), Muted = rgb(144, 124, 134),
		Accent = rgb(255, 92, 145), Success = rgb(52, 211, 153), Warning = rgb(251, 191, 36), Danger = rgb(248, 81, 99),
	},
	Emerald = {
		Back = rgb(8, 12, 11), Side = rgb(11, 16, 14), Panel = rgb(15, 21, 19), Raised = rgb(22, 31, 28),
		Hover = rgb(30, 42, 38), Stroke = rgb(35, 49, 44), Text = rgb(236, 247, 243), Muted = rgb(116, 142, 133),
		Accent = rgb(52, 211, 153), Success = rgb(52, 211, 153), Warning = rgb(251, 191, 36), Danger = rgb(248, 81, 99),
	},
	Crimson = {
		Back = rgb(13, 9, 10), Side = rgb(18, 12, 14), Panel = rgb(24, 16, 18), Raised = rgb(34, 22, 25),
		Hover = rgb(45, 30, 34), Stroke = rgb(54, 35, 40), Text = rgb(248, 238, 240), Muted = rgb(148, 122, 128),
		Accent = rgb(244, 63, 94), Success = rgb(52, 211, 153), Warning = rgb(251, 191, 36), Danger = rgb(248, 81, 99),
	},
}

local Fonts = {
	Inter = "rbxassetid://12187365364",
	Gotham = "rbxasset://fonts/families/GothamSSm.json",
	BuilderSans = "rbxasset://fonts/families/BuilderSans.json",
	Ubuntu = "rbxasset://fonts/families/Ubuntu.json",
	RobotoMono = "rbxasset://fonts/families/RobotoMono.json",
	Jura = "rbxasset://fonts/families/Jura.json",
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

local connections = {}
local bindings = {}
local hooks = {}
local fontLabels = {}
local surfaceFrames = {}

local function link(signal, fn)
	local c = signal:Connect(fn)
	table.insert(connections, c)
	return c
end

local function tween(obj, props, time, style, dir)
	TS:Create(obj, TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
end

local function apply(obj, props, animate, time)
	if animate then
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

local function refreshTheme(syncControls)
	local alive = {}
	for _, b in bindings do
		if b[1].Parent then
			tween(b[1], {[b[2]] = T[b[3]]}, 0.28)
			table.insert(alive, b)
		end
	end
	bindings = alive
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
	local family = Fonts[name] or name
	if type(family) ~= "string" then
		return
	end
	FONT = Font.new(family, Enum.FontWeight.Medium)
	FONT_B = Font.new(family, Enum.FontWeight.SemiBold)
	FONT_X = Font.new(family, Enum.FontWeight.Bold)
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

function Lumen:SetTransparency(alpha)
	alpha = math.clamp(tonumber(alpha) or 0, 0, 0.75)
	self.Config.Transparency = alpha
	local alive = {}
	for _, entry in surfaceFrames do
		local frame, factor = entry[1], entry[2]
		if frame.Parent then
			tween(frame, {BackgroundTransparency = alpha * factor}, 0.2)
			table.insert(alive, entry)
		end
	end
	surfaceFrames = alive
end

local function registerSurface(frame, factor)
	factor = factor or 1
	frame.BackgroundTransparency = Lumen.Config.Transparency * factor
	table.insert(surfaceFrames, {frame, factor})
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

local function corner(r)
	return create("UICorner", {CornerRadius = typeof(r) == "UDim" and r or UDim.new(0, r)})
end

local function stroke(color, thickness, transparency)
	local props = {
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}
	if type(color) == "string" then
		props.Theme = {Color = color}
	else
		props.Color = color
	end
	return create("UIStroke", props)
end

local function pad(t, r, b, l)
	r = r or t
	b = b or t
	l = l or r
	return create("UIPadding", {
		PaddingTop = UDim.new(0, t),
		PaddingRight = UDim.new(0, r),
		PaddingBottom = UDim.new(0, b),
		PaddingLeft = UDim.new(0, l),
	})
end

local function list(gap, props)
	local p = {Padding = UDim.new(0, gap), SortOrder = Enum.SortOrder.LayoutOrder}
	if props then
		for k, v in props do
			p[k] = v
		end
	end
	return create("UIListLayout", p)
end

local function text(props)
	local weight = "M"
	if props.FontFace == FONT_X then
		weight = "X"
	elseif props.FontFace == FONT_B then
		weight = "B"
	end
	local p = {
		BackgroundTransparency = 1,
		FontFace = FONT,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Text = "",
		Size = UDim2.fromScale(1, 1),
		Theme = {TextColor3 = "Text"},
	}
	for k, v in props do
		p[k] = v
	end
	if props.TextColor3 and not props.Theme then
		p.Theme = nil
	end
	return registerFont(create("TextLabel", p), weight)
end

local function hit(parent)
	return create("TextButton", {
		Parent = parent,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
	})
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function isMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

local function mouse()
	return UIS:GetMouseLocation()
end

local function inside(frame, pos)
	local p, s = frame.AbsolutePosition, frame.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local Core = {
	["chevron-down"] = 134243273101015, ["chevron-right"] = 92473583511724, ["x"] = 110786993356448,
	["minus"] = 118026365011536, ["bell"] = 97392696311902, ["bell-off"] = 78560046118930,
	["search"] = 121018724060431, ["check"] = 93898873302694, ["layers"] = 81973586053257,
	["house"] = 98755624629571, ["settings"] = 80758916183665, ["info"] = 124560466474914,
	["circle-check"] = 85262178816537, ["triangle-alert"] = 125920361880643, ["circle-x"] = 76821953846248,
	["keyboard"] = 121474456068237, ["palette"] = 86350350950064, ["clock"] = 121808839832144,
	["eye"] = 100033680381365, ["crosshair"] = 134242818164054, ["sliders-horizontal"] = 85538382643347,
	["user"] = 81589895647169, ["layout-grid"] = 81344910161871, ["power"] = 96479131758775,
	["trash-2"] = 109843431391323, ["zap"] = 130551565616516, ["shield"] = 110987169760162,
	["globe"] = 114238209622913, ["folder"] = 80846616596607, ["save"] = 126116963775616,
	["download"] = 134814648082393, ["upload"] = 138212042425501, ["gamepad-2"] = 92483947987410,
	["sparkles"] = 138635884129147, ["rotate-ccw"] = 110116685948665, ["star"] = 136141469398409,
	["lock"] = 134724289526879, ["play"] = 135609604299893, ["sword"] = 124448418211665,
	["target"] = 87563802520297, ["code"] = 107380207681249, ["terminal"] = 106783148545356,
	["list"] = 113179976918783, ["menu"] = 77021539815611, ["pin"] = 120978111007514,
	["plus"] = 111774323017047, ["copy"] = 78979572434545, ["mouse-pointer-2"] = 117093892862228,
}

Lumen.IconSource = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
Lumen.Icons = {}

local remoteIcons
local function iconAsset(name)
	if name == nil or name == "" then
		return nil
	end
	if type(name) == "number" then
		return "rbxassetid://" .. name
	end
	if name:find("^rbxasset") or name:find("^rbxthumb") then
		return name
	end
	if Lumen.Icons[name] then
		return Lumen.Icons[name]
	end
	if Core[name] then
		return "rbxassetid://" .. Core[name]
	end
	if remoteIcons == nil then
		local ok, data = pcall(function()
			return loadstring(game:HttpGet(Lumen.IconSource))()
		end)
		remoteIcons = ok and type(data) == "table" and data or false
	end
	if remoteIcons and remoteIcons[name] then
		return remoteIcons[name]
	end
	return nil
end

local function icon(parent, name, size, color)
	local asset = iconAsset(name)
	if not asset then
		return nil
	end
	local props = {
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size),
		Image = asset,
	}
	if type(color) == "string" then
		props.Theme = {ImageColor3 = color}
	else
		props.ImageColor3 = color or WHITE
	end
	return create("ImageLabel", props)
end

local function center(obj)
	if not obj then
		return nil
	end
	obj.AnchorPoint = Vector2.new(0.5, 0.5)
	obj.Position = UDim2.fromScale(0.5, 0.5)
	return obj
end

local Gui = create("ScreenGui", {
	Name = "Lumen",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 1000,
})
do
	local ok = pcall(function()
		Gui.Parent = (gethui and gethui()) or CoreGui
	end)
	if not ok or not Gui.Parent then
		Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
end
Lumen.Gui = Gui

local function layer(z)
	return create("Frame", {Parent = Gui, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = z})
end

local Layers = {
	Hud = layer(1), Windows = layer(2), Dock = layer(3), Panels = layer(4),
	Toasts = layer(5), Popups = layer(6), Tip = layer(7), Splash = layer(8),
}

local function play(id, volume)
	if not Lumen.Config.Sounds or not id or id == "" then
		return
	end
	local s = create("Sound", {SoundId = id, Volume = volume or 0.5, Parent = SoundService})
	s:Play()
	task.delay(6, function()
		s:Destroy()
	end)
end

local function shadow(parent, spread, transparency)
	return create("ImageLabel", {
		Parent = parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, spread, 1, spread),
		BackgroundTransparency = 1,
		Image = "rbxassetid://5554236805",
		ImageColor3 = BLACK,
		ImageTransparency = transparency or 0.55,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(23, 23, 277, 277),
		ZIndex = 0,
	})
end

local function accentGradient(grad, strength)
	onTheme(function()
		grad.Color = ColorSequence.new(T.Accent, T.Accent:Lerp(BLACK, strength or 0.35))
	end)
end

local function rim(parent, thickness)
	local s = create("UIStroke", {
		Parent = parent,
		Color = WHITE,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
	local g = create("UIGradient", {Parent = s, Rotation = 55})
	onTheme(function()
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.Accent:Lerp(T.Stroke, 0.35)),
			ColorSequenceKeypoint.new(0.4, T.Stroke),
			ColorSequenceKeypoint.new(1, T.Stroke),
		})
	end)
	return s
end

local popup
local function closePopup()
	if popup then
		local p = popup
		popup = nil
		p.Close()
	end
end

local function openPopup(frames, close, owner)
	closePopup()
	popup = {Frames = frames, Close = close, Owner = owner}
end

local function popupOpenFor(owner)
	return popup ~= nil and popup.Owner == owner
end

link(UIS.InputBegan, function(i)
	if popup and isPress(i) then
		local m = mouse()
		for _, f in popup.Frames do
			if inside(f, m) then
				return
			end
		end
		closePopup()
	end
end)

link(UIS.InputChanged, function(i)
	if popup and i.UserInputType == Enum.UserInputType.MouseWheel then
		local m = mouse()
		for _, f in popup.Frames do
			if inside(f, m) then
				return
			end
		end
		closePopup()
	end
end)

local function place(anchor, w, h, right)
	local p, s = anchor.AbsolutePosition, anchor.AbsoluteSize
	local view = Gui.AbsoluteSize
	local x = right and (p.X + s.X - w) or p.X
	x = math.clamp(x, 8, math.max(8, view.X - w - 8))
	local y = p.Y + s.Y + 6
	if y + h > view.Y - 8 then
		y = p.Y - h - 6
	end
	return UDim2.fromOffset(x, y)
end

local tip = create("CanvasGroup", {
	Parent = Layers.Tip,
	Visible = false,
	GroupTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0),
	Theme = {BackgroundColor3 = "Raised"},
}, {corner(8), stroke("Stroke"), pad(7, 11)})
local tipLabel = text({
	Parent = tip,
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0),
	TextSize = 12,
	TextTruncate = Enum.TextTruncate.None,
})
local tipToken = 0

link(RS.RenderStepped, function()
	if tip.Visible then
		local m, s, v = mouse(), tip.AbsoluteSize, Gui.AbsoluteSize
		local x = math.clamp(m.X + 14, 8, math.max(8, v.X - s.X - 8))
		local y = m.Y + 22
		if y + s.Y > v.Y - 8 then
			y = m.Y - s.Y - 12
		end
		tip.Position = UDim2.fromOffset(x, y)
	end
end)

local function tooltip(obj, content)
	obj.MouseEnter:Connect(function()
		tipToken += 1
		local token = tipToken
		task.delay(0.35, function()
			if token ~= tipToken then
				return
			end
			tipLabel.Text = type(content) == "function" and content() or content
			tip.Visible = true
			tween(tip, {GroupTransparency = 0}, 0.15)
		end)
	end)
	obj.MouseLeave:Connect(function()
		tipToken += 1
		local token = tipToken
		tween(tip, {GroupTransparency = 1}, 0.1)
		task.delay(0.12, function()
			if token == tipToken then
				tip.Visible = false
			end
		end)
	end)
end

local function ripple(parent, color)
	local m = mouse()
	local p, s = parent.AbsolutePosition, parent.AbsoluteSize
	local d = math.max(s.X, s.Y) * 2.4
	local dot = create("Frame", {
		Parent = parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(m.X - p.X, m.Y - p.Y),
		Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = color or WHITE,
		BackgroundTransparency = 0.86,
		BorderSizePixel = 0,
		ZIndex = 0,
	}, {corner(PILL)})
	tween(dot, {Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, 0.55)
	task.delay(0.6, function()
		dot:Destroy()
	end)
end

local function drag(handle, target, onEnd)
	local dragging, start, origin
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			start = mouse()
			origin = target.Position
		end
	end)
	link(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			local d = mouse() - start
			target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
			local view, p, s = Gui.AbsoluteSize, target.AbsolutePosition, target.AbsoluteSize
			local cx = math.clamp(p.X, 120 - s.X, view.X - 120)
			local cy = math.clamp(p.Y, 0, view.Y - 60)
			if cx ~= p.X or cy ~= p.Y then
				target.Position += UDim2.fromOffset(cx - p.X, cy - p.Y)
			end
		end
	end)
	link(UIS.InputEnded, function(i)
		if dragging and isPress(i) then
			dragging = false
			if onEnd then
				onEnd()
			end
		end
	end)
end

local Base = {}
Base.__index = Base

function Base:OnChanged(fn)
	table.insert(self._l, fn)
	return self
end

function Base:Fire(silent)
	if self.Flag then
		Lumen.Flags[self.Flag] = self.Value
	end
	if silent then
		return
	end
	for _, fn in self._l do
		task.spawn(fn, self.Value, self.Alpha)
	end
end

local function component(o, value, callback)
	local obj = setmetatable({Value = value, Flag = o.Flag, _l = {}}, Base)
	if callback then
		table.insert(obj._l, callback)
	end
	if o.Flag then
		Lumen.Options[o.Flag] = obj
		Lumen.Flags[o.Flag] = value
	end
	return obj
end

local function openMenu(anchor, o)
	local values = o.Values
	local w = math.max(o.Width or anchor.AbsoluteSize.X, 150)
	local searchable = o.Search or #values > 7
	local listH = math.min(#values * 30 + 8, 210)
	local h = listH + (searchable and 40 or 0)
	local panel = create("CanvasGroup", {
		Parent = Layers.Popups,
		Size = UDim2.fromOffset(w, h),
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(10), stroke("Stroke")})
	local final = place(anchor, w, h, o.Right)
	panel.Position = final + UDim2.fromOffset(0, -8)
	tween(panel, {Position = final, GroupTransparency = 0}, 0.22)

	local scroll = create("ScrollingFrame", {
		Parent = panel,
		Position = UDim2.fromOffset(0, searchable and 40 or 0),
		Size = UDim2.new(1, 0, 0, listH),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Theme = {ScrollBarImageColor3 = "Stroke"},
	}, {pad(4), list(2)})

	local entries = {}
	local function restyle()
		for name, e in entries do
			local on = o.Selected(name)
			tween(e.Label, {TextColor3 = on and T.Accent or T.Text}, 0.14)
			e.Check.Visible = on
		end
	end

	for idx, name in values do
		local b = create("TextButton", {
			Parent = scroll,
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = idx,
			Theme = {BackgroundColor3 = "Hover"},
		}, {corner(7)})
		local label = text({Parent = b, Text = tostring(name), Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0), TextSize = 12})
		local check = icon(b, "check", 14, "Accent")
		check.AnchorPoint = Vector2.new(1, 0.5)
		check.Position = UDim2.new(1, -9, 0.5, 0)
		entries[name] = {Button = b, Label = label, Check = check}
		b.MouseEnter:Connect(function()
			tween(b, {BackgroundTransparency = 0.35}, 0.12)
		end)
		b.MouseLeave:Connect(function()
			tween(b, {BackgroundTransparency = 1}, 0.12)
		end)
		b.Activated:Connect(function()
			o.OnPick(name)
			if o.Multi then
				restyle()
			else
				closePopup()
			end
		end)
	end
	restyle()

	if searchable then
		local box = create("Frame", {
			Parent = panel,
			Position = UDim2.fromOffset(8, 8),
			Size = UDim2.new(1, -16, 0, 26),
			Theme = {BackgroundColor3 = "Raised"},
		}, {corner(7), stroke("Stroke")})
		local glass = icon(box, "search", 13, "Muted")
		glass.AnchorPoint = Vector2.new(0, 0.5)
		glass.Position = UDim2.new(0, 9, 0.5, 0)
		local input = registerFont(create("TextBox", {
			Parent = box,
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(1, -34, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			PlaceholderText = "Filter...",
			FontFace = FONT,
			TextSize = 12,
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			Theme = {TextColor3 = "Text", PlaceholderColor3 = "Muted"},
		}), "M")
		input:GetPropertyChangedSignal("Text"):Connect(function()
			local q = input.Text:lower()
			for name, e in entries do
				e.Button.Visible = q == "" or tostring(name):lower():find(q, 1, true) ~= nil
			end
		end)
	end

	local closed = false
	local function close()
		if closed then
			return
		end
		closed = true
		if o.OnClose then
			o.OnClose()
		end
		tween(panel, {Position = final + UDim2.fromOffset(0, -8), GroupTransparency = 1}, 0.15)
		task.delay(0.16, function()
			panel:Destroy()
		end)
	end
	openPopup({panel, anchor}, close, o.Owner or anchor)
	return close
end

local KeyNames = {
	LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
	LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Backspace = "Bksp", Escape = "Esc",
	Delete = "Del", PageUp = "PgUp", PageDown = "PgDn", Insert = "Ins", CapsLock = "Caps",
	MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
}
local UNKNOWN = Enum.KeyCode.Unknown

local function keyName(v)
	if not v or v == UNKNOWN then
		return "None"
	end
	return KeyNames[v.Name] or v.Name
end

local function matches(v, i)
	return v ~= nil and v ~= UNKNOWN and (i.KeyCode == v or i.UserInputType == v)
end

local function makeBind(right, o, fire, label, isActive)
	local default = o.Default
	if type(default) == "string" then
		default = Enum.KeyCode[default] or UNKNOWN
	end
	local kb = component(o, default or UNKNOWN)
	kb.Mode = o.Mode or "Toggle"
	kb.Active = kb.Mode == "Always"

	local chip = registerFont(create("TextButton", {
		Parent = right,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, 22),
		LayoutOrder = 1,
		AutoButtonColor = false,
		FontFace = FONT_B,
		TextSize = 11,
		Text = "",
		Theme = {BackgroundColor3 = "Raised", TextColor3 = "Muted"},
	}, {corner(6), stroke("Stroke"), pad(0, 8)}), "B")
	local listening = false

	local function render()
		chip.Text = listening and "..." or keyName(kb.Value)
		tween(chip, {TextColor3 = listening and T.Accent or T.Muted}, 0.15)
	end
	onTheme(render)

	function kb:Set(v, silent)
		if type(v) == "string" then
			v = Enum.KeyCode[v]
		end
		self.Value = v or UNKNOWN
		render()
		self:Fire(silent)
	end

	chip.Activated:Connect(function()
		closePopup()
		listening = true
		Lumen.Listening = true
		render()
	end)

	if o.Modes ~= false then
		chip.MouseButton2Click:Connect(function()
			openMenu(chip, {
				Values = {"Toggle", "Hold", "Always"},
				Width = 110,
				Right = true,
				Selected = function(n)
					return kb.Mode == n
				end,
				OnPick = function(n)
					kb.Mode = n
					if n == "Always" then
						kb.Active = true
						fire(true, "Always", true)
					end
				end,
			})
		end)
	end

	link(UIS.InputBegan, function(i, processed)
		if listening then
			if i.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				Lumen.Listening = false
				Lumen.LastBind = tick()
				local cancel = i.KeyCode == Enum.KeyCode.Escape or i.KeyCode == Enum.KeyCode.Backspace
				kb:Set(cancel and UNKNOWN or i.KeyCode)
			elseif i.UserInputType == Enum.UserInputType.MouseButton2 or i.UserInputType == Enum.UserInputType.MouseButton3 then
				listening = false
				Lumen.Listening = false
				Lumen.LastBind = tick()
				kb:Set(i.UserInputType)
			end
			return
		end
		if processed or kb.Mode == "Always" or not matches(kb.Value, i) then
			return
		end
		if kb.Mode == "Hold" then
			kb.Active = true
		else
			kb.Active = not kb.Active
		end
		fire(true, kb.Mode, kb.Active)
	end)

	link(UIS.InputEnded, function(i)
		if kb.Mode == "Hold" and kb.Active and matches(kb.Value, i) then
			kb.Active = false
			fire(false, "Hold", false)
		end
	end)

	table.insert(Lumen.Binds, {
		Name = label or "Bind",
		Bind = kb,
		Active = isActive or function()
			return kb.Mode == "Always" or kb.Active
		end,
	})

	render()
	return kb
end

local Presets = {
	rgb(255, 255, 255), rgb(248, 81, 99), rgb(251, 146, 60), rgb(250, 204, 21),
	rgb(52, 211, 153), rgb(41, 148, 255), rgb(124, 92, 255), rgb(244, 114, 182),
}

local function hex(c)
	return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local function makeColor(right, o)
	local obj = component(o, o.Default or rgb(124, 92, 255), o.Callback)
	obj.Alpha = o.Alpha or 1
	local h, s, v = obj.Value:ToHSV()
	local a = obj.Alpha

	local swatch = create("TextButton", {
		Parent = right,
		LayoutOrder = 2,
		Size = UDim2.fromOffset(28, 18),
		BackgroundColor3 = obj.Value,
		Text = "",
		AutoButtonColor = false,
	}, {corner(5), stroke("Stroke")})

	local refs, panel, mode

	local function sync(silent)
		obj.Value = Color3.fromHSV(h, s, v)
		obj.Alpha = a
		swatch.BackgroundColor3 = obj.Value
		if refs then
			refs.sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			refs.svDot.Position = UDim2.fromScale(s, 1 - v)
			refs.hueDot.Position = UDim2.fromScale(h, 0.5)
			refs.alphaDot.Position = UDim2.fromScale(a, 0.5)
			refs.alphaFill.BackgroundColor3 = obj.Value
			refs.preview.BackgroundColor3 = obj.Value
			if not refs.hex:IsFocused() then
				refs.hex.Text = hex(obj.Value)
			end
			if not refs.r:IsFocused() then
				refs.r.Text = tostring(math.floor(obj.Value.R * 255 + 0.5))
			end
			if not refs.g:IsFocused() then
				refs.g.Text = tostring(math.floor(obj.Value.G * 255 + 0.5))
			end
			if not refs.b:IsFocused() then
				refs.b.Text = tostring(math.floor(obj.Value.B * 255 + 0.5))
			end
		end
		obj:Fire(silent)
	end

	local function pick()
		local m = mouse()
		if mode == "sv" then
			s = math.clamp((m.X - refs.sv.AbsolutePosition.X) / refs.sv.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((m.Y - refs.sv.AbsolutePosition.Y) / refs.sv.AbsoluteSize.Y, 0, 1)
		elseif mode == "hue" then
			h = math.clamp((m.X - refs.hue.AbsolutePosition.X) / refs.hue.AbsoluteSize.X, 0, 1)
		elseif mode == "alpha" then
			a = math.clamp((m.X - refs.alpha.AbsolutePosition.X) / refs.alpha.AbsoluteSize.X, 0, 1)
		end
		sync()
	end

	link(UIS.InputChanged, function(i)
		if mode and refs and isMove(i) then
			pick()
		end
	end)
	link(UIS.InputEnded, function(i)
		if isPress(i) then
			mode = nil
		end
	end)

	local final
	local function close()
		if not panel then
			return
		end
		local p = panel
		panel, refs, mode = nil, nil, nil
		tween(p, {Position = final + UDim2.fromOffset(0, -8), GroupTransparency = 1}, 0.15)
		task.delay(0.16, function()
			p:Destroy()
		end)
	end

	local function handle(parent, x, y, w, hgt, radius)
		return create("TextButton", {
			Parent = parent,
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(w, hgt),
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = WHITE,
		}, {corner(radius)})
	end

	local function dot(parent, size)
		return create("Frame", {
			Parent = parent,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(size, size),
			BackgroundColor3 = WHITE,
		}, {corner(PILL), stroke(BLACK, 1, 0.5)})
	end

	local function open()
		panel = create("CanvasGroup", {
			Parent = Layers.Popups,
			Size = UDim2.fromOffset(230, 290),
			GroupTransparency = 1,
			Theme = {BackgroundColor3 = "Panel"},
		}, {corner(12), stroke("Stroke")})
		final = place(swatch, 230, 290, true)
		panel.Position = final + UDim2.fromOffset(0, -8)
		tween(panel, {Position = final, GroupTransparency = 0}, 0.22)

		local sv = handle(panel, 12, 12, 206, 124, 8)
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		create("Frame", {Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE}, {
			corner(8), create("UIGradient", {Transparency = NumberSequence.new(0, 1)}),
		})
		create("Frame", {Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = BLACK}, {
			corner(8), create("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}),
		})
		local svDot = dot(sv, 12)
		svDot.Position = UDim2.fromScale(s, 1 - v)

		local keys = {}
		for i = 0, 6 do
			table.insert(keys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
		end
		local hue = handle(panel, 12, 146, 206, 10, 5)
		create("UIGradient", {Parent = hue, Color = ColorSequence.new(keys)})
		local hueDot = dot(hue, 14)
		hueDot.Position = UDim2.fromScale(h, 0.5)

		local alpha = handle(panel, 12, 166, 206, 10, 5)
		alpha.BackgroundColor3 = rgb(52, 52, 62)
		local alphaFill = create("Frame", {Parent = alpha, Size = UDim2.fromScale(1, 1), BackgroundColor3 = obj.Value}, {
			corner(5), create("UIGradient", {Transparency = NumberSequence.new(1, 0)}),
		})
		local alphaDot = dot(alpha, 14)
		alphaDot.Position = UDim2.fromScale(a, 0.5)

		local preview = create("Frame", {
			Parent = panel,
			Position = UDim2.fromOffset(12, 188),
			Size = UDim2.fromOffset(26, 26),
			BackgroundColor3 = obj.Value,
		}, {corner(7), stroke("Stroke")})
		local box = registerFont(create("TextBox", {
			Parent = panel,
			Position = UDim2.fromOffset(44, 188),
			Size = UDim2.fromOffset(174, 26),
			Text = hex(obj.Value),
			FontFace = FONT,
			TextSize = 12,
			ClearTextOnFocus = false,
			Theme = {BackgroundColor3 = "Raised", TextColor3 = "Text"},
		}, {corner(7), stroke("Stroke")}), "M")

		local function channelBox(x, val)
			return registerFont(create("TextBox", {
				Parent = panel,
				Position = UDim2.fromOffset(x, 222),
				Size = UDim2.fromOffset(64, 24),
				Text = tostring(math.floor(val * 255 + 0.5)),
				FontFace = FONT,
				TextSize = 11,
				ClearTextOnFocus = false,
				Theme = {BackgroundColor3 = "Raised", TextColor3 = "Text"},
			}, {corner(6), stroke("Stroke")}), "M")
		end
		local rBox = channelBox(12, obj.Value.R)
		local gBox = channelBox(83, obj.Value.G)
		local bBox = channelBox(154, obj.Value.B)

		local function applyRGB()
			local rr = math.clamp(tonumber(rBox.Text) or 0, 0, 255)
			local gg = math.clamp(tonumber(gBox.Text) or 0, 0, 255)
			local bb = math.clamp(tonumber(bBox.Text) or 0, 0, 255)
			h, s, v = rgb(rr, gg, bb):ToHSV()
			sync()
		end
		rBox.FocusLost:Connect(applyRGB)
		gBox.FocusLost:Connect(applyRGB)
		bBox.FocusLost:Connect(applyRGB)

		local swatches = create("Frame", {
			Parent = panel,
			Position = UDim2.fromOffset(12, 256),
			Size = UDim2.fromOffset(206, 22),
			BackgroundTransparency = 1,
		}, {list(6, {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})})
		for idx, color in Presets do
			local b = create("TextButton", {
				Parent = swatches,
				Size = UDim2.fromOffset(20, 20),
				BackgroundColor3 = color,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = idx,
			}, {corner(PILL)})
			b.MouseEnter:Connect(function()
				tween(b, {Size = UDim2.fromOffset(23, 23)}, 0.12)
			end)
			b.MouseLeave:Connect(function()
				tween(b, {Size = UDim2.fromOffset(20, 20)}, 0.12)
			end)
			b.Activated:Connect(function()
				h, s, v = color:ToHSV()
				sync()
			end)
		end

		refs = {sv = sv, svDot = svDot, hue = hue, hueDot = hueDot, alpha = alpha, alphaDot = alphaDot, alphaFill = alphaFill, preview = preview, hex = box, r = rBox, g = gBox, b = bBox}

		sv.InputBegan:Connect(function(i)
			if isPress(i) then
				mode = "sv"
				pick()
			end
		end)
		hue.InputBegan:Connect(function(i)
			if isPress(i) then
				mode = "hue"
				pick()
			end
		end)
		alpha.InputBegan:Connect(function(i)
			if isPress(i) then
				mode = "alpha"
				pick()
			end
		end)
		box.FocusLost:Connect(function()
			local r, g, b = box.Text:match("^#?(%x%x)(%x%x)(%x%x)$")
			if r then
				h, s, v = rgb(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)):ToHSV()
				sync()
			else
				box.Text = hex(obj.Value)
			end
		end)

		openPopup({panel, swatch}, close, swatch)
	end

	function obj:Set(c, silent, alpha)
		h, s, v = c:ToHSV()
		a = alpha or a
		sync(silent)
	end

	swatch.Activated:Connect(function()
		if popupOpenFor(swatch) then
			closePopup()
		else
			open()
		end
	end)
	return obj
end

function Base:Bind(o)
	o = o or {}
	if self._modes == false then
		o.Modes = false
	end
	return makeBind(self._right, o, self._fire, self._label, self._active)
end

function Base:Color(o)
	return makeColor(self._right, o or {})
end

local Elements = {}
local ElementMeta = {__index = Elements}

local function build(self, o, height, muted)
	self.Order += 1
	local hasDesc = o.Description ~= nil
	height = height or (hasDesc and 50 or 38)
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, height),
		LayoutOrder = self.Order,
		BackgroundTransparency = 1,
		Theme = {BackgroundColor3 = "Hover"},
	}, {corner(9)})
	local right = create("Frame", {
		Parent = row,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(0, 28),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ZIndex = 2,
	}, {list(7, {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})})
	local title = text({
		Parent = row,
		Text = o.Name or "",
		Position = UDim2.fromOffset(10, hasDesc and 8 or 0),
		Size = UDim2.new(1, -20, 0, hasDesc and 18 or height),
		Theme = {TextColor3 = muted and "Muted" or "Text"},
	})
	local desc
	if hasDesc then
		desc = text({
			Parent = row,
			Text = o.Description,
			Position = UDim2.fromOffset(10, 26),
			Size = UDim2.new(1, -20, 0, 16),
			TextSize = 11,
			Theme = {TextColor3 = "Muted"},
		})
	end
	local function fit()
		local rw = right.AbsoluteSize.X
		local padR = rw > 0 and (rw + 28) or 20
		title.Size = UDim2.new(1, -padR, 0, title.Size.Y.Offset)
		if desc then
			desc.Size = UDim2.new(1, -padR, 0, 16)
		end
	end
	right:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
	fit()
	row.MouseEnter:Connect(function()
		tween(row, {BackgroundTransparency = 0.65}, 0.14)
	end)
	row.MouseLeave:Connect(function()
		tween(row, {BackgroundTransparency = 1}, 0.18)
	end)
	if o.Tooltip then
		tooltip(row, o.Tooltip)
	end
	table.insert(self.Items, {Row = row, Name = (o.Name or ""):lower()})
	return row, title, right
end

function Elements:Label(content)
	local o = type(content) == "table" and content or {Name = content}
	local obj = component(o, nil)
	local _, title, right = build(self, o, 32, true)
	obj._right = right
	obj._label = o.Name
	function obj:SetText(v)
		title.Text = v
	end
	return obj
end

function Elements:Paragraph(o)
	o = o or {}
	self.Order += 1
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = self.Order,
	}, {pad(6, 10), list(4)})
	local title = text({Parent = row, Text = o.Name or "", FontFace = FONT_B, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1})
	local body = text({
		Parent = row,
		Text = o.Content or "",
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
		SetTitle = function(_, v)
			title.Text = v
		end,
		SetContent = function(_, v)
			body.Text = v
		end,
	}
end

function Elements:Divider()
	self.Order += 1
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		LayoutOrder = self.Order,
	})
	create("Frame", {
		Parent = row,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.new(1, -20, 0, 1),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Stroke"},
	})
	table.insert(self.Items, {Row = row, Name = false})
end

function Elements:Button(o)
	o = o or {}
	self.Order += 1
	local primary = o.Style == "Primary"
	local row = create("Frame", {
		Parent = self.Body,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundTransparency = 1,
		LayoutOrder = self.Order,
	})
	local b = create("TextButton", {
		Parent = row,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -12, 0, 32),
		Text = "",
		AutoButtonColor = false,
		ClipsDescendants = true,
		BackgroundColor3 = primary and T.Accent or T.Raised,
	}, {corner(8)})
	if not primary then
		stroke("Stroke").Parent = b
	end
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
	local ico
	if o.Icon then
		ico = icon(b, o.Icon, 15, primary and WHITE or T.Text)
		if ico then
			ico.AnchorPoint = Vector2.new(0, 0.5)
			ico.Position = UDim2.new(0, 12, 0.5, 0)
		end
	end
	local label = text({
		Parent = b,
		Text = o.Name or "Button",
		Position = UDim2.fromOffset(ico and 36 or 12, 0),
		Size = UDim2.new(1, -(ico and 48 or 24), 1, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		FontFace = FONT_B,
		TextColor3 = primary and WHITE or T.Text,
	})
	local function fitBtn()
		local rw = right.AbsoluteSize.X
		local leftPad = ico and 36 or 12
		local rightPad = rw > 0 and (rw + 18) or leftPad
		local side = math.max(leftPad, rightPad)
		label.Position = UDim2.fromOffset(side, 0)
		label.Size = UDim2.new(1, -side * 2, 1, 0)
	end
	right:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitBtn)
	fitBtn()

	local hovered = false
	local function render(animate)
		local base = primary and T.Accent or T.Raised
		local over = primary and T.Accent:Lerp(WHITE, 0.14) or T.Hover
		apply(b, {BackgroundColor3 = hovered and over or base}, animate, 0.15)
		label.TextColor3 = primary and WHITE or T.Text
		if ico and not primary then
			ico.ImageColor3 = T.Text
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

	local name = o.Name or "Button"
	local armed = false
	local function restore()
		label.Text = name
		tween(label, {TextColor3 = primary and WHITE or T.Text}, 0.15)
	end
	local function trigger()
		if o.DoubleTap and not armed then
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
		if o.Callback then
			task.spawn(o.Callback)
		end
	end
	b.Activated:Connect(function()
		ripple(b)
		trigger()
	end)
	if o.Tooltip then
		tooltip(b, o.Tooltip)
	end
	table.insert(self.Items, {Row = row, Name = name:lower()})

	local obj = component(o, nil)
	obj._right = right
	obj._label = name
	obj._modes = false
	obj._fire = function(down)
		if down then
			trigger()
		end
	end
	function obj:SetText(v)
		name = v
		label.Text = v
	end
	return obj
end

function Elements:Toggle(o)
	o = o or {}
	local obj = component(o, o.Default == true, o.Callback)
	local row, _, right = build(self, o)
	local click = hit(row)
	click.ZIndex = 1
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

	local function place_(on, w)
		return UDim2.new(0, on and (38 - 3 - w) or 3, 0.5, 0)
	end

	local function render(animate)
		local on = obj.Value
		apply(track, {BackgroundColor3 = on and T.Accent or T.Hover}, animate, 0.18)
		apply(knob, {
			Position = place_(on, 14),
			Size = UDim2.fromOffset(14, 14),
			BackgroundColor3 = on and WHITE or T.Muted,
		}, animate, 0.26)
	end
	onTheme(render)

	click.MouseButton1Down:Connect(function()
		tween(knob, {Size = UDim2.fromOffset(18, 14), Position = place_(obj.Value, 18)}, 0.1)
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
		obj:Set(not obj.Value)
	end)

	obj._right = right
	obj._label = o.Name
	obj._active = function()
		return obj.Value
	end
	obj._fire = function(down, mode)
		if mode == "Hold" then
			obj:Set(down)
		elseif down then
			obj:Set(not obj.Value)
		end
	end
	return obj
end

function Elements:Slider(o)
	o = o or {}
	local min, max, inc = o.Min or 0, o.Max or 100, o.Increment or 1
	local dec = #(tostring(inc):match("%.(%d+)") or "")
	local fmt = "%." .. dec .. "f"
	local obj = component(o, math.clamp(o.Default or min, min, max), o.Callback)
	local hasDesc = o.Description ~= nil
	local totalH = hasDesc and 66 or 52
	local trackY = hasDesc and 48 or 34
	local row, title, right = build(self, o, totalH)
	right.Visible = false
	title.Position = UDim2.fromOffset(10, 7)
	title.Size = UDim2.new(1, -104, 0, 18)

	local box = registerFont(create("TextBox", {
		Parent = row,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 6),
		Size = UDim2.fromOffset(78, 20),
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
		if o.Format then
			return o.Format(obj.Value)
		end
		return string.format(fmt, obj.Value) .. (o.Suffix or "")
	end
	local function render(instant)
		local goal = UDim2.fromScale((obj.Value - min) / (max - min), 1)
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

	local function grow()
		tween(knob, {Size = (dragging or hovering) and UDim2.fromOffset(15, 15) or UDim2.fromOffset(12, 12)}, 0.16, Enum.EasingStyle.Back)
	end

	local function fromMouse()
		local a = math.clamp((mouse().X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
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
		if isPress(i) then
			dragging = true
			grow()
			fromMouse()
		end
	end)
	link(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			fromMouse()
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
		if n then
			set(n)
		end
		render(true)
	end)

	render(true)
	return obj
end

function Elements:Dropdown(o)
	o = o or {}
	local multi = o.Multi == true
	local values = o.Values or {}
	local default = o.Default
	if multi then
		default = type(default) == "table" and table.clone(default) or {}
	end
	local obj = component(o, default, o.Callback)
	local _, _, right = build(self, o)
	local ring = stroke("Stroke")
	local field = create("TextButton", {
		Parent = right,
		LayoutOrder = 100,
		Size = UDim2.fromOffset(o.Width or 158, 28),
		AutoButtonColor = false,
		Text = "",
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(8), ring})
	local shown = text({Parent = field, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -32, 1, 0), TextSize = 12})
	local chevron = icon(field, "chevron-down", 13, "Muted")
	chevron.AnchorPoint = Vector2.new(0.5, 0.5)
	chevron.Position = UDim2.new(1, -14, 0.5, 0)

	local function selected(name)
		if multi then
			return table.find(obj.Value, name) ~= nil
		end
		return obj.Value == name
	end

	local function render()
		local empty = multi and #obj.Value == 0 or (not multi and obj.Value == nil)
		if empty then
			shown.Text = o.Placeholder or "None"
		elseif multi then
			local n = #obj.Value
			shown.Text = n <= 2 and table.concat(obj.Value, ", ") or (obj.Value[1] .. " +" .. (n - 1))
		else
			shown.Text = tostring(obj.Value)
		end
		shown.TextColor3 = empty and T.Muted or T.Text
	end
	onTheme(render)

	function obj:Set(v, silent)
		if multi then
			self.Value = type(v) == "table" and table.clone(v) or {}
		else
			self.Value = v
		end
		render()
		self:Fire(silent)
	end

	function obj:SetValues(new)
		values = new
		closePopup()
		if not multi and self.Value ~= nil and not table.find(values, self.Value) then
			self:Set(nil)
		end
	end

	field.MouseEnter:Connect(function()
		if not popupOpenFor(field) then
			tween(ring, {Color = T.Muted}, 0.14)
		end
	end)
	field.MouseLeave:Connect(function()
		if not popupOpenFor(field) then
			tween(ring, {Color = T.Stroke}, 0.14)
		end
	end)
	field.Activated:Connect(function()
		if popupOpenFor(field) then
			closePopup()
			return
		end
		tween(chevron, {Rotation = 180}, 0.22)
		tween(ring, {Color = T.Accent}, 0.18)
		openMenu(field, {
			Values = values,
			Multi = multi,
			Search = o.Search,
			Width = field.AbsoluteSize.X,
			Right = true,
			OnClose = function()
				tween(chevron, {Rotation = 0}, 0.22)
				tween(ring, {Color = T.Stroke}, 0.18)
			end,
			Selected = selected,
			OnPick = function(name)
				if multi then
					local i = table.find(obj.Value, name)
					if i then
						table.remove(obj.Value, i)
					else
						table.insert(obj.Value, name)
					end
					render()
					obj:Fire()
				else
					obj:Set(name)
				end
			end,
		})
	end)

	render()
	return obj
end

function Elements:Input(o)
	o = o or {}
	local obj = component(o, o.Default or "", o.Callback)
	local _, _, right = build(self, o)
	local ring = stroke("Stroke")
	local box = registerFont(create("TextBox", {
		Parent = right,
		LayoutOrder = 100,
		Size = UDim2.fromOffset(o.Width or 158, 28),
		Text = obj.Value,
		PlaceholderText = o.Placeholder or "",
		FontFace = FONT,
		TextSize = 12,
		ClearTextOnFocus = o.ClearOnFocus == true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Theme = {BackgroundColor3 = "Raised", TextColor3 = "Text", PlaceholderColor3 = "Muted"},
	}, {corner(8), ring, pad(0, 10)}), "M")
	box.Focused:Connect(function()
		tween(ring, {Color = T.Accent}, 0.18)
	end)
	box.FocusLost:Connect(function()
		tween(ring, {Color = T.Stroke}, 0.18)
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
		if o.Live then
			obj.Value = box.Text
			obj:Fire()
		end
	end)
	function obj:Set(v, silent)
		self.Value = tostring(v)
		box.Text = self.Value
		self:Fire(silent)
	end
	return obj
end

function Elements:Keybind(o)
	o = o or {}
	local _, _, right = build(self, o)
	local kb
	kb = makeBind(right, o, function(_, _, active)
		if o.Callback then
			task.spawn(o.Callback, active, kb.Value)
		end
	end, o.Name)
	if o.OnChange then
		kb:OnChanged(o.OnChange)
	end
	return kb
end

function Elements:ColorPicker(o)
	o = o or {}
	local _, _, right = build(self, o)
	return makeColor(right, o)
end

local Tab = {}
local TabMeta = {__index = Tab}

function Tab:Section(o)
	o = type(o) == "string" and {Name = o} or (o or {})
	local col
	if o.Side == "Right" then
		col = 2
	elseif o.Side == "Left" then
		col = 1
	else
		col = self.Counts[1] <= self.Counts[2] and 1 or 2
	end
	self.Counts[col] += 1

	local frame = registerSurface(create("Frame", {
		Parent = self.Columns[col],
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		LayoutOrder = self.Counts[col],
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(12), stroke("Stroke"), list(0)}), 0.7)

	local header = create("TextButton", {
		Parent = frame,
		Size = UDim2.new(1, 0, 0, 40),
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
	text({
		Parent = header,
		Text = o.Name or "Section",
		Position = UDim2.fromOffset(x, 0),
		Size = UDim2.new(1, -x - 40, 1, 0),
		FontFace = FONT_B,
	})
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

	local section = setmetatable({Frame = frame, Body = body, Items = {}, Order = 0, Name = o.Name, Collapsed = false}, ElementMeta)

	function section:SetCollapsed(state)
		if state == self.Collapsed then
			return
		end
		self.Collapsed = state
		if state then
			holder.AutomaticSize = Enum.AutomaticSize.None
			holder.Size = UDim2.new(1, 0, 0, holder.AbsoluteSize.Y)
			tween(holder, {Size = UDim2.new(1, 0, 0, 0)}, 0.28)
			tween(chevron, {Rotation = -90}, 0.22)
			tween(line, {BackgroundTransparency = 1}, 0.22)
		else
			tween(holder, {Size = UDim2.new(1, 0, 0, body.AbsoluteSize.Y)}, 0.28)
			tween(chevron, {Rotation = 0}, 0.22)
			tween(line, {BackgroundTransparency = 0}, 0.22)
			task.delay(0.3, function()
				if not self.Collapsed then
					holder.AutomaticSize = Enum.AutomaticSize.Y
				end
			end)
		end
	end

	if o.Collapsible ~= false then
		header.Activated:Connect(function()
			section:SetCollapsed(not section.Collapsed)
		end)
	end
	if o.Collapsed then
		section:SetCollapsed(true)
	end

	table.insert(self.Sections, section)
	return section
end

function Tab:Filter(query)
	for _, section in self.Sections do
		local any = false
		for _, item in section.Items do
			local show = query == "" or (item.Name ~= false and item.Name:find(query, 1, true) ~= nil)
			item.Row.Visible = show
			any = any or show
		end
		section.Frame.Visible = query == "" or any
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
	local root, scale, body, glow = self.Root, self.Scale, self.Body, self.Glow
	if want then
		root.Visible = true
		if not self.AtDock then
			root.Position = self.Rest + UDim2.fromOffset(0, 22)
			scale.Scale = targetScale * 0.94
			body.GroupTransparency = 1
			glow.ImageTransparency = 1
		end
		self.AtDock = false
		tween(root, {Position = self.Rest}, 0.45)
		tween(scale, {Scale = targetScale}, 0.45)
		tween(body, {GroupTransparency = 0}, 0.28)
		tween(glow, {ImageTransparency = 0.55}, 0.4)
	else
		if self.Minimized and self.Opened and hub.Visible then
			self.AtDock = true
			tween(root, {Position = hub:_iconCenter(self)}, 0.38)
			tween(scale, {Scale = 0.18}, 0.38)
		else
			self.AtDock = false
			tween(root, {Position = self.Rest + UDim2.fromOffset(0, 12)}, 0.25)
			tween(scale, {Scale = targetScale * 0.96}, 0.25)
		end
		tween(body, {GroupTransparency = 1}, 0.24)
		tween(glow, {ImageTransparency = 1}, 0.24)
		task.delay(0.4, function()
			if self.Token == token then
				root.Visible = false
			end
		end)
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

function Window:Destroy()
	self.Hub:_dockRemove(self)
	local list_ = self.Hub.Windows
	table.remove(list_, table.find(list_, self))
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
		Theme = {TextColor3 = "Muted"},
	})
	label.TextTransparency = 0.15
	self.Cursor += 30
	self.TabsScroll.CanvasSize = UDim2.fromOffset(0, self.Cursor + 8)
end

function Window:Select(tab)
	if self.Active == tab then
		return
	end
	local prev = self.Active
	self.Active = tab
	self.PageToken += 1
	local token = self.PageToken
	if prev then
		prev:Filter("")
	end
	for _, t in self.Tabs do
		t:_style(t == tab, true)
		if t ~= tab and t ~= prev then
			t.Page.Visible = false
		end
	end
	self.Indicator.Visible = true
	if prev then
		tween(self.Indicator, {Position = UDim2.fromOffset(10, tab.Y)}, 0.36)
	else
		self.Indicator.Position = UDim2.fromOffset(10, tab.Y)
	end
	self.Heading.Text = tab.Name
	self.Search.Text = ""
	if prev then
		local old = prev.Page
		tween(old, {GroupTransparency = 1}, 0.12)
		task.delay(0.14, function()
			if self.PageToken == token then
				old.Visible = false
			end
		end)
	end
	local page = tab.Page
	page.Position = UDim2.fromOffset(0, 16)
	page.GroupTransparency = 1
	page.Visible = true
	tween(page, {Position = UDim2.fromOffset(0, 0), GroupTransparency = 0}, 0.38)
end

function Window:Tab(o)
	o = type(o) == "string" and {Name = o} or (o or {})
	local win = self
	local tab = setmetatable({Window = self, Name = o.Name or "Tab", Sections = {}, Counts = {0, 0}, Y = self.Cursor}, TabMeta)
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
	local ico = icon(btn, o.Icon or "layout-grid", 16, T.Muted)
	ico.AnchorPoint = Vector2.new(0, 0.5)
	ico.Position = UDim2.new(0, 14, 0.5, 0)
	local label = text({
		Parent = btn,
		Text = tab.Name,
		Position = UDim2.fromOffset(42, 0),
		Size = UDim2.new(1, -50, 1, 0),
		FontFace = FONT_B,
		TextColor3 = T.Muted,
	})

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
			tween(btn, {BackgroundTransparency = 0.5}, 0.14)
			tween(label, {TextColor3 = T.Text}, 0.14)
		end
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundTransparency = 1}, 0.18)
		if win.Active ~= tab then
			tween(label, {TextColor3 = T.Muted}, 0.18)
		end
	end)
	btn.Activated:Connect(function()
		closePopup()
		win:Select(tab)
	end)

	local page = create("CanvasGroup", {
		Parent = self.Pages,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
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
	}, {pad(18, 20, 22, 20)})
	local layout = list(14, {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Top})
	local holder = create("Frame", {
		Parent = scroll,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
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
		local wide = scroll.AbsoluteSize.X >= 520
		layout.FillDirection = wide and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
		for _, c in columns do
			c.Size = wide and UDim2.new(0.5, -7, 0, 0) or UDim2.fromScale(1, 0)
		end
	end
	scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(relayout)
	relayout()

	tab.Page = page
	tab.Columns = columns
	tab.Button = btn

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		self:Select(tab)
	end
	return tab
end

function Hub:Window(o)
	o = o or {}
	local win = setmetatable({
		Hub = self,
		Name = o.Name or "Window",
		Description = o.Description or "",
		IconName = o.Icon or "layers",
		Tabs = {},
		Opened = o.Open ~= false,
		Minimized = false,
		Shown = false,
		AtDock = false,
		Token = 0,
		PageToken = 0,
		Cursor = 8,
	}, Window)
	table.insert(self.Windows, win)
	local index = #self.Windows
	self.Z += 1
	local SW = 212
	local minW, minH = 660, 420

	local root = create("Frame", {
		Name = win.Name,
		Parent = Layers.Windows,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, (index - 1) * 28, 0.5, (index - 1) * 28 - 22),
		Size = o.Size or UDim2.fromOffset(880, 580),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = self.Z,
	})
	local scale = create("UIScale", {Parent = root, Scale = (Lumen.Config.Scale or 1) * 0.94})
	local glow = shadow(root, 84, 1)
	local body = registerSurface(create("CanvasGroup", {
		Parent = root,
		Size = UDim2.fromScale(1, 1),
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Back"},
	}, {corner(16)}), 1)
	rim(body)

	win.Root, win.Rest, win.Scale, win.Body, win.Glow = root, root.Position, scale, body, glow

	local side = registerSurface(create("Frame", {
		Parent = body,
		Size = UDim2.new(0, SW, 1, 0),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Side"},
	}), 0.85)
	create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BorderSizePixel = 0,
		Theme = {BackgroundColor3 = "Stroke"},
	})

	local brand = create("Frame", {Parent = side, Size = UDim2.new(1, 0, 0, 72), BackgroundTransparency = 1})
	local brandHit = hit(brand)
	brandHit.ZIndex = 0
	local bubble = create("Frame", {
		Parent = brand,
		Position = UDim2.fromOffset(18, 18),
		Size = UDim2.fromOffset(36, 36),
		BackgroundColor3 = WHITE,
	}, {corner(11), create("UIGradient", {Rotation = 45})})
	accentGradient(bubble:FindFirstChildOfClass("UIGradient"))
	center(icon(bubble, win.IconName, 18, WHITE))
	text({
		Parent = brand,
		Text = win.Name,
		Position = UDim2.fromOffset(64, 18),
		Size = UDim2.new(1, -74, 0, 18),
		FontFace = FONT_X,
		TextSize = 14,
	})
	text({
		Parent = brand,
		Text = win.Description,
		Position = UDim2.fromOffset(64, 37),
		Size = UDim2.new(1, -74, 0, 14),
		TextSize = 11,
		Theme = {TextColor3 = "Muted"},
	})

	local tabsScroll = create("ScrollingFrame", {
		Parent = side,
		Position = UDim2.fromOffset(0, 72),
		Size = UDim2.new(1, 0, 1, -140),
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
		Position = UDim2.new(0, 18, 0.5, 0),
		Size = UDim2.fromOffset(34, 34),
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=60&h=60",
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(PILL)})
	text({
		Parent = footer,
		Text = player.DisplayName,
		Position = UDim2.fromOffset(62, 18),
		Size = UDim2.new(1, -72, 0, 16),
		FontFace = FONT_B,
		TextSize = 12,
	})
	text({
		Parent = footer,
		Text = "@" .. player.Name,
		Position = UDim2.fromOffset(62, 35),
		Size = UDim2.new(1, -72, 0, 14),
		TextSize = 11,
		Theme = {TextColor3 = "Muted"},
	})

	local content = create("Frame", {
		Parent = body,
		Position = UDim2.fromOffset(SW, 0),
		Size = UDim2.new(1, -SW, 1, 0),
		BackgroundTransparency = 1,
	})
	local top = create("Frame", {Parent = content, Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1})
	local topHit = hit(top)
	topHit.ZIndex = 0
	local heading = text({
		Parent = top,
		Position = UDim2.fromOffset(22, 0),
		Size = UDim2.new(1, -340, 1, 0),
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
			tween(b, {BackgroundTransparency = danger and 0.8 or 0.2, BackgroundColor3 = danger and T.Danger or T.Hover}, 0.14)
			tween(ic, {ImageColor3 = danger and T.Danger or T.Text}, 0.14)
		end)
		b.MouseLeave:Connect(function()
			tween(b, {BackgroundTransparency = 1}, 0.18)
			tween(ic, {ImageColor3 = T.Muted}, 0.18)
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
		tween(searchBox, {Size = UDim2.fromOffset(240, 32)}, 0.3)
		tween(searchRing, {Color = T.Accent}, 0.18)
	end)
	search.FocusLost:Connect(function()
		tween(searchBox, {Size = UDim2.fromOffset(184, 32)}, 0.3)
		tween(searchRing, {Color = T.Stroke}, 0.18)
	end)
	search:GetPropertyChangedSignal("Text"):Connect(function()
		if win.Active then
			win.Active:Filter(search.Text:lower())
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
	drag(brandHit, root, saveRest)
	drag(topHit, root, saveRest)

	local grip = create("TextButton", {
		Parent = body,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(1, 1),
		Size = UDim2.fromOffset(22, 22),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 5,
	})
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
		if isPress(i) then
			resizing = true
			startMouse = mouse()
			startSize = root.Size
			startPos = root.Position
		end
	end)
	link(UIS.InputChanged, function(i)
		if resizing and isMove(i) then
			local sc = Lumen.Config.Scale or 1
			local d = (mouse() - startMouse) / sc
			local view = Gui.AbsoluteSize
			local w = math.clamp(startSize.X.Offset + d.X, minW, (view.X - 24) / sc)
			local h = math.clamp(startSize.Y.Offset + d.Y, minH, (view.Y - 24) / sc)
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

local function follow(ghost, target, spread)
	local function sync()
		local p, s = target.AbsolutePosition, target.AbsoluteSize
		ghost.Position = UDim2.fromOffset(p.X + s.X / 2, p.Y + s.Y / 2)
		ghost.Size = UDim2.fromOffset(s.X + spread, s.Y + spread)
	end
	target:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync)
	target:GetPropertyChangedSignal("AbsolutePosition"):Connect(sync)
	sync()
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
	for win, e in self.Entries do
		local opened = win.Opened
		local focused = opened and not win.Minimized and self.Focused == win
		tween(e.Indicator, {
			Size = UDim2.fromOffset(opened and (focused and 16 or 6) or 0, 3),
			BackgroundColor3 = focused and T.Accent or T.Muted,
		}, 0.26)
		tween(e.Icon, {ImageColor3 = opened and T.Text or T.Muted}, 0.22)
	end
end

function Hub:_refreshBlur()
	if not self.BlurEffect then
		self.BlurEffect = create("BlurEffect", {Parent = Lighting, Size = 0})
	end
	local any = false
	for _, w in self.Windows do
		any = any or w.Shown
	end
	local want = Lumen.Config.Blur and any
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
		tween(btn, {BackgroundTransparency = 0.45}, 0.14)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundTransparency = 1}, 0.18)
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

function Hub:_buildDock()
	local dock = registerSurface(create("Frame", {
		Parent = Layers.Dock,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 110),
		Size = UDim2.fromOffset(0, 58),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 0.04,
		ZIndex = 2,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(20), pad(0, 10), list(6, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})}), 0.85)
	rim(dock)
	local ghost = shadow(Layers.Dock, 0, 0.5)
	ghost.ZIndex = 1
	follow(ghost, dock, 54)
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
		Size = UDim2.fromOffset(42, 42),
		BackgroundColor3 = WHITE,
		Text = "",
		AutoButtonColor = false,
	}, {corner(13), create("UIGradient", {Rotation = 45})})
	accentGradient(hubBtn:FindFirstChildOfClass("UIGradient"))
	center(icon(hubBtn, self.IconName, 20, WHITE))
	local hs = create("UIScale", {Parent = hubBtn})
	pressable(hubBtn, hs, 1.07, 0.93)
	tooltip(hubBtn, self.Name)
	self.HubButton = hubBtn

	sep(2)
	self.DockWindows = create("Frame", {
		Parent = dock,
		LayoutOrder = 3,
		Size = UDim2.fromOffset(0, 58),
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
		Size = UDim2.fromOffset(50, 58),
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
		Size = UDim2.fromOffset(42, 42),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Theme = {BackgroundColor3 = "Raised"},
	}, {corner(13)})
	center(icon(bell, "bell", 19, "Text"))
	local bs = create("UIScale", {Parent = bell})
	bell.MouseEnter:Connect(function()
		tween(bell, {BackgroundTransparency = 0.45}, 0.14)
	end)
	bell.MouseLeave:Connect(function()
		tween(bell, {BackgroundTransparency = 1}, 0.18)
	end)
	pressable(bell, bs, 1.08, 0.92)
	tooltip(bell, "Notifications")
	self.Bell = bell
	self.Badge = create("Frame", {
		Parent = bell,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(1, -10, 0, 10),
		Size = UDim2.fromOffset(9, 9),
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
	local panel = create("CanvasGroup", {
		Parent = Layers.Panels,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -86),
		Size = UDim2.fromOffset(width, height),
		GroupTransparency = 1,
		Visible = false,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(18)})
	rim(panel)
	return panel
end

function Hub:_reveal(panel, _, frames, owner, onClose, x)
	panel.Visible = true
	panel.GroupTransparency = 1
	local rest = x and UDim2.new(0, x, 1, -86) or UDim2.new(0.5, 0, 1, -86)
	panel.Position = rest + UDim2.fromOffset(0, 22)
	tween(panel, {Position = rest, GroupTransparency = 0}, 0.36)
	openPopup(frames, function()
		if onClose then
			onClose()
		end
		tween(panel, {Position = rest + UDim2.fromOffset(0, 18), GroupTransparency = 1}, 0.2)
		task.delay(0.22, function()
			if popup == nil or popup.Owner ~= owner then
				panel.Visible = false
			end
		end)
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
				tween(b, {BackgroundTransparency = 0.4}, 0.14)
			end)
			b.MouseLeave:Connect(function()
				tween(b, {BackgroundTransparency = 1}, 0.18)
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
			tween(b, {BackgroundTransparency = danger and 0.82 or 0.2, BackgroundColor3 = danger and T.Danger or T.Hover}, 0.14)
			tween(ic, {ImageColor3 = danger and T.Danger or T.Text}, 0.14)
		end)
		b.MouseLeave:Connect(function()
			tween(b, {BackgroundTransparency = 1}, 0.18)
			tween(ic, {ImageColor3 = T.Muted}, 0.18)
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
			tween(b, {BackgroundTransparency = 0.2}, 0.14)
			if ic then
				tween(ic, {ImageColor3 = T.Text}, 0.14)
			else
				tween(b, {TextColor3 = T.Text}, 0.14)
			end
		end)
		b.MouseLeave:Connect(function()
			tween(b, {BackgroundTransparency = 1}, 0.18)
			if ic then
				tween(ic, {ImageColor3 = self.DND and T.Warning or T.Muted}, 0.18)
			else
				tween(b, {TextColor3 = T.Muted}, 0.18)
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
	local content = o.Content or o.Description
	local duration = o.Duration or Lumen.Config.ToastDuration or 4

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
	local card = create("CanvasGroup", {
		Parent = wrap,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, offsetX, 1, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		GroupTransparency = 1,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(14)})
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
		BackgroundTransparency = 0.04,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(11), stroke("Stroke"), pad(0, 14, 0, 8), list(10, {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})}), 0.85)
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
		Size = UDim2.fromOffset(215, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Theme = {BackgroundColor3 = "Panel"},
	}, {corner(12), stroke("Stroke"), list(0)}), 0.85)
	self.BindFrame = frame
	local head = create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 1})
	local headHit = hit(head)
	headHit.ZIndex = 0
	local ic = icon(head, "keyboard", 14, "Accent")
	ic.AnchorPoint = Vector2.new(0, 0.5)
	ic.Position = UDim2.new(0, 13, 0.5, 0)
	text({Parent = head, Text = "Keybinds", Position = UDim2.fromOffset(35, 0), Size = UDim2.new(1, -46, 1, 0), FontFace = FONT_B, TextSize = 12})
	create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, LayoutOrder = 2, Theme = {BackgroundColor3 = "Stroke"}})
	drag(headHit, frame)
	local rows = create("Frame", {
		Parent = frame,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 3,
	}, {pad(6, 8, 8, 8), list(2)})
	local made = {}
	local acc = 0
	link(RS.Heartbeat, function(dt)
		acc += dt
		if acc < 0.1 or not frame.Parent then
			return
		end
		acc = 0
		for idx, entry in Lumen.Binds do
			local r = made[entry]
			if not r then
				local row = create("Frame", {Parent = rows, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = idx}, {corner(6)})
				local name = text({Parent = row, Text = entry.Name, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -76, 1, 0), TextSize = 12, TextColor3 = T.Muted})
				local key = text({Parent = row, Text = "", Position = UDim2.fromScale(0, 0), Size = UDim2.new(1, -8, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, TextSize = 11, FontFace = FONT_B, TextColor3 = T.Muted})
				r = {Row = row, Name = name, Key = key}
				made[entry] = r
			end
			local bound = entry.Bind.Value ~= UNKNOWN or entry.Bind.Mode == "Always"
			r.Row.Visible = bound
			if bound then
				local on = entry.Active()
				local modeTag = entry.Bind.Mode == "Always" and "Always" or keyName(entry.Bind.Value)
				r.Key.Text = "[" .. modeTag .. "]"
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
			local m = mouse()
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
		self.Ready = true
		tween(self.Dock, {Position = UDim2.new(0.5, 0, 1, -16)}, 0.7, Enum.EasingStyle.Back)
		for i, win in self.Windows do
			task.delay(0.08 + (i - 1) * 0.14, function()
				win:_apply()
			end)
		end
	end
	if o.Splash == false then
		task.defer(finish)
		return
	end
	task.spawn(function()
		local dim = create("Frame", {
			Parent = Layers.Splash,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = BLACK,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		})
		local card = center(create("CanvasGroup", {
			Parent = Layers.Splash,
			Size = UDim2.fromOffset(310, 184),
			GroupTransparency = 1,
			Theme = {BackgroundColor3 = "Panel"},
		}, {corner(24)}))
		rim(card)
		local sc = create("UIScale", {Parent = card, Scale = 0.88})
		local bub = create("Frame", {
			Parent = card,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 26),
			Size = UDim2.fromOffset(56, 56),
			BackgroundColor3 = WHITE,
		}, {corner(18), create("UIGradient", {Rotation = 45})})
		accentGradient(bub:FindFirstChildOfClass("UIGradient"))
		center(icon(bub, self.IconName, 26, WHITE))
		text({Parent = card, Text = self.Name, Position = UDim2.fromOffset(0, 96), Size = UDim2.new(1, 0, 0, 22), TextXAlignment = Enum.TextXAlignment.Center, FontFace = FONT_X, TextSize = 17})
		text({Parent = card, Text = self.Description, Position = UDim2.fromOffset(0, 119), Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Center, TextSize = 12, Theme = {TextColor3 = "Muted"}})
		local back = create("Frame", {
			Parent = card,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 152),
			Size = UDim2.fromOffset(190, 4),
			BorderSizePixel = 0,
			Theme = {BackgroundColor3 = "Hover"},
		}, {corner(PILL)})
		local fill = create("Frame", {
			Parent = back,
			Size = UDim2.fromScale(0, 1),
			BorderSizePixel = 0,
			Theme = {BackgroundColor3 = "Accent"},
		}, {corner(PILL)})

		tween(dim, {BackgroundTransparency = 0.55}, 0.45)
		tween(card, {GroupTransparency = 0}, 0.35)
		tween(sc, {Scale = 1}, 0.6, Enum.EasingStyle.Back)
		play(o.LoadedSound)
		task.wait(0.35)
		tween(fill, {Size = UDim2.fromScale(1, 1)}, 1.05, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
		task.wait(1.25)
		tween(card, {GroupTransparency = 1}, 0.3)
		tween(sc, {Scale = 1.06}, 0.35)
		tween(dim, {BackgroundTransparency = 1}, 0.4)
		task.wait(0.38)
		dim:Destroy()
		card:Destroy()
		finish()
	end)
end

function Hub:Settings(window)
	window:Category("Customization")
	local tab = window:Tab({Name = "UI Settings", Icon = "palette"})

	local themeSec = tab:Section({Name = "Theme & Colors", Icon = "palette", Side = "Left"})

	local themeNames = {}
	for name in Themes do
		table.insert(themeNames, name)
	end
	table.sort(themeNames)

	themeSec:Dropdown({
		Name = "Preset Theme",
		Description = "Load a curated color palette",
		Values = themeNames,
		Default = "Midnight",
		Flag = "UIThemePreset",
		Callback = function(name)
			Lumen:SetTheme(name)
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

	themeSec:Divider()

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

	themeSec:Button({
		Name = "Reset Theme Colors",
		Icon = "rotate-ccw",
		Callback = function()
			local preset = Lumen.Flags.UIThemePreset or "Midnight"
			Lumen:SetTheme(preset)
			self:Notify({Title = "Theme Reset", Content = "Restored " .. preset .. " palette.", Type = "Info"})
		end,
	})

	local winSec = tab:Section({Name = "Window & Effects", Icon = "sliders-horizontal", Side = "Right"})

	local menuBind = winSec:Keybind({
		Name = "Menu Toggle Key",
		Description = "Show or hide the entire hub",
		Default = self.Key,
		Modes = false,
		Flag = "UIMenuKey",
	})
	menuBind:OnChanged(function(k)
		if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode and k ~= UNKNOWN then
			self.Key = k
		end
	end)

	winSec:Slider({
		Name = "UI Scale",
		Description = "Resize windows for your monitor",
		Min = 75,
		Max = 125,
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
		Description = "Acrylic surface opacity",
		Min = 0,
		Max = 65,
		Increment = 5,
		Default = math.floor((Lumen.Config.Transparency or 0) * 100 + 0.5),
		Suffix = "%",
		Flag = "UITransparency",
		Callback = function(v)
			Lumen:SetTransparency(v / 100)
		end,
	})

	winSec:Toggle({
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
	})

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

	local hudSec = tab:Section({Name = "HUD & Notifications", Icon = "bell", Side = "Right"})

	local watermark, binds
	hudSec:Toggle({
		Name = "Watermark Overlay",
		Description = "Draggable FPS, ping & time bar",
		Default = false,
		Flag = "UIWatermark",
		Callback = function(v)
			watermark = watermark or self:Watermark()
			watermark:SetVisible(v)
		end,
	})

	hudSec:Toggle({
		Name = "Keybind List Overlay",
		Description = "Show active binds on screen",
		Default = false,
		Flag = "UIKeybindList",
		Callback = function(v)
			binds = binds or self:KeybindList()
			binds:SetVisible(v)
		end,
	})

	hudSec:Dropdown({
		Name = "Notification Corner",
		Values = {"BottomRight", "TopRight", "BottomLeft", "TopLeft"},
		Default = "BottomRight",
		Flag = "UIToastPos",
		Callback = function(v)
			self:SetToastPosition(v)
		end,
	})

	hudSec:Toggle({
		Name = "Notification Sounds",
		Default = true,
		Flag = "UISounds",
		Callback = function(v)
			Lumen.Config.Sounds = v
		end,
	})

	hudSec:Toggle({
		Name = "Do Not Disturb",
		Description = "Silence popups and badge alerts",
		Default = false,
		Flag = "UIDND",
		Callback = function(v)
			self:SetDND(v)
		end,
	})

	local cfgTab = window:Tab({Name = "Configs", Icon = "folder"})
	local cfgSec = cfgTab:Section({Name = "Configuration Manager", Icon = "folder", Side = "Left"})

	local nameInput = cfgSec:Input({Name = "Config Name", Default = "default", Placeholder = "name..."})
	local picker = cfgSec:Dropdown({
		Name = "Saved Profiles",
		Values = Lumen:ListConfigs(),
		Callback = function(v)
			if v then
				nameInput:Set(v)
			end
		end,
	})
	local function refresh()
		picker:SetValues(Lumen:ListConfigs())
	end
	cfgSec:Button({
		Name = "Save Config",
		Style = "Primary",
		Icon = "save",
		Callback = function()
			local ok = Lumen:SaveConfig(nameInput.Value)
			self:Notify({Title = ok and "Config Saved" or "Save Failed", Content = nameInput.Value, Type = ok and "Success" or "Error"})
			refresh()
		end,
	})
	cfgSec:Button({
		Name = "Load Config",
		Icon = "download",
		Callback = function()
			local ok = Lumen:LoadConfig(nameInput.Value)
			self:Notify({Title = ok and "Config Loaded" or "Load Failed", Content = nameInput.Value, Type = ok and "Success" or "Error"})
		end,
	})
	cfgSec:Button({
		Name = "Delete Config",
		Icon = "trash-2",
		DoubleTap = true,
		Callback = function()
			Lumen:DeleteConfig(nameInput.Value)
			refresh()
		end,
	})
	cfgSec:Button({
		Name = "Refresh List",
		Icon = "rotate-ccw",
		Callback = refresh,
	})

	local sysSec = cfgTab:Section({Name = "Session", Icon = "power", Side = "Right"})
	sysSec:Paragraph({
		Name = "Lumen UI v" .. Lumen.Version,
		Content = "All theme colors, transparency, blur, keybinds, and feature states are automatically included when saving a profile.",
	})
	sysSec:Button({
		Name = "Copy Config JSON",
		Icon = "copy",
		Callback = function()
			if setclipboard then
				setclipboard(Lumen:ExportJSON())
				self:Notify({Title = "Copied", Content = "Configuration JSON copied to clipboard.", Type = "Success"})
			end
		end,
	})
	sysSec:Button({
		Name = "Unload Interface",
		Icon = "power",
		DoubleTap = true,
		Callback = function()
			Lumen:Unload()
		end,
	})

	return tab
end

function Lumen:Taskbar(o)
	o = o or {}
	if o.Blur ~= nil then
		if type(o.Blur) == "boolean" then
			self.Config.Blur = o.Blur
		elseif type(o.Blur) == "number" then
			self.Config.Blur = o.Blur > 0
			self.Config.BlurSize = o.Blur
		end
	end
	if o.Transparency then
		self.Config.Transparency = o.Transparency
	end
	if o.Scale then
		self.Config.Scale = o.Scale
	end
	local hub = setmetatable({
		Name = o.Name or "Hub",
		Description = o.Description or "",
		IconName = o.Icon or "layers",
		Windows = {},
		Entries = {},
		History = {},
		Toasts = {},
		Unread = 0,
		Visible = true,
		Ready = false,
		DND = false,
		Z = 10,
		Key = o.Key or Enum.KeyCode.RightShift,
		Sound = o.NotifySound,
	}, Hub)
	Lumen.Hub = hub
	hub:_buildDock()
	hub:_buildStart()
	hub:_buildNotifications()
	hub:_inputs()
	hub:_splash(o)
	return hub
end

local function encode(v, alpha)
	if typeof(v) == "Color3" then
		return {__c = {v.R, v.G, v.B, alpha or 1}}
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
		data[flag] = encode(option.Value, option.Alpha)
	end
	return HttpService:JSONEncode(data)
end

function Lumen:ListConfigs()
	local names = {}
	if listfiles and isfolder and isfolder(self.Folder) then
		for _, path in listfiles(self.Folder) do
			local name = path:match("([^/\\]+)%.json$")
			if name then
				table.insert(names, name)
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
	if makefolder and isfolder and not isfolder(self.Folder) then
		makefolder(self.Folder)
	end
	return pcall(writefile, self.Folder .. "/" .. name .. ".json", self:ExportJSON())
end

function Lumen:LoadConfig(name)
	local path = self.Folder .. "/" .. tostring(name) .. ".json"
	if not (readfile and isfile and isfile(path)) then
		return false
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)
	if not ok then
		return false
	end
	for flag, raw in data do
		local option = self.Options[flag]
		if option then
			local value, alpha = decode(raw)
			option:Set(value, false, alpha)
		end
	end
	return true
end

function Lumen:DeleteConfig(name)
	local path = self.Folder .. "/" .. tostring(name) .. ".json"
	if delfile and isfile and isfile(path) then
		delfile(path)
		return true
	end
	return false
end

function Lumen:Unload()
	for _, c in connections do
		c:Disconnect()
	end
	table.clear(connections)
	table.clear(bindings)
	table.clear(hooks)
	table.clear(fontLabels)
	table.clear(surfaceFrames)
	if self.Hub then
		for _, t in self.Hub.Toasts do
			t.Conn:Disconnect()
		end
		if self.Hub.BlurEffect then
			self.Hub.BlurEffect:Destroy()
		end
	end
	Gui:Destroy()
	env.Lumen = nil
end

return Lumen
