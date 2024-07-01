inherit pkgconfig qprebuilt

DESCRIPTION = "Bitbake recipe for QDL application. QDL is used to flash image \
using Sahara protocol / Firehose protocol."
HOMEPAGE = "https://git.codelinaro.org/explore/"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS += "glib-2.0 libxml2 libusb1"

FILESPATH =+ "${WORKSPACE}:"
BRANCH = "qdl/scorching/master"
SRCREV = "aeb70e0645d6583b34b99c3025ebd2b8475d322b"
SRC_URI = "git://git.codelinaro.org/clo/qsdk/oss/tools/qdl.git;protocol=https;branch=${BRANCH}"
SRC_URI += "file://0001-qdl-Change-usb-macro.patch"
SRC_URI += "file://0001-qdl-Modify-Makefile.patch"
SRC_URI += "file://0001-qdl-Remove-sahara-for-pcie-channel.patch"
SRC_URI += "file://0001-qdl-Add-support-for-pcie-channel.patch"
S = "${WORKDIR}/git"

do_install:append() {
    install -d ${D}/usr/sbin/
    install -m 0555 ${S}/qdl ${D}/usr/sbin/qdl
}
