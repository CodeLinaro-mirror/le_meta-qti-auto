FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0004-ima-do-not-add-any-measure-rules-to-improve-boot-tim.patch', '', d)}"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleevm', 'file://0007-evm-Move-evm_hmac-and-evm_hash-from-evm_main.c-to-ev.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleevm', 'file://0008-evm-check-for-remount-ro-in-progress-before-writing.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleevm', 'file://0009-evm-Allow-non-SHA1-digital-signatures.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleevm', 'file://0010-evm-check-hash-algorithm-passed-to-init_desc.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleevm', 'file://0011-evm-exclude-data-partition-from-verification.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'nad-prod', 'file://0012-sa515m.dtsi-nad-core-subsys-backup-cma-removal.patch', '', d)}"

do_patch_prepend () {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'true', 'false', d)}; then
		cd ${S}/
		patch -p1 < ${WORKDIR}/0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch
		patch -p1 < ${WORKDIR}/0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch
		patch -p1 < ${WORKDIR}/0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch
		patch -p1 < ${WORKDIR}/0004-ima-do-not-add-any-measure-rules-to-improve-boot-tim.patch
		cd -
		rm -f ${WORKDIR}/0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch
		rm -f ${WORKDIR}/0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch
		rm -f ${WORKDIR}/0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch
		rm -f ${WORKDIR}/0004-ima-do-not-add-any-measure-rules-to-improve-boot-tim.patch
	fi
	if ${@bb.utils.contains('DISTRO_FEATURES', 'vbleevm', 'true', 'false', d)}; then
		cd ${S}/
		patch -p1 < ${WORKDIR}/0007-evm-Move-evm_hmac-and-evm_hash-from-evm_main.c-to-ev.patch
		patch -p1 < ${WORKDIR}/0008-evm-check-for-remount-ro-in-progress-before-writing.patch
		patch -p1 < ${WORKDIR}/0009-evm-Allow-non-SHA1-digital-signatures.patch
		patch -p1 < ${WORKDIR}/0010-evm-check-hash-algorithm-passed-to-init_desc.patch
		patch -p1 < ${WORKDIR}/0011-evm-exclude-data-partition-from-verification.patch
		cd -
		rm -f ${WORKDIR}/0007-evm-Move-evm_hmac-and-evm_hash-from-evm_main.c-to-ev.patch
		rm -f ${WORKDIR}/0008-evm-check-for-remount-ro-in-progress-before-writing.patch
		rm -f ${WORKDIR}/0009-evm-Allow-non-SHA1-digital-signatures.patch
		rm -f ${WORKDIR}/0010-evm-check-hash-algorithm-passed-to-init_desc.patch
		rm -f ${WORKDIR}/0011-evm-exclude-data-partition-from-verification.patch
	fi
	if ${@bb.utils.contains('DISTRO_FEATURES', 'nad-prod', 'true', 'false', d)}; then
		cd ${S}/
		patch -p1 < ${WORKDIR}/0012-sa515m.dtsi-nad-core-subsys-backup-cma-removal.patch
		cd -
		rm -f ${WORKDIR}/0012-sa515m.dtsi-nad-core-subsys-backup-cma-removal.patch
	fi
}
