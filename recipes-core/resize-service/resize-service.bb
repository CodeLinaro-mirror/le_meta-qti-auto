SUMMARY = "Tool for resize data partition"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

SRC_URI = "file://resize-userdata.service"

S = "${WORKDIR}"

inherit systemd

SYSTEMD_SERVICE_${PN} = "resize-userdata.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install() {
    if ${@bb.utils.contains('IMAGE_FEATURES','read-only-rootfs','true','false',d)}; then
        sed -i -e 's/^After=.*$/After=dev-disk-by\x2dpartlabel-userdata.device var-lib.mount/' ${S}/resize-userdata.service
        sed -i    '/ConditionPathExists=.*$/d' ${S}/resize-userdata.service
        sed -i    '/^Before=.*$/a\ConditionPathExists=\/var\/lib\/need_resize' ${S}/resize-userdata.service
        sed -i -e 's/^ExecStartPost=.*$/ExecStartPost=\/bin\/rm -rf \/var\/lib\/need_resize/' ${S}/resize-userdata.service
    fi
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/resize-userdata.service ${D}${systemd_unitdir}/system/resize-userdata.service
    install -d ${D}/var/lib
    touch ${D}/var/lib/need_resize
}

FILES_${PN} += "${systemd_unitdir}/system/resize-userdata.service"
FILES_${PN} += "/var/lib/need_resize"

RDEPENDS_${PN} += "e2fsprogs-resize2fs"
