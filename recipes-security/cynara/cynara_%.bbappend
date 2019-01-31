FILESEXTRAPATHS_append := ":${THISDIR}/files"

SRC_URI += "file://cynara_update_policy.service"

# Force cynara/security-manager policy generated at first boot
pkg_postinst_${PN} () {
    # Fail on error.
    set -e
    mkdir -p $D${sysconfdir}/cynara
    ${CHSMACK} -a System $D${sysconfdir}/cynara

    if [ ! -e "$D/var/db/security-manager" ]; then
        mkdir -p $D/var/db
        cp -ra $D/usr/dbspace/ $D/var/db/security-manager
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        if [ -n "$D" ]; then
            OPTS="--root=$D"
        fi
        systemctl $OPTS disable init-security-manager-db.service
    fi
    exit 0
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/
    install -d ${D}${systemd_unitdir}/system/sysinit.target.wants/
    install -d ${D}/var/lib
    touch ${D}/var/lib/need_update_cynara_policy
    install ${WORKDIR}/cynara_update_policy.service ${D}${systemd_unitdir}/system/cynara_update_policy.service
    ln -sf ${systemd_unitdir}/system/cynara.service ${D}${systemd_unitdir}/system/multi-user.target.wants/cynara.service
    ln -sf ${systemd_unitdir}/system/cynara_update_policy.service ${D}${systemd_unitdir}/system/sysinit.target.wants/cynara_update_policy.service
}
