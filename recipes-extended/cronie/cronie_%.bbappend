FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
            file://crontab \
"

do_install:append() {
    install -m 0600 ${WORKDIR}/crontab ${D}${sysconfdir}/
}

PACKAGE_ARCH ?= "${MACHINE_ARCH}"
