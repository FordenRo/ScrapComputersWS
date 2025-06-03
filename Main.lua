---WS Library
---@class ws
local ws = { Version = "0.1", events = {}, tasks = {}, guis = {} }

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
	function event.Destroy() table.remove(ws.events, table.find(ws.events, event)) end
	table.insert(ws.events, event); return event; end
function ws.RunDelayed(callback, delay) --[[@return Task]]
	local task = { Callback = callback, delay = delay, alive = 0 }
	function task.Destroy() table.remove(ws.tasks, table.find(ws.tasks, task)) end
	table.insert(ws.tasks, task); return task; end
function ws.RunRepeated(callback, repeatDelay, delay) --[[@return Task]]
	local task = { Callback = callback, alive = 0, delay = delay or 0, repeatDelay = repeatDelay or 1 }
	function task.Destroy() table.remove(ws.tasks, table.find(ws.tasks, task)) end
	table.insert(ws.tasks, task); return task; end
function ws.CreateGUI(display, background) --[[@return Gui]]
	local gui = { Display = display, components = {}, Visible = true, Background = background or "000000" }
	local function applyDestroyFunction(component) function component.Destroy() table.remove(gui.components, table.find(gui.components, component)) end end
	local function applyGetSizeFunction(component) function component.GetSize() return component.w, component.h end end
	local anchors = { TopLeft = { 0, 0 }, Top = { 0.5, 0 }, TopRight = { 1, 0 }, Left = { 0, 0.5 }, Center = { 0.5, 0.5 }, Right = { 1, 0.5 }, BottomLeft = { 0, 1 }, Bottom = { 0.5, 1 }, BottomRight = { 1, 1 } }
	local function applyAnchor(component) local mx, my = unpack(anchors[component.Anchor]); local w, h = component.GetSize(); return component.x - w * mx, component.y - h * my end
	function gui.CreateText(text, x, y, color, anchor)
		local component = { Text = text, x = x, y = y, Visible = true, Color = color or "ffffff", Anchor = anchor or "TopLeft" }
		applyDestroyFunction(component)
		function component.GetSize() return gui.Display.calcTextSize(component.Text) end
		function component.update() local ax, ay = applyAnchor(component); gui.Display.drawText(ax, ay, component.Text, component.Color) end
		table.insert(gui.components, component); return component; end
	function gui.CreateRect(x, y, w, h, color, anchor, border)
		local component = { x = x, y = y, w = w, h = h, Visible = true, Color = color or "ffffff", Anchor = anchor or "TopLeft", Border = border and { Thickness = border.Thickness, Color = border.Color or "000000" } }
		applyDestroyFunction(component); applyGetSizeFunction(component)
		function component.update()
			local border = component.Border; local ax, ay = applyAnchor(component)
			if border then gui.Display.drawFilledRect(ax - border.Thickness, ay - border.Thickness, component.w + border.Thickness * 2, component.h + border.Thickness * 2, border.Color) end
			gui.Display.drawFilledRect(ax, ay, component.w, component.h, component.Color); end
		table.insert(gui.components, component); return component; end
	function gui.CreateOutline(x, y, w, h, color, anchor)
		local component = { x = x, y = y, w = w, h = h, Visible = true, Color = color or "ffffff", Anchor = anchor or "TopLeft" }
		applyDestroyFunction(component); applyGetSizeFunction(component)
		function component.update() local ax, ay = applyAnchor(component); gui.Display.drawRect(ax, ay, component.w, component.h, component.Color) end
		table.insert(gui.components, component); return component; end
	function gui.CreateLine(x, y, x1, y1, color)
		local component = { x = x, y = y, x1 = x1, y1 = y1, Visible = true, Color = color or "ffffff" }
		applyDestroyFunction(component)
		function component.update() gui.Display.drawLine(component.x, component.y, component.x1, component.y1, component.Color) end
		function component.GetSize() return math.max(component.x, component.x1) - math.min(component.x, component.x1), math.max(component.y, component.y1) - math.min(component.y, component.y1) end
		table.insert(gui.components, component); return component; end
	function gui.CreateImage(imageData, x, y, anchor)
		local component = { x = x, y = y, ImageData = imageData, Visible = true, Anchor = anchor or "TopLeft" }
		applyDestroyFunction(component); local pixels = {}
		local function rePosition()
			local x, y = applyAnchor(component); for _, v in pairs(component.ImageData.Pixels) do table.insert(pixels, { x = (v.x + x) or 0, y = (v.y + y) or 0, color = v.color }) end
		end; rePosition()
		function component.GetSize() return unpack(component.ImageData.Size) end
		function component.update() gui.Display.drawFromTable(pixels) end
		table.insert(gui.components, component); return component; end
	function gui.CreateCircle(x, y, radius, color, anchor, border)
		local component = { x = x, y = y, Radius = radius, Visible = true, Color = color or "ffffff", Anchor = anchor or "TopLeft", Border = border and { Thickness = border.Thickness, Color = border.Color or "000000" } }
		applyDestroyFunction(component)
		function component.GetSize() return component.Radius * 2, component.Radius * 2 end
		function component.update() local border = component.Border; local ax, ay = applyAnchor(component)
			if border then gui.Display.drawFilledCircle(ax + component.Radius, ay + component.Radius, component.Radius + border.Thickness, border.Color) end
			gui.Display.drawFilledCircle(ax + component.Radius, ay + component.Radius, component.Radius, component.Color); end
		table.insert(gui.components, component); return component; end
	function gui.CreateCircleOutline(x, y, radius, color, anchor)
		local component = { x = x, y = y, Radius = radius, Visible = true, Color = color or "ffffff", Anchor = anchor or "TopLeft" }
		applyDestroyFunction(component)
		function component.GetSize() return component.Radius * 2, component.Radius * 2 end
		function component.update() local ax, ay = applyAnchor(component); gui.Display.drawCircle(ax + component.Radius, ay + component.Radius, component.Radius, component.Color) end
		table.insert(gui.components, component); return component; end
	function gui.GetSize() return gui.Display.getDimensions() end
	function gui.update() gui.Display.clear(gui.Background); for _, v in pairs(gui.components) do if v.Visible then v.update() end end; gui.Display.update() end
	function gui.Destroy() gui.Display.clear(); gui.Display.update(); table.remove(ws.guis, table.find(ws.guis, gui)) end
	table.insert(ws.guis, gui); return gui; end
function ws.update(deltaTime)
	for _, task in pairs(ws.tasks) do task.alive = task.alive + deltaTime * 40
		if task.active then if task.alive >= task.repeatDelay then task.Callback(deltaTime); task.alive = 0 end
		elseif task.alive >= task.delay then task.Callback(deltaTime); if task.repeatDelay == nil then task.Destroy() else task.alive = 0; task.active = true end; end; end
	for _, event in pairs(ws.events) do
		if event.alive ~= nil then event.alive = event.alive + deltaTime * 40 end
		if event.alive == nil or event.alive >= event.updateDelay then
			local args = { event.fun() }
			if args[1] then if not event.active then event.Fire(select(2, unpack(args))); if event.oneShot then event.Destroy(); else event.active = true end end
			else event.active = false end; event.alive = 0; end; end
	for _, gui in pairs(ws.guis) do if gui.Visible then gui.update() end end; end
function ws.error(err)
	local args = string.split(err, ":"); local msg, line = string.capitalize(string.strip(args[#args])), args[#args - 3]
	for _, v in pairs(sc.getDisplays()) do local gui = ws.CreateGUI(v)
		local w, h = gui.GetSize(); local ew, eh = v.calcTextSize(msg); gui.CreateRect(w / 2 + 1, h / 2 - 20, ew + 10, eh * 3 + 10, "ff5555", "Center"); gui.CreateText("Error!", w / 2, h / 2 - 20 - eh, nil, "Center"); gui.CreateText(msg, w / 2 + 1, h / 2 - 20, nil, "Center"); gui.CreateText("Line: " .. tostring(line), w / 2, h / 2 - 20 + eh, nil, "Center")
		local rw, rh = v.calcTextSize("Restart needed"); gui.CreateRect(w / 2, h - 20 + 5, rw + 10, rh + 10, "ff5555", "Bottom"); gui.CreateText("Restart needed", w / 2, h - 20, nil, "Bottom"); gui.update(); end
	for _, v in pairs(sc.getTerminals()) do v.send(string.format("Error!\n%s\nLine: %d\n\nRestart needed", msg, line)) end
end
function ws.Destroy() for _, v in pairs(table.mergeLists(ws.events, ws.tasks, ws.guis)) do v.Destroy() end end
function math.sign(x) return x < 0 and -1 or x > 0 and 1 or 0 end --[[@return -1|0|1]]
function table.find(table, value) for k, v in pairs(table) do if v == value then return k end end end --[[@return any]]
function table.mergeLists(...) local t = {}; for _, tb in pairs({ ... }) do for _, v in pairs(tb) do table.insert(t, v) end end; return t end --[[@param ... table<integer, any>]]
function table.merge(...) local t = {}; for k, v in pairs({ ... }) do t[k] = v end; return t end --[[@param ... table]]
function string.split(s, sep) if sep == nil then sep = "%s" end; local t = {}; for str in s:gmatch("([^" .. sep .. "]+)") do table.insert(t, str) end; return t end --[[@return string[] ]]
function string.capitalize(s) return (s:gsub("^%l", string.upper)) end
function string.strip(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
--stylua ignore end
--#endregion
