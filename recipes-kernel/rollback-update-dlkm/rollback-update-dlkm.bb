DESCRIPTION = "Anti Rollback update driver for accessing TZ and check the fuse   \
    for current stored ARB index"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

inherit module linux-kernel-base

PR = "r0"

DEPENDS = "securemsmdlkm-headers"

do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_compile[lockfiles] = "${TMPDIR}/techpack-dtbs-compile.lock"

FILESPATH   =+ "${WORKSPACE}:"
SRC_URI = "file://vendor/qcom/opensource/nad-core-kernel/rollback-update"

S = "${WORKDIR}/vendor/qcom/opensource/nad-core-kernel/rollback-update"

EXTRA_OEMAKE += "TARGET_SUPPORT=${BASEMACHINE}"

do_compile() {

    cd ${WORKSPACE}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform
    export SMC_HDR_PATH="${RECIPE_SYSROOT}/usr/include"

    BUILD_CONFIG=${KERNEL_BUILD_CONFIG} \
    EXT_MODULES=../../vendor/qcom/opensource/nad-core-kernel/rollback-update \
    ROOTDIR=${WORKSPACE}/vendor/qcom/opensource/nad-core-kernel/rollback-update \
    MODULE_OUT=${WORKDIR}/ \
    OUT_DIR=${KERNEL_OUT_PATH}/ \
    ./build/build_module.sh
}

do_install() {
    ${STRIP} --strip-debug ${WORKDIR}/rollback_update.ko

    LD_LIBRARY_PATH=${WORKSPACE}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform/prebuilts/kernel-build-tools/linux-x86/lib64/ \
        ${STAGING_KERNEL_BUILDDIR}/scripts/sign-file sha1 ${STAGING_KERNEL_BUILDDIR}/certs/signing_key.pem \
        ${STAGING_KERNEL_BUILDDIR}/certs/signing_key.x509 ${WORKDIR}/rollback_update.ko

    install -m 0755 ${WORKDIR}/rollback_update.ko -D ${D}${nonarch_libdir}/modules/rollback_update.ko
}

RPROVIDES:${PN} += "kernel-module-rollback-update-${KERNEL_VERSION}"
FILES:${PN} += "${nonarch_libdir}/modules/*"
