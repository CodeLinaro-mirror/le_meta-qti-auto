inherit kernel-arch pkgconfig multilib_header

SUMMARY = "CLO Linux Kernel Headers"
DESCRIPTION = "Installs MSM kernel headers required to build userspace. \
These headers are installed in ${includedir}/linux-msm path."
LICENSE = "GPLv2.0-with-linux-syscall-note"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

#FILESEXTRAPATHS:prepend := "${WORKSPACE}:${KERNEL_PREBUILT_PATH}:"
FILESPATH =+ "${WORKSPACE}:"

SRC_URI   =  "file://kernel-${PV}/kernel_platform/msm-kernel"

S  =  "${WORKDIR}/kernel-${PV}/kernel_platform/msm-kernel"

DEPENDS = "rsync-native"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_populate_kernel_header_artifacts() {
    mkdir -p ${B}/headers
    cp -a ${WORKDIR}/kernel_uapi_headers/usr/ ${B}/headers/
}

# addtask do_populate_kernel_header_artifacts after do_compile before do_install

do_install () {
	oe_runmake headers_install INSTALL_HDR_PATH=${D}${includedir}/linux-msm/usr/
	# Kernel should not be exporting this header
	rm -f ${D}${exec_prefix}/include/scsi/scsi.h

	# The ..install.cmd conflicts between various configure runs
	find ${D}${includedir} -name ..install.cmd | xargs rm -f

}

# kernel headers are generally machine specific
PACKAGE_ARCH = "${MACHINE_ARCH}"

# Allow to build empty main package, to include -dev package into the SDK
ALLOW_EMPTY:${PN} = "1"

FILES:${PN}-dev += "linux-msm/*"

INHIBIT_DEFAULT_DEPS = "1"
