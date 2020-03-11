local function get_query()
    local line = vis.win.selection.line
    local pos = vis.win.selection.col
    local str = vis.win.file.lines[line]

    local from, to = 0, 0
    while pos > to do
        from, to = str:find('[%a_]+[%a%d_]*', to + 1)
        if from == nil or from > pos then
            return nil
        end
    end

    return string.sub(str, from, to)
end

vis:map(vis.modes.NORMAL, "gx", function()
    local cur_word = get_query()
    print(cur_word)
    os.execute("xdg-open " .. cur_word)
end, "Jump to URL")
