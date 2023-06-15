SUMMARY = "QTI MVM driver"
DESCRIPTION = "MVM driver takes care of sending the CV2X messages \
for verification to MVM and sending the results back to userspace. \
This driver will be loaded as a module from the userspace"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = "virtual/kernel"

PR = "r1"

SRC_URI = "file://vendor/qcom/opensource/mvm-kernel/"

S = "${WORKDIR}/vendor/qcom/opensource/mvm-kernel"

inherit pkgconfig module systemd deploy

FILESPATH =+ "${WORKSPACE}:"

SYSTEMD_SERVICE_${PN} += "mvm_dlkm.service"

addtask deploy after do_install

do_compile() {

    cd ${WORKSPACE}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform  && \
    BUILD_CONFIG=${KERNEL_BUILD_CONFIG} \
    EXT_MODULES=../../vendor/qcom/opensource/mvm-kernel \
    ROOTDIR=${WORKSPACE}/ \
    MODULE_OUT=${WORKDIR}/vendor/qcom/opensource/mvm-kernel-out \
    OUT_DIR=${KERNEL_OUT_PATH}/ \
    ./build/build_module.sh
}


do_install() {
    install -d ${D}/usr/lib/modules/

    #Signing and installing the mvm module
    LD_LIBRARY_PATH=${WORKSPACE}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform/prebuilts/kernel-build-tools/linux-x86/lib64/ \
    ${STAGING_KERNEL_BUILDDIR}/scripts/sign-file sha1 ${STAGING_KERNEL_BUILDDIR}/certs/signing_key.pem \
    ${STAGING_KERNEL_BUILDDIR}/certs/signing_key.x509 ${WORKDIR}/vendor/qcom/opensource/mvm-kernel-out/mvm_dlkm.ko
    install -m 0755 ${WORKDIR}/vendor/qcom/opensource/mvm-kernel-out/mvm_dlkm.ko -D ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/mvm.ko

    #Install the mvm_dlkm service file
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${S}/mvm_dlkm.service -D ${D}${systemd_unitdir}/system/mvm_dlkm.service
}

# Copy kernel modules into image specific deploy directory.
do_deploy() {
    if ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-host', 'false', 'true', d)}; then
        install -d ${DEPLOYDIR}/kernel_modules/${PN}
        install -m 0644 ${WORKDIR}/vendor/qcom/opensource/mvm-kernel-out/mvm_dlkm.ko ${DEPLOYDIR}/kernel_modules/${PN}/mvm.ko
    fi
}

FILES_${PN} += "${libdir}/modules/*"
RPROVIDES_${PN} += "mvm-dlkm"

RM_WORK_EXCLUDE += "mvm-dlkm"
