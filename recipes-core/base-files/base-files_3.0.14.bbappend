FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

dirs755_append +="/firmware /dsp /bluetooth"
SRC_URI_append_automotive += "file://${BASEMACHINE}/fstab"

do_install_append_smack () {
      # replace the old smack rules from "System _ -----l" to "System _ rwxa--"
      sed -i "1c System _ rwxa--"  ${D}/${sysconfdir}/smack/accesses.d/default-access-domains
}


do_install_append () {
    # use fstab for mount management
    rm -rf ${D}${sysconfdir}/systemd/system
    rm -rf ${D}${systemd_unitdir}/system

    if [ -L ${D}/usr/local ]; then
        rm ${D}/usr/local
    fi
}
