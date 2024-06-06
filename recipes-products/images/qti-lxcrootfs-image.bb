inherit core-image

# This creates lxcrootfs which will be used with container

do_image_ext4[noexec] = "1"
do_image_ubi[noexec] = "1"
do_image_ubifs[noexec] = "1"
do_image_multiubi[noexec] = "1"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

DEPENDS += "squashfs-tools-native \
            ${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'mtd-utils-native', '', d)} \
            refpolicy-mls-auto"

LXCRFSIMAGE_UBIFS ?= "${IMGDEPLOYDIR}/lxcrootfs.ubifs"
LXCRFSIMAGE_SQUASHFS ?= "${IMGDEPLOYDIR}/lxcrootfs.squash"
SELINUX_FILE_CONTEXTS_LXC ?= "${STAGING_DIR_HOST}/etc/selinux/mls/contexts/files/file_contexts"

CORE_IMAGE_BASE_INSTALL = '\
     ${CORE_IMAGE_EXTRA_INSTALL} \
     '

CORE_IMAGE_EXTRA_INSTALL = "\
     packagegroup-qti-lxc-con \
"
# Use busybox as login manager
IMAGE_LOGIN_MANAGER = "busybox-static"

# Include minimum init and init scripts
IMAGE_DEV_MANAGER = "udev"
IMAGE_INIT_MANAGER = "none"
IMAGE_INITSCRIPTS ?= ""

IMAGE_LINGUAS = ""

# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

remove_opkg_files () {
    rm -rf ${IMAGE_ROOTFS}/usr/lib/opkg/
    rm -rf ${IMAGE_ROOTFS}/usr/share/
    rm -rf ${IMAGE_ROOTFS}/var/lib/opkg/info/
}

fakeroot do_create_lxcrootfs_ubifs() {
   mkfs.ubifs -r ${IMAGE_ROOTFS} -o ${LXCRFSIMAGE_UBIFS} ${MKUBIFS_ARGS}
}

fakeroot do_create_lxcrootfs_squash() {
    #create lxcrootfs squash image
    if [[ "${DISTRO_FEATURES}" =~ "selinux" ]] ; then
        mksquashfs ${IMAGE_ROOTFS} ${LXCRFSIMAGE_SQUASHFS} -context-file ${SELINUX_FILE_CONTEXTS_LXC} -noappend -comp xz -Xdict-size 32K -noI -Xbcj arm -b 65536 -processors 1
    else
        mksquashfs ${IMAGE_ROOTFS} ${LXCRFSIMAGE_SQUASHFS} -noappend -comp xz -Xdict-size 32K -noI -Xbcj arm -b 65536 -processors 1
    fi

}
ROOTFS_POSTPROCESS_COMMAND += "remove_opkg_files;"

python () {
     bb.build.addtask('do_create_lxcrootfs_ubifs', 'do_image_complete', 'do_image', d)
     bb.build.addtask('do_create_lxcrootfs_squash', 'do_image_complete', 'do_create_lxcrootfs_ubifs', d)
}
