require ../common-auto-image.inc

IMAGE_INSTALL_remove += "edk2"
IMAGE_INSTALL_remove += "packagegroup-multimedia"
IMAGE_INSTALL += "setup-network"
IMAGE_INSTALL_remove += "packagegroup-agl-demo-platform"

