FILESEXTRAPATHS_prepend := "${THISDIR}/systemd:"

SRC_URI_append += " \
    file://label-cache.service \
    file://label-persist.service \
    file://label-data.service \
"

do_install_append_mdm9650() {
    if ${@bb.utils.contains('DISTRO_FEATURES','selinux','true','false',d)}; then
        install -d ${D}${systemd_system_unitdir}/local-fs.target.wants
        install -d ${D}${systemd_system_unitdir}/multi-user.target.wants

        install -m 0644 ${WORKDIR}/label-cache.service ${D}${systemd_system_unitdir}/label-cache.service
        install -m 0644 ${WORKDIR}/label-persist.service ${D}${systemd_system_unitdir}/label-persist.service
        install -m 0644 ${WORKDIR}/label-data.service ${D}${systemd_system_unitdir}/label-data.service

        ln -sf  ../label-cache.service  ${D}${systemd_system_unitdir}/multi-user.target.wants/label-cache.service
        ln -sf  ../label-persist.service  ${D}${systemd_system_unitdir}/multi-user.target.wants/label-persist.service
        ln -sf  ../label-data.service  ${D}${systemd_system_unitdir}/local-fs.target.wants/label-data.service
    fi
}
