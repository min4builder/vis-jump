local function get_query()
    local line = vis.win.selection.line
    local pos = vis.win.selection.col
    local str = vis.win.file.lines[line]
    local len_str = string.len(str)

    local to = str:find('%s', pos) - 1
    if to == nil then to = string.len(str) end
    local from = str:reverse():find('%s', len_str - pos + 1)
    if from == nil then
        from = 1
    else
        -- reverse index
        from = len_str - from + 2
    end
    return str:sub(from, to)
end

vis:map(vis.modes.NORMAL, "gx", function()
    local cur_word = get_query()
    -- https://bugs.freedesktop.org/show_bug.cgi?id=103807  x
    -- https://www.damejidlo.cz/potrefena-husa-vinohrady
    os.execute("xdg-open '" .. cur_word .. "'")
end, "Jump to URL")
