# Add packages on top of root file system
# Reference "meta-qti-bsp/recipes-products/image/commone/common-base-image.inc"

# Add iproute2 module
IMAGE_INSTALL += "iproute2"
IMAGE_INSTALL += "iproute2-tc"
IMAGE_INSTALL += "iproute2-ss"

IMAGE_INSTALL += "system-core-adbd"
IMAGE_INSTALL += "system-core-usb"
IMAGE_INSTALL += "emac-dwc-eqos"

IMAGE_INSTALL_remove += "system-conf"
