
include conf/machine/include/basemachine.inc

SOC_FAMILY ?= "sa8155"
include conf/machine/include/soc-family.inc

# Pull in security flags
require ${COREBASE}/meta-qti-bsp/conf/distro/include/security_flags.inc

include conf/machine/include/arm/arch-armv8.inc

TMPDIR = "${TOPDIR}/tmp-glibc"

PREFERRED_PROVIDER_virtual/kernel = "linux-msm"
PREFERRED_VERSION_linux-msm = "4.14"

# Prefer tcpdump 4.9.x by default
PREFERRED_VERSION_tcpdump              ?= "4.9.%"

# Wayland/Weston
PREFERRED_VERSION_weston = "1.9.0"
PREFERRED_VERSION_wayland = "1.9.0"
PREFERRED_VERSION_wayland-native = "1.9.0"
PREFERRED_VERSION_wayland-ivi-extension = "1.9.1"

MACHINE_DISPLAY_WIDTH_PIXELS ?= "480"
MACHINE_DISPLAY_HEIGHT_PIXELS ?= "640"

SERIAL_CONSOLE ?= "${@['', '115200 ttyMSM0'][d.getVar('VARIANT', True) == ('' or 'debug')]}"

DISTRO ?= "automotive"

EXTRA_IMAGE_FEATURES = "tools-debug"

# DISTRO_FEATURES_append = " ro-rootfs"

# Use systemd init manager.
DISTRO_FEATURES_remove = "sysvinit"
DISTRO_FEATURES_append = " systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"
VIRTUAL-RUNTIME_dev_manager = "udev"
VIRTUAL-RUNTIME_init_manager = "systemd"

# Change Image features for systemd.
IMAGE_DEV_MANAGER = "udev"
IMAGE_INIT_MANAGER = "systemd"
IMAGE_INITSCRIPTS = ""

PAGE_SIZE ?= '4096'

MACHINE_FEATURES += "kernel26 keyboard"
