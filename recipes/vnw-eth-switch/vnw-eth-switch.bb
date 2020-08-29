DESCRIPTION = "Ethernet Switch Driver"
LICENSE = "GPL-2.0-only WITH Linux-syscall-note & BSD-3-Clause"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

inherit module systemd

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://vnw-eth-sw-kernel/"
SRC_URI += "file://vnw_eth_switch_start_stop_le"
SRC_URI += "file://vnw_eth_switch.service"

S = "${WORKDIR}/vnw-eth-sw-kernel/"

do_module_signing() {
    if [ -f ${STAGING_KERNEL_BUILDDIR}/signing_key.priv ]; then
        bbnote "Signing ${PN} module"
        ${STAGING_KERNEL_DIR}/scripts/sign-file sha512 ${STAGING_KERNEL_BUILDDIR}/signing_key.priv \
        ${STAGING_KERNEL_BUILDDIR}/signing_key.x509 \
        ${PKGDEST}/${PROVIDES_NAME}/lib/modules/$${KERNEL_VERSION}/extra/sja1105pqrs.ko
    else
        bbnote "${PN} module is not being signed"
    fi
}

do_install() {
    module_do_install
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/initscripts
        install -m 0755 ${WORKDIR}/vnw_eth_switch_start_stop_le ${D}${sysconfdir}/initscripts

        install -d ${D}${systemd_unitdir}/system/
        install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/

        #Ethernet switch Service
        install -m 0644 ${WORKDIR}/vnw_eth_switch.service -D ${D}${systemd_unitdir}/system/vnw_eth_switch.service

        # enable the service for multi-user.target
        ln -sf ${systemd_unitdir}/system/vnw_eth_switch.service \
                ${D}${systemd_unitdir}/system/multi-user.target.wants/vnw_eth_switch.service
    fi
}

FILES_${PN} += "${systemd_unitdir}/system/*"
FILES_${PN} += "${sysconfdir}/initscripts/*"
