---WS Library
---@class ws
local ws = { Version = "0.2", events = {}, tasks = {}, guis = {}, tweens = {} }

---On load
function onLoad() end

---On update
---@param deltaTime number
function onUpdate(deltaTime) ws.update(deltaTime) end

---On error
---@param err string
function onError(err) ws.error(err) end

---On reload
function onReload() onDestroy() end

---On shutdown
function onDestroy() ws.Destroy() end

--#region WS
---@diagnostic disable: duplicate-set-field, redundant-parameter
--stylua: ignore start

function ws.CreateEvent(callback, fun, oneShot, updateDelay) --[[@return Event]]
	local event = { Fire = callback, fun = fun, oneShot = oneShot, updateDelay = updateDelay or 1 }
	function event.Destroy() table.remove(ws.events, table.find(ws.events, event)) end; table.insert(ws.events, event); return event; end
function ws.RunDelayed(callback, delay) --[[@return Task]]
	local task = { Callback = callback, delay = delay, alive = 0 }
	function task.Destroy() table.remove(ws.tasks, table.find(ws.tasks, task)) end; table.insert(ws.tasks, task); return task; end
function ws.RunRepeated(callback, repeatDelay, delay) --[[@return Task]]
	local task = { Callback = callback, alive = 0, delay = delay or 0, repeatDelay = repeatDelay or 1 }
	function task.Destroy() table.remove(ws.tasks, table.find(ws.tasks, task)) end; table.insert(ws.tasks, task); return task; end
function ws.CreateTween(object, property, value, duration, fun, easingType, easingDirection) --[[@return Tween]]
	local tween = { Object = object, Property = property, startValue = object[property], Value = value, Duration = duration, fun = fun, EasingType = easingType or "Linear", EasingDirection = easingDirection or "In", currentTime = 0 }
	function tween.Destroy() table.remove(ws.tweens, table.find(ws.tweens, tween)) end; function tween.Pause() tween.active = false end; function tween.Start() tween.active = true end
	table.insert(ws.tweens, tween); return tween; end
function ws.CreateGUI(display, background) --[[@return Gui]]
	local gui = { Display = display, components = {}, Visible = true, Background = background or "000000" }
	local function applyGetSizeFunction(component) function component.GetSize() return component.Size end end
	local anchors = { TopLeft = ws.Vector2(0, 0), Top = ws.Vector2(0.5, 0), TopRight = ws.Vector2(1, 0), Left = ws.Vector2(0, 0.5), Center = ws.Vector2(0.5, 0.5), Right = ws.Vector2(1, 0.5), BottomLeft = ws.Vector2(0, 1), Bottom = ws.Vector2(0.5, 1), BottomRight = ws.Vector2(1, 1) }
	local function applyAnchor(component) return component.Position - component.GetSize() * anchors[component.Anchor] end
	local function createBaseComponent(component) component = table.merge(component, { Visible = true, ZIndex = 1 }); function component.Destroy() table.remove(gui.components, table.find(gui.components, component)) end; function component.SetZIndex(index) component.ZIndex = index; table.sort(gui.components, function(a, b) return a.ZIndex < b.ZIndex end) end return component end
	function gui.CreateText(text, position, color, anchor)
		local component = createBaseComponent({ Text = text, Position = position, Color = color or "ffffff", Anchor = anchor or "TopLeft" })
		function component.GetSize() return ws.Vector2(gui.Display.calcTextSize(component.Text)) end
		function component.update() local pos = applyAnchor(component); gui.Display.drawText(pos.x, pos.y, component.Text, component.Color) end
		table.insert(gui.components, component); return component; end
	function gui.CreateRect(position, size, color, anchor, border)
		local component = createBaseComponent({ Position = position, Size = size, Color = color or "ffffff", Anchor = anchor or "TopLeft", Border = border and { Thickness = border.Thickness, Color = border.Color or "000000" } })
		applyGetSizeFunction(component)
		function component.update()
			local border = component.Border; local pos = applyAnchor(component)
			if border then gui.Display.drawFilledRect(pos.x - border.Thickness, pos.y - border.Thickness, component.Size.x + border.Thickness * 2, component.Size.y + border.Thickness * 2, border.Color) end
			gui.Display.drawFilledRect(pos.x, pos.y, component.Size.x, component.Size.y, component.Color); end
		table.insert(gui.components, component); return component; end
	function gui.CreateOutline(position, size, color, anchor)
		local component = createBaseComponent({ Position = position, Size = size, Color = color or "ffffff", Anchor = anchor or "TopLeft" })
		applyGetSizeFunction(component)
		function component.update() local pos = applyAnchor(component); gui.Display.drawRect(pos.x, pos.y, component.Size.x, component.Size.y, component.Color) end
		table.insert(gui.components, component); return component; end
	function gui.CreateLine(position, position1, color)
		local component = createBaseComponent({ Position = position, Position1 = position1, Color = color or "ffffff" })
		function component.update() gui.Display.drawLine(component.Position.x, component.Position.y, component.Position1.x, component.Position1.y, component.Color) end
		function component.GetSize() return math.max(component.Position.x, component.Position1.x) - math.min(component.Position.x, component.Position1.x), math.max(component.Position.y, component.Position1.y) - math.min(component.Position.y, component.Position1.y) end
		table.insert(gui.components, component); return component; end
	function gui.CreateImage(imageData, position, anchor)
		local component = createBaseComponent({ Position = position, ImageData = imageData, Anchor = anchor or "TopLeft" })
		local pixels = {}
		local function rePosition()
			local x, y = applyAnchor(component); for _, v in pairs(component.ImageData.Pixels) do table.insert(pixels, { x = (v.x + x) or 0, y = (v.y + y) or 0, color = v.color }) end
		end; rePosition()
		function component.GetSize() return ws.Vector2(unpack(component.ImageData.Size)) end
		function component.update() gui.Display.drawFromTable(pixels) end
		table.insert(gui.components, component); return component; end
	function gui.CreateCircle(position, radius, color, anchor, border)
		local component = createBaseComponent({ Position = position, Radius = radius, Color = color or "ffffff", Anchor = anchor or "TopLeft", Border = border and { Thickness = border.Thickness, Color = border.Color or "000000" } })
		function component.GetSize() return ws.Vector2(component.Radius * 2, component.Radius * 2) end
		function component.update() local border = component.Border; local pos = applyAnchor(component)
			if border then gui.Display.drawFilledCircle(pos.x + component.Radius, pos.y + component.Radius, component.Radius + border.Thickness, border.Color) end
			gui.Display.drawFilledCircle(pos.x + component.Radius, pos.y + component.Radius, component.Radius, component.Color); end
		table.insert(gui.components, component); return component; end
	function gui.CreateCircleOutline(position, radius, color, anchor)
		local component = createBaseComponent({ Position = position, Radius = radius, Color = color or "ffffff", Anchor = anchor or "TopLeft" })
		function component.GetSize() return ws.Vector2(component.Radius * 2, component.Radius * 2) end
		function component.update() local pos = applyAnchor(component); gui.Display.drawCircle(pos.x + component.Radius, pos.y + component.Radius, component.Radius, component.Color) end
		table.insert(gui.components, component); return component; end
	function gui.GetSize() return ws.Vector2(gui.Display.getDimensions()) end
	function gui.update() gui.Display.clear(gui.Background); for _, v in pairs(gui.components) do if v.Visible then v.update() end end; gui.Display.update() end
	function gui.Destroy() gui.Display.clear(); gui.Display.update(); table.remove(ws.guis, table.find(ws.guis, gui)) end
	table.insert(ws.guis, gui); return gui; end
do local meta = { __unm = function(a) return ws.Vector2(-a.x, -a.y) end, __add = function(a, b) return ws.Vector2(a.x + b.x, a.y + b.y) end, __sub = function(a, b) return ws.Vector2(a.x - b.x, a.y - b.y) end, __mul = function(a, b) if type(b) == "number" then b = ws.Vector2(b, b) end; return ws.Vector2(a.x * b.x, a.y * b.y) end, __div = function(a, b) if type(b) == "number" then b = ws.Vector2(b, b) end; return ws.Vector2(a.x / b.x, a.y / b.y) end, __eq = function(a, b) return a.x == b.x and a.y == b.y end }
	ws.Vector2 = setmetatable({}, { __call = function(_, x, y) local t = table.clone(ws.Vector2 --[[@as table]]); t.x = x or 0; t.y = y or 0; return setmetatable(t, meta) end }) --[[@class Vector2Impl]]
	function ws.Vector2.lerp(a, b, t) return ws.Vector2(math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t)) end
	function ws.Vector2.length(vec) return math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2)) end
	function ws.Vector2.angle(a, b) return a * b / (a:length() * b:length()) end
	function ws.Vector2.dot(a, b) return a * b end end
do local meta = { __unm = function(a) return ws.Vector3(-a.x, -a.y, -a.z) end, __add = function(a, b) return ws.Vector3(a.x + b.x, a.y + b.y, a.z + b.z) end, __sub = function(a, b) return ws.Vector3(a.x - b.x, a.y - b.y, a.z - b.z) end, __mul = function(a, b) if type(b) == "number" then b = ws.Vector3(b, b, b) end; return ws.Vector3(a.x * b.x, a.y * b.y, a.z * b.z) end, __div = function(a, b) if type(b) == "number" then b = ws.Vector3(b, b, b) end; return ws.Vector3(a.x / b.x, a.y / b.y, a.z / b.z) end, __eq = function(a, b) return a.x == b.x and a.y == b.y and a.z == b.z end }
	ws.Vector3 = setmetatable({}, { __call = function(_, x, y, z) local t = table.clone(ws.Vector3 --[[@as table]]); t.x = x or 0; t.y = y or 0; t.z = z or 0; return setmetatable(t, meta) end }) --[[@class Vector3Impl]]
	function ws.Vector3.lerp(a, b, t) return ws.Vector3(math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t), math.lerp(a.z, b.z, t)) end
	function ws.Vector3.length(vec) return math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2) + math.pow(vec.z, 2)) end
	function ws.Vector3.angle(a, b) return a * b / (a:length() * b:length()) end
	function ws.Vector3.dot(a, b) return a * b end end
function ws.update(deltaTime)
	for _, task in pairs(ws.tasks) do task.alive = task.alive + deltaTime * 40; if task.active then if task.alive >= task.repeatDelay then task.Callback(deltaTime); task.alive = 0 end elseif task.alive >= task.delay then task.Callback(deltaTime); if task.repeatDelay == nil then task.Destroy() else task.alive = 0; task.active = true end; end; end
	for _, event in pairs(ws.events) do if event.alive ~= nil then event.alive = event.alive + deltaTime * 40 end
		if event.alive == nil or event.alive >= event.updateDelay then local args = { event.fun() }; if args[1] then if not event.active then event.Fire(select(2, unpack(args))); if event.oneShot then event.Destroy(); else event.active = true end end else event.active = false end; event.alive = 0; end; end
	for _, tween in pairs(ws.tweens) do if tween.active then tween.currentTime = tween.currentTime + deltaTime * 40; tween.Object[tween.Property] = tween.fun(tween.startValue, tween.Value, sm.util.easing(tween.EasingType == "Linear" and "linear" or ("ease" .. tween.EasingDirection .. tween.EasingType), math.min(tween.currentTime / tween.Duration, 1))); if tween.currentTime >= tween.Duration then tween.Destroy() end end end
	for _, gui in pairs(ws.guis) do if gui.Visible then gui.update() end end end
function ws.error(err)
	local args = string.split(err, ":"); local msg, line = string.capitalize(string.strip(args[#args])), args[#args - 3]
	for _, v in pairs(sc.getDisplays()) do local gui = ws.CreateGUI(v); local size = gui.GetSize(); local ew, eh = v.calcTextSize(msg); gui.CreateRect(size / 2 + ws.Vector2(1, -20), ws.Vector2(ew + 10, eh * 3 + 5), "ff5555", "Center"); gui.CreateText("Error!", size / 2 - ws.Vector2(0, 20 + eh), nil, "Center"); gui.CreateText(msg, size / 2 + ws.Vector2(1, -20), nil, "Center"); gui.CreateText("Line: " .. tostring(line), size / 2 + ws.Vector2(0, eh - 20), nil, "Center")
		local rw, rh = v.calcTextSize("Restart needed"); gui.CreateRect(ws.Vector2(size.x / 2, size.y - 20 + 5), ws.Vector2(rw + 10, rh + 10), "ff5555", "Bottom"); gui.CreateText("Restart needed", ws.Vector2(size.x / 2, size.y - 20), nil, "Bottom"); gui.update(); end
	for _, v in pairs(sc.getTerminals()) do v.send(string.format("\n-- Error --\n%s\nLine: %d\n\nRestart needed\n", msg, line)) end end
function ws.Destroy() for _, v in pairs(table.mergeLists(ws.events, ws.tasks, ws.guis)) do v.Destroy() end end
function math.lerp(a, b, t) return sm.util.lerp(a, b, t) end
function math.sign(x) return x < 0 and -1 or x > 0 and 1 or 0 end --[[@return -1|0|1]]
function table.find(table, value) for k, v in pairs(table) do if v == value then return k end end end --[[@return any]]
function table.clone(table) return sc.table.clone(table) end --[[@param table table]]
function table.mergeLists(...) local t = {}; for _, tb in pairs({ ... }) do for _, v in pairs(tb) do table.insert(t, v) end end; return t end --[[@param ... table<integer, any>]]
function table.merge(...) local t = {}; for _, tb in pairs({ ... }) do for k, v in pairs(tb) do t[k] = v end end; return t end --[[@param ... table]]
function string.split(s, sep) if sep == nil then sep = "%s" end; local t = {}; for str in s:gmatch("([^" .. sep .. "]+)") do table.insert(t, str) end; return t end --[[@return string[] ]]
function string.capitalize(s) return (s:gsub("^%l", string.upper)) end
function string.strip(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
--stylua ignore end
--#endregion
