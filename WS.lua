---@diagnostic disable: missing-return, duplicate-set-field

---Class for events
---@class Event
---@field Fire fun(...: any?)
---@field fun fun(): (boolean, ...: any?)
---@field oneShot boolean?
---@field active boolean?
---@field updateDelay integer
---@field alive integer?
---@field Destroy function

---Class for tasks
---@class Task
---@field Callback fun(deltaTime: number)
---@field repeatDelay number?
---@field delay number
---@field alive integer
---@field active boolean?
---@field Destroy function

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
---@field x integer
---@field y integer
---@field Visible boolean
local BaseGuiComponent = {}

---Destroys GUI Component
function BaseGuiComponent.Destroy() end

---Updates and draws GUI Component
---@param deltaTime number
function BaseGuiComponent.update(deltaTime) end

---Class for GUI components
---@class GuiComponent: BaseGuiComponent
---@field Color MultiColorTypeNonNil
---@field Anchor Anchor
local GuiComponent = {}

---Returns actual size of GUI Component
function GuiComponent.GetSize() end

---@class GuiText: GuiComponent
---@field Text string

---@class GuiOutline: GuiComponent
---@field w integer
---@field h integer

---@class GuiCircleOutline: GuiComponent
---@field Radius integer

---@class GuiRect: GuiOutline
---@field Border GuiBorder

---@class GuiLine: BaseGuiComponent
---@field x1 integer
---@field y1 integer
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
---@param x integer
---@param y integer
---@param anchor Anchor?
---@param color MultiColorType
---@overload fun(text: string, x: integer, y: integer): GuiText
---@overload fun(text: string, x: integer, y: integer, color: MultiColorTypeNonNil): GuiText
---@return GuiText
function Gui.CreateText(text, x, y, color, anchor) end

---Creates rectangle
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param anchor Anchor?
---@param color MultiColorType
---@param border GuiBorder
---@overload fun(x: integer, y: integer, w: integer, h: integer): GuiRect
---@overload fun(x: integer, y: integer, w: integer, h: integer, color: MultiColorTypeNonNil): GuiRect
---@overload fun(x: integer, y: integer, w: integer, h: integer, color: MultiColorType, anchor: Anchor): GuiRect
---@return GuiRect
function Gui.CreateRect(x, y, w, h, color, anchor, border) end

---Creates rectangular outline
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param anchor Anchor
---@param color MultiColorType
---@overload fun(x: integer, y: integer, w: integer, h: integer): GuiOutline
---@overload fun(x: integer, y: integer, w: integer, h: integer, color: MultiColorTypeNonNil): GuiOutline
---@return GuiOutline
function Gui.CreateOutline(x, y, w, h, color, anchor) end

---Creates line
---@param x integer
---@param y integer
---@param x1 integer
---@param y1 integer
---@param color MultiColorTypeNonNil
---@overload fun(x: integer, y: integer, x1: integer, y1: integer): GuiLine
---@return GuiLine
function Gui.CreateLine(x, y, x1, y1, color) end

---Creates image
---@param imageData ImageData
---@param x integer
---@param y integer
---@param anchor Anchor
---@overload fun(imageData: ImageData, x: integer, y: integer): GuiImage
---@return GuiImage
function Gui.CreateImage(imageData, x, y, anchor) end

---Creates circle
---@param x integer
---@param y integer
---@param radius integer
---@param color MultiColorType
---@param anchor Anchor?
---@param border GuiBorder
---@overload fun(x: integer, y: integer, radius: integer): GuiCircle
---@overload fun(x: integer, y: integer, radius: integer, color: MultiColorTypeNonNil): GuiCircle
---@overload fun(x: integer, y: integer, radius: integer, color: MultiColorType, anchor: Anchor): GuiCircle
---@return GuiCircle
function Gui.CreateCircle(x, y, radius, color, anchor, border) end

---Creates circle outline
---@param x integer
---@param y integer
---@param radius integer
---@param color MultiColorType
---@param anchor Anchor
---@overload fun(x: integer, y: integer, radius: integer)
---@overload fun(x: integer, y: integer, radius: integer, color: MultiColorTypeNonNil): GuiCircleOutline
---@return GuiCircleOutline
function Gui.CreateCircleOutline(x, y, radius, color, anchor) end

---Returns GUI size
---@return integer, integer
function Gui.GetSize() end

---Updates GUI
function Gui.update() end

---Destroys GUI
function Gui.Destroy() end

---Returns sign of a number
---@param x number
---@return -1|0|1
function math.sign(x) end

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
