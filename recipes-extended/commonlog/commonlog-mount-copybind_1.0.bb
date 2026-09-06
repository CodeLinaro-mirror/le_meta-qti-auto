SUMMARY = "Common logging config mount-copybind service"
DESCRIPTION = "Bind-mounts the persistent /systemrw/commonlog.cfg over \
/etc/commonlog.cfg at boot via mount-copybind, so CLOG's runtime \
configuration survives across boots on a read-only rootfs."
HOMEPAGE = "https://www.codelinaro.org/"

LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

SRC_URI = "file://commonlog-mount-copybind.service"

S = "${WORKDIR}"

inherit allarch systemd features_check

REQUIRED_DISTRO_FEATURES = "systemd"

SYSTEMD_SERVICE:${PN} = "commonlog-mount-copybind.service"

RDEPENDS:${PN} += "volatile-binds"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/commonlog-mount-copybind.service ${D}${systemd_unitdir}/system/
}

FILES:${PN} += "${systemd_unitdir}/system/commonlog-mount-copybind.service"
