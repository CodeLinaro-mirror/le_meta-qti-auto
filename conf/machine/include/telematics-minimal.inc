KERNEL_VARIANT:qti-distro-debug ??= "minimal_debug_"
KERNEL_VARIANT:qti-distro-perf ??= "minimal_perf_"

MACHINE_FEATURES:remove += "qti-wwan-plus-cv2x qti-cv2x-compensator qti-sensors qti-bluetooth qti-audio qti-location qti-wlan qti-tele-lxc qti-nad-fde"

FLAVOR = "minimal"

RDEPENDS:packagegroup-qti-data:remove = " \
	modem-monitor \
"

