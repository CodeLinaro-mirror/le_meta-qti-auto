SUMMARY = "Binary commonlog configuration library"
DESCRIPTION = "Binary configuration library providing raw and resolved commonlog app/context lookups"
HOMEPAGE = "https://www.codelinaro.org/"
PR = "r1"

LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://telematics/platform/oss/commonlog/commonlog-cfglib/"
SRC_DIR = "${WORKSPACE}/telematics/platform/oss/commonlog/commonlog-cfglib"
S = "${WORKDIR}/telematics/platform/oss/commonlog/commonlog-cfglib"

DEPENDS += "perl-native glib-2.0"
EXTRA_OECONF = "--with-glib"

inherit autotools-brokensep pkgconfig

FILES:${PN} += "${sysconfdir}/commonlog.cfg"
CONFFILES:${PN} += "${sysconfdir}/commonlog.cfg"
