local fs = require "nixio.fs"
local util = require "nixio.util"
if luci.sys.call("pidof adbyby > /dev/null") == 0 then	
	m = Map("adbyby","广告屏蔽大师","广告屏蔽大师运行中")
else
	m = Map("adbyby","广告屏蔽大师","广告屏蔽大师未运行")
end
s = m:section(TypedSection, "adbyby", "基本设置")
s.anonymous = true

s:tab("basic",  translate("Settings"))

s:taboption("basic", Flag, "enabled", "启用ADbyby")

up = s:taboption("basic", Button, "update","一键更新规则","<br />更新ADbyby的广告过滤规则")
up.inputstyle = "apply"
up.write = function(call)
	luci.sys.call("sh /usr/share/adbyby/sh/update.sh")
end

dw = s:taboption("basic", Button, "dw","关闭透明代理","<br />暂时关闭ADbyby")
dw.inputstyle = "reset"
dw.write = function(closeadbyby)
	luci.sys.call("iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8118")
end

kq = s:taboption("basic", Button, "kq","开启透明代理","<br />关闭后当然还要开启啦！")
kq.inputstyle = "apply"
kq.write = function(openadbyby)
	luci.sys.call("iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8118")
end

s:taboption("basic", DummyValue,"opennewwindow" ,translate("<br /><p align=\"justify\"><script type=\"text/javascript\"></script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"ADbyby官网\" onclick=\"window.open('http://www.adbyby.com/')\" /></p>"))

s:tab("config", translate("ADbyby配置"))

adbyby_config = s:taboption("config", Value, "_adbyby_config", 
	translate("ADbyby配置"), 
	translate("一般情况保持默认即可"))
adbyby_config.template = "cbi/tvalue"
adbyby_config.rows = 20
adbyby_config.wrap = "off"

function adbyby_config.cfgvalue(self, section)
	return fs.readfile("/usr/share/adbyby/adhook.ini") or ""
end
function adbyby_config.write(self, section, value1)
	if value1 then
		value1 = value1:gsub("\r\n?", "\n")
		fs.writefile("/tmp/adhook.ini", value1)
		if (luci.sys.call("cmp -s /tmp/adhook.ini /usr/share/adbyby/adhook.ini") == 1) then
			fs.writefile("/usr/share/adbyby/adhook.ini", value1)
		end
		fs.remove("/tmp/adhook.ini")
	end
end

s:tab("user", translate("自定义规则"))
editconf_user = s:taboption("user", Value, "_editconf_user", 
	translate("添加自定义规则"), 
	translate("添加你自己的屏蔽规则"))
editconf_user.template = "cbi/tvalue"
editconf_user.rows = 20
editconf_user.wrap = "off"

function editconf_user.cfgvalue(self, section)
	return fs.readfile("/usr/share/adbyby/data/user.txt") or ""
end
function editconf_user.write(self, section, value2)
	if value2 then
		value2 = value2:gsub("\r\n?", "\n")
		fs.writefile("/tmp/user.txt", value2)
		if (luci.sys.call("cmp -s /tmp/user.txt /usr/share/adbyby/data/user.txt") == 1) then
			fs.writefile("/usr/share/adbyby/data/user.txt", value2)
		end
		fs.remove("/tmp/user.txt")
	end
end

return m
