---@diagnostic disable: missing-return, duplicate-set-field

--#region WS

---WS module
---@class ws
local ws = {}

---Init WS module
function ws.Init() end

---Update WS module
---@param deltaTime number
function ws.Update(deltaTime) end

---Handle error
---@param err string
function ws.Error(err) end

---Destroys WS module
function ws.Destroy() end
--#endregion


--#region Task

---Task class
---@class Task
local Task = {}

---Returns task repeat delay (ticks)
---@return integer
function Task.GetRepeatDelay() end

---Sets task repeat delay (ticks)
---@param delay integer
function Task.SetRepeatDelay(delay) end

---Destroys the task
function Task.Destroy() end

---Calls callback after given delay
---@param callback fun(deltaTime: number)
---@param delay integer Delay (ticks)
---@return Task
function ws.RunDelayed(callback, delay) end

---Calls callback every time after repeatDelay
---@param callback fun(deltaTime: number)
---@param repeatDelay integer? Repeat delay (ticks). Defaults to 1
---@param delay integer? Task start delay (ticks)
---@return Task
function ws.RunRepeated(callback, repeatDelay, delay) end
--#endregion

--#region Connection

---Connection class
---@class Connection
local Connection = {}

---Destroys the connection
function Connection.Destroy() end
--#endregion

--#region Event

---Event class
---@class Event
local Event = {}

---Fires the event
function Event.Fire(...) end

---Connect the event
---@param callback fun(...)
---@return Connection
function Event.Connect(callback) end

---Destroys the event
function Event.Destroy() end

---Fires when the return of function `fun` is true
---@param callback fun()
---@param fun fun(): boolean
---@param oneShot boolean? Fire event once
---@param updateDelay integer? Return checking delay (ticks). Defaults to 1
---@return Event
function ws.CreateEvent(callback, fun, oneShot, updateDelay) end

---Fires when the return of function `fun` is changed
---@param callback fun(state: any)
---@param fun fun(): state: any
---@param oneShot boolean? Fire event once
---@param updateDelay integer? Change checking delay (ticks). Defaults to 1
---@return Event
function ws.CreateChangeEvent(callback, fun, oneShot, updateDelay) end
--#endregion

--#region Tween

---Class for tweens
---@class Tween
local Tween = {}

---@alias EasingType
---| "Linear"
---| "Sine"
---| "Cubic"
---| "Quad"
---| "Quart"
---| "Quint"
---| "Back"
---| "Bounce"

---@alias EasingDirection
---| "In"
---| "Out"
---| "InOut"

---Starts the tween
function Tween.Start() end

---Stops the tween
function Tween.Stop() end

---Destroys the tween
function Tween.Destroy() end

---Interpolates value from `from` to `to`
---@param callback fun(value: number) Tween callback
---@param from number Tween from
---@param to number Tween to
---@param duration integer Tweening duration (ticks)
---@param easingType EasingType? Easing type. Defaults to Linear
---@param easingDirection EasingDirection? Easing direction. Defaults to In
---@return Tween
function ws.CreateTween(callback, from, to, duration, easingType, easingDirection) end
--#endregion


--#region GUI

--#region GUI class

---Gui class
---@class Gui
local Gui = {}

---Returns GUI size
---@return Vector2
function Gui.GetSize() end

---Returns the GUI display
---@return Display
function Gui.GetDisplay() end

---Returns visibility of GUI
---@return boolean
function Gui.IsVisible() end

---Sets visibility of GUI
---@param visible boolean
function Gui.SetVisibility(visible) end

---Returns GUI update delay (ticks)
---@return integer
function Gui.GetUpdateDelay() end

---Sets GUI update delay (ticks)
---@param delay integer
function Gui.SetUpdateDelay(delay) end

---Returns background color of GUI
---@return MultiColorTypeNonNil
function Gui.GetBackground() end

---Sets background color of GUI
---@param background MultiColorTypeNonNil
function Gui.SetBackground(background) end

--Updates GUI
function Gui.Update() end

---Destroys GUI
function Gui.Destroy() end

---Creates GUI
---
---If `display` not present, GUI will be created on first connected display
---@param display Display?
---@param background MultiColorType
---@return Gui
function ws.CreateGUI(display, background) end
--#endregion

--#region GuiComponent

---Base class for all GUI components
---@class GuiComponent
local GuiComponent = {}

---Returns actual size of GUI component
---@return Vector2
function GuiComponent.GetSize() end

---Returns position of GUI component
---@return Vector2
function GuiComponent.GetPosition() end

---Sets position of GUI component
---@param position Vector2
function GuiComponent.SetPosition(position) end

---Returns visibility of GUI component
---@return boolean
function GuiComponent.IsVisible() end

---Sets visibility of GUI component
---@param visible boolean
function GuiComponent.SetVisibility(visible) end

---Returns ZIndex of GUI component
---@return integer
function GuiComponent.GetZIndex() end

---Sets ZIndex of GUI component
---@param zIndex integer
function GuiComponent.SetZIndex(zIndex) end

---Destroys GUI component
function GuiComponent.Destroy() end
--#endregion

--#region AnchoredGuiComponent

---Base class for anchored GUI components
---@class AnchoredGuiComponent: GuiComponent
local AnchoredGuiComponent = {}

---@alias GuiAnchor
---| "TopLeft"
---| "Top"
---| "TopRight"
---| "Left"
---| "Center"
---| "Right"
---| "BottomLeft"
---| "Bottom"
---| "BottomRight"

---Returns anchor of GUI component
---@return GuiAnchor
function AnchoredGuiComponent.GetAnchor() end

---Sets anchor of GUI component
---@param anchor GuiAnchor
function AnchoredGuiComponent.SetAnchor(anchor) end
--#endregion

--#region ColoredGuiComponent

---Base class for GUI components with color
---@class ColoredGuiComponent: GuiComponent
local ColoredGuiComponent = {}

---Returns color of GUI component
---@return MultiColorTypeNonNil
function ColoredGuiComponent.GetColor() end

---Sets color of GUI component
---@param color MultiColorTypeNonNil
function ColoredGuiComponent.SetColor(color) end
--#endregion

--#region BorderedGuiComponent

---Base class for GUI components with border
---@class BorderedGuiComponent: AnchoredGuiComponent, ColoredGuiComponent
local BorderedGuiComponent = {}

---Returns border color of GUI component
---@return MultiColorTypeNonNil
function BorderedGuiComponent.GetBorderColor() end

---Sets border color of GUI component
---@param color MultiColorTypeNonNil
function BorderedGuiComponent.SetBorderColor(color) end

---Returns border thickness of GUI component
---@return integer
function BorderedGuiComponent.GetBorderThickness() end

---Sets border thickness of GUI component
---@param thickness integer
function BorderedGuiComponent.SetBorderThickness(thickness) end
--#endregion

--#region GuiText

---GuiText class
---@class GuiText: AnchoredGuiComponent, ColoredGuiComponent
local GuiText = {}

---Returns text 
---@return string
function GuiText.GetText() end

---Sets text
---@param text string
function GuiText.SetText(text) end

---Creates text
---@param text string
---@param position Vector2
---@param color MultiColorType
---@param anchor GuiAnchor?
---@return GuiText
function Gui.CreateText(text, position, color, anchor) end
--#endregion

--#region GuiOutline

---GuiOutline class
---@class GuiOutline: AnchoredGuiComponent, ColoredGuiComponent
local GuiOutline = {}

---Sets size of GUI component
---@param size Vector2
function GuiOutline.SetSize(size) end

---Creates rectangular outline
---@param position Vector2
---@param size Vector2
---@param color MultiColorType
---@param anchor GuiAnchor?
---@return GuiOutline
function Gui.CreateOutline(position, size, color, anchor) end
--#endregion

--#region GuiCircleOutline

---GuiCircleOutline class
---@class GuiCircleOutline: AnchoredGuiComponent, ColoredGuiComponent
local GuiCircleOutline = {}

---Returns radius of outline
---@return integer
function GuiCircleOutline.GetRadius() end

---Sets radius of outline
---@param radius integer
function GuiCircleOutline.SetRadius(radius) end

---Creates circle outline
---@param position Vector2
---@param radius integer
---@param color MultiColorType
---@param anchor GuiAnchor?
---@return GuiCircleOutline
function Gui.CreateCircleOutline(position, radius, color, anchor) end
--#endregion

--#region GuiLine

---GuiLine class
---@class GuiLine: ColoredGuiComponent
local GuiLine = {}

---Returns second point of line
---@return Vector2
function GuiLine.GetPosition2() end

---Sets second point of line
---@param position Vector2
function GuiLine.SetPosition2(position) end

---Creates line
---@param position Vector2
---@param position2 Vector2
---@param color MultiColorType
---@return GuiLine
function Gui.CreateLine(position, position2, color) end
--#endregion

--#region GuiRect

---GuiRect class
---@class GuiRect: GuiOutline, BorderedGuiComponent
local GuiRect = {}

---Creates rectangle
---@param position Vector2
---@param size Vector2
---@param color MultiColorType
---@param anchor GuiAnchor?
---@return GuiRect
function Gui.CreateRect(position, size, color, anchor) end
--#endregion

--#region GuiCircle

---GuiCircle class
---@class GuiCircle: GuiCircleOutline, BorderedGuiComponent
local GuiCircle = {}

---Creates circle
---@param position Vector2
---@param radius integer
---@param color MultiColorType
---@param anchor GuiAnchor?
---@return GuiCircle
function Gui.CreateCircle(position, radius, color, anchor) end
--#endregion

--#region GuiImage

---GuiImage class
---@class GuiImage: AnchoredGuiComponent
local GuiImage = {}

---@class ImageData
---@field Size integer[]
---@field Pixels PixelTable

---Returns image data
---@return ImageData
function GuiImage.GetImageData() end

---Sets image data
---@param imageData ImageData
function GuiImage.SetImageData(imageData) end

---Creates image
---@param imageData ImageData
---@param position Vector2
---@param anchor GuiAnchor?
---@return GuiImage
function Gui.CreateImage(imageData, position, anchor) end
--#endregion

--#endregion


--#region Utils

--#region Math

---Linear interpolation between two values
---@param a number
---@param b number
---@param t number
---@return number
function math.lerp(a, b, t) end

---Returns sign of a number
---@param x number
---@return -1|0|1
function math.sign(x) end
--#endregion

--#region Table

---Clones a table
---@param table table
---@return table
function table.clone(table) end

---Returns the index of the `value` in the `table`, otherwise return nil
---@param table table
---@param value any
---@return any
function table.find(table, value) end

---Removes from `list` the element with `value`, returns true if success
---@param list table
---@param value any
function table.removeValue(list, value) end

---Merges lists to one list
---@param ... table<integer, any>
---@return table list
function table.mergeLists(...) end

---Merges tables to one table. The last one will overwrite the elements of the first ones
---@param ... table
---@return table
function table.merge(...) end
--#endregion

--#region String

---Separates a string `s` with separator `sep`
---@param s string
---@param sep string? Separator, defaults to `%s`
---@return string[]
function string.split(s, sep) end

---Uppers first character of the string `s`
---@param s string
---@return string
function string.capitalize(s) end

---Removes escape characters on the sides of a string `s`
---@param s string
---@return string
function string.strip(s) end
--#endregion

--#region Vector2

---2D Vector implementation
---@class Vector2Impl
---@field zero Vector2 Vector2(0, 0)
---@field xAxis Vector2 Vector2(1, 0)
---@field yAxis Vector2 Vector2(0, 1)
---@field one Vector2 Vector2(1, 1)
---@overload fun(x: number, y: number): Vector2
ws.Vector2 = {}

---@class Vector2: Vector2Impl
---@field x number
---@field y number
---@operator mul(number): Vector2
---@operator add(Vector2): Vector2
---@operator sub(Vector2): Vector2
---@operator mul(Vector2): Vector2
---@operator div(Vector2): Vector2
---@operator div(number): Vector2
---@operator unm: Vector2

---Linear interpolation between two vectors
---@param a Vector2
---@param b Vector2
---@param t number
---@return Vector2
function ws.Vector2.lerp(a, b, t) end

---Dot product of two vectors
---@param a Vector2
---@param b Vector2
---@return number
function ws.Vector2.dot(a, b) end

---Returns length of a vector
---@param vec Vector2
---@return number
function ws.Vector2.length(vec) end

---Returns angle between two vectors
---@param a Vector2
---@param b Vector2
---@return number
function ws.Vector2.angle(a, b) end
--#endregion

--#region Vector3

---3D Vector implementation
---@class Vector3Impl
---@field zero Vector3 Vector3(0, 0, 0)
---@field xAxis Vector3 Vector3(1, 0, 0)
---@field yAxis Vector3 Vector3(0, 1, 0)
---@field zAxis Vector3 Vector3(0, 0, 1)
---@field one Vector3 Vector3(1, 1, 1)
---@overload fun(x: number, y: number, z: number): Vector3
ws.Vector3 = {}

---@class Vector3: Vector3Impl
---@field x number
---@field y number
---@field z number
---@operator mul(number): Vector3
---@operator add(Vector3): Vector3
---@operator sub(Vector3): Vector3
---@operator mul(Vector3): Vector3
---@operator div(Vector3): Vector3
---@operator div(number): Vector3
---@operator unm: Vector3

---Linear interpolation between two vectors
---@param a Vector3
---@param b Vector3
---@param t number
---@return Vector3
function ws.Vector3.lerp(a, b, t) end

---Dot product of two vectors
---@param a Vector3
---@param b Vector3
---@return number
function ws.Vector3.dot(a, b) end

---Returns length of a vector
---@param vec Vector3
---@return number
function ws.Vector3.length(vec) end

---Returns angle between two vectors
---@param a Vector3
---@param b Vector3
---@return number
function ws.Vector3.angle(a, b) end

---Returns cross product of two vectors
---@param a Vector3
---@param b Vector3
---@return Vector3
function ws.Vector3.cross(a, b) end
--#endregion

--#endregion
