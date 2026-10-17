local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local env = getgenv and getgenv() or _G
if env.Lumen then
	pcall(env.Lumen.Unload, env.Lumen)
end

local Library = {Flags = {}, Options = {}, Folder = "Lumen"}
env.Lumen = Library

local T = {
	Back = Color3.fromRGB(11, 11, 13),
	Side = Color3.fromRGB(15, 15, 18),
	Panel = Color3.fromRGB(19, 19, 23),
	Raised = Color3.fromRGB(27, 27, 33),
	Hover = Color3.fromRGB(35, 35, 42),
	Stroke = Color3.fromRGB(36, 36, 43),
	Text = Color3.fromRGB(236, 236, 241),
	Muted = Color3.fromRGB(125, 125, 138),
	Accent = Color3.fromRGB(138, 108, 255),
}
Library.Theme = T

local FONT = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
local FONT_B = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)

local connections = {}
local refreshers = {}

local function bind(signal, fn)
	local c = signal:Connect(fn)
	table.insert(connections, c)
	return c
end

local function onAccent(fn)
	fn()
	table.insert(refreshers, fn)
end

function Library:SetAccent(color)
	T.Accent = color
	for _, fn in refreshers do
		fn()
	end
end

local function create(class, props, children)
	local inst = Instance.new(class)
	local parent = props.Parent
	for k, v in props do
		if k ~= "Parent" then
			inst[k] = v
		end
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
	return create("UICorner", {CornerRadius = UDim.new(0, r)})
end

local function stroke(color, thickness, transparency)
	return create("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
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

local function list(gap)
	return create("UIListLayout", {Padding = UDim.new(0, gap), SortOrder = Enum.SortOrder.LayoutOrder})
end

local function text(props)
	local p = {
		BackgroundTransparency = 1,
		FontFace = FONT,
		TextSize = 13,
		TextColor3 = T.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Text = "",
		Size = UDim2.fromScale(1, 1),
	}
	for k, v in props do
		p[k] = v
	end
	return create("TextLabel", p)
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

local function tween(obj, props, time, style)
	TS:Create(obj, TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function apply(obj, props, animate)
	if animate then
		tween(obj, props)
	else
		for k, v in props do
			obj[k] = v
		end
	end
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function isMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

local function inside(frame, pos)
	local p, s = frame.AbsolutePosition, frame.AbsoluteSize
	return pos.X >= p.X and pos.X <= p.X + s.X and pos.Y >= p.Y and pos.Y <= p.Y + s.Y
end

local Gui = create("ScreenGui", {
	Name = "Lumen",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 100,
})
do
	local ok = pcall(function()
		Gui.Parent = (gethui and gethui()) or CoreGui
	end)
	if not ok or not Gui.Parent then
		Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
end
Library.Gui = Gui

local iconSource
local function resolveIcon(name)
	if type(name) ~= "string" or name == "" then
		return
	end
	if name:find("^rbxasset") or name:find("^rbxthumb") then
		return {Image = name}
	end
	if Library.IconResolver then
		local ok, data = pcall(Library.IconResolver, name)
		if ok and data then
			return data
		end
	end
	if iconSource == nil then
		local ok, module = pcall(function()
			return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua"))()
		end)
		iconSource = ok and module or false
		if iconSource then
			pcall(iconSource.SetIconsType, "lucide")
		end
	end
	if iconSource then
		local ok, data = pcall(iconSource.Icon, name)
		if ok and type(data) == "table" and data[1] then
			local rect = data[2] or {}
			return {Image = data[1], RectOffset = rect.ImageRectPosition, RectSize = rect.ImageRectSize}
		end
	end
end

local function icon(parent, name, size, color)
	local data = resolveIcon(name)
	if not data then
		return
	end
	local img = create("ImageLabel", {
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size, size),
		Image = data.Image,
		ImageColor3 = color or T.Text,
	})
	if data.RectOffset then
		img.ImageRectOffset = data.RectOffset
		img.ImageRectSize = data.RectSize
	end
	return img
end

local function glyph(parent, name, fallback, size, color)
	local img = icon(parent, name, size, color)
	if img then
		return img, "ImageColor3"
	end
	local label = text({
		Parent = parent,
		Text = fallback,
		Size = UDim2.fromOffset(size, size),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextSize = size,
		TextColor3 = color,
	})
	return label, "TextColor3"
end

local popup
local function closePopup()
	if popup then
		local p = popup
		popup = nil
		p.Close()
	end
end

local function openPopup(frames, close)
	closePopup()
	popup = {Frames = frames, Close = close}
end

bind(UIS.InputBegan, function(i)
	if popup and isPress(i) then
		local m = UIS:GetMouseLocation()
		for _, f in popup.Frames do
			if inside(f, m) then
				return
			end
		end
		closePopup()
	end
end)

bind(UIS.InputChanged, function(i)
	if popup and i.UserInputType == Enum.UserInputType.MouseWheel then
		local m = UIS:GetMouseLocation()
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

local function drag(handle, target)
	local dragging, start, origin
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			start = i.Position
			origin = target.Position
		end
	end)
	bind(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			local d = i.Position - start
			target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
		end
	end)
	bind(UIS.InputEnded, function(i)
		if isPress(i) then
			dragging = false
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
		Library.Flags[self.Flag] = self.Value
	end
	if silent then
		return
	end
	for _, fn in self._l do
		task.spawn(fn, self.Value)
	end
end

local function component(o, value, callback)
	local obj = setmetatable({Value = value, Flag = o.Flag, _l = {}}, Base)
	if callback then
		table.insert(obj._l, callback)
	end
	if o.Flag then
		Library.Options[o.Flag] = obj
		Library.Flags[o.Flag] = value
	end
	return obj
end

local function row(self, height)
	self.Order = (self.Order or 0) + 1
	return create("Frame", {
		Parent = self.Container,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundTransparency = 1,
		LayoutOrder = self.Order,
	})
end

local function hex(c)
	return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
end

local Elements = {}
local ElementMeta = {__index = Elements}

function Elements:Label(content)
	local r = row(self, 0)
	r.AutomaticSize = Enum.AutomaticSize.Y
	local label = text({
		Parent = r,
		Text = content or "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextColor3 = T.Muted,
		TextTruncate = Enum.TextTruncate.None,
		TextSize = 12,
	})
	pad(2, 0, 2, 0).Parent = label
	return {
		SetText = function(_, v)
			label.Text = v
		end,
	}
end

function Elements:Divider()
	local r = row(self, 9)
	create("Frame", {
		Parent = r,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = T.Stroke,
		BorderSizePixel = 0,
	})
end

function Elements:Button(o)
	o = o or {}
	local r = row(self, 32)
	local b = create("TextButton", {
		Parent = r,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = T.Raised,
		Text = "",
		AutoButtonColor = false,
	}, {corner(6)})
	local label = text({Parent = b, Text = o.Name or "Button", TextXAlignment = Enum.TextXAlignment.Center})
	local held = false
	b.MouseEnter:Connect(function()
		if not held then
			tween(b, {BackgroundColor3 = T.Hover})
		end
	end)
	b.MouseLeave:Connect(function()
		held = false
		tween(b, {BackgroundColor3 = T.Raised})
	end)
	b.MouseButton1Down:Connect(function()
		held = true
		tween(b, {BackgroundColor3 = T.Accent}, 0.08)
	end)
	b.MouseButton1Up:Connect(function()
		held = false
		tween(b, {BackgroundColor3 = T.Hover}, 0.2)
	end)
	b.Activated:Connect(function()
		if o.Callback then
			task.spawn(o.Callback)
		end
	end)
	return {
		SetText = function(_, v)
			label.Text = v
		end,
	}
end

function Elements:Toggle(o)
	o = o or {}
	local obj = component(o, o.Default == true, o.Callback)
	local r = row(self, 30)
	text({Parent = r, Text = o.Name or "Toggle", Size = UDim2.new(1, -50, 1, 0)})
	local track = create("Frame", {
		Parent = r,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(34, 18),
		BackgroundColor3 = T.Raised,
	}, {corner(9)})
	local knob = create("Frame", {
		Parent = track,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = T.Muted,
	}, {corner(6)})
	local click = hit(r)

	local function render(animate)
		local on = obj.Value
		apply(track, {BackgroundColor3 = on and T.Accent or T.Raised}, animate)
		apply(knob, {
			Position = on and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
			BackgroundColor3 = on and Color3.new(1, 1, 1) or T.Muted,
		}, animate)
	end

	onAccent(function()
		render(false)
	end)

	function obj:Set(v, silent)
		self.Value = v == true
		render(true)
		self:Fire(silent)
	end

	click.Activated:Connect(function()
		obj:Set(not obj.Value)
	end)
	return obj
end

function Elements:Slider(o)
	o = o or {}
	local min, max, inc = o.Min or 0, o.Max or 100, o.Increment or 1
	local dec = #(tostring(inc):match("%.(%d+)") or "")
	local fmt = "%." .. dec .. "f"
	local obj = component(o, math.clamp(o.Default or min, min, max), o.Callback)
	local r = row(self, 40)
	text({Parent = r, Text = o.Name or "Slider", Size = UDim2.new(1, -70, 0, 20)})
	local value = text({
		Parent = r,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.fromOffset(66, 20),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextColor3 = T.Muted,
	})
	local track = create("Frame", {
		Parent = r,
		Position = UDim2.fromOffset(0, 28),
		Size = UDim2.new(1, 0, 0, 4),
		BackgroundColor3 = T.Raised,
	}, {corner(2)})
	local fill = create("Frame", {Parent = track, Size = UDim2.fromScale(0, 1), BackgroundColor3 = T.Accent}, {corner(2)})
	local knob = create("Frame", {
		Parent = fill,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Color3.new(1, 1, 1),
	}, {corner(5)})
	local area = create("TextButton", {
		Parent = r,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Position = UDim2.fromOffset(0, 20),
		Size = UDim2.new(1, 0, 0, 20),
	})
	onAccent(function()
		fill.BackgroundColor3 = T.Accent
	end)

	local dragging = false
	local function render(animate)
		apply(fill, {Size = UDim2.fromScale((obj.Value - min) / (max - min), 1)}, animate)
		value.Text = string.format(fmt, obj.Value) .. (o.Suffix or "")
	end

	local function set(v, silent)
		v = math.clamp(math.floor((v - min) / inc + 0.5) * inc + min, min, max)
		v = tonumber(string.format(fmt, v))
		local changed = v ~= obj.Value
		obj.Value = v
		render(not dragging)
		if changed or silent then
			obj:Fire(silent)
		end
	end

	function obj:Set(v, silent)
		set(v, silent)
	end

	local function fromMouse()
		local a = math.clamp((UIS:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		set(min + (max - min) * a)
	end

	area.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			tween(knob, {Size = UDim2.fromOffset(14, 14)}, 0.12)
			fromMouse()
		end
	end)
	bind(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			fromMouse()
		end
	end)
	bind(UIS.InputEnded, function(i)
		if dragging and isPress(i) then
			dragging = false
			tween(knob, {Size = UDim2.fromOffset(10, 10)}, 0.12)
		end
	end)

	render(false)
	return obj
end

function Elements:Input(o)
	o = o or {}
	local obj = component(o, o.Default or "", o.Callback)
	local r = row(self, 30)
	text({Parent = r, Text = o.Name or "Input", Size = UDim2.new(1, -150, 1, 0)})
	local ring = stroke(T.Accent, 1, 1)
	local box = create("TextBox", {
		Parent = r,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(140, 26),
		BackgroundColor3 = T.Raised,
		Text = obj.Value,
		PlaceholderText = o.Placeholder or "",
		PlaceholderColor3 = T.Muted,
		TextColor3 = T.Text,
		FontFace = FONT,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, {corner(6), pad(0, 8), ring})
	box.Focused:Connect(function()
		ring.Color = T.Accent
		tween(ring, {Transparency = 0})
	end)
	box.FocusLost:Connect(function()
		tween(ring, {Transparency = 1})
		obj.Value = box.Text
		obj:Fire()
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
	local unknown = Enum.KeyCode.Unknown
	local obj = component(o, o.Default or unknown, o.OnChange)
	local r = row(self, 30)
	text({Parent = r, Text = o.Name or "Keybind", Size = UDim2.new(1, -80, 1, 0)})
	local box = create("TextButton", {
		Parent = r,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = T.Raised,
		AutoButtonColor = false,
		FontFace = FONT,
		TextSize = 12,
		TextColor3 = T.Muted,
		Text = "",
	}, {corner(6), pad(0, 10)})
	local listening = false

	local function render()
		box.Text = listening and "..." or (obj.Value == unknown and "None" or obj.Value.Name)
		tween(box, {TextColor3 = listening and T.Accent or T.Muted})
	end

	function obj:Set(v, silent)
		if type(v) == "string" then
			v = Enum.KeyCode[v] or unknown
		end
		self.Value = v or unknown
		render()
		self:Fire(silent)
	end

	box.Activated:Connect(function()
		listening = true
		render()
	end)

	bind(UIS.InputBegan, function(i, processed)
		if listening then
			if i.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				local cancel = i.KeyCode == Enum.KeyCode.Escape or i.KeyCode == Enum.KeyCode.Backspace
				obj:Set(cancel and unknown or i.KeyCode)
			end
			return
		end
		if not processed and obj.Value ~= unknown and i.KeyCode == obj.Value and o.Callback then
			task.spawn(o.Callback, obj.Value)
		end
	end)

	render()
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
	local r = row(self, 30)
	text({Parent = r, Text = o.Name or "Dropdown", Size = UDim2.new(1, -160, 1, 0)})
	local box = create("Frame", {
		Parent = r,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(150, 26),
		BackgroundColor3 = T.Raised,
	}, {corner(6)})
	local shown = text({Parent = box, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0), TextSize = 12})
	local chevron = glyph(box, "chevron-down", "v", 12, T.Muted)
	chevron.AnchorPoint = Vector2.new(1, 0.5)
	chevron.Position = UDim2.new(1, -8, 0.5, 0)
	local click = hit(box)

	local function selected(name)
		if multi then
			return table.find(obj.Value, name) ~= nil
		end
		return obj.Value == name
	end

	local function render()
		local empty = multi and #obj.Value == 0 or (not multi and obj.Value == nil)
		if empty then
			shown.Text = "None"
		else
			shown.Text = multi and table.concat(obj.Value, ", ") or tostring(obj.Value)
		end
		shown.TextColor3 = empty and T.Muted or T.Text
	end

	local panel
	local function close()
		if not panel then
			return
		end
		local p = panel
		panel = nil
		tween(p, {Size = UDim2.fromOffset(p.AbsoluteSize.X, 0)}, 0.12)
		task.delay(0.12, function()
			p:Destroy()
		end)
	end

	local function open()
		local w = box.AbsoluteSize.X
		local h = math.min(#values * 28 + 8, 172)
		panel = create("Frame", {
			Parent = Gui,
			Position = place(box, w, h, false),
			Size = UDim2.fromOffset(w, 0),
			BackgroundColor3 = T.Panel,
			ClipsDescendants = true,
			ZIndex = 100,
		}, {corner(8), stroke(T.Stroke)})
		local scroll = create("ScrollingFrame", {
			Parent = panel,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = T.Stroke,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
		}, {pad(4), list(2)})
		local labels = {}
		for idx, name in values do
			local b = create("TextButton", {
				Parent = scroll,
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundColor3 = T.Hover,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = idx,
			}, {corner(6)})
			labels[name] = text({
				Parent = b,
				Text = tostring(name),
				Position = UDim2.fromOffset(10, 0),
				Size = UDim2.new(1, -20, 1, 0),
				TextColor3 = selected(name) and T.Accent or T.Muted,
			})
			b.MouseEnter:Connect(function()
				tween(b, {BackgroundTransparency = 0})
			end)
			b.MouseLeave:Connect(function()
				tween(b, {BackgroundTransparency = 1})
			end)
			b.Activated:Connect(function()
				if multi then
					local i = table.find(obj.Value, name)
					if i then
						table.remove(obj.Value, i)
					else
						table.insert(obj.Value, name)
					end
					labels[name].TextColor3 = selected(name) and T.Accent or T.Muted
					render()
					obj:Fire()
				else
					obj:Set(name)
					closePopup()
				end
			end)
		end
		tween(panel, {Size = UDim2.fromOffset(w, h)}, 0.15)
		openPopup({panel, box}, close)
	end

	function obj:Set(v, silent)
		if multi then
			self.Value = type(v) == "table" and table.clone(v) or {}
		else
			self.Value = v
		end
		render()
		self:Fire(silent)
	end

	function obj:SetValues(list_)
		values = list_
		closePopup()
	end

	click.Activated:Connect(function()
		if panel then
			closePopup()
		else
			open()
		end
	end)

	render()
	return obj
end

function Elements:ColorPicker(o)
	o = o or {}
	local obj = component(o, o.Default or Color3.fromRGB(138, 108, 255), o.Callback)
	local h, s, v = obj.Value:ToHSV()
	local r = row(self, 30)
	text({Parent = r, Text = o.Name or "Color", Size = UDim2.new(1, -50, 1, 0)})
	local swatch = create("TextButton", {
		Parent = r,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		Size = UDim2.fromOffset(34, 18),
		BackgroundColor3 = obj.Value,
		Text = "",
		AutoButtonColor = false,
	}, {corner(5)})

	local refs
	local panel
	local dragMode

	local function sync(silent)
		obj.Value = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = obj.Value
		if refs then
			refs.sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			refs.svCursor.Position = UDim2.fromScale(s, 1 - v)
			refs.hueCursor.Position = UDim2.fromScale(h, 0.5)
			refs.hex.Text = hex(obj.Value)
		end
		obj:Fire(silent)
	end

	local function pick()
		local m = UIS:GetMouseLocation()
		if dragMode == "sv" then
			s = math.clamp((m.X - refs.sv.AbsolutePosition.X) / refs.sv.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((m.Y - refs.sv.AbsolutePosition.Y) / refs.sv.AbsoluteSize.Y, 0, 1)
		elseif dragMode == "hue" then
			h = math.clamp((m.X - refs.hue.AbsolutePosition.X) / refs.hue.AbsoluteSize.X, 0, 1)
		end
		sync()
	end

	bind(UIS.InputChanged, function(i)
		if dragMode and refs and isMove(i) then
			pick()
		end
	end)
	bind(UIS.InputEnded, function(i)
		if isPress(i) then
			dragMode = nil
		end
	end)

	local function close()
		if not panel then
			return
		end
		local p = panel
		panel = nil
		refs = nil
		dragMode = nil
		p:Destroy()
	end

	local function open()
		panel = create("Frame", {
			Parent = Gui,
			Size = UDim2.fromOffset(194, 190),
			BackgroundColor3 = T.Panel,
			ZIndex = 100,
		}, {corner(8), stroke(T.Stroke)})
		panel.Position = place(swatch, 194, 190, true)

		local sv = create("TextButton", {
			Parent = panel,
			Position = UDim2.fromOffset(12, 12),
			Size = UDim2.fromOffset(170, 110),
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
		}, {corner(6)})
		create("Frame", {Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1)}, {
			corner(6),
			create("UIGradient", {Transparency = NumberSequence.new(0, 1)}),
		})
		create("Frame", {Parent = sv, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0)}, {
			corner(6),
			create("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)}),
		})
		local svCursor = create("Frame", {
			Parent = sv,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(s, 1 - v),
			Size = UDim2.fromOffset(10, 10),
			BackgroundTransparency = 1,
		}, {corner(5), stroke(Color3.new(1, 1, 1), 2)})

		local keys = {}
		for i = 0, 6 do
			table.insert(keys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
		end
		local hue = create("TextButton", {
			Parent = panel,
			Position = UDim2.fromOffset(12, 132),
			Size = UDim2.fromOffset(170, 10),
			Text = "",
			AutoButtonColor = false,
			BackgroundColor3 = Color3.new(1, 1, 1),
		}, {corner(5), create("UIGradient", {Color = ColorSequence.new(keys)})})
		local hueCursor = create("Frame", {
			Parent = hue,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(h, 0.5),
			Size = UDim2.fromOffset(4, 16),
			BackgroundColor3 = Color3.new(1, 1, 1),
		}, {corner(2), stroke(Color3.new(0, 0, 0), 1, 0.5)})

		local box = create("TextBox", {
			Parent = panel,
			Position = UDim2.fromOffset(12, 152),
			Size = UDim2.fromOffset(170, 26),
			BackgroundColor3 = T.Raised,
			Text = hex(obj.Value),
			TextColor3 = T.Text,
			FontFace = FONT,
			TextSize = 12,
			ClearTextOnFocus = false,
		}, {corner(6)})

		refs = {sv = sv, svCursor = svCursor, hue = hue, hueCursor = hueCursor, hex = box}

		sv.InputBegan:Connect(function(i)
			if isPress(i) then
				dragMode = "sv"
				pick()
			end
		end)
		hue.InputBegan:Connect(function(i)
			if isPress(i) then
				dragMode = "hue"
				pick()
			end
		end)
		box.FocusLost:Connect(function()
			local rr, gg, bb = box.Text:match("^#?(%x%x)(%x%x)(%x%x)$")
			if rr then
				h, s, v = Color3.fromRGB(tonumber(rr, 16), tonumber(gg, 16), tonumber(bb, 16)):ToHSV()
				sync()
			else
				box.Text = hex(obj.Value)
			end
		end)

		openPopup({panel, swatch}, close)
	end

	function obj:Set(c, silent)
		h, s, v = c:ToHSV()
		sync(silent)
	end

	swatch.Activated:Connect(function()
		if panel then
			closePopup()
		else
			open()
		end
	end)
	return obj
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
	local frame = create("Frame", {
		Parent = self.Columns[col],
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = T.Panel,
		BorderSizePixel = 0,
		LayoutOrder = self.Counts[col],
	}, {corner(8), stroke(T.Stroke), list(0)})
	local header = create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, LayoutOrder = 1})
	text({
		Parent = header,
		Text = o.Name or "Section",
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -28, 1, 0),
		FontFace = FONT_B,
	})
	create("Frame", {Parent = frame, Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = T.Stroke, BorderSizePixel = 0, LayoutOrder = 2})
	local body = create("Frame", {
		Parent = frame,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 3,
	}, {pad(10, 14), list(6)})
	return setmetatable({Container = body}, ElementMeta)
end

function Library:Window(o)
	o = o or {}
	local window = {Key = o.Key or Enum.KeyCode.RightShift, Open = true}
	local tabs = {}
	local order = 0

	local main = create("Frame", {
		Name = "Window",
		Parent = Gui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = o.Size or UDim2.fromOffset(680, 450),
		BackgroundColor3 = T.Back,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, {corner(10), stroke(T.Stroke)})
	local scale = create("UIScale", {Parent = main})

	local side = create("Frame", {Parent = main, Size = UDim2.new(0, 184, 1, 0), BackgroundColor3 = T.Side, BorderSizePixel = 0})
	create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = T.Stroke,
		BorderSizePixel = 0,
	})

	local head = create("Frame", {Parent = side, Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1})
	local logo = create("Frame", {
		Parent = head,
		Position = UDim2.fromOffset(16, 17),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = T.Accent,
	}, {corner(8)})
	onAccent(function()
		logo.BackgroundColor3 = T.Accent
	end)
	local mark = icon(logo, o.Icon or "layers", 16, Color3.new(1, 1, 1))
	if mark then
		mark.AnchorPoint = Vector2.new(0.5, 0.5)
		mark.Position = UDim2.fromScale(0.5, 0.5)
	else
		text({
			Parent = logo,
			Text = string.upper(string.sub(o.Title or "L", 1, 1)),
			TextXAlignment = Enum.TextXAlignment.Center,
			FontFace = FONT_B,
			TextColor3 = Color3.new(1, 1, 1),
		})
	end
	text({
		Parent = head,
		Text = o.Title or "Lumen",
		Position = UDim2.fromOffset(54, 14),
		Size = UDim2.new(1, -62, 0, 18),
		FontFace = FONT_B,
		TextSize = 14,
	})
	text({
		Parent = head,
		Text = o.Subtitle or "",
		Position = UDim2.fromOffset(54, 31),
		Size = UDim2.new(1, -62, 0, 14),
		TextSize = 11,
		TextColor3 = T.Muted,
	})

	local tabList = create("ScrollingFrame", {
		Parent = side,
		Position = UDim2.fromOffset(0, 62),
		Size = UDim2.new(1, 0, 1, -122),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, {pad(4, 10), list(2)})

	local footer = create("Frame", {
		Parent = side,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundTransparency = 1,
	})
	create("Frame", {Parent = footer, Size = UDim2.new(1, -1, 0, 1), BackgroundColor3 = T.Stroke, BorderSizePixel = 0})
	local player = Players.LocalPlayer
	create("ImageLabel", {
		Parent = footer,
		Position = UDim2.fromOffset(16, 15),
		Size = UDim2.fromOffset(30, 30),
		BackgroundColor3 = T.Raised,
		Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48",
	}, {corner(15)})
	text({
		Parent = footer,
		Text = player.DisplayName,
		Position = UDim2.fromOffset(54, 14),
		Size = UDim2.new(1, -62, 0, 16),
		FontFace = FONT_B,
		TextSize = 12,
	})
	text({
		Parent = footer,
		Text = "@" .. player.Name,
		Position = UDim2.fromOffset(54, 30),
		Size = UDim2.new(1, -62, 0, 14),
		TextSize = 11,
		TextColor3 = T.Muted,
	})

	local content = create("Frame", {
		Parent = main,
		Position = UDim2.fromOffset(184, 0),
		Size = UDim2.new(1, -184, 1, 0),
		BackgroundTransparency = 1,
	})
	local top = create("Frame", {Parent = content, Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1})
	local heading = text({
		Parent = top,
		Position = UDim2.fromOffset(20, 0),
		Size = UDim2.new(1, -80, 1, 0),
		FontFace = FONT_B,
		TextSize = 15,
	})
	create("Frame", {
		Parent = content,
		Position = UDim2.fromOffset(0, 52),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = T.Stroke,
		BorderSizePixel = 0,
	})

	local close = create("TextButton", {
		Parent = top,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = T.Raised,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	}, {corner(7)})
	local cross, crossProp = glyph(close, "x", "×", 16, T.Muted)
	cross.AnchorPoint = Vector2.new(0.5, 0.5)
	cross.Position = UDim2.fromScale(0.5, 0.5)
	close.MouseEnter:Connect(function()
		tween(close, {BackgroundTransparency = 0})
		tween(cross, {[crossProp] = T.Text})
	end)
	close.MouseLeave:Connect(function()
		tween(close, {BackgroundTransparency = 1})
		tween(cross, {[crossProp] = T.Muted})
	end)

	local pages = create("Frame", {
		Parent = content,
		Position = UDim2.fromOffset(0, 53),
		Size = UDim2.new(1, 0, 1, -53),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	drag(top, main)
	drag(head, main)

	function window:Toggle(state)
		if state == nil then
			state = not self.Open
		end
		self.Open = state
		closePopup()
		if state then
			scale.Scale = 0.95
			main.Visible = true
			tween(scale, {Scale = 1}, 0.18)
		else
			tween(scale, {Scale = 0.95}, 0.12)
			task.delay(0.12, function()
				if not self.Open then
					main.Visible = false
				end
			end)
		end
	end

	close.Activated:Connect(function()
		window:Toggle(false)
	end)

	bind(UIS.InputBegan, function(i, processed)
		if not processed and i.KeyCode == window.Key then
			window:Toggle()
		end
	end)

	function window:Destroy()
		main:Destroy()
	end

	function window:Category(name)
		order += 1
		local label = text({
			Parent = tabList,
			Text = string.upper(name),
			Size = UDim2.new(1, 0, 0, 26),
			FontFace = FONT_B,
			TextSize = 10,
			TextColor3 = T.Muted,
			LayoutOrder = order,
		})
		pad(8, 0, 0, 10).Parent = label
	end

	function window:Tab(t)
		t = type(t) == "string" and {Name = t} or (t or {})
		order += 1
		local tab = setmetatable({Counts = {0, 0}}, TabMeta)

		local btn = create("Frame", {
			Parent = tabList,
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = T.Raised,
			BackgroundTransparency = 1,
			LayoutOrder = order,
		}, {corner(7)})
		local bar = create("Frame", {
			Parent = btn,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(3, 0),
			BackgroundColor3 = T.Accent,
			BorderSizePixel = 0,
		}, {corner(2)})
		onAccent(function()
			bar.BackgroundColor3 = T.Accent
		end)
		local ico = icon(btn, t.Icon, 16, T.Muted)
		if ico then
			ico.AnchorPoint = Vector2.new(0, 0.5)
			ico.Position = UDim2.new(0, 12, 0.5, 0)
		end
		local label = text({
			Parent = btn,
			Text = t.Name or "Tab",
			Position = UDim2.fromOffset(ico and 38 or 14, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextColor3 = T.Muted,
		})
		local click = hit(btn)

		local page = create("ScrollingFrame", {
			Parent = pages,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = T.Stroke,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
		}, {pad(16, 20)})
		local holder = create("Frame", {
			Parent = page,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, {
			create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 12),
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})
		local function column(index)
			return create("Frame", {
				Parent = holder,
				Size = UDim2.new(0.5, -6, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = index,
			}, {list(12)})
		end
		tab.Columns = {column(1), column(2)}

		local active = false
		function tab:Activate(on)
			active = on
			page.Visible = on
			tween(btn, {BackgroundTransparency = on and 0 or 1})
			tween(bar, {Size = UDim2.fromOffset(3, on and 16 or 0)})
			tween(label, {TextColor3 = on and T.Text or T.Muted})
			if ico then
				tween(ico, {ImageColor3 = on and T.Accent or T.Muted})
			end
			if on then
				heading.Text = t.Name or "Tab"
			end
		end

		click.MouseEnter:Connect(function()
			if not active then
				tween(label, {TextColor3 = T.Text})
			end
		end)
		click.MouseLeave:Connect(function()
			if not active then
				tween(label, {TextColor3 = T.Muted})
			end
		end)
		click.Activated:Connect(function()
			closePopup()
			for _, other in tabs do
				other:Activate(other == tab)
			end
		end)

		table.insert(tabs, tab)
		if #tabs == 1 then
			tab:Activate(true)
		end
		return tab
	end

	return window
end

local toasts = create("Frame", {
	Parent = Gui,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -20, 1, -20),
	Size = UDim2.fromOffset(280, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	ZIndex = 200,
}, {
	create("UIListLayout", {
		Padding = UDim.new(0, 8),
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})

function Library:Notify(o)
	o = o or {}
	local duration = o.Duration or 4
	local wrap = create("Frame", {
		Parent = toasts,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})
	local card = create("Frame", {
		Parent = wrap,
		Position = UDim2.fromOffset(300, 0),
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = T.Panel,
		ClipsDescendants = true,
	}, {corner(8), stroke(T.Stroke)})
	local inner = create("Frame", {
		Parent = card,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {pad(12, 14, 14, 14), list(4)})
	text({Parent = inner, Text = o.Title or "Notification", Size = UDim2.new(1, 0, 0, 16), FontFace = FONT_B, LayoutOrder = 1})
	if o.Content then
		text({
			Parent = inner,
			Text = o.Content,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			TextColor3 = T.Muted,
			TextSize = 12,
			LayoutOrder = 2,
		})
	end
	local bar = create("Frame", {
		Parent = card,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = T.Accent,
		BorderSizePixel = 0,
	})
	tween(card, {Position = UDim2.fromOffset(0, 0)}, 0.3, Enum.EasingStyle.Quint)
	tween(bar, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)
	task.delay(duration, function()
		tween(card, {Position = UDim2.fromOffset(300, 0)}, 0.25, Enum.EasingStyle.Quint)
		task.wait(0.28)
		wrap:Destroy()
	end)
end

local function encode(v)
	if typeof(v) == "Color3" then
		return {__c = {v.R, v.G, v.B}}
	elseif typeof(v) == "EnumItem" then
		return {__k = v.Name}
	end
	return v
end

local function decode(v)
	if type(v) == "table" then
		if v.__c then
			return Color3.new(v.__c[1], v.__c[2], v.__c[3])
		elseif v.__k then
			return Enum.KeyCode[v.__k]
		end
	end
	return v
end

function Library:SaveConfig(name)
	if not writefile then
		return false
	end
	local data = {}
	for flag, value in self.Flags do
		data[flag] = encode(value)
	end
	if makefolder and isfolder and not isfolder(self.Folder) then
		makefolder(self.Folder)
	end
	writefile(self.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
	return true
end

function Library:LoadConfig(name)
	local path = self.Folder .. "/" .. name .. ".json"
	if not (readfile and isfile and isfile(path)) then
		return false
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)
	if not ok then
		return false
	end
	for flag, value in data do
		local option = self.Options[flag]
		if option then
			option:Set(decode(value))
		end
	end
	return true
end

function Library:Unload()
	for _, c in connections do
		c:Disconnect()
	end
	table.clear(connections)
	table.clear(refreshers)
	Gui:Destroy()
end

return Library
