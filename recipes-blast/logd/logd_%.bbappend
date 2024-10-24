do_install:append(){
           sed -i '/\[Service\]/a SupplementaryGroups=logd leprop' ${D}${systemd_unitdir}/system/earlyinit-logd.service
}
