SUMMARY = "QTI package group for the CLOG/commonlog family"

LICENSE = "BSD-3-Clause-Clear"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGES = "packagegroup-commonlog"

ALLOW_EMPTY:${PN} = "1"

RDEPENDS:${PN} += "\
    commonlog-cfglib \
    commonlog-lib \
    commonlog-ctrl \
    commonlog-mount-copybind \
    "
