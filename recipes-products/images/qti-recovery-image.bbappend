
DEPENDS += "squashfs-tools-native"

RECOVERYFS_SQUASHFS_IMAGE = "recoveryfs.squashfs"

RECOVERYFS_SQUASHFS_UBI_IMAGE = "recoveryfs-squashfs.ubi"

RECOVERYFS_SQUASHFS_UBINIZE_CFG = "ubinize-recoveryfs-squashfs.cfg"

do_create_recoveryfs_squashfs[prefuncs] += "update_usb_composition"
do_create_recoveryfs_squashfs[prefuncs] += "generate_public_key"
do_create_recoveryfs_squashfs[prefuncs] += "create_system_dir"
do_create_recoveryfs_squashfs[prefuncs] += "create_recoveryfs_squashfs_ubinize_config"
do_create_recoveryfs_squashfs[dirs] = "${IMGDEPLOYDIR}"

create_recoveryfs_squashfs_ubinize_config() {
    echo \[recoveryfs_volume\] > "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo mode=ubi >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo image="${RECOVERYFS_SQUASHFS_IMAGE}" >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_id=0 >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_type=dynamic >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_name=recoveryfs >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_flags=autoresize >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
}

fakeroot do_create_recoveryfs_squashfs() {

    #if ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'true', 'false', d)}; then
    #    mksquashfs ${IMAGE_ROOTFS} ${RECOVERYFS_SQUASHFS_IMAGE} -context-file ${SELINUX_FILE_CONTEXTS} -noappend -comp xz
    #else
         mksquashfs ${IMAGE_ROOTFS} ${RECOVERYFS_SQUASHFS_IMAGE} -noappend -comp xz
    #fi

    ubinize -o ${RECOVERYFS_SQUASHFS_UBI_IMAGE} ${UBINIZE_ARGS} ${RECOVERYFS_SQUASHFS_UBINIZE_CFG}
    chmod 644 ${RECOVERYFS_SQUASHFS_UBI_IMAGE}
}

python () {
    bb.build.addtask('do_create_recoveryfs_squashfs', 'do_image_complete', 'do_image', d)
}
