#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-adm
PKG_VERSION:=1.3.1
PKG_RELEASE:=2.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-adm
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Luci support for adm1.3
  DEPENDS:=+luci +libstdcpp +kmod-nls-utf8 +librt +libpthread
  PKGARCH:=all
endef

define Package/luci-app-adm/description
	Luci support for adm
endef

define Package/luci-app-adm/postinst
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
	( . /etc/uci-defaults/luci-adm) && rm -f /etc/uci-defaults/luci-adm
	chmod 755 /etc/init.d/adm >/dev/null 2>&1
	/etc/init.d/adm enable >/dev/null 2>&1
	exit 0
}
endef

define Build/Compile
endef

define Package/luci-app-adm/install
	$(CP) ./files/* $(1)
endef

define Package/luci-app-adm/postrm
#!/bin/sh
rm -rf /usr/share/adm
rm /etc/init.d/adm
rm /etc/config/adm
endef

$(eval $(call BuildPackage,luci-app-adm))
