
dirs755_append +="/firmware /dsp "

do_install_append_smack () {
      # replace the old smack rules from "System _ -----l" to "System _ rwxa--"
      sed -i "1c System _ rwxa--"  ${D}/${sysconfdir}/smack/accesses.d/default-access-domains
}

do_install_append () {
    if [ -L ${D}/usr/local ]; then
        rm ${D}/usr/local
    fi
}
