DESCRIPTION = "Installs public certificate on root file system for IMA"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://x509_ima.der \
           file://privkey_ima.pem \
           ${@bb.utils.contains('COMBINED_FEATURES', 'vbleevm', 'file://x509_evm.der', '', d)}"

S = "${WORKDIR}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d "${D}${sysconfdir}/keys"
    install -m 0444 "${WORKDIR}/x509_ima.der" "${D}${sysconfdir}/keys"
    if ${@bb.utils.contains('COMBINED_FEATURES', 'vbleevm', 'true', 'false', d)}; then
        install -m 0444 "${WORKDIR}/x509_evm.der" "${D}${sysconfdir}/keys"
    fi
}

do_install_append_class-native() {
    install -d ${D}${sysconfdir}/keys
    install -m 0444 "${WORKDIR}/privkey_ima.pem" "${D}${sysconfdir}/keys"
}

BBCLASSEXTEND = "native"
