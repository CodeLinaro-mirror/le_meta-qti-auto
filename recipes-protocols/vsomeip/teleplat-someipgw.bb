SUMMARY = "Telematics platform SOME/IP Gateway service"
DESCRIPTION = "Builds and packages the telematics platform SOME/IP Gateway service."
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

inherit systemd pkgconfig useradd

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telematics/platform/oss/teleplat-someipgw/ \
file://teleplat-someipgw.service \
"

S = "${WORKDIR}/telematics/platform/oss/teleplat-someipgw"

DEPENDS += "vsomeip boost jansson"
RDEPENDS:${PN} += "vsomeip"

SYSTEMD_SERVICE:${PN} = "teleplat-someipgw.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "-u 3052 -s /sbin/nologin -U gateway"

do_compile() {
    oe_runmake -C ${S}
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/telePlatSomeipGWSvc ${D}${bindir}/telePlatSomeipGWSvc

    install -d ${D}${sysconfdir}/teleplat-someipgw
    install -m 0644 ${S}/teleplat-someipgw.json ${D}${sysconfdir}/teleplat-someipgw/
    install -m 0644 ${S}/teleplat-someipgw_1.json ${D}${sysconfdir}/teleplat-someipgw/
    install -m 0644 ${S}/teleplat-someipgw-lxc.json ${D}${sysconfdir}/teleplat-someipgw/

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/teleplat-someipgw.service \
        ${D}${systemd_unitdir}/system/teleplat-someipgw.service
}

FILES:${PN} += "${sysconfdir}/teleplat-someipgw ${systemd_unitdir}/system/teleplat-someipgw.service"
