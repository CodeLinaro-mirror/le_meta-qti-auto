inherit systemd pkgconfig

DESCRIPTION = "open-avb tools"
HOMEPAGE = "https://github.com/AVnu/Open-AVB"
LICENSE = "BSD-2-Clause & BSD-3-Clause"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/BSD-2-Clause;md5=cb641bc04cda31daea161b1bc15da69f \
    file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9 \
"

PR = "r1"

DEPENDS += "alsa-lib glib-2.0 libpcap pciutils cmake-native qmi-framework"

DEPENDS:append:sa415m = " alsa-intf"
DEPENDS:append:sa515m = " tinyalsa"
DEPENDS:append:sa410m = " tinyalsa"
DEPENDS:append:sa525m = " pal"

FILESEXTRAPATHS:prepend := "${WORKSPACE}:"

SRC_URI = "file://external/open-avb/ \
           file://avb.patch \
           file://gptp-daemon_v1.service \
           file://gptp-daemon-tmpfilesd.conf"

S = "${WORKDIR}/external/open-avb/"

GPTP_AUTO_START_ENABLE = "NO"
RGPTP_SRV_INCLUDED = "YES"
RGPTP_CLNT_INCLUDED = "YES"

EXTRA_OEMAKE += "AVB_FEATURE_NEUTRINO=1"

EXTRA_OEMAKE:append:mdm9650 = " PCI_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE:append:mdm9607 = " PCI_SUPPORT_INCLUDED=0"
EXTRA_OEMAKE:append:sa415m = " ALSA_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE:append:sa515m = " TINYALSA_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE:append:sa410m = " TINYALSA_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE:append:sa525m = " PAL_SUPPORT_INCLUDED=1"
EXTRA_OEMAKE:append:auto = " SDX_ALSA_LIB_INCLUDED=1"

PACKAGECONFIG:sa525m = "pal"

EXTRA_OEMAKE += "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " SYSTEMD_SUPPORT_INCLUDED=1", " SYSTEMD_SUPPORT_INCLUDED=0", d)}"
EXTRA_OEMAKE += "${@bb.utils.contains("PACKAGECONFIG", "pal", " AUDIO_INC_DIR=/usr/include/pal", " AUDIO_INC_DIR=/usr/include/alsa", d)}"
EXTRA_OEMAKE += "${@bb.utils.contains("PACKAGECONFIG", "pal", " AUDIO_LIB=pal", " AUDIO_LIB=asound", d)}"
EXTRA_OEMAKE += "${@oe.utils.conditional('GPTP_AUTO_START_ENABLE', 'YES', 'GPTP_AUTO_START=1', 'GPTP_AUTO_START=0', d)}"
EXTRA_OEMAKE += "${@oe.utils.conditional('RGPTP_SRV_INCLUDED', 'YES', 'RGPTP_ENABLED=1', 'RGPTP_ENABLED=0', d)}"
EXTRA_OEMAKE += "${@oe.utils.conditional('RGPTP_CLNT_INCLUDED', 'YES', 'RGPTP_CLNT_ENABLED=1', 'RGPTP_CLNT_ENABLED=0', d)}"

SYSTEMD_SERVICE:${PN} = "${@oe.utils.conditional('GPTP_AUTO_START_ENABLE', 'YES', 'gptp-daemon.service', '', d)}"

TARGET_CC_ARCH += "${LDFLAGS}"

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
          install -m 0644 ${WORKDIR}/gptp-daemon_v1.service -D ${D}${systemd_unitdir}/system/gptp-daemon.service
          install -d ${D}${sysconfdir}/tmpfiles.d/
          install -m 0644 ${WORKDIR}/gptp-daemon-tmpfilesd.conf ${D}${sysconfdir}/tmpfiles.d/gptp-daemon-tmpfilesd.conf
       fi
    fi
}

FILES_SOLIBSDEV = ""
FILES:${PN} += "${bindir}/*"
FILES:${PN} += "${libdir}/*"
FILES:${PN} += "${userfsdatadir}/avb/*"

