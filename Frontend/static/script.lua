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
            gurt.crumbs.set({
                name = 'search',
                value = search.value
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
local textarea = gurt.select("#text-area")
textarea.text = "Please Go To gurt://wiki.web/wiki/<wiki-name> to see a wiki page"

local key = gurt.crumbs.get('search')
local list = gurt.select("#list")

-- Check if the list element exists before proceeding.
if list == nil then
  trace.error("could not select #list")
  return -2
end

local pages_json = gurt.crumbs.get('pages')
local pages = nil

-- Check if pages_json is not nil or empty before parsing.
if pages_json ~= nil and pages_json ~= "" then
    local success, parsed_data = pcall(JSON.parse, pages_json)
    if success and parsed_data ~= nil and parsed_data.folders ~= nil then
        pages = parsed_data.folders
    end
    end

    -- If pages is nil or not a table, initialize it to an empty table to prevent errors.
    if pages == nil or type(pages) ~= 'table' then
    pages = {}
    end

    local search_key_lower = key:lower()
    local filtered_pages = {}

    -- Filter pages, handling the case where 'pages' might be empty.
    for _, page in ipairs(pages) do
    if type(page) == 'string' and page:lower():find(search_key_lower, 1) then
        table.insert(filtered_pages, page)
    end
    end

    -- If no filtered pages are found, the loop below will not execute, which is the desired behavior.
    for _, page in ipairs(filtered_pages) do
    local path = "../wiki/" .. page
    trace.log(page .. " " .. path)
    local html_page = gurt.create("p", { text = page })
    list:append(html_page)
    end
end