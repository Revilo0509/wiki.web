local element = gurt.select('#text')

if element ~= nil then
    local t = 1
    setInterval(function()
        element.text = tostring(t)
        t = t + 1
    end, 1000)
else
    trace.error("Could not find the element with ID '#text'.")
end
