inherit autotools-brokensep pkgconfig

SUMMARY = "sensor hal daemon service headers"
DESCRIPTION = "Provides sensor hal daemon headers"
PR = "r1"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=3775480a712fc46a69647678acb234cb"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_hal_daemon"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_hal_daemon"

# don't run these functions
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${includedir}
    install -m 644 ${S}/*.h ${D}${includedir}
}
