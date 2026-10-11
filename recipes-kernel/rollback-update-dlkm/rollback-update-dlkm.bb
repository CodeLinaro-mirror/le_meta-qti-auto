DESCRIPTION = "Rollback update driver for accessing TZ and check the fuse for current stored ARB index"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

inherit linux-kernel-base

PR = "r0"

do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_compile[lockfiles] = "${TMPDIR}/build_modules.lock"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://vendor/qcom/opensource/nad-core-kernel/rollback-update"

S = "${WORKDIR}/vendor/qcom/opensource/nad-core-kernel/rollback-update"

EXT_KP_MODULES = "${@os.path.relpath("${S}", "${KERNEL_PLATFORM_PATH}")}"

SIGN_PATH = "${@bb.utils.contains('BASEMACHINE', 'sa510m', 'dist', \
               bb.utils.contains('MACHINE_FEATURES', 'qti-vm-target', 'dist', '../msm-kernel/certs', d), d)}"

CERT_PATH = "${@bb.utils.contains('BASEMACHINE', 'sa510m', 'dist', \
               bb.utils.contains('MACHINE_FEATURES', 'qti-vm-target', 'dist', '../msm-kernel/certs', d), d)}"

LD_PATH = "${@oe.utils.conditional('KERNEL_TOOLS_USES_MUSLC', 'True', \
            "${LD_PATH_MUSLC}", "${LD_PATH_GLIBC}", d)}"

STRIP_VERSION = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-target', '${KP_STRIP_VERSION}', '9.3.0', d)}"
GCCVER_AVAILABLE = "${@''.join(filter(lambda x: x != '%', '${GCCVERSION}'))}.0"
STRIP_VERSION = "${@bb.utils.contains_any('BASEMACHINE', 'sa510m', '13.3.0', '${GCCVER_AVAILABLE}', d)}"

TARGET_BOARD_PLATFORM ?= "${BASEMACHINE}"
TARGET_BOARD_PLATFORM:sa510m = "sa510m"
# If your MACHINE is named 'sa510m-1g', this maps the platform string to 'sa510m.1g'
TARGET_BOARD_PLATFORM:sa510m-1g = "sa510m.1g"

do_configure() {
    cp -f ${WORKSPACE}/vendor/qcom/opensource/nad-core-kernel/rollback-update/Makefile \
        ${WORKSPACE}/vendor/qcom/opensource/nad-core-kernel/rollback-update/Makefile.am
}

do_compile:sa510m() {
    variant="${@bb.utils.contains('DEBUG_BUILD', '1', 'debug', 'perf', d)}"

    cd ${KERNEL_PLATFORM_PATH}

    ENABLE_DDK_BUILD="true" \
    BUILD_CONFIG=${KERNEL_BUILD_CONFIG} \
    EXT_MODULES=../../vendor/qcom/opensource/nad-core-kernel/rollback-update \
    ROOTDIR=${WORKSPACE}/vendor/qcom/opensource/nad-core-kernel/rollback-update \
    KERNEL_KIT=${KERNEL_PREBUILT_PATH} \
    VARIANT=${variant}_defconfig \
    OUT_DIR=${KERNEL_OUT_PATH} \
    MODULE_OUT=${WORKDIR}/ \
    TARGET_BOARD_PLATFORM=${TARGET_BOARD_PLATFORM} \
    ./build/build_module.sh
}

do_strip_and_sign_modules() {
    ${STAGING_DIR_NATIVE}/usr/libexec/${TARGET_SYS}/gcc/${TARGET_SYS}/${STRIP_VERSION}/strip \
        --strip-debug ${WORKDIR}/rollback_update.ko

    TOOLS_LIB="${WORKSPACE}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform/prebuilts/kernel-build-tools/linux-x86/lib64"
    DIST_LIB="${KERNEL_PREBUILT_PATH}/${SIGN_PATH}"

    export LD_LIBRARY_PATH="${TOOLS_LIB}:${DIST_LIB}:${LD_LIBRARY_PATH}"

    ${KERNEL_PREBUILT_PATH}/${SIGN_PATH}/sign-file sha1 \
        ${KERNEL_PREBUILT_PATH}/${CERT_PATH}/signing_key.pem \
        ${KERNEL_PREBUILT_PATH}/${CERT_PATH}/signing_key.x509 \
        ${WORKDIR}/rollback_update.ko
}

python () {
    bb.build.addtask('do_strip_and_sign_modules', 'do_install', 'do_compile', d)
}

do_install() {
    install -d ${D}${libdir}/modules

    install -m 0755 ${WORKDIR}/rollback_update.ko \
        ${D}${libdir}/modules/rollback_update.ko
}

FILES:${PN} += "${libdir}/modules/*"
