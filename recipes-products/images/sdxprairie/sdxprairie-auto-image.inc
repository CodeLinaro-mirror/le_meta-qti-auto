# Auto open source Packages
IMAGE_INSTALL += "chrony"
IMAGE_INSTALL += "chronyc"
IMAGE_INSTALL += "libsensors"
IMAGE_INSTALL += "sensor-hal-daemon"
IMAGE_INSTALL += "sensor-client-api"
IMAGE_INSTALL += "sensor-socket"
IMAGE_INSTALL += "sensor-util-lib"
IMAGE_INSTALL += "open-avb"
IMAGE_INSTALL += "telux-lib"
IMAGE_INSTALL += "telux-samples"
IMAGE_INSTALL += "telux-services-ril"
IMAGE_INSTALL += "start-scripts-init-can"
IMAGE_INSTALL += "nbd-client"
IMAGE_INSTALL += "vnw-eth-switch"
IMAGE_INSTALL += "mosquitto"

# Test tools
IMAGE_INSTALL += "can-utils"
IMAGE_INSTALL += "i2c-tools"
IMAGE_INSTALL += "net-tools"
IMAGE_INSTALL += "pps-tools"
IMAGE_INSTALL += "spitools"
IMAGE_INSTALL += "sensor-client-api-testapp"
IMAGE_INSTALL += "sensor-util-testapp"

IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'keyutils', '',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'ima-evm-utils', '',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'attr', '',d)}"

# Target SDK Packages
TOOLCHAIN_TARGET_TASK_append_sa515m += "telux"
TOOLCHAIN_TARGET_TASK_append_sa515m += "sensor-hal-daemon-hdr"
TOOLCHAIN_TARGET_TASK_append_sa515m += "sensor-client-api"

# Stream update
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update','libevent','',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update','libchrome','',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update','libbrillo','',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update','libalzma','',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update','libxz','',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update','libbspatch','',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES','nad-stream-update', 'stream-update', '', d)}"
