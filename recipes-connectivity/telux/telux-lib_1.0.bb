inherit qcommon cmake

SUMMARY = "Telematics SDK stub library"
DESCRIPTION = "Stub library that can be used to compile telematics applications."

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

SRC_DIR = "${WORKSPACE}/telux/public/bin"
S = "${WORKDIR}/telux/Re/bin"

FILES_SOLIBSDEV = ""
FILES_${PN} += "${libdir}/*.so"