FILESEXTRAPATHS:prepend := "${THISDIR}/chrony:"

SRC_URI += "file://chrony-gvm.conf"

do_install:append() {
    if [ ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'True', 'False', d)} = True ]; then
        rm -f ${D}${sysconfdir}/chrony.conf
        install -m 0640 ${WORKDIR}/chrony-gvm.conf ${D}${sysconfdir}/chrony.conf
    fi
    chmod 640 ${D}${sysconfdir}/chrony.conf
}

do_configure() {
    ./configure --sysconfdir=${sysconfdir} --bindir=${bindir} --sbindir=${sbindir} \
        --localstatedir=${localstatedir} --datarootdir=${datadir} \
        --with-ntp-era=$(date -d '1970-01-01 00:00:00+00:00' +'%s') \
        --with-pidfile=/run/chrony/chronyd.pid \
        --chronyrundir=/run/chrony \
        --host-system=Linux \
        --enable-debug \
        ${PACKAGECONFIG_CONFARGS}
}
