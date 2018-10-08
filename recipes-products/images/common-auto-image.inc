# Add packages on top of root file system
# Reference "meta-qti-bsp/recipes-products/image/commone/common-base-image.inc"

IMAGE_INSTALL += "system-core-adbd"
IMAGE_INSTALL += "system-core-usb"

IMAGE_INSTALL_remove += "system-conf"