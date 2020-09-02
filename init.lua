local M = {}

local function getPath(str, sep)
    vis:info('str = ' .. str)
    sep = sep or '/'
    if str:sub(1, 1) == '@' then str = str:sub(2) end
    return str:match("(.*" .. sep .. ")")
end

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
    -- read/write pipes in Lua are close to impossible
    -- http://lua-users.org/lists/lua-l/2007-10/msg00189.html
    -- perhaps
    -- local status, out, err = vis:pipe(vis.win.file, vis.win.selection.range, cmd)
    -- but it doesn't work
    local tmpfile = os.tmpname()
    local cmd = getPath(debug.getinfo(2,'S').source) .. "abbrevURL.lua >" .. tmpfile
    local ahandle = io.popen(cmd, 'w')
    ahandle:write(vis.win.file.lines[line])
    ahandle:close()
    ahandle = io.open(tmpfile)
    local out = rtrim(ahandle:read("*a"))
    ahandle:close()
    os.remove(tmpfile)
    vis.win.file.lines[line] = out
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
   local my_col = vis.win.selection.col
   local my_line = vis.win.selection.line
   M.replace_URLs()
   vis.win:draw()
   vis.win.selection:to(my_line, my_col)
end, "Shorten URLs")
vis:operator_new("gK", function(file, range, pos)
    -- local cmd = getPath(debug.getinfo(2,'S').source) .. "abbrevURL.lua"
    local cmd = "abbrevURL"
    local status, out, err = vis:pipe(file, range, cmd)
    if not status then
    	vis:info(err)
	else
		file:delete(range)
		file:insert(range.start, out)
	end
 vis.win:draw()
	return range.start -- new cursor location
end, "Formatting operator, abbreviate URL")

return M
