FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_class-native = "${@bb.utils.contains('DISTRO_FEATURES_NATIVE', 'vbleima', ' file://use-predefined-uuid-for-ima.patch', '',d)}"
