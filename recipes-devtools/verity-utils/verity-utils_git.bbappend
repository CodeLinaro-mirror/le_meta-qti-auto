FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES','dm-verity', 'file://0001-openssl-1.1.1-compatibility.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES','dm-verity', 'file://0001-Openssl-1.1.-Replace-deprecated-BN_init-with-BN_new.patch', '', d)}"
