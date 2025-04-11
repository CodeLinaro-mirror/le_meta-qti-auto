FILESEXTRAPATHS_prepend := "${THISDIR}/cronie:" 

SRC_URI += "\
            file://crontab \ 
" 

do_install_append() {
    install -m 0600 ${WORKDIR}/crontab ${D}${sysconfdir}/
}

PACKAGE_ARCH ?= "${MACHINE_ARCH}"
