inherit systemd

DESCRIPTION = "open-avb tools"
HOMEPAGE = "https://github.com/AVnu/Open-AVB"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://examples/LICENSE;md5=81ccd62d4bc28bafc5e1a2576536b927 \
		    file://daemons/LICENSE;md5=81ccd62d4bc28bafc5e1a2576536b927 \
		    file://lib/avtp_pipeline/LICENSE;md5=8f7b370a91d698ed80d2d20e8e01fbb6"

PR = "r1"

DEPENDS += "alsa-lib glib-2.0 libpcap pciutils cmake-native qmi-framework"
DEPENDS_append_sa415m += "alsa-intf"
DEPENDS_append_sa515m += "tinyalsa"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://external/open-avb/ \
		file://avb.patch \
		file://gptp-daemon.service \
		file://gptp_udev_rules.rules \
		file://gptp-daemon-tmpfilesd.conf"

S = "${WORKDIR}/external/open-avb/"

GPTP_AUTO_START_ENABLE= "NO"
RGPTP_SRV_INCLUDED= "YES"
RGPTP_CLNT_INCLUDED= "YES"

EXTRA_OEMAKE += "AVB_FEATURE_NEUTRINO=1"
EXTRA_OEMAKE_append_mdm9650 = " PCI_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE_append_mdm9607 = " PCI_SUPPORT_INCLUDED=0"
EXTRA_OEMAKE_append_sa515m = " TINYALSA_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE_append_auto = " SDX_ALSA_LIB_INCLUDED=1"
EXTRA_OEMAKE += "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " SYSTEMD_SUPPORT_INCLUDED=1", " SYSTEMD_SUPPORT_INCLUDED=0", d)}"
EXTRA_OEMAKE += "${@oe.utils.conditional('GPTP_AUTO_START_ENABLE', 'YES', 'GPTP_AUTO_START=1', 'GPTP_AUTO_START=0', d)}"
EXTRA_OEMAKE += "${@oe.utils.conditional('RGPTP_SRV_INCLUDED', 'YES', 'RGPTP_ENABLED=1', 'RGPTP_ENABLED=0', d)}"
EXTRA_OEMAKE += "${@oe.utils.conditional('RGPTP_CLNT_INCLUDED', 'YES', 'RGPTP_CLNT_ENABLED=1', 'RGPTP_CLNT_ENABLED=0', d)}"
SYSTEMD_SERVICE_${PN} = "${@oe.utils.conditional('GPTP_AUTO_START_ENABLE', 'YES', 'gptp-daemon.service', '', d)}"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

do_compile() {
    oe_runmake libgptp
    oe_runmake daemons_all
    oe_runmake avtp_pipeline
    oe_runmake libgptp_test
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/daemons/maap/linux/maap_daemon ${D}${bindir}
    install -m 0755 ${S}/daemons/mrpd/mrpd ${D}${bindir}
    install -m 0755 ${S}/daemons/mrpd/mrpctl ${D}${bindir}
    install -m 0755 ${S}/daemons/gptp/linux/build/obj/daemon_cl ${D}${bindir}
    install -m 0755 ${S}/lib/avtp_pipeline/build/bin/openavb_harness ${D}${bindir}
    install -d ${D}${libdir}
    install -m 0755 ${S}/lib/avtp_pipeline/build/lib/*.so ${D}${libdir}
    install -d ${D}${userfsdatadir}/avb
    install -m 0644 ${S}/lib/avtp_pipeline/build/bin/*.ini ${D}${userfsdatadir}/avb
    install -m 0755 ${S}/examples/libgptp_test/libgptp_test ${D}${bindir}
    install -m 0755 ${S}/lib/libgptp/*.so ${D}${libdir}

    if (test "x${GPTP_AUTO_START_ENABLE}" == "xYES"); then
       if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
          install -d ${D}${systemd_unitdir}/system/
          install -m 0644 ${WORKDIR}/gptp-daemon.service -D ${D}${systemd_unitdir}/system/gptp-daemon.service
          install -d ${D}${sysconfdir}/tmpfiles.d/
          install -m 0644 ${WORKDIR}/gptp-daemon-tmpfilesd.conf ${D}${sysconfdir}/tmpfiles.d/gptp-daemon-tmpfilesd.conf

          install -d ${D}${sysconfdir}/udev/rules.d/
          install -m 0777 ${WORKDIR}/gptp_udev_rules.rules -D ${D}${sysconfdir}/udev/rules.d/gptp_udev_rules.rules
       fi
    fi
}

FILES_SOLIBSDEV = ""
FILES_${PN} += "${bindir}/*"
FILES_${PN} += "${libdir}/*"
FILES_${PN} += "${userfsdatadir}/avb/*"
