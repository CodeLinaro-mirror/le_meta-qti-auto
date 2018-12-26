
require ../common-auto-image.inc

EXTRA_IMAGECMD_ext4 = "-i 4096 -b 4096"

IMAGE_ROOTFS_SIZE = "1048576"

IMAGE_INSTALL += "edk2"
IMAGE_INSTALL += "pciutils"

IMAGE_INSTALL += "systemd-machine-units"
IMAGE_INSTALL += "start-script-ab-slot-util"

IMAGE_INSTALL += "packagegroup-ros-qti"
