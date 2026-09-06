SUMMARY = "CLOG - Unified Logging Wrapper Library"
DESCRIPTION = "Unified, component-based logging wrapper library supporting DLT, DIAG, syslog, logcat, file, and console backends"
HOMEPAGE = "https://www.codelinaro.org/"
PR = "r1"

LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://telematics/platform/oss/commonlog/commonlog-lib/"
SRC_DIR = "${WORKSPACE}/telematics/platform/oss/commonlog/commonlog-lib"
S = "${WORKDIR}/telematics/platform/oss/commonlog/commonlog-lib"

DEPENDS += "commonlog-cfglib glib-2.0"
EXTRA_OECONF = "--with-glib"

inherit autotools-brokensep pkgconfig

require commonlog-common.inc

do_install:append() {
    install -d -m 0777 ${D}/data/common_logs/
}

FILES:${PN} += "/data/common_logs/"
