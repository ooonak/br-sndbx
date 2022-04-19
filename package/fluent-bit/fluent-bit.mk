FLUENT_BIT_VERSION = 1.9.2
FLUENT_BIT_SITE = $(call github,fluent,fluent-bit,v$(FLUENT_BIT_VERSION))
FLUENT_BIT_LICENSE = Apache License v2.0
FLUENT_BIT_LICENSE_FILE = LICENSE

# https://docs.fluentbit.io/manual/installation/sources/build-and-install
# General Options
FLUENT_BIT_CONF_OPTS += -DFLB_LUAJIT=OFF
FLUENT_BIT_CONF_OPTS += -DFLB_SIGNV4=OFF
FLUENT_BIT_CONF_OPTS += -DFLB_EXAMPLES=OFF
# Development Options
FLUENT_BIT_CONF_OPTS += -DFLB_BACKTRACE=OFF
# Input Plugins
# Filter Plugins
# Output Plugins

ifeq ($(BR2_PACKAGE_HOST_FLEX)$(BR2_PACKAGE_HOST_BISON),yy)
FLUENT_BIT_DEPENDENCIES += host-flex host-bison
FLUENT_BIT_CONF_OPTS += -DFLB_RECORD_ACCESSOR=ON -DFLB_STREAM_PROCESSOR=ON
else
FLUENT_BIT_CONF_OPTS += -DFLB_RECORD_ACCESSOR=OFF -DFLB_STREAM_PROCESSOR=OFF
endif

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),)
FLUENT_BIT_DEPENDENCIES += musl-fts
FLUENT_BIT_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-lfts
endif

define FLUENT_BIT_INSTALL_CONF
    mkdir -p $(TARGET_DIR)/etc/fluent-bit
    $(INSTALL) -m 0644 -D $(@D)/conf/fluent-bit.conf \
      $(TARGET_DIR)/etc/fluent-bit/fluent-bit.conf
    $(INSTALL) -m 0644 -D $(@D)/conf/plugins.conf \
      $(TARGET_DIR)/etc/fluent-bit/plugins.conf
endef

FLUENT_BIT_POST_INSTALL_TARGET_HOOKS += FLUENT_BIT_INSTALL_CONF

$(eval $(cmake-package))

