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
