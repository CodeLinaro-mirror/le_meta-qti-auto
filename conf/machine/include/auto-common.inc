
include conf/machine/include/basemachine.inc

SOC_FAMILY ?= "sa8155"
include conf/machine/include/soc-family.inc

# Pull in security flags
require ${COREBASE}/meta-qti-bsp/conf/distro/include/security_flags.inc

include conf/machine/include/arm/arch-armv8.inc


PREFERRED_PROVIDER_virtual/kernel = "linux-msm"
PREFERRED_VERSION_linux-msm = "4.14"

MACHINE_DISPLAY_WIDTH_PIXELS ?= "480"
MACHINE_DISPLAY_HEIGHT_PIXELS ?= "640"

SERIAL_CONSOLE ?= "${@['', '115200 ttyMSM0'][d.getVar('VARIANT', True) == ('' or 'debug')]}"

DISTRO ?= "automotive"

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

KERNEL_DTS_NAME = "qcs405-rumi"
KERNEL_BASE = "0x80000000"
KERNEL_TAGS_OFFSET = "0x1e00000"
KERNEL_CONFIG = "${@['qcs405-perf_defconfig', 'qcs405_defconfig'][d.getVar('VARIANT', True) == ('' or 'debug')]}"

KERNEL_CMD_PARAMS ?= "noinitrd ro rootwait console=ttyMSM0,115200,n8 no_console_suspend=1 androidboot.hardware=qcom androidboot.console=ttyMSM0 lpm_levels.sleep_disabled=1"
