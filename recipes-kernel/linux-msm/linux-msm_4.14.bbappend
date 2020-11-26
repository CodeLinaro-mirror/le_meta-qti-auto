FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0001-keys-bypass-selinux-key-permissions-checking.patch', '', d)}"

do_patch_prepend () {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'true', 'false', d)}; then
		cd ${S}/
		patch -p1 < ${WORKDIR}/0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch
		patch -p1 < ${WORKDIR}/0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch
		patch -p1 < ${WORKDIR}/0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch
		patch -p1 < ${WORKDIR}/0001-keys-bypass-selinux-key-permissions-checking.patch
		cd -
		rm -f ${WORKDIR}/0001-keys-bypass-selinux-key-permissions-checking.patch
		rm -f ${WORKDIR}/0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch
		rm -f ${WORKDIR}/0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch
		rm -f ${WORKDIR}/0001-keys-bypass-selinux-key-permissions-checking.patch
	fi
}
