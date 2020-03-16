local function get_query()
    local line = vis.win.selection.line
    local pos = vis.win.selection.col
    local str = vis.win.file.lines[line]
    local len_str = string.len(str)

    local to = str:find('%s', pos)
    if to == nil then to = len_str else to = to - 1 end
    local from = str:reverse():find('%s', len_str - pos + 1)
    if from == nil then from = 1 else from = len_str - from + 2 end
    return str:sub(from, to)
end

local function replace_URLs()
    local line = vis.win.selection.line
    local str = vis.win.file.lines[line]

    str = str:gsub("https://github.com/(.*)/issues/(%d+)", "gh#%1#%2")
    str = str:gsub("https://github.com/(.*)/pull/(%d+)", "gh#%1#%2")
    str = str:gsub("https://gitlab.com/(.*)/issues/(%d+)", "gl#%1#%2")
    str = str:gsub("https://gitlab.com/(.*)/pull/(%d+)", "gl#%1#%2")
    str = str:gsub("https://sourceforge.net/support/tracker.php%?aid=(%d+)", "sh#%1")
    str = str:gsub("https://sf.net/support/tracker.php%?aid=(%d+)", "sh#%1")
    str = str:gsub("https://sourceforge.net/p/(.*)/patches/(%d+)/", "shp#%1#%2")
    str = str:gsub("https://sourceforge.net/p/(.*)/bugs/(%d+)/", "shb#%1#%2")
    str = str:gsub("https://sf.net/support/p/(.*)/patches/(%d+)/", "shp#%1#%2")
    str = str:gsub("https://sf.net/support/p/(.*)/bugs/(%d+)/", "shb#%1#%2")
    str = str:gsub("https://bitbucket.org/(.*)/issues/(%d+)/", "bt#%1#%2")
    str = str:gsub("https://build.suse.de/request/show/(%d+)", "ssr#%1")
    str = str:gsub("https://build.opensuse.org/request/show/(%d+)", "ssr#%1")
    str = str:gsub("https://bugzilla.opensuse.org/show_bug.cgi%?id=(%d+)", "boo#%1")
    str = str:gsub("https://bugzilla.opensuse.org/(%d+)", "boo#%1")
    str = str:gsub("https://bugzilla.suse.com/show_bug.cgi%?id=(%d+)", "bsc#%1")
    str = str:gsub("https://bugzilla.suse.com/(%d+)", "bsc#%1")
    str = str:gsub("https://jira.suse.com/browse/(%d+)", "jsc#%1")
    str = str:gsub("https://bugs.python.org/issue(%d+)", "bpo#%1")
    str = str:gsub("https://bugs.launchpad.net/[^]+/+bug/(%d+)", "lp#%1")

    vis.win.file.lines[line] = str
end

vis:map(vis.modes.NORMAL, "gx", function()
    local cur_word = get_query()
    -- https://bugzilla.suse.com/show_bug.cgi?id=1130840
    -- https://bugs.freedesktop.org/show_bug.cgi?id=103807  x
    -- https://www.damejidlo.cz/potrefena-husa-vinohrady
    -- gh#python/cpython#7778 or bpo#34032
    os.execute("osurl '" .. cur_word .. "'")
end, "Jump to URL")

-- https://en.opensuse.org/openSUSE:Packaging_Patches_guidelines#Current_set_of_abbreviations
vis:map(vis.modes.NORMAL, "gG", function()
    replace_URLs()
end, "Shorten URLs")
