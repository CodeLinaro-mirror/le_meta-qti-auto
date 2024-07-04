FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PERSIST_PROP_SUPPORT ?= 'True'
PERSIST_PROP_SUPPORT:qti-distro-tele = 'False'

PERSIST_SERVICE = '${@oe.utils.conditional('PERSIST_PROP_SUPPORT','True','persist-prop.service','',d)}'
SYSTEMD_SERVICE:${PN} = "${@bb.utils.contains('DISTRO_FEATURES','systemd','${PERSIST_SERVICE}','',d)}"


do_install(){
    install -d ${D}
    install -m 0644 ${S}/build.prop ${D}/build.prop

    if ${@bb.utils.contains('PERSIST_PROP_SUPPORT','True', 'true','false', d)}; then
         install -m 0755 ${WORKDIR}/persist-prop.sh -D ${D}${base_sbindir}/persist-prop.sh
         install -d ${D}${systemd_unitdir}/system
         install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/
         install -m 644 ${WORKDIR}/persist-prop.service ${D}/${systemd_unitdir}/system
         ln -sf ${systemd_unitdir}/system/persist-prop.service ${D}${systemd_unitdir}/system/multi-user.target.wants/persist-prop.service
    fi
}
