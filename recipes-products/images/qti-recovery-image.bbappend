
DEPENDS += "squashfs-tools-native binutils-cross-arm"

RECOVERYFS_SQUASHFS_IMAGE = "recoveryfs.squashfs"

RECOVERYFS_SQUASHFS_UBI_IMAGE = "recoveryfs-squashfs.ubi"

RECOVERYFS_SQUASHFS_UBINIZE_CFG = "ubinize-recoveryfs-squashfs.cfg"

KERNEL_VERSION = "${@oe.utils.read_file('${STAGING_KERNEL_BUILDDIR}/kernel-abiversion')}"

do_create_recoveryfs_squashfs[prefuncs] += "update_usb_composition"
do_create_recoveryfs_squashfs[prefuncs] += "generate_public_key"
do_create_recoveryfs_squashfs[prefuncs] += "create_system_dir"
do_create_recoveryfs_squashfs[prefuncs] += "create_recoveryfs_squashfs_ubinize_config"
do_create_recoveryfs_squashfs[dirs] = "${IMGDEPLOYDIR}"

create_recoveryfs_squashfs_ubinize_config[dirs] = "${IMGDEPLOYDIR}"
create_recoveryfs_squashfs_ubinize_config() {
    echo \[recoveryfs_volume\] > "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo mode=ubi >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo image="${RECOVERYFS_SQUASHFS_IMAGE}" >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_id=0 >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_type=dynamic >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_name=recoveryfs >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
    echo vol_flags=autoresize >> "${RECOVERYFS_SQUASHFS_UBINIZE_CFG}"
}

do_copy_dlkm_to_recoveryfs_squashfs() {
    install -m 0755 ${DEPLOY_DIR_IMAGE}/kernel_modules/mtd_blkdevs.ko  -D ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/mtd_blkdevs.ko
    install -m 0755 ${DEPLOY_DIR_IMAGE}/kernel_modules/mtdblock.ko  -D ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/mtdblock.ko
    install -m 0755 ${DEPLOY_DIR_IMAGE}/kernel_modules/gluebi.ko  -D ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/gluebi.ko

    ${STRIP} --strip-debug ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/mtd_blkdevs.ko
    ${STRIP} --strip-debug ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/mtdblock.ko
    ${STRIP} --strip-debug ${IMAGE_ROOTFS}/lib/modules/${KERNEL_VERSION}/gluebi.ko
}

fakeroot do_create_recoveryfs_squashfs() {
    if [ "${BASEMACHINE}" = "sa510m" ]; then
        do_copy_dlkm_to_recoveryfs_squashfs
        rm -rf ${IMAGE_ROOTFS}/cache
        ln -sf /data/cache ${IMAGE_ROOTFS}/cache
    fi

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
