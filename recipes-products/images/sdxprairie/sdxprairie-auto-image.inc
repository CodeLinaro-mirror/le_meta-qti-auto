# Auto open source Packages
IMAGE_INSTALL += "chrony"
IMAGE_INSTALL += "chronyc"
IMAGE_INSTALL += "libsensors"
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

# Target SDK Packages
TOOLCHAIN_TARGET_TASK_append_sa515m += "telux"
