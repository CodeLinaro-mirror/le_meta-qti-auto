do_install:append() {
    sed -i '/^StandardOutput=/d' ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
    sed -i '/^TTYPath=/d'        ${D}${systemd_unitdir}/system.conf.d/00-${PN}.conf
}
