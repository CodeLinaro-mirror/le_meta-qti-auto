FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch', '', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'vbleima', 'file://0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch', '', d)}"
