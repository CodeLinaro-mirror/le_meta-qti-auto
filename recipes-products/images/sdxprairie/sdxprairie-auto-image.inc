# Auto open source Packages
IMAGE_INSTALL += "chrony"
IMAGE_INSTALL += "chronyc"
IMAGE_INSTALL += "libsensors"
IMAGE_INSTALL += "sensor-hal-daemon"
IMAGE_INSTALL += "sensor-client-api"
IMAGE_INSTALL += "sensor-socket"
IMAGE_INSTALL += "open-avb"
IMAGE_INSTALL += "telux-lib"
IMAGE_INSTALL += "telux-samples"
IMAGE_INSTALL += "telux-services-ril"
IMAGE_INSTALL += "start-scripts-init-can"
IMAGE_INSTALL += "nbd-client"
IMAGE_INSTALL += "vnw-eth-switch"

# Test tools
IMAGE_INSTALL += "can-utils"
IMAGE_INSTALL += "i2c-tools"
IMAGE_INSTALL += "net-tools"
IMAGE_INSTALL += "pps-tools"
IMAGE_INSTALL += "spitools"
IMAGE_INSTALL += "sensor-client-api-testapp"

IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'keyutils', '',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'ima-evm-utils', '',d)}"
IMAGE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'attr', '',d)}"

# Target SDK Packages
TOOLCHAIN_TARGET_TASK_append_sa515m += "telux"
TOOLCHAIN_TARGET_TASK_append_sa515m += "sensor-hal-daemon-hdr"
TOOLCHAIN_TARGET_TASK_append_sa515m += "sensor-client-api"
