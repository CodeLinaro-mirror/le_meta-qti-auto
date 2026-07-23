FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-logd-Grant-process-with-dlt-primary-group-access-to-.patch \
    file://logd_override.conf \
"

do_install:append(){
           sed -i '/\[Service\]/a SupplementaryGroups=logd leprop' ${D}${systemd_unitdir}/system/earlyinit-logd.service
}

do_install:append:sa525m-fotavm(){
    install -m 0644 ${WORKDIR}/logd_override.conf -D ${D}${systemd_unitdir}/system/logd.path.d/override.conf
}
