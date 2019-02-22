do_install_append() {
    if ${@bb.utils.contains('IMAGE_FEATURES','read-only-rootfs','true','false',d)}; then
        sed -i -e '/^ExecStartPost/d'  ${D}${systemd_unitdir}/system/run-agl-postinsts.service
        sed -i -e 's/\/etc\/agl-postinsts/\/var\/agl-postinsts/'  ${D}${systemd_unitdir}/system/run-agl-postinsts.service
        sed -i -e 's/\/etc\/agl-postinsts/\/var\/agl-postinsts/'  ${D}${sbindir}/run-agl-postinsts
    fi
}
