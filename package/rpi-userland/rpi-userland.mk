################################################################################
#
# rpi-userland
#
################################################################################

RPI_USERLAND_VERSION = b69f807ce59189457662c2144a8e7e12dc776988
RPI_USERLAND_SITE = $(call github,raspberrypi,userland,$(RPI_USERLAND_VERSION))
RPI_USERLAND_LICENSE = BSD-3c
RPI_USERLAND_LICENSE_FILES = LICENCE
RPI_USERLAND_INSTALL_STAGING = YES
RPI_USERLAND_CONF_OPT = -DVMCS_INSTALL_PREFIX=/usr -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="$(TARGET_CFLAGS)"

ifeq ($(BR2_PACKAGE_WAYLAND),y)
RPI_USERLAND_DEPENDENCIES += wayland
RPI_USERLAND_CONF_OPT += -DBUILD_WAYLAND=1
endif

define RPI_USERLAND_POST_TARGET_CLEANUP
	rm -f $(TARGET_DIR)/usr/bin/vchiq_test
	rm -f $(TARGET_DIR)/usr/sbin/vcfiled
	rm -f $(TARGET_DIR)/etc/init.d/vcfiled
	rm -f $(TARGET_DIR)/usr/share/install/vcfiled
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/install
	rm -Rf $(TARGET_DIR)/usr/src
endef

RPI_USERLAND_POST_INSTALL_TARGET_HOOKS += RPI_USERLAND_POST_TARGET_CLEANUP

$(eval $(cmake-package))
