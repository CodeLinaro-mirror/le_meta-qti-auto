inherit autotools pkgconfig

SUMMARY = "sensor dlt log library"
DESCRIPTION = "The provides DLT library interface"
PR = "r1"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

DEPENDS = "glib-2.0 libcutils dlt-daemon"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_dlt_log"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_dlt_log"

EXTRA_OECONF = "--with-core-includes=${WORKSPACE}/system/core/include \
                --with-glib"
