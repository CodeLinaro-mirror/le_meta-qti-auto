do_install_append() {
    rm ${D}${sysconfdir}/profile.d/bash_completion.sh
}
