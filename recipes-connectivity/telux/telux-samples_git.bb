inherit qcommon cmake

SUMMARY = "Telematics SDK Samples"
DESCRIPTION = "Telematics SDK Samples"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

SRC_DIR = "${WORKSPACE}/telux/public/"
S = "${WORKDIR}/telux/public/samples"

EXTRA_OECMAKE += "${@bb.utils.contains('MACHINE_FEATURES', 'cv2x', '-DMACHINE_HAS_CV2X_ONLY=ON', '', d)} "

SRCREV = "${AUTOREV}"

DEPENDS += "telux telux-lib"
