inherit autotools pkgconfig

SUMMARY = "sensor util library"
DESCRIPTION = "The provides library interface to the util clients"
PR = "r1"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=aa1caf1ecca146c499d29f5ff4709389"

DEPENDS = "glib-2.0 libcutils"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/utils/lib"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/utils/lib"

EXTRA_OECONF = "--with-core-includes=${WORKSPACE}/system/core/include \
                --with-glib"

