inherit qimage ${@bb.utils.contains('MACHINE_FEATURES', 'nand-boot','qimage-tele-squashfs-ubi', '',d)} populate_sdk_qti ${@bb.utils.contains('MACHINE_FEATURES', 'dm-verity-initramfs-v4', 'dm-verity-initramfs-v4 qramdisk', '', d)}

MLIBPREFIX ?= ""

# Set the build time as timestamp
REPRODUCIBLE_TIMESTAMP_ROOTFS = ""

CORE_IMAGE_BASE_INSTALL = '\
    ${MLIBPREFIX}packagegroup-core-boot \
    ${MLIBPREFIX}packagegroup-base-extended \
    \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    '

IMAGE_FEATURES += " \
        read-only-rootfs ${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'persist-volume', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'tele-squashfs-ubi', 'modem-volume', '', d)} \
        ${@bb.utils.contains('COMBINED_FEATURES', 'qti-nad-telaf', 'telaf-volume', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-tele-lxc', 'lxcrootfs-volume', '', d)} \
"

IMAGE_FEATURES:append:sa510m = " \
        ${@oe.utils.conditional('DEBUG_BUILD', '1', 'empty-root-password serial-autologin-root', '', d )} \
"

python () {
    if d.getVar('PREFERRED_VERSION_linux-msm') == "5.15":
        bb.build.addtask('do_merge_dtbs', 'do_makeboot', bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'do_makesystem_ubi', 'do_makesystem', d), d)
        bb.build.addtask('do_copy_abl', 'do_image_complete', 'do_makeboot', d)
}

do_merge_dtbs() {
    install -d ${DEPLOY_DIR_IMAGE}/build-artifacts/techpack-dtbos
    cd ${WORKSPACE}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform && \
    LD_LIBRARY_PATH=../out/msm-kernel-${MACHINE}-${KERNEL_VARIANT}defconfig/host/lib/:LD_LIBRARY_PATH \
    OUT_DIR=${KERNEL_OUT_PATH}/ \
    BUILD_CONFIG=${KERNEL_BUILD_CONFIG}  \
    ./build/android/merge_dtbs.sh \
    ${DEPLOY_DIR_IMAGE}/build-artifacts/dtb \
    ${DEPLOY_DIR_IMAGE}/build-artifacts/techpack-dtbos ${DEPLOY_DIR_IMAGE}/dtbs
}
do_merge_dtbs[depends] += "virtual/kernel:do_deploy"

do_copy_abl[dirs] = "${DEPLOY_DIR_IMAGE}"
do_copy_abl() {
    if [ -f ${KERNEL_PREBUILT_DISTDIR}/abl_userdebug.elf ]; then
        install -m 0644 ${KERNEL_PREBUILT_DISTDIR}/abl_userdebug.elf ${DEPLOY_DIR_IMAGE}/${PN}/abl_userdebug.elf
    fi
}

TOOLCHAIN_TARGET_TASK += "sensor-hal-daemon-hdr telux"

TOOLCHAIN_TARGET_TASK:sa510m:remove += "sensor-hal-daemon-hdr telux"

# Remove unsupported SDK packages
TOOLCHAIN_TARGET_TASK:remove = "ath6kl-utils-staticdev"
TOOLCHAIN_TARGET_TASK:remove = "kernel-devsrc"

# Exclude packages
PACKAGE_EXCLUDE += "kernel-dev"

# Modem is a partition on SA510M
IMAGE_FEATURES:remove:sa510m = "modem-volume"
