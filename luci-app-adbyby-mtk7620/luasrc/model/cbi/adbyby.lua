local fs = require "nixio.fs"
local util = require "nixio.util"
if luci.sys.call("pidof adbyby > /dev/null") == 0 then	
	m = Map("adbyby","广告屏蔽大师","广告屏蔽大师运行中")
else
	m = Map("adbyby","广告屏蔽大师","广告屏蔽大师未启动")
end
s = m:section(TypedSection, "adbyby", "基本设置")
s.anonymous = true
s:option(Flag, "enabled", "启用")
return m
