local fs = require "nixio.fs"
local util = require "nixio.util"

button = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"button\" value=\" " .. translate("ADM官网") .. " \" onclick=\"window.open('http://www.admflt.com/')\"/>"
m = Map("adm","阿呆喵广告屏蔽","<strong><font color=\"red\">ADM是一款免费且功能强大的广告拦截软件。</font></strong>"..button)

s = m:section(TypedSection, "adm", "基本设置")
s.anonymous = true

s:tab("basic",  translate("ADM设置"))
s:tab("config", translate("高级配置"))
s:tab("user", translate("自定义规则"))

if luci.sys.call("pidof adm > /dev/null") == 0 then
	yx = "阿呆喵正在运行！"
else
	yx = "阿呆喵未运行！"
end

s:taboption("basic", Flag, "enabled","启用ADM","<br /><strong><font color=\"00FFFF\">状态：</font></strong>"..yx)

if luci.sys.call("iptables -t nat -L PREROUTING | grep 18309 >> /dev/null") == 0 then	
	dw = s:taboption("basic", Button, "dw","关闭透明代理","<strong><font color=\"red\">【当前已开启代理】</font></strong>")
	dw.inputstyle = "reset"
	dw.write = function()
		luci.sys.call("iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 18309")
	end
else
	kq = s:taboption("basic", Button, "kq","开启透明代理","<strong><font color=\"red\">【当前未开启代理】</font></strong>")
	kq.inputstyle = "apply"
	kq.write = function()
		luci.sys.call("iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 18309")
	end
end

s:taboption("config", Flag, "rule_new","开启规则同步")
s:taboption("config", Flag, "err_log","开启错误日志")

p = s:taboption("config", Flag, "proxy","开启全局代理")
p = s:taboption("config", ListValue, "type", "代理模式")
p:value("2", translate("http代理"))
p:value("3", translate("sock4代理"))
p:value("4", translate("sock4A代理"))
p:value("5", translate("sock5代理"))
p:value("6", translate("sock5t代理"))
p:depends("proxy","1")
p = s:taboption("config", Value, "pip", "上游IP")
p:depends("proxy","1")
p = s:taboption("config", Value, "pport", "上游端口")
p:depends("proxy","1")

p = s:taboption("config", Flag, "autoproxy","开启智能代理","<strong><font color=\"red\">需要提供proxylist.txt文件</font></strong>")
p = s:taboption("config", ListValue, "aptype", "智能代理模式")
p:value("2", translate("http代理"))
p:value("5", translate("sock5代理"))
p:depends("autoproxy","1")
p = s:taboption("config", Value, "apip", "上游IP")
p:depends("autoproxy","1")
p = s:taboption("config", Value, "apport", "上游端口")
p:depends("autoproxy","1")

editconf_user = s:taboption("user", Value, "_editconf_user", 
	translate("添加自定义规则"), 
	translate("添加你自己的过滤规则"))
editconf_user.template = "cbi/tvalue"
editconf_user.rows = 20
editconf_user.wrap = "off"

function editconf_user.cfgvalue(self, section)
	return fs.readfile("/usr/share/adm/cache/user.txt") or ""
end
function editconf_user.write(self, section, value1)
	if value1 then
		value1 = value1:gsub("\r\n?", "\n")
		fs.writefile("/tmp/user.txt", value1)
		if (luci.sys.call("cmp -s /tmp/user.txt /usr/share/adm/cache/user.txt") == 1) then
			fs.writefile("/usr/share/adm/cache/user.txt", value1)
		end
		fs.remove("/tmp/user.txt")
	end
end

s = m:section(TypedSection, "extrule", translate("第三方规则"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "address", translate("规则地址"))

return m