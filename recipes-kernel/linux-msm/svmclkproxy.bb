inherit autotools pkgconfig systemd

DESCRIPTION = "Enable or Disable misc clks in SVM"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI += " \
    file://svm_clk_proxy.service \
"
S = "${WORKDIR}/files"

do_compile[noexec] = "1"

do_install() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_unitdir}/system/
        install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/

        if ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-host', 'true', 'false', d)}; then
            install -m 0644 ${WORKDIR}/svm_clk_proxy.service ${D}${systemd_unitdir}/system/svm_clk_proxy.service
            ln -sf ${systemd_unitdir}/system/svm_clk_proxy.service \
                   ${D}${systemd_unitdir}/system/multi-user.target.wants/svm_clk_proxy.service
        fi
    fi
}

FILES_${PN} += "${systemd_unitdir}/system/*"

