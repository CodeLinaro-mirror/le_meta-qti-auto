# Auto OPEN SOURCE PACKAGES
include ${BASEMACHINE}/${BASEMACHINE}-auto-image.inc

do_update_permissions() {
    # Change file permissions for sa2150p-nand
    if ${@bb.utils.contains('MACHINE', 'sa2150p-nand', 'true', 'false', d)}; then
        chmod 644 ${IMAGE_ROOTFS}/etc/passwd
    fi
}

ROOTFS_POSTPROCESS_COMMAND += " do_update_permissions; "
IMAGE_INSTALL += "libsensors"
IMAGE_INSTALL += "sensor-socket"
IMAGE_INSTALL += "sensor-client-api-testapp"
IMAGE_INSTALL += "boost"
