inherit pkgconfig cmake

SUMMARY = "Telematics SDK Samples"
DESCRIPTION = "Telematics SDK Samples"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telux/public/"
S = "${WORKDIR}/telux/public/samples/"

SRCREV = "${AUTOREV}"

DEPENDS += "telux telux-lib"
