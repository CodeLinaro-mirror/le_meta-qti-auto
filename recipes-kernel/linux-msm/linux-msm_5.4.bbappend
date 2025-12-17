FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'file://0001-ubifs-Populate-UUID-in-superblock-of-ubi-file-system.patch', '', d)} \
            ${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'file://0002-ima-disable-creating-sysfs-entries-for-ima-policy.patch', '', d)}    \
            ${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'file://0003-ima-Define-IMA-appraisal-measure-rules-based-on-uuid.patch', '', d)} \
            ${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'file://0004-ima-do-not-add-any-measure-rules-to-improve-boot-tim.patch', '', d)} \
            ${@bb.utils.contains('COMBINED_FEATURES', 'vbleevm', 'file://0001-evm-exclude-data-partition-from-verification.patch', '', d)}         \
            ${@bb.utils.contains('COMBINED_FEATURES', 'qti-audio', 'file://0001-add-y2038-64bit-timer-in-sound.patch', '', d)}         \
            ${@bb.utils.contains('DISTRO_FEATURES', 'zram', 'file://zram.cfg', '', d)} \
           "
