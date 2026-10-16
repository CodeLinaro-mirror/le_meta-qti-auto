SUMMARY = "Binary commonlog configuration library"
DESCRIPTION = "Binary configuration library providing raw and resolved commonlog app/context lookups"
HOMEPAGE = "https://www.codelinaro.org/"
PR = "r1"

LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = " \
    file://telematics/platform/oss/commonlog/commonlog-cfglib/ \
    file://commonlog-mount-copybind.service \
    file://commonlog-sink-config.conf \
    file://commonlog-logd.conf \
"
SRC_DIR = "${WORKSPACE}/telematics/platform/oss/commonlog/commonlog-cfglib"
S = "${WORKDIR}/telematics/platform/oss/commonlog/commonlog-cfglib"

DEPENDS += "perl-native glib-2.0"
EXTRA_OECONF = "--with-glib"

inherit autotools-brokensep pkgconfig systemd

REQUIRED_DISTRO_FEATURES = "systemd"

do_install:append() {
    # Add the commonlog-sink-config
    install -d ${D}${sysconfdir}/
    install -m 0644 ${WORKDIR}/commonlog-sink-config.conf ${D}${sysconfdir}/commonlog-sink-config.conf

    # Add systemd drop file for logd service
    install -d ${D}${sysconfdir}/systemd/system/logd.service.d
    install -m 0644 ${WORKDIR}/commonlog-logd.conf ${D}${sysconfdir}/systemd/system/logd.service.d/commonlog-logd.conf

    # Add mount copybind service
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/commonlog-mount-copybind.service ${D}${systemd_unitdir}/system/
}

FILES:${PN} += "${sysconfdir}/commonlog.cfg"
CONFFILES:${PN} += "${sysconfdir}/commonlog.cfg"
SYSTEMD_SERVICE:${PN} = "commonlog-mount-copybind.service"
