# Add packages on top of root file system
# Reference "meta-qti-bsp/recipes-products/image/commone/common-base-image.inc"

require recipes-platform/images/agl-demo-platform.bb

IMAGE_INSTALL += "edk2"
IMAGE_INSTALL += "pciutils"
IMAGE_INSTALL += "systemd-machine-units"
IMAGE_INSTALL += "start-script-ab-slot-util"
IMAGE_INSTALL += "binder"

# Add iproute2 module
IMAGE_INSTALL += "iproute2"
IMAGE_INSTALL += "iproute2-tc"
IMAGE_INSTALL += "iproute2-ss"
IMAGE_INSTALL += "iperf3"
IMAGE_INSTALL += "ethtool"
IMAGE_INSTALL += "tcpdump"
IMAGE_INSTALL += "vlan"
IMAGE_INSTALL += "bridge-utils"
IMAGE_INSTALL += "connman"

IMAGE_INSTALL += "system-core-adbd"
IMAGE_INSTALL += "system-core-usb"
IMAGE_INSTALL += "emac-dwc-eqos"
IMAGE_INSTALL += "open-avb"
IMAGE_INSTALL += "python"
IMAGE_INSTALL += "resize-service"

IMAGE_INSTALL_remove += "system-conf"
