---@class ws
local ws = {}

---On load
function onLoad() ws.Init() end

---On update
---@param deltaTime number
function onUpdate(deltaTime) ws.Update(deltaTime) end

---On error
---@param err string
function onError(err) ws.Error(err) end

---On reload
function onReload() onDestroy() end

---On shutdown
function onDestroy() ws.Destroy() end

--#region WS
---@diagnostic disable: duplicate-set-field, redundant-parameter
--stylua: ignore start

function ws.Init() ws.Version = "0.3"; ws.tasks = {}; ws.guis = {} end
function ws.Update(deltaTime) for _, task in pairs(ws.tasks) do task.alive = task.alive + deltaTime * 40; if task.active then if task.alive >= task.repeatDelay then task.callback(deltaTime); task.alive = 0 end elseif task.alive >= task.delay then task.callback(deltaTime); if task.repeatDelay == nil then task.destroy() else task.alive = 0; task.active = true end end end end
function ws.Error(err) local args = string.split(err, ":"); local msg, line = string.capitalize(string.strip(args[#args])), args[#args - 3]
	for _, v in pairs(sc.getDisplays()) do local gui = ws.CreateGUI(v); local msgLabel = gui.CreateText(msg, gui.GetSize() / 2 - ws.Vector2.yAxis * 15, "ffffff", "Center")
		gui.CreateText("Error!", msgLabel.GetPosition() - msgLabel.GetSize() * ws.Vector2.yAxis, "ffffff", "Center"); gui.CreateText("Line: " .. tostring(line), msgLabel.GetPosition() + msgLabel.GetSize() * ws.Vector2.yAxis, "ffffff", "Center")
		gui.CreateRect(msgLabel.GetPosition(), msgLabel.GetSize() * ws.Vector2(1, 3) + ws.Vector2(10, 5), "ff5555", "Center").SetZIndex(0)
		local restartLabel = gui.CreateText("Restart needed", gui.GetSize() * ws.Vector2(0.5, 0.9), "ffffff", "Bottom"); gui.CreateRect(restartLabel.GetPosition() + ws.Vector2.yAxis * 5, restartLabel.GetSize() + ws.Vector2.one * 10, "ff5555", "Bottom").SetZIndex(0); gui.Update() end
	for _, v in pairs(sc.getTerminals()) do v.send(string.format("\n-- Error --\n%s\nLine: %d\n\nRestart needed\n", msg, line)) end end
function ws.Destroy() for _, v in pairs(table.mergeLists(ws.tasks, ws.guis)) do v.destroy() end end
function ws.RunDelayed(callback, delay) --[[@return Task]]
	local _task = { callback = callback, delay = delay, alive = 0 }; table.insert(ws.tasks, _task)
	local Task = { GetRepeatDelay = nil, SetRepeatDelay = nil, Destroy = function() table.removeValue(ws.tasks, _task) end } --[[@as Task]]; _task.destroy = Task.Destroy; return Task end
function ws.RunRepeated(callback, repeatDelay --[[@param repeatDelay integer?]], delay --[[@param delay integer?]]) --[[@return Task]]
	local _task = { callback = callback, repeatDelay = repeatDelay or 1, delay = delay or 0, alive = 0 }; table.insert(ws.tasks, _task)
	local Task = { GetRepeatDelay = function() return _task.repeatDelay end, SetRepeatDelay = function(delay) _task.repeatDelay = delay end, Destroy = function() table.removeValue(ws.tasks, _task) end } --[[@as Task]]; _task.destroy = Task.Destroy; return Task end
function ws.CreateEvent(callback, fun, oneShot --[[@param oneShot boolean?]], updateDelay --[[@param updateDelay integer?]]) --[[@return Event]]
	local task; local connections, active = {}, false
	local Event = { Fire = function() for _, v in connections do v() end end, Connect = function(callback) table.insert(connections, callback) end, Destroy = function() connections = nil; task.Destroy() end } --[[@as Event]]
	task = ws.RunRepeated(function() if fun() then if not active then Event.Fire(); if oneShot then Event.Destroy() else active = true end end else active = false end end, updateDelay or 1); return Event end
function ws.CreateChangeEvent(callback, fun, oneShot --[[@param oneShot boolean?]], updateDelay --[[@param updateDelay integer?]]) --[[@return Event]]
	local task; local connections, lastState = {}, fun()
	local Event = { Fire = function(state) for _, v in connections do v(state) end end, Connect = function(callback) table.insert(connections, callback) end, Destroy = function() connections = nil; task.Destroy() end } --[[@as Event]]
	task = ws.RunRepeated(function() local state = fun(); if state ~= lastState then Event.Fire(state) if oneShot then Event.Destroy() else lastState = state end end end, updateDelay or 1); return Event end
function ws.CreateTween(callback, from, to, duration, easingType --[[@param easingType EasingType?]], easingDirection --[[@param easingDirection EasingDirection?]]) --[[@return Tween]]
	local task; local currentTime, active = 0, false
	local Tween = { Start = function() active = true end, Stop = function() active = false end, Destroy = function() task.Destroy() end } --[[@as Tween]]
	task = ws.RunRepeated(function(deltaTime) if active then currentTime = currentTime + deltaTime * 40; callback(math.lerp(from, to, sm.util.easing(easingType == "Linear" and "linear" or ("ease" .. easingDirection .. easingType), math.min(currentTime / duration, 1)))); if currentTime >= duration then Tween.Destroy() end end end); return Tween end
function ws.CreateGUI(display --[[@param display Display?]], background --[[@param background MultiColorType]]) --[[@return Gui]] display, background = display or sc.getDisplays()[1], background or "000000"; local task, _gui; local visibility, components = true, {}
	local anchors = { TopLeft = ws.Vector2(0, 0), Top = ws.Vector2(0.5, 0), TopRight = ws.Vector2(1, 0), Left = ws.Vector2(0, 0.5), Center = ws.Vector2(0.5, 0.5), Right = ws.Vector2(1, 0.5), BottomLeft = ws.Vector2(0, 1), Bottom = ws.Vector2(0.5, 1), BottomRight = ws.Vector2(1, 1) }
	local function getAnchoredPosition(component --[[@param component AnchoredGuiComponent]]) return component.GetPosition() - component.GetSize() * anchors[component.GetAnchor()] end
	local function getBaseGuiComponent(component) return table.merge({ visible = true, zIndex = 1 }, component) end
	local function getBaseAnchoredComponent(component) return table.merge({ anchor = "TopLeft" }, component) end
	local function getBaseColoredComponent(component) return table.merge({ color = "ffffff" }, component) end
	local function getBaseBorderedComponent(component) return table.merge({ borderColor = "555555", borderThickness = 0 }, component) end
	local function createGuiComponent(component, replace) return table.merge({ GetSize = function() return component.size end, GetPosition = function() return component.position end, SetPosition = function(position) component.position = position end, IsVisible = function() return component.visible end, SetVisibility = function(visible) component.visible = visible end, GetZIndex = function() return component.zIndex end, SetZIndex = function(zIndex) component.zIndex = zIndex; table.sort(components, function(a, b) return a.zIndex < b.zIndex end) end, Destroy = function() table.removeValue(components, component) end }, replace or {}) end
	local function createAnchoredComponent(component, replace) return table.merge({ GetAnchor = function() return component.anchor end }, replace or {}) end
	local function applyAnchor(t, component --[[@param component AnchoredGuiComponent]]) component.SetAnchor = function(anchor) t.anchor = anchor; t.absolutePosition = getAnchoredPosition(component) + ws.Vector2(1, 1) end; component.SetAnchor(t.anchor) end
	local function createColoredComponent(component, replace) return table.merge({ GetColor = function() return component.color end, SetColor = function(color) component.color = color end }, replace or {}) end
	local function createBorderedComponent(component, replace) return table.merge({ GetBorderColor = function() return component.borderColor end, SetBorderColor = function(color) component.borderColor = color end, GetBorderThickness = function() return component.borderThickness end, SetBorderThickness = function(thickness) component.borderThickness = thickness end }, replace or {}) end
	local Gui = { GetSize = function() return ws.Vector2(display.getDimensions()) end, GetDisplay = function() return display end, IsVisible = function() return visibility end, SetVisibility = function(visible) visibility = visible end, GetUpdateDelay = function() return task.GetRepeatDelay() end, SetUpdateDelay = function(delay) task.SetRepeatDelay(delay) end,
		GetBackground = function() return background end, SetBackground = function(background) background = background end, Update = function() display.clear(background); for _, v in pairs(components) do v.update() end; display.update() end, Destroy = function() task.Destroy(); display.clear(); display.update(); table.removeValue(ws.guis, _gui) end,
		CreateText = function(text, position, color, anchor)
			local component = getBaseGuiComponent(getBaseAnchoredComponent(getBaseColoredComponent({ text = text, position = position, color = color, anchor = anchor })))
			local GuiText = createGuiComponent(component, createAnchoredComponent(component, createColoredComponent(component, { GetSize = function() return ws.Vector2(display.calcTextSize(component.text)) + ws.Vector2.xAxis end, GetText = function() return component.text end, SetText = function(text) component.text = text end })))
			component.update = function() display.drawText(component.absolutePosition.x, component.absolutePosition.y, component.text, component.color) end; applyAnchor(component, GuiText); table.insert(components, component); return GuiText end,
		CreateOutline = function(position, size, color, anchor)
			local component = getBaseGuiComponent(getBaseAnchoredComponent(getBaseColoredComponent({ position = position, size = size, color = color, anchor = anchor })))
			local GuiOutline = createGuiComponent(component, createAnchoredComponent(component, createColoredComponent(component)))
			component.update = function() display.drawRect(component.absolutePosition.x, component.absolutePosition.y, component.size.x, component.size.y, component.color) end; applyAnchor(component, GuiOutline); table.insert(components, component); return GuiOutline end,
		CreateCircleOutline = function(position, radius, color, anchor)
			local component = getBaseGuiComponent(getBaseAnchoredComponent(getBaseColoredComponent({ position = position, radius = radius, color = color, anchor = anchor })))
			local GuiCircleOutline = createGuiComponent(component, createAnchoredComponent(component, createColoredComponent(component, { GetSize = function() return ws.Vector2(component.radius * 2, component.radius * 2) end, GetRadius = function() return component.radius end, SetRadius = function(radius) component.radius = radius end })))
			component.update = function() display.drawCircle(component.absolutePosition.x, component.absolutePosition.y, component.radius, component.color) end; applyAnchor(component, GuiCircleOutline); table.insert(components, component); return GuiCircleOutline end,
		CreateLine = function(position, position2, color)
			local component = getBaseGuiComponent(getBaseColoredComponent({ position = position, position2 = position2, color = color }))
			local GuiLine = createGuiComponent(component, createColoredComponent(component, { GetPosition2 = function() return component.position2 end, SetPosition2 = function(position) component.position2 = position end }))
			component.update = function() display.drawLine(component.position.x, component.position.y, component.position2.x, component.position2.y, component.color) end; table.insert(components, component); return GuiLine end,
		CreateRect = function(position, size, color, anchor)
			local component = getBaseGuiComponent(getBaseAnchoredComponent(getBaseColoredComponent(getBaseBorderedComponent({ position = position, size = size, color = color, anchor = anchor }))))
			local GuiRect = createGuiComponent(component, createAnchoredComponent(component, createColoredComponent(component, createBorderedComponent(component, { SetSize = function(size) component.size = size end }))))
			component.update = function() if component.borderThickness > 0 then display.drawFilledRect(component.absolutePosition.x - component.borderThickness, component.absolutePosition.y - component.borderThickness, component.size.x + component.borderThickness, component.size.y + component.borderThickness, component.borderColor) end; display.drawFilledRect(component.absolutePosition.x, component.absolutePosition.y, component.size.x, component.size.y, component.color) end; applyAnchor(component, GuiRect); table.insert(components, component); return GuiRect end,
		CreateCircle = function(position, radius, color, anchor)
			local component = getBaseGuiComponent(getBaseAnchoredComponent(getBaseColoredComponent(getBaseBorderedComponent({ position = position, radius = radius, color = color, anchor = anchor }))))
			local GuiCircle = createGuiComponent(component, createAnchoredComponent(component, createColoredComponent(component, createBorderedComponent(component, { GetSize = function() return ws.Vector2(component.radius * 2, component.radius * 2) end, GetRadius = function() return component.radius end, SetRadius = function(radius) component.radius = radius end }))))
			component.update = function() if component.borderThickness > 0 then display.drawFilledCircle(component.absolutePosition.x, component.absolutePosition.y, component.radius + component.borderThickness, component.borderColor) end; display.drawFilledCircle(component.absolutePosition.x, component.absolutePosition.y, component.radius, component.color) end; applyAnchor(component, GuiCircle); table.insert(components, component); return GuiCircle end,
		CreateImage = function(imageData, position, anchor)
			local component = getBaseGuiComponent(getBaseAnchoredComponent({ imageData = imageData, position = position, anchor = anchor }))
			local GuiImage = createGuiComponent(component, createAnchoredComponent(component, { GetSize = function() return ws.Vector2(0, 0) end, GetImageData = function() return component.imageData end, SetImageData = function() component.imageData = imageData end, SetPosition = function(position) component.position = position end }))
			component.update = function() end
			applyAnchor(component, GuiImage); table.insert(components, component); return GuiImage end, } --[[@as Gui]]
	task = ws.RunRepeated(function() if Gui.IsVisible() then Gui.Update() end end); _gui = { destroy = Gui.Destroy }; table.insert(ws.guis, _gui); return Gui end
function math.lerp(a, b, t) return sm.util.lerp(a, b, t) end
function math.sign(x) return x < 0 and -1 or x > 0 and 1 or 0 end --[[@return -1|0|1]]
function table.clone(table --[[@param table table]]) return sc.table.clone(table) end
function table.find(table, value) for k, v in pairs(table) do if v == value then return k end end end --[[@return any]]
function table.removeValue(list --[[@param list table]], value) table.remove(list, table.find(list, value)) end
function table.mergeLists(... --[[@param ... table<integer, any>]]) local t = {}; for _, tb in pairs({ ... }) do for _, v in pairs(tb) do table.insert(t, v) end end; return t end --[[@return table list]]
function table.merge(... --[[@param ... table]]) local t = {}; for _, tb in pairs({ ... }) do for k, v in pairs(tb) do t[k] = v end end; return t end
function string.split(s, sep --[[@param sep string?]]) if sep == nil then sep = "%s" end; local t = {}; for str in s:gmatch("([^" .. sep .. "]+)") do table.insert(t, str) end; return t end --[[@return string[] ]]
function string.capitalize(s) return (s:gsub("^%l", string.upper)) end
function string.strip(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
do local meta = { __unm = function(a) return ws.Vector2(-a.x, -a.y) end, __add = function(a, b) return ws.Vector2(a.x + b.x, a.y + b.y) end, __sub = function(a, b) return ws.Vector2(a.x - b.x, a.y - b.y) end, __mul = function(a, b) if type(b) == "number" then b = ws.Vector2(b, b) end; return ws.Vector2(a.x * b.x, a.y * b.y) end, __div = function(a, b) if type(b) == "number" then b = ws.Vector2(b, b) end; return ws.Vector2(a.x / b.x, a.y / b.y) end, __eq = function(a, b) return a.x == b.x and a.y == b.y end }
	ws.Vector2 = setmetatable({}, { __call = function(_, x, y) local t = table.clone(ws.Vector2 --[[@as table]]); t.x = x or 0; t.y = y or 0; return setmetatable(t, meta) end }) --[[@class Vector2Impl]]
	ws.Vector2.zero = ws.Vector2(0, 0)
	ws.Vector2.xAxis = ws.Vector2(1, 0)
	ws.Vector2.yAxis = ws.Vector2(0, 1)
	ws.Vector2.one = ws.Vector2(1, 1)
	function ws.Vector2.lerp(a, b, t) return ws.Vector2(math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t)) end
	function ws.Vector2.dot(a, b) return a * b end
	function ws.Vector2.length(vec) return math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2)) end
	function ws.Vector2.angle(a, b) return a * b / (a:length() * b:length()) end end
do local meta = { __unm = function(a) return ws.Vector3(-a.x, -a.y, -a.z) end, __add = function(a, b) return ws.Vector3(a.x + b.x, a.y + b.y, a.z + b.z) end, __sub = function(a, b) return ws.Vector3(a.x - b.x, a.y - b.y, a.z - b.z) end, __mul = function(a, b) if type(b) == "number" then b = ws.Vector3(b, b, b) end; return ws.Vector3(a.x * b.x, a.y * b.y, a.z * b.z) end, __div = function(a, b) if type(b) == "number" then b = ws.Vector3(b, b, b) end; return ws.Vector3(a.x / b.x, a.y / b.y, a.z / b.z) end, __eq = function(a, b) return a.x == b.x and a.y == b.y and a.z == b.z end }
	ws.Vector3 = setmetatable({}, { __call = function(_, x, y, z) local t = table.clone(ws.Vector3 --[[@as table]]); t.x = x or 0; t.y = y or 0; t.z = z or 0; return setmetatable(t, meta) end }) --[[@class Vector3Impl]]
	ws.Vector3.zero = ws.Vector3(0, 0, 0)
	ws.Vector3.xAxis = ws.Vector3(1, 0, 0)
	ws.Vector3.yAxis = ws.Vector3(0, 1, 0)
	ws.Vector3.zAxis = ws.Vector3(0, 0, 1)
	ws.Vector3.one = ws.Vector3(1, 1, 1)
	function ws.Vector3.lerp(a, b, t) return ws.Vector3(math.lerp(a.x, b.x, t), math.lerp(a.y, b.y, t), math.lerp(a.z, b.z, t)) end
	function ws.Vector3.dot(a, b) return a * b end
	function ws.Vector3.length(vec) return math.sqrt(math.pow(vec.x, 2) + math.pow(vec.y, 2) + math.pow(vec.z, 2)) end
	function ws.Vector3.angle(a, b) return a * b / (a:length() * b:length()) end
	function ws.Vector3.cross(a, b) return ws.Vector3(a.y * a.z - a.z * b.y, a.z * b.y - a.x * b.z, a.x * b.y - a.y * b.x) end end
--stylua: ignore end
--#endregion
