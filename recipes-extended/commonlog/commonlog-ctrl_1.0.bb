SUMMARY = "Commonlog binary config control tool"
DESCRIPTION = "Administrative tool for inspecting and updating commonlog binary configuration files"
HOMEPAGE = "https://www.codelinaro.org/"
PR = "r1"

LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://telematics/platform/oss/commonlog/commonlog-ctrl/"
SRC_DIR = "${WORKSPACE}/telematics/platform/oss/commonlog/commonlog-ctrl"
S = "${WORKDIR}/telematics/platform/oss/commonlog/commonlog-ctrl"

DEPENDS = "commonlog-cfglib glib-2.0"
EXTRA_OECONF = "--with-glib"

inherit autotools-brokensep pkgconfig
