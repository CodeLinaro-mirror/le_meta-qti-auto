inherit autotools systemd pkgconfig

SUMMARY = "sensor idl client"
DESCRIPTION = "This recipe compiles sensor idl client application"
PR = "r1"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS = "glib-2.0 common-api-c++ vsomeip common-api-c++-someip open-avb"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_idl_client"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_idl_client"

FILES:${PN} += "${libdir}/*"
FILES:${PN} += "/usr/etc/*"
SOLIBS = ".so*"
FILES_SOLIBSDEV = ""
INSANE_SKIP:${PN} = "dev-so"

RDEPENDS:${PN} = "open-avb"

EXTRA_OECONF = "--with-core-includes=${WORKSPACE}/system/core/include \
                --with-gptp \
		--with-glib"
