inherit pkgconfig cmake systemd

SUMMARY = "Telematics SDK Samples"
DESCRIPTION = "Telematics SDK Samples"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telux/public/"
S = "${WORKDIR}/telux/public/samples/"

EXTRA_OECMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '-DWITH_SYSTEMD:BOOL=ON', '', d)}"
EXTRA_OECMAKE += "-DMACHINE_HAS_CV2X=ON"

SYSTEMD_SERVICE_${PN} = "chrony-sock.service"

SRCREV = "${AUTOREV}"

DEPENDS += "telux telux-lib systemd"
