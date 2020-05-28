local M = {}

local function rtrim(s)
    local n = #s
    while n > 0 and s:find("^%s", n) do n = n - 1 end
    return s:sub(1, n)
end

M.get_query = function()
    local line = vis.win.selection.line
    local pos = vis.win.selection.col
    local str = vis.win.file.lines[line]
    local len_str = string.len(str)

    local URLchars = '[^a-zA-Z0-9%?._=+;&/:@#-]'
    local to = str:find(URLchars, pos)
    if to == nil then to = len_str else to = to - 1 end
    local from = str:reverse():find(URLchars, len_str - pos + 1)
    if from == nil then from = 1 else from = len_str - from + 2 end
    return str:sub(from, to)
end

M.replace_URLs = function()
    local line = vis.win.selection.line
    local str = vis.win.file.lines[line]
    -- print(debug.getinfo(2,'S').source)
    local ahandle = io.popen("abbrevURL " .. str)
    str = rtrim(ahandle:read("*a"))
    ahandle:close()
    vis.win.file.lines[line] = str
end

vis:map(vis.modes.NORMAL, "gx", function()
    local cur_word = M.get_query()
    -- https://bugzilla.suse.com/show_bug.cgi?id=1130840
    -- https://bugs.freedesktop.org/show_bug.cgi?id=103807  x
    -- https://www.damejidlo.cz/potrefena-husa-vinohrady
    -- gh#python/cpython#7778 or bpo#34032
    -- (https://src.adamsgaard.dk/)
    if M.gx_cmd == nil then M.gx_cmd = 'setsid xdg-open' end
    local command = M.gx_cmd .. " '" .. cur_word .. "'"
    -- print("command = '" .. command .. "'")
    os.execute(command)
end, "Jump to URL")

-- https://en.opensuse.org/openSUSE:Packaging_Patches_guidelines#Current_set_of_abbreviations
vis:map(vis.modes.NORMAL, "gG", function()
    M.replace_URLs()
    vis.win:draw()
end, "Shorten URLs")

return M
