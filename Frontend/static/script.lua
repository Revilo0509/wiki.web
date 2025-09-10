gurt.body:on('keydown', function(event)
    local search = gurt.select('#search')
    if search == nil then
        print("Could not find #search-input")
        return -1
    end
    if event.key == 'Enter' then
        trace.log(' ')
        local response = fetch("/api/count")
        if response:ok() then
            local text = response:text()

            gurt.crumbs.set({
                name = 'pages',
                value = text
            })
            gurt.location.goto('/search')

        else
            trace.log('Failed Fetching Pages: ' .. response.status)
        end
    end
end)

local url = gurt.location.href
local pattern = "gurt://[^/]*"
local stripped_url = string.gsub(url, pattern, "")

if stripped_url == "/search" then
    
end