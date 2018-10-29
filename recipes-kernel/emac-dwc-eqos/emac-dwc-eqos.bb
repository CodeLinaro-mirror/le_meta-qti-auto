SUMMARY = "emac-dwc-eqos"

DESCRIPTION = "emac ethernet"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS = "virtual/kernel"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/vendor/qcom/opensource/drivers:"
SRC_URI = "file://emac-dwc-eqos"
SRC_URI += "file://emac-dwc-eqos.service"

PR = "r0"
PV = "0.1"

S =  "${WORKDIR}/emac-dwc-eqos"

INHIBIT_PACKAGE_STRIP = "1"

inherit module systemd qperf

SYSTEMD_SERVICE_${PN} = "emac-dwc-eqos.service"
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

        cp ${S}/emac_dwc_eqos.ko ${S}/emac_dwc_eqos.ko.unsigned

        if [ "${KERNEL_VERSION:0:4}" = "4.14" ]; then
            ${STAGING_KERNEL_BUILDDIR}/scripts/sign-file $KMOD_SIG_HASH $MODSECKEY $MODPUBKEY ${S}/emac_dwc_eqos.ko
        else
            perl ${STAGING_KERNEL_DIR}/scripts/sign-file $KMOD_SIG_HASH $MODSECKEY $MODPUBKEY ${S}/emac_dwc_eqos.ko
        fi
    fi;
}


do_install_append() {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}/etc
    #touch ${WORKDIR}/emac_dwc_eqos/config.ini
    #install ${WORKDIR}/emac_dwc_eqos/config.ini ${D}/etc/ntn_config.ini

    install -m 0644 ${WORKDIR}/emac-dwc-eqos.service ${D}${systemd_unitdir}/system/emac-dwc-eqos.service
}

FILES_${PN} += "${systemd_unitdir}/system/emac-dwc-eqos.service \
                /etc/* \
"



