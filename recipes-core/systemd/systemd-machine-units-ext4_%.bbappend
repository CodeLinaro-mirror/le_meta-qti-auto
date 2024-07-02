FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://vm-bootsys.mount"
SRC_URI += " file://vm-bootsys-mount.service"
SRC_URI += " file://systemrw-gvm.conf"
SRC_URI += " file://firmware-ext4-mount.sh"

do_install:append () {
    if ${@bb.utils.contains('MACHINE_MNT_POINTS','/systemrw','true','false',d)}; then
        if ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'true', 'false', d)}; then
            install -d ${D}/lib/systemd/system/systemrw.mount.d
            install -m 0755 ${WORKDIR}/systemrw-gvm.conf ${D}/lib/systemd/system/systemrw.mount.d/
        fi
    fi
    if ${@bb.utils.contains('MACHINE_FEATURES', 'emmc-boot', 'true', 'false', d)}; then
        install -m 0744 ${S}/firmware-ext4-mount.sh ${D}${sysconfdir}/initscripts/firmware-ext4-mount.sh
    fi
}
