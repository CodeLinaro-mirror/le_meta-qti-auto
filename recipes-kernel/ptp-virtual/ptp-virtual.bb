DESCRIPTION = "lib ptp"

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/external:"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://ptp-virtual"
SRC_URI += "file://ptp-virtual.service"
DEPENDS = "virtual/kernel"

S = "${WORKDIR}/ptp-virtual"
inherit module systemd kernel-arch qperf
INHIBIT_PACKAGE_STRIP = "1"
EXTRA_OEMAKE += "CONFIG_ARCH_MSM=y"

SYSTEMD_SERVICE_${PN} = "ptp-virtual.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_compile_append () {
    KMOD_SIG_ALL=`cat ${STAGING_KERNEL_BUILDDIR}/.config | grep CONFIG_MODULE_SIG_ALL | cut -d'=' -f2`
    KMOD_SIG_HASH=`cat ${STAGING_KERNEL_BUILDDIR}/.config | grep CONFIG_MODULE_SIG_HASH | cut -d'=' -f2 | sed 's/\"//g'`
    if [ "$KMOD_SIG_ALL" = "y" ] && [ -n "$KMOD_SIG_HASH" ]; then
        if [ "${KERNEL_VERSION:0:4}" = "4.14" ]; then
            MODSECKEY=${STAGING_KERNEL_BUILDDIR}/certs/signing_key.pem
            MODPUBKEY=${STAGING_KERNEL_BUILDDIR}/certs/signing_key.x509
        else
            MODSECKEY=${STAGING_KERNEL_BUILDDIR}/signing_key.priv
            MODPUBKEY=${STAGING_KERNEL_BUILDDIR}/signing_key.x509
        fi

        cp ${S}/ptp_virtual.ko ${S}/ptp_virtual.ko.unsigned

        if [ "${KERNEL_VERSION:0:4}" = "4.14" ]; then
            ${STAGING_KERNEL_BUILDDIR}/scripts/sign-file $KMOD_SIG_HASH $MODSECKEY $MODPUBKEY ${S}/ptp_virtual.ko
        else
            perl ${STAGING_KERNEL_DIR}/scripts/sign-file $KMOD_SIG_HASH $MODSECKEY $MODPUBKEY ${S}/ptp_virtual.ko
        fi

    fi;
}

do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}/etc
        install -m 0644 ${WORKDIR}/ptp-virtual.service ${D}${systemd_unitdir}/system/ptp-virtual.service
}

FILES_${PN} += "${systemd_unitdir}/system/ptp-virtual.service \
                /etc/* \
"
