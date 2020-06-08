#!/usr/bin/lua
local str = ''

if #arg == 0 then
str = io.read("*l")
else
str = arg[1]:lower()
end

str = str:gsub("https?://github.com/(.*)/issues/(%d+)", "gh#%1#%2")
str = str:gsub("https?://github.com/(.*)/pull/(%d+)", "gh#%1#%2")
str = str:gsub("https?://gitlab.com/(.*)/-/issues/(%d+)", "gl#%1#%2")
str = str:gsub("https?://gitlab.com/(.*)/issues/(%d+)", "gl#%1#%2")
str = str:gsub("https?://gitlab.com/(.*)/pull/(%d+)", "gl#%1#%2")
str = str:gsub("https?://sourceforge.net/support/tracker.php%?aid=(%d+)", "sh#%1")
str = str:gsub("https?://sf.net/support/tracker.php%?aid=(%d+)", "sh#%1")
str = str:gsub("https?://sourceforge.net/p/(.*)/patches/(%d+)/", "shp#%1#%2")
str = str:gsub("https?://sourceforge.net/p/(.*)/bugs/(%d+)/", "shb#%1#%2")
str = str:gsub("https?://sf.net/support/p/(.*)/patches/(%d+)/", "shp#%1#%2")
str = str:gsub("https?://sf.net/support/p/(.*)/bugs/(%d+)/", "shb#%1#%2")
str = str:gsub("https?://bitbucket.org/(.*)/issues/(%d+)/", "bt#%1#%2")
str = str:gsub("https?://build.suse.de/request/show/(%d+)", "ssr#%1")
str = str:gsub("https?://build.opensuse.org/request/show/(%d+)", "sr#%1")
str = str:gsub("https?://bugzilla.opensuse.org/show_bug.cgi%?id=(%d+)", "boo#%1")
str = str:gsub("https?://bugzilla.opensuse.org/(%d+)", "boo#%1")
str = str:gsub("https?://bugzilla.suse.com/show_bug.cgi%?id=(%d+)", "bsc#%1")
str = str:gsub("https?://bugzilla.suse.com/(%d+)", "bsc#%1")
str = str:gsub("https?://bugzilla.redhat.com/show_bug.cgi%?id=(%d+)", "rh#%1")
str = str:gsub("https?://bugzilla.redhat.com/(%d+)", "rh#%1")
str = str:gsub("https?://jira.suse.com/browse/(%a+)", "jsc#%1")
str = str:gsub("https?://bugs.python.org/issue(%d+)", "bpo#%1")
str = str:gsub("https?://bugs.launchpad.net/.+/%+bug/(%d+)", "lp#%1")

print(str)
