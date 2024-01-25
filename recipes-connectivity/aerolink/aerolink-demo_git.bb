inherit cmake

DESCRIPTION = "Aerolink V2X security library demo apps"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://cv2x/security/aerolink-public/demo"
SRC_DIR = "${WORKSPACE}/cv2x/security/aerolink-public/demo"
S =  "${WORKDIR}/cv2x/security/aerolink-public/demo"

DEPENDS = "aerolink-headers aerolink"

FILES:${PN} += "${bindir}/*"
