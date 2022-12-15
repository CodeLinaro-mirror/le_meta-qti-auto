inherit autotools pkgconfig

SUMMARY = "sensor util lib test application "
DESCRIPTION = "Sensor util test app used to configure hal_config file"
PR = "r1"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

DEPENDS = "sensor-util-lib"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/utils/test_app"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/utils/test_app"

EXTRA_OECONF += "--with-glib"
