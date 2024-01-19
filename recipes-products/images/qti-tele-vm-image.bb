inherit qimage qramdisk qimage-vm

DEPENDS += "virtual/kernel"

ENABLE_SECUREMSM = "${@d.getVar('MACHINE_SUPPORTS_SECUREMSM') or "True"}"

CORE_IMAGE_BASE_INSTALL = '\
    ${MLIBPREFIX}packagegroup-core-boot \
    ${MLIBPREFIX}packagegroup-base-extended \
    \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    '

CORE_IMAGE_EXTRA_INSTALL += " \
    ${MLIBPREFIX}coreutils \
    ${MLIBPREFIX}sdcard-scripts-automount \
    ${MLIBPREFIX}e2fsprogs-mke2fs \
    ${MLIBPREFIX}packagegroup-android-utils \
    ${MLIBPREFIX}packagegroup-qti-core-vm \
    ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', '${MLIBPREFIX}packagegroup-selinux-minimal', '', d)} \
    ${@oe.utils.conditional('ENABLE_SECUREMSM', 'True', '${MLIBPREFIX}packagegroup-qti-securemsm', '', d)} \
    ${MLIBPREFIX}post-boot \
    ${MLIBPREFIX}libgpiod ${MLIBPREFIX}libgpiod-tools \
    ${MLIBPREFIX}systemd-machine-units \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-location', '${MLIBPREFIX}packagegroup-qti-location-vm', '', d)} \
    ${MLIBPREFIX}packagegroup-qti-telematics \
    ${MLIBPREFIX}packagegroup-qti-data-vm \
    ${@bb.utils.contains('DISTRO_FEATURES', 'qti-telux', '${MLIBPREFIX}packagegroup-qti-telsdk', '', d)} \
    ${MLIBPREFIX}packagegroup-support-utils \
"

# Exclude packages
PACKAGE_EXCLUDE += "readline"

ROOTFS_POSTPROCESS_COMMAND_remove = " do_fsconfig;"
USE_DEPMOD = "0"
