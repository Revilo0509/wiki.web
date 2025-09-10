--! @module Gurted
--! @desc Gurted provides a Lua API for dynamic web development.

--! @global gurt
--! @desc Main global object for DOM manipulation and core functionality.
gurt = {}

--! @function gurt.select
--! @desc Selects the first element matching the CSS selector.
--! @param selector string The CSS selector.
--! @return table The first element found, or nil if none.
function gurt.select(selector) end

--! @function gurt.selectAll
--! @desc Selects all elements matching the CSS selector.
--! @param selector string The CSS selector.
--! @return table An array of elements.
function gurt.selectAll(selector) end

--! @function gurt.create
--! @desc Creates a new HTML element.
--! @param tagName string The tag name of the element to create.
--! @param options table An optional table with attributes like 'text', 'style', 'id'.
--! @return table The newly created element.
function gurt.create(tagName, options) end

--! @global gurt.body
--! @desc Reference to the document body element.
gurt.body = {}

--! @global gurt.location
--! @desc Browser location and navigation control.
gurt.location = {
    --! @property href string
    --! @desc The current URL.
    href = "",
    --! @function reload
    --! @desc Reloads the current page.
    reload = function() end,
    --! @function goto
    --! @desc Navigates to a new URL.
    --! @param url string The URL to navigate to.
    ["goto"] = function(url) end,
    --! @property query table
    --! @desc Query parameter access.
    query = {
        --! @function get
        --! @desc Gets a specific query parameter value.
        --! @param name string The name of the parameter.
        --! @return string The value of the parameter.
        get = function(name) end,
        --! @function has
        --! @desc Checks if a query parameter exists.
        --! @param name string The name of the parameter.
        --! @return boolean True if the parameter exists.
        has = function(name) end,
        --! @function getAll
        --! @desc Gets all values for a repeated parameter.
        --! @param name string The name of the parameter.
        --! @return table An array of values.
        getAll = function(name) end
    }
}

--! @global trace
--! @desc Global trace table for logging messages to the console.
trace = {
    --! @function log
    --! @desc Logs a message to the console. Identical to print().
    --! @param message any The message to log.
    log = function(message) end,
    --! @function warn
    --! @desc Logs a warning message to the console.
    --! @param message any The message to log.
    warn = function(message) end,
    --! @function error
    --! @desc Logs an error message to the console.
    --! @param message any The message to log.
    error = function(message) end
}

--! @global Time
--! @desc Time API for handling timestamps, formatting, and timing.
Time = {
    --! @function now
    --! @desc Gets the current Unix timestamp.
    --! @return number The current timestamp.
    now = function() end,
    --! @function format
    --! @desc Formats a timestamp using format strings.
    --! @param timestamp number The Unix timestamp.
    --! @param format string The format string (e.g., '%Y-%m-%d').
    --! @return string The formatted date/time string.
    format = function(timestamp, format) end,
    --! @function date
    --! @desc Gets date components as a table.
    --! @param timestamp number The Unix timestamp.
    --! @return table A table with date components ('year', 'month', 'day', 'hour', etc.).
    date = function(timestamp) end,
    --! @function sleep
    --! @desc Pauses execution for a specified duration. **Use with caution, as it blocks the Lua thread.**
    --! @param seconds number The number of seconds to sleep.
    sleep = function(seconds) end,
    --! @function benchmark
    --! @desc Measures function execution time.
    --! @param func function The function to benchmark.
    --! @return number The elapsed time in seconds.
    --! @return ... The return values of the benchmarked function.
    benchmark = function(func) end,
    --! @function timer
    --! @desc Creates a timer object for measuring intervals.
    --! @return table A timer object.
    timer = function() end,
    --! @function delay
    --! @desc Creates a non-blocking delay object.
    --! @param seconds number The duration of the delay.
    --! @return table A delay object.
    delay = function(seconds) end
}

--! @class Timer
--! @desc A timer object for measuring time intervals.
Timer = {
    --! @function elapsed
    --! @desc Gets the elapsed time since the timer was created or reset.
    --! @return number The elapsed time in seconds.
    elapsed = function(self) end,
    --! @function reset
    --! @desc Resets the timer's start time.
    reset = function(self) end
}

--! @class Delay
--! @desc A delay object for non-blocking waits.
Delay = {
    --! @function complete
    --! @desc Checks if the delay is complete.
    --! @return boolean True if the delay has finished.
    complete = function(self) end,
    --! @function remaining
    --! @desc Gets the remaining time of the delay.
    --! @return number The remaining time in seconds.
    remaining = function(self) end
}

--! @function setTimeout
--! @desc Executes a function after a delay.
--! @param callback function The function to execute.
--! @param milliseconds number The delay in milliseconds.
--! @return number A timeout ID.
function setTimeout(callback, milliseconds) end

--! @function setInterval
--! @desc Executes a function repeatedly at intervals.
--! @param callback function The function to execute.
--! @param milliseconds number The interval in milliseconds.
--! @return number An interval ID.
function setInterval(callback, milliseconds) end

--! @function clearTimeout
--! @desc Cancels a scheduled timeout.
--! @param timeoutId number The ID of the timeout to cancel.
function clearTimeout(timeoutId) end

--! @function clearInterval
--! @desc Cancels a scheduled interval.
--! @param intervalId number The ID of the interval to cancel.
function clearInterval(intervalId) end

--! @global Clipboard
--! @desc API for interacting with the system clipboard.
Clipboard = {
    --! @function write
    --! @desc Writes text to the system clipboard.
    --! @param text string The text to write.
    write = function(text) end
}

--! @class Element
--! @desc Represents a single HTML element in the DOM.
Element = {
    --! @property text string
    --! @desc Gets or sets the text content of the element.
    text = "",
    --! @property value string
    --! @desc Gets or sets the value of form elements.
    value = "",
    --! @property visible boolean
    --! @desc Gets or sets element visibility.
    visible = false,
    --! @property children table
    --! @desc An array of child elements.
    children = {},
    --! @property parent table
    --! @desc The parent element.
    parent = {},
    --! @property nextSibling table
    --! @desc The next adjacent sibling element.
    nextSibling = {},
    --! @property previousSibling table
    --! @desc The previous adjacent sibling element.
    previousSibling = {},
    --! @property firstChild table
    --! @desc The first child element.
    firstChild = {},
    --! @property lastChild table
    --! @desc The last child element.
    lastChild = {},
    --! @property classList table
    --! @desc Provides methods for managing CSS classes.
    classList = {
        --! @function add
        --! @desc Adds one or more classes to the element.
        --! @param ... string The classes to add.
        add = function(...) end,
        --! @function remove
        --! @desc Removes one or more classes from the element.
        --! @param ... string The classes to remove.
        remove = function(...) end,
        --! @function toggle
        --! @desc Toggles a class on the element.
        --! @param className string The class to toggle.
        toggle = function(className) end,
        --! @function contains
        --! @desc Checks if the element has a specific class.
        --! @param className string The class name to check.
        --! @return boolean True if the class exists.
        contains = function(className) end,
        --! @function item
        --! @desc Gets a class by its 1-based index.
        --! @param index number The index of the class.
        --! @return string The class name.
        item = function(index) end,
        --! @property length number
        --! @desc The number of classes on the element.
        length = 0
    },
    --! @function on
    --! @desc Adds an event listener to the element.
    --! @param eventName string The name of the event (e.g., 'click', 'keydown').
    --! @param callback function The function to call when the event occurs.
    --! @return table A subscription object to manage the listener.
    on = function(self, eventName, callback) end,
    --! @function append
    --! @desc Appends a child element to this element.
    --! @param childElement table The element to append.
    append = function(self, childElement) end,
    --! @function remove
    --! @desc Removes the element from the DOM.
    remove = function(self) end,
    --! @function insertBefore
    --! @desc Inserts an element before a reference element.
    --! @param newElement table The element to insert.
    --! @param referenceElement table The element to insert before.
    insertBefore = function(self, newElement, referenceElement) end,
    --! @function insertAfter
    --! @desc Inserts an element after a reference element.
    --! @param newElement table The element to insert.
    --! @param referenceElement table The element to insert after.
    insertAfter = function(self, newElement, referenceElement) end,
    --! @function replace
    --! @desc Replaces a child element with a new element.
    --! @param oldElement table The element to replace.
    --! @param newElement table The new element.
    replace = function(self, oldElement, newElement) end,
    --! @function clone
    --! @desc Creates a copy of the element.
    --! @param deep boolean If true, a deep clone including children is created.
    --! @return table A copy of the element.
    clone = function(self, deep) end,
    --! @function getAttribute
    --! @desc Gets the value of an element's attribute.
    --! @param name string The name of the attribute.
    --! @return string The attribute value.
    getAttribute = function(self, name) end,
    --! @function setAttribute
    --! @desc Sets the value of an element's attribute.
    --! @param name string The name of the attribute.
    --! @param value string The value to set.
    setAttribute = function(self, name, value) end,
    --! @function show
    --! @desc Makes the element visible.
    show = function(self) end,
    --! @function hide
    --! @desc Hides the element.
    hide = function(self) end,
    --! @function focus
    --! @desc Sets focus on the element.
    focus = function(self) end,
    --! @function unfocus
    --! @desc Removes focus from the element.
    unfocus = function(self) end,
    --! @function createTween
    --! @desc Creates a tween animation object for the element.
    --! @return table A tween object.
    createTween = function(self) end,
    --! @property duration number
    --! @desc The duration of an audio element in seconds.
    duration = 0,
    --! @property currentTime number
    --! @desc The current playback position of an audio element in seconds.
    currentTime = 0,
    --! @property volume number
    --! @desc The volume of an audio element (0.0 to 1.0).
    volume = 0,
    --! @property loop boolean
    --! @desc Indicates if an audio element is looping.
    loop = false,
    --! @property src string
    --! @desc The source URL of an audio element.
    src = "",
    --! @property playing boolean
    --! @desc True if the audio is currently playing.
    playing = false,
    --! @property paused boolean
    --! @desc True if the audio is currently paused.
    paused = false,
    --! @function play
    --! @desc Starts playback of an audio element.
    play = function(self) end,
    --! @function pause
    --! @desc Pauses playback of an audio element.
    pause = function(self) end,
    --! @function stop
    --! @desc Stops playback and resets the position of an audio element.
    stop = function(self) end,
    --! @function withContext
    --! @desc Gets a drawing context for a canvas element.
    --! @param contextType string '2d' or 'shader'.
    --! @return table The drawing context.
    withContext = function(self, contextType) end
}

--! @class Subscription
--! @desc An object to manage and unsubscribe from event listeners.
Subscription = {
    --! @function unsubscribe
    --! @desc Unsubscribes the event listener.
    unsubscribe = function(self) end
}

--! @class Tween
--! @desc An object for building and playing animations.
Tween = {
    --! @function to
    --! @desc Sets the target value for a property to animate.
    --! @param property string The property name ('opacity', 'x', 'y', etc.).
    --! @param value any The target value.
    --! @return table The tween object for chaining.
    to = function(self, property, value) end,
    --! @function duration
    --! @desc Sets the duration of the animation.
    --! @param seconds number The duration in seconds.
    --! @return table The tween object for chaining.
    duration = function(self, seconds) end,
    --! @function easing
    --! @desc Sets the easing type for the animation.
    --! @param type string The easing type ('in', 'out', 'inout', 'outin').
    --! @return table The tween object for chaining.
    easing = function(self, type) end,
    --! @function transition
    --! @desc Sets the transition type for the animation.
    --! @param type string The transition type ('linear', 'quad', 'cubic', etc.).
    --! @return table The tween object for chaining.
    transition = function(self, type) end,
    --! @function play
    --! @desc Starts the animation.
    play = function(self) end
}

--! @class CanvasContext2D
--! @desc A 2D drawing context for a canvas.
CanvasContext2D = {
    --! @function fillRect
    --! @desc Draws a filled rectangle.
    --! @param x number The x-coordinate.
    --! @param y number The y-coordinate.
    --! @param width number The width.
    --! @param height number The height.
    --! @param color string The fill color.
    fillRect = function(self, x, y, width, height, color) end,
    --! @function strokeRect
    --! @desc Draws a rectangle outline.
    --! @param x number The x-coordinate.
    --! @param y number The y-coordinate.
    --! @param width number The width.
    --! @param height number The height.
    --! @param color string The stroke color.
    --! @param strokeWidth number The stroke width.
    strokeRect = function(self, x, y, width, height, color, strokeWidth) end,
    --! @function clearRect
    --! @desc Clears a rectangular area.
    --! @param x number The x-coordinate.
    --! @param y number The y-coordinate.
    --! @param width number The width.
    --! @param height number The height.
    clearRect = function(self, x, y, width, height) end,
    --! @function drawCircle
    --! @desc Draws a filled or outlined circle.
    --! @param x number The x-coordinate of the center.
    --! @param y number The y-coordinate of the center.
    --! @param radius number The radius.
    --! @param color string The color.
    --! @param filled boolean True for a filled circle, false for an outline.
    drawCircle = function(self, x, y, radius, color, filled) end,
    --! @function drawText
    --! @desc Draws text on the canvas.
    --! @param x number The x-coordinate.
    --! @param y number The y-coordinate.
    --! @param text string The text to draw.
    --! @param color string The text color.
    drawText = function(self, x, y, text, color) end,
    --! @function setFont
    --! @desc Sets the font size for drawing text.
    --! @param font string The font string (e.g., '20px sans-serif').
    setFont = function(self, font) end,
    --! @function measureText
    --! @desc Measures the width of a given text string.
    --! @param text string The text to measure.
    --! @return table A metrics table with the 'width' property.
    measureText = function(self, text) end,
    --! @function beginPath
    --! @desc Starts a new path for drawing.
    beginPath = function(self) end,
    --! @function moveTo
    --! @desc Moves the current drawing point without drawing.
    --! @param x number The x-coordinate.
    --! @param y number The y-coordinate.
    moveTo = function(self, x, y) end,
    --! @function lineTo
    --! @desc Draws a line from the current point to a new point.
    --! @param x number The x-coordinate.
    --! @param y number The y-coordinate.
    lineTo = function(self, x, y) end,
    --! @function closePath
    --! @desc Closes the current path.
    closePath = function(self) end,
    --! @function stroke
    --! @desc Draws the outline of the current path.
    stroke = function(self) end,
    --! @function fill
    --! @desc Fills the current path.
    fill = function(self) end,
    --! @function arc
    --! @desc Creates an arc path.
    --! @param x number The x-coordinate of the center.
    --! @param y number The y-coordinate of the center.
    --! @param radius number The radius.
    --! @param startAngle number The starting angle in radians.
    --! @param endAngle number The ending angle in radians.
    --! @param counterclockwise boolean True for a counter-clockwise arc.
    arc = function(self, x, y, radius, startAngle, endAngle, counterclockwise) end,
    --! @function quadraticCurveTo
    --! @desc Adds a quadratic Bezier curve to the current path.
    --! @param controlX number The x-coordinate of the control point.
    --! @param controlY number The y-coordinate of the control point.
    --! @param endX number The x-coordinate of the end point.
    --! @param endY number The y-coordinate of the end point.
    quadraticCurveTo = function(self, controlX, controlY, endX, endY) end,
    --! @function bezierCurveTo
    --! @desc Adds a cubic Bezier curve to the current path.
    --! @param cp1x number The x-coordinate of the first control point.
    --! @param cp1y number The y-coordinate of the first control point.
    --! @param cp2x number The x-coordinate of the second control point.
    --! @param cp2y number The y-coordinate of the second control point.
    --! @param endX number The x-coordinate of the end point.
    --! @param endY number The y-coordinate of the end point.
    bezierCurveTo = function(self, cp1x, cp1y, cp2x, cp2y, endX, endY) end,
    --! @function setStrokeStyle
    --! @desc Sets the color for subsequent stroke operations.
    --! @param color string The color string.
    setStrokeStyle = function(self, color) end,
    --! @function setFillStyle
    --! @desc Sets the color for subsequent fill operations.
    --! @param color string The color string.
    setFillStyle = function(self, color) end,
    --! @function setLineWidth
    --! @desc Sets the line width for strokes.
    --! @param width number The line width in pixels.
    setLineWidth = function(self, width) end,
    --! @function save
    --! @desc Saves the current canvas state.
    save = function(self) end,
    --! @function restore
    --! @desc Restores the most recently saved canvas state.
    restore = function(self) end,
    --! @function translate
    --! @desc Adds a translation transformation.
    --! @param x number The x-offset.
    --! @param y number The y-offset.
    translate = function(self, x, y) end,
    --! @function rotate
    --! @desc Adds a rotation transformation.
    --! @param angle number The rotation angle in radians.
    rotate = function(self, angle) end,
    --! @function scale
    --! @desc Adds a scaling transformation.
    --! @param x number The x-scale factor.
    --! @param y number The y-scale factor.
    scale = function(self, x, y) end,
}

--! @class CanvasContextShader
--! @desc A shader context for a canvas.
CanvasContextShader = {
    --! @function source
    --! @desc Sets the shader source code.
    --! @param code string The shader code.
    source = function(self, code) end,
}

--! @function fetch
--! @desc Makes an HTTP request.
--! @param url string The URL to fetch.
--! @param options table An optional table with request options ('method', 'headers', 'body').
--! @return table The response object.
function fetch(url, options) end

--! @class Response
--! @desc An object representing an HTTP response.
Response = {
    --! @property status number
    --! @desc The HTTP status code.
    status = 0,
    --! @property statusText string
    --! @desc The HTTP status message.
    statusText = "",
    --! @property headers table
    --! @desc A table of response headers.
    headers = {},
    --! @function ok
    --! @desc Checks if the response status is in the 200-299 range.
    --! @return boolean True if the response is successful.
    ok = function(self) end,
    --! @function json
    --! @desc Parses the response body as JSON.
    --! @return table The parsed Lua data.
    json = function(self) end,
    --! @function text
    --! @desc Gets the response body as plain text.
    --! @return string The response text.
    text = function(self) end
}

--! @global WebSocket
--! @desc API for real-time WebSocket communication.
WebSocket = {
    --! @property CONNECTING number
    --! @desc WebSocket connection state: 0.
    CONNECTING = 0,
    --! @property OPEN number
    --! @desc WebSocket connection state: 1.
    OPEN = 1,
    --! @property CLOSING number
    --! @desc WebSocket connection state: 2.
    CLOSING = 2,
    --! @property CLOSED number
    --! @desc WebSocket connection state: 3.
    CLOSED = 3,
    --! @function new
    --! @desc Creates a new WebSocket object.
    --! @param url string The WebSocket URL.
    --! @return table The WebSocket object.
    new = function(url) end,
    --! @property readyState number
    --! @desc The current state of the WebSocket connection.
    readyState = 0,
    --! @function on
    --! @desc Adds an event listener to the WebSocket.
    --! @param eventName string 'open', 'message', 'close', or 'error'.
    --! @param callback function The function to call when the event occurs.
    on = function(self, eventName, callback) end,
    --! @function send
    --! @desc Sends data through the WebSocket connection.
    --! @param data any The data to send.
    send = function(self, data) end,
    --! @function close
    --! @desc Closes the WebSocket connection.
    close = function(self) end
}

--! @function urlEncode
--! @desc Encodes a string for safe use in URLs.
--! @param s string The string to encode.
--! @return string The URL-encoded string.
function urlEncode(s) end

--! @function urlDecode
--! @desc Decodes a percent-encoded URL string.
--! @param s string The URL-encoded string.
--! @return string The decoded string.
function urlDecode(s) end

--! @global JSON
--! @desc API for converting between Lua data and JSON strings.
JSON = {
    --! @function stringify
    --! @desc Converts Lua data to a JSON string.
    --! @param data table The Lua table to convert.
    --! @return string The JSON string.
    stringify = function(data) end,
    --! @function parse
    --! @desc Parses a JSON string to Lua data.
    --! @param jsonString string The JSON string to parse.
    --! @return table The parsed Lua data.
    --! @return string An error message if parsing fails.
    parse = function(jsonString) end
}

--! @global Regex
--! @desc API for pattern matching with regular expressions.
Regex = {
    --! @function new
    --! @desc Creates a new regex object.
    --! @param pattern string The regex pattern string.
    --! @return table The regex object.
    new = function(pattern) end
}

--! @class Regex
--! @desc A regex object for testing and matching strings.
Regex = {
    --! @function test
    --! @desc Tests if the pattern matches anywhere in the text.
    --! @param text string The text to test.
    --! @return boolean True if a match is found.
    test = function(self, text) end,
    --! @function match
    --! @desc Finds the first match and returns capture groups.
    --! @param text string The text to search.
    --! @return table An array of captured groups, or nil if no match.
    match = function(self, text) end
}

--! @global table
--! @desc Lua's built-in table library with added Gurted functionality.
table = {
    --! @function tostring
    --! @desc Converts a table to a readable string representation.
    --! @param t table The table to convert.
    --! @return string The string representation of the table.
    tostring = function(t) end
}

--! @global string
--! @desc Lua's built-in string library with added Gurted functionality.
string = {
    --! @function replace
    --! @desc Replaces the first occurrence of a substring or regex pattern.
    --! @param text string The original string.
    --! @param search string|table The string or regex pattern to search for.
    --! @param replacement string The replacement string.
    --! @return string The new string.
    replace = function(text, search, replacement) end,
    --! @function replaceAll
    --! @desc Replaces all occurrences of a substring or regex pattern.
    --! @param text string The original string.
    --! @param search string|table The string or regex pattern to search for.
    --! @param replacement string The replacement string.
    --! @return string The new string.
    replaceAll = function(text, search, replacement) end,
    --! @function trim
    --! @desc Removes leading and trailing whitespace from a string.
    --! @param text string The string to trim.
    --! @return string The trimmed string.
    trim = function(text) end
}