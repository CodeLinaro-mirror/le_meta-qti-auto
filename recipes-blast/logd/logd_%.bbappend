do_install:append(){
        if [ "${MACHINE}" == "sa525m" ]; then
           sed -i '/\[Service\]/a SupplementaryGroups=logd leprop' ${D}${systemd_unitdir}/system/earlyinit-logd.service
        fi
}
