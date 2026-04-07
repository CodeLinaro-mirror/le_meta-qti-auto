inherit kernel-arch pkgconfig multilib_header

SUMMARY = "CAF Linux Kernel Headers"
DESCRIPTION = "Installs MSM kernel headers required to build userspace. \
These headers are installed in ${includedir}/linux-msm path."
LICENSE = "GPLv2.0-with-linux-syscall-note"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

COMPATIBLE_MACHINE = "sa510m|sa510m-1g"

FILESEXTRAPATHS:prepend := "${WORKSPACE}:"

SRC_URI   =  "file://kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform/msm-kernel"

S  =  "${WORKDIR}/kernel-${PREFERRED_VERSION_linux-msm}/kernel_platform/msm-kernel"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_populate_kernel_header_artifacts() {
    mkdir -p ${B}/headers
    cp -a ${KERNEL_PREBUILT_DISTDIR}/kernel-uapi-headers.tar.gz ${B}/headers
    cd ${B}/headers
    tar -xvzf kernel-uapi-headers.tar.gz
    rm -f kernel-uapi-headers.tar.gz
}

addtask do_populate_kernel_header_artifacts after do_compile before do_install

do_install () {
    cd ${B}
    headerdir=${B}/headers
    kerneldir=${D}${includedir}/linux-msm
    install -d $kerneldir
    install -d ${D}${includedir}/linux

    if [ -d $headerdir/${includedir} ]; then
        mkdir -p $kerneldir/${includedir}
        cp -fR $headerdir/${includedir}/* $kerneldir/${includedir}
    fi

    # Copy IPA UAPI headers explicitly into the linux-msm vendor namespace
    # to avoid file-conflict with linux-libc-headers which owns ${includedir}/linux/
    if [ -d ${S}/include/uapi/linux ]; then
        install -m 0644 ${S}/include/uapi/linux/msm_ipa.h ${D}${includedir}/linux
        install -m 0644 ${S}/include/uapi/linux/rmnet_ipa_fd_ioctl.h ${D}${includedir}/linux
        install -m 0644 ${S}/include/uapi/linux/ipa_qmi_service_v01.h ${D}${includedir}/linux
    fi
}

# kernel headers are generally machine specific
PACKAGE_ARCH = "${MACHINE_ARCH}"

# Allow to build empty main package, to include -dev package into the SDK
ALLOW_EMPTY:${PN} = "1"

FILES:${PN}-dev += "linux-msm/*"

INHIBIT_DEFAULT_DEPS = "1"
