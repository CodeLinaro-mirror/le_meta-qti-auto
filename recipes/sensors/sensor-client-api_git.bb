inherit autotools-brokensep pkgconfig

SUMMARY = "sensor client api library"
DESCRIPTION = "The client api provides library interface to the clients"
PR = "r1"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=3775480a712fc46a69647678acb234cb"

DEPENDS = "glib-2.0 sensor-socket libcutils sensor-hal-daemon-hdr libsensors"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_client_api"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_client_api"

EXTRA_OECONF = "--with-core-includes=${WORKSPACE}/system/core/include \
                --with-glib"

