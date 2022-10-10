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

inherit autotools-brokensep pkgconfig module

EXTRA_OECONF_append = " \
                --with-kernel=${STAGING_KERNEL_BUILDDIR} \
                --with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include \
                "
FILESPATH =+ "${WORKSPACE}:"
FILES_${PN} += "${libdir}/modules/*"

RPROVIDES_${PN} += "mvm-dlkm"
