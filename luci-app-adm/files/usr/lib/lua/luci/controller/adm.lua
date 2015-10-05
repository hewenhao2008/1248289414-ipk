module("luci.controller.adm", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/adm") then
		return
	end
	local page
	page = entry({"admin", "services", "adm"}, cbi("adm"), _("阿呆喵广告屏蔽"), 56)
	page.dependent = true
end
