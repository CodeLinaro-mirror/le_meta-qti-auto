BASEMACHINE ?= "sa510m"
require conf/machine/include/basemachine.inc

DEFAULTTUNE ?= "armv7athf-neon"
include conf/machine/include/arm/arch-armv7a.inc

PREFERRED_PROVIDER_virtual/kernel = "linux-msm"
PREFERRED_PROVIDER_virtual/mkbootimg-native = "mkbootimg-gki-native"
PREFERRED_PROVIDER_virtual/dtc-native = "dtc-android-build-native"
PREFERRED_PROVIDER_virtual/mkdtimg-native = "mkdtimg-gki-native"
PREFERRED_PROVIDER_virtual/refpolicy = "refpolicy-mls-auto"
PREFERRED_VERSION_linux-msm = "6.6"
PREFERRED_VERSION_linux-msm-headers = "6.6"
PREFERRED_VERSION_kernel-toolchain = "6.6"
PREFERRED_VERSION_kernel-toolchain-native = "6.6"
PREFERRED_VERSION_mod-signing-keys = "6.6"
PREFERRED_VERSION_dtc-android-build = "6.6"
PREFERRED_VERSION_mkbootimg-gki-native = "6.6"
PREFERRED_VERSION_dtc-android-build-native = "6.6"
PREFERRED_VERSION_mkdtimg-gki-native = "6.6"
PREFERRED_VERSION_securemsmdlkm = "1.1"
PREFERRED_VERSION_audiodevicetree = "6.6"
PREFERRED_VERSION_cta = "1.1"
PREFERRED_VERSION_avbtool = "git"
PREFERRED_VERSION_avbtool-native = "git"

SERIAL_CONSOLES = "115200;ttyMSM0"
KERNEL_IMAGETYPE = "zImage"
KERNEL_BASE = "0xa8000000"
KERNEL_TAGS_OFFSET = "0x1e00000"
KERNEL_CONFIG ?= "vendor/sa510_defconfig"
KERNEL_CONFIG:qti-distro-debug ?= "vendor/sa510-debug_defconfig"
CONSOLE_PARAM ?= "console=ttyMSM0,115200,n8 "
CONSOLE_PARAM:qti-distro-perf ?= "console=ttyMSM0,115200,n8 loglevel=0 systemd.log_level=0 systemd.show_status=0"
IPC_LOGGING_PARAM ?= ""
IPC_LOGGING_PARAM:qti-distro-debug ?= "qcom_ipc_logging.enabled=1"
KERNEL_CMD_PARAMS = "ro rootwait ${CONSOLE_PARAM} androidboot.console=ttyMSM0 lpm_levels.sleep_disabled=1 firmware_class.path=/data/firmware/image,/lib/firmware/updates,/vm-bootsys/boot service_locator.enable=1 net.ifnames=0 ${IPC_LOGGING_PARAM}"
KERNEL_VARIANT ??= ""
KERNEL_VARIANT:qti-distro-debug ??= "debug_"
KERNEL_VARIANT:qti-distro-perf ??= "perf_"
KERNEL_DTB_NAMES = "dtb.img"
KERNEL_TYPE = "msm-kernel"

MACHINE_USES_KERNEL_PREBUILTS = "True"
KERNEL_PLATFORM_PATH = "${WORKSPACE}/kernel-6.6/kernel_platform"
KERNEL_PREBUILT_PATH ?= "${WORKSPACE}/kernel-6.6/out/msm-kernel-sa510m-${KERNEL_VARIANT}defconfig/"
KERNEL_PREBUILT_DISTDIR = "${KERNEL_PREBUILT_PATH}/dist"
KERNEL_OUT_PATH ?= "${KERNEL_PREBUILT_PATH}"
KERNEL_BUILD_CONFIG ?= "msm-kernel/build.config.msm.sa510m"

KERNEL_DEFCONFIG = "msm-kernel-sa510m-${KERNEL_VARIANT}defconfig"

# MACHINE_FEATURES ##
# qti-adsp:               Machine supports QTI adsp solution
# qti-cdsp:               Machine supports QTI cdsp solution
# qti-ab-boot:            Machine supports a/b boot
# qti-security:           Machine supports QTI security solution
# qti-wifi:               Machine supports QTI WiFi solution
# qti-audio:              Machine supports QTI audio solution
# qti-bluetooth:          Machine supports QTI bluetooth solution
# qti-sensors:            Machine supports sensors qti solution
# qti-location:           Machine supports Location solution
# qti-data-modem:         Machine supports QTI data modem solution
# qti-mvm:                Machine supports QTI MVM solution
# qseecompat:             Machine supports qseecom compat solution
# qti-tzlog:              Machine supports tz/qsee logs
# qti-smciqseecomd:       Machine supports smcinvoke based listeners
# android-binder:         Machine supports android binder
# dm-verity-initramfs-v4: Machine supports Initramfs and dm-verity working with AVB
# qti-nad-telaf:          Machine supports telematics application framework
# qti-nad-mrc             Machine supports mrcd feature

MACHINE_FEATURES += "qti-sdx dm-verity-initramfs-v4 qti-security qseecompat qti-tzlog qti-smciqseecomd gptee ssgtzd ta_autoload android-binder tele-squashfs-ubi qti-location qti-wlan qti-sensors qti-audio qti-data-modem qti-bluetooth qwesd"

# For sdk toolcahin
DISTRO_FEATURES_NATIVESDK += " dm-verity-initramfs-v4"

#CONFLICT_MACHINE_FEATURES += "qti-cv2x"

MACHINE_MNT_POINTS = " \
    /firmware \
    /systemrw \
    /persist \
    /data \
"

PAGE_SIZE ?= '4096'
EXTRA_IMAGECMD ?= "-N 2048"

MACHINE_SUPPORTS_DTBO = "False"
MACHINE_SUPPORTS_PDMAPPER = "False"
MACHINE_SUPPORTS_INIT_RAMDISK = "False"
TOYBOX_RAMDISK = "False"
MACHINE_SUPPORTS_ANDROID_PROPERTIES = "False"

USBCOMPOSITION = "90B8"

# On msm-5.4 or above ufs driver supports BSG Device.
UFS_BSG_DEV_USAGE = "True"

# Fixes for boot image dtb appending
BOOT_HEADER_VERSION = "2"

# Enable debug configuration for post-boot recipe
PACKAGECONFIG:append:pn-post-boot = "debug"

INHERIT:remove = "uninative"

# Disable autosuspend for USB peripheral mode
MACHINE_SUPPORTS_USB_AUTOSUSPEND = "False"

# Disable display dependency
MACHINE_SUPPORTS_DISPLAY = "False"

INHERIT += "utils base patch staging"
USER_CLASSES += "staging base"

BBMASK += " meta-qti-bsp/meta-qti-customizations/core/recipes-devtools/subversion/subversion_%.bbappend \
            meta-qti-bsp/meta-qti-customizations/core/recipes-devtools/rpm/rpm_%.bbappend \
            meta-qti-bsp/meta-qti-customizations/core/recipes-devtools/e2fsprogs/e2fsprogs_%.bbappend \
            meta-qti-bsp/meta-qti-customizations/core/recipes-kernel/dtc/dtc_%.bbappend \
            meta-qti-bsp/recipes-kernel/kmod/kmod_%.bbappend \
            meta-qti-bsp/recipes-core/ncurses/ncurses_%.bbappend \
            meta-qti-bsp/recipes-devtools/squashfs-tools/squashfs-tools_git.bbappend \
            meta-qti-auto/recipes-core/zlib/zlib_%.bbappend \
            meta-qti-bsp/meta-qti-customizations/core/recipes-devtools/binutils/* \
            meta-qti-bsp/meta-qti-customizations/core/recipes-devtools/perl/perl_%.bbappend \
            meta-qti-bsp/recipes-connectivity/chrony/chrony_2.4.bb \
            meta-qti-auto/recipes-extended/lxc/busybox-init.bb \
          "
