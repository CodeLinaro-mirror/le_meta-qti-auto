require ../common-auto-image.inc

IMAGE_INSTALL_remove += "edk2"
IMAGE_INSTALL_remove += "packagegroup-multimedia"
IMAGE_INSTALL += "setup-network"
IMAGE_INSTALL_remove += "packagegroup-agl-demo-platform"
IMAGE_INSTALL_remove += "iperf3"
IMAGE_INSTALL_remove += "mtd-utils-ubifs"

