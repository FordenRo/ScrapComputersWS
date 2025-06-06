---@diagnostic disable: missing-return, duplicate-set-field

---Class for events
---@class Event
---@field oneShot boolean?
---@field active boolean?
---@field updateDelay integer
---@field alive integer?
local Event = {}

---@param ... any
function Event.Fire(...) end

---@return boolean, ...
function Event.fun() end

---Destroys the event
function Event.Destroy() end

---Class for tasks
---@class Task
---@field repeatDelay number?
---@field delay number
---@field alive integer
---@field active boolean?
local Task = {}

---@param deltaTime number
function Task.Callback(deltaTime) end

---Destroys the task
function Task.Destroy() end

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

---Class for tweens
---@class Tween
---@field Object any
---@field currentTime number
---@field Property string
---@field active boolean?
---@field Value any
---@field Duration integer
---@field EasingType EasingType
---@field EasingDirection EasingDirection
local Tween = {}

---Destroys the tween
function Tween.Destroy() end

---Starts the tween
function Tween.Start() end

---Stops the tween
function Tween.Stop() end

---@param a any
---@param b any
---@param t number
---@return any
function Tween.fun(a, b, t) end

---@class ws
---@field Version string Version of WS module
---@field events Event[]
---@field tasks Task[]
---@field guis Gui[]
local ws = {}

---Calls callback when fun returns true
---
---If fun returns multiple values, these values will be transfered to callback arguments
---@param callback fun(...: any?)
---@param fun fun(): (boolean, ...: any?)
---@param oneShot boolean Fire event once, then destroy. Defaults to false
---@param updateDelay integer Fun calls delay (ticks)
---@overload fun(callback: fun(...: any?), fun: fun(): (boolean, ...: any?)): Event
---@overload fun(callback: fun(...: any?), fun: fun(): (boolean, ...: any?), oneShot: boolean): Event
---@return Event
function ws.CreateEvent(callback, fun, oneShot, updateDelay) end

---Calls callback after given delay
---@param callback fun(deltaTime: number)
---@param delay integer Delay (ticks)
---@return Task
function ws.RunDelayed(callback, delay) end

---Calls callback every time after repeatDelay
---@param callback fun(deltaTime: number)
---@param repeatDelay integer Repeat delay (ticks). Defaults to 1
---@param delay integer Task start delay (ticks)
---@overload fun(callback: fun(deltaTime: number)): Task
---@overload fun(callback: fun(deltaTime: number), repeatDelay: integer): Task
---@return Task
function ws.RunRepeated(callback, repeatDelay, delay) end

---Tweens object's property to given value
---@param object any Object to tween
---@param property string Property to tween
---@param value any Target tweening value
---@param fun fun(a: any, b: any, t: number): any Lerping function. Will be applied to value
---@param duration integer Tweening time (ticks)
---@param easingType EasingType Easing type. Defaults to Linear
---@param easingDirection EasingDirection Easing direction. Defaults to In
---@overload fun(object: any, property: string, value: any, duration: integer, fun: fun(a: any, b: any, t: number): any): Tween
---@return Tween
function ws.CreateTween(object, property, value, duration, fun, easingType, easingDirection) end

---Creates GUI
---@param display Display
---@param background MultiColorTypeNonNil
---@overload fun(display: Display): Gui
---@return Gui
function ws.CreateGUI(display, background) end

---Updates WS module
---@param deltaTime number
function ws.update(deltaTime) end

---Error handler
---@param err string
function ws.error(err) end

---Destroys WS module
function ws.Destroy() end

---2D Vector implementation
---@class Vector2Impl
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

---3D Vector implementation
---@class Vector3Impl
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

---@alias Anchor
---| "TopLeft"
---| "Top"
---| "TopRight"
---| "Left"
---| "Center"
---| "Right"
---| "BottomLeft"
---| "Bottom"
---| "BottomRight"

---Base class for all GUI components
---@class BaseGuiComponent
---@field Position Vector2
---@field Visible boolean
---@field ZIndex integer
local BaseGuiComponent = {}

---Destroys GUI Component
function BaseGuiComponent.Destroy() end

---Sets the ZIndex of GuiComponent
---@param index integer
function BaseGuiComponent.SetZIndex(index) end

---Updates and draws GUI Component
function BaseGuiComponent.update() end

---Class for GUI components
---@class GuiComponent: BaseGuiComponent
---@field Color MultiColorTypeNonNil
---@field Anchor Anchor
local GuiComponent = {}

---Returns actual size of GUI Component
---@return Vector2
function GuiComponent.GetSize() end

---@class GuiText: GuiComponent
---@field Text string

---@class GuiOutline: GuiComponent
---@field Size Vector2

---@class GuiCircleOutline: GuiComponent
---@field Radius integer

---@class GuiRect: GuiOutline
---@field Border GuiBorder

---@class GuiLine: BaseGuiComponent
---@field Position2 Vector2
---@field Color MultiColorTypeNonNil

---@class GuiBorder
---@field Thickness integer
---@field Color MultiColorType

---@class GuiImage: BaseGuiComponent
---@field ImageData ImageData
---@field Anchor Anchor

---@class GuiCircle: GuiComponent
---@field Radius integer
---@field Border GuiBorder

---@class ImageData
---@field Size integer[]
---@field Pixels PixelTable

---GUI class
---@class Gui
---@field Visible boolean
---@field Display Display
---@field components GuiComponent[]
---@field Background MultiColorTypeNonNil
local Gui = {}

---Creates text
---@param text string
---@param position Vector2
---@param anchor Anchor?
---@param color MultiColorType
---@overload fun(text: string, position): GuiText
---@overload fun(text: string, position, color: MultiColorTypeNonNil): GuiText
---@return GuiText
function Gui.CreateText(text, position, color, anchor) end

---Creates rectangle
---@param position Vector2
---@param size Vector2
---@param anchor Anchor?
---@param color MultiColorType
---@param border GuiBorder
---@overload fun(position: Vector2, size: Vector2): GuiRect
---@overload fun(position: Vector2, size: Vector2, color: MultiColorTypeNonNil): GuiRect
---@overload fun(position: Vector2, size: Vector2, color: MultiColorType, anchor: Anchor): GuiRect
---@return GuiRect
function Gui.CreateRect(position, size, color, anchor, border) end

---Creates rectangular outline
---@param position Vector2
---@param size Vector2
---@param anchor Anchor
---@param color MultiColorType
---@overload fun(position: Vector2, size: Vector2): GuiOutline
---@overload fun(position: Vector2, size: Vector2, color: MultiColorTypeNonNil): GuiOutline
---@return GuiOutline
function Gui.CreateOutline(position, size, color, anchor) end

---Creates line
---@param position Vector2
---@param position2 Vector2
---@param color MultiColorTypeNonNil
---@overload fun(position, position2): GuiLine
---@return GuiLine
function Gui.CreateLine(position, position2, color) end

---Creates image
---@param imageData ImageData
---@param position Vector2
---@param anchor Anchor
---@overload fun(imageData: ImageData, position): GuiImage
---@return GuiImage
function Gui.CreateImage(imageData, position, anchor) end

---Creates circle
---@param position Vector2
---@param radius integer
---@param color MultiColorType
---@param anchor Anchor?
---@param border GuiBorder
---@overload fun(position, radius: integer): GuiCircle
---@overload fun(position, radius: integer, color: MultiColorTypeNonNil): GuiCircle
---@overload fun(position, radius: integer, color: MultiColorType, anchor: Anchor): GuiCircle
---@return GuiCircle
function Gui.CreateCircle(position, radius, color, anchor, border) end

---Creates circle outline
---@param position Vector2
---@param radius integer
---@param color MultiColorType
---@param anchor Anchor
---@overload fun(position, radius: integer)
---@overload fun(position, radius: integer, color: MultiColorTypeNonNil): GuiCircleOutline
---@return GuiCircleOutline
function Gui.CreateCircleOutline(position, radius, color, anchor) end

---Returns GUI size
---@return Vector2
function Gui.GetSize() end

---Updates GUI
function Gui.update() end

---Destroys GUI
function Gui.Destroy() end

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

---Clones a table
---@param table table
---@return table
function table.clone(table) end

---Returns the index of the value in the table, otherwise return nil
---@param table table
---@param value any
---@return any
function table.find(table, value) end

---Merges lists to one list
---@param ... table<integer, any>
---@return table
function table.mergeLists(...) end

---Merges tables to one table. The last one will overwrite the elements of the first ones
---@param ... table
---@return table
function table.merge(...) end

---Separates a string using a separator
---@param s string
---@param sep string Separator, defaults to %s
---@overload fun(s: string): string[]
---@return string[]
function string.split(s, sep) end

---Uppers first character of the string
---@param s string
---@return string
function string.capitalize(s) end

---Removes escape characters on the sides of a string
---@param s string
---@return string
function string.strip(s) end
