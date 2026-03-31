FILESEXTRAPATHS:prepend:sa525m := "${THISDIR}/files:"

VOLATILE_BINDS:sa525m:qti-distro-tele-debug = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data/mka_supplicant-eth0.conf /etc/data/mka_supplicant-eth0.conf\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/ target=multi-user.target\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml target=multi-user.target\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/qvirtmgr.json /etc/qvirtmgr.json\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini\n\
/systemrw/commonapi4someip.ini /etc/commonapi4someip.ini\n\
/systemrw/vsomeip-location.json /etc/vsomeip-location.json\n\
/systemrw/sensors.conf /etc/sensors.conf\n\
/systemrw/izat.conf /etc/izat.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/sap.conf /etc/sap.conf\n\
/systemrw/apdr.conf /etc/apdr.conf\n\
/systemrw/eCall.conf /etc/eCall.conf target=multi-user.target\n\
/systemrw/telux_chrony-sock.conf /etc/telux_chrony-sock.conf\n\
/systemrw/telux_power_refd.conf /etc/telux_power_refd.conf target=multi-user.target\n\
/systemrw/vsomeip-sensor_service.json /usr/etc/vsomeip/SensorInterface/vsomeip-sensor_service.json\n\
/systemrw/telsdk_app.conf /etc/telsdk_app.conf target=multi-user.target\n\
/systemrw/Datafilter.conf /etc/Datafilter.conf target=multi-user.target\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf target=multi-user.target\n\
"

VOLATILE_BINDS:sa525m:qti-distro-tele-perf = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/ target=multi-user.target\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini\n\
/systemrw/commonapi4someip.ini /etc/commonapi4someip.ini\n\
/systemrw/vsomeip-location.json /etc/vsomeip-location.json\n\
/systemrw/sensors.conf /etc/sensors.conf\n\
/systemrw/izat.conf /etc/izat.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/sap.conf /etc/sap.conf\n\
/systemrw/apdr.conf /etc/apdr.conf\n\
/systemrw/telux_power_refd.conf /etc/telux_power_refd.conf target=multi-user.target\n\
/systemrw/vsomeip-sensor_service.json /usr/etc/vsomeip/SensorInterface/vsomeip-sensor_service.json\n\
"

VOLATILE_BINDS:sa525m-televm = "\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/data /etc/data/\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/eCall.conf /etc/eCall.conf\n\
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
"

VOLATILE_BINDS:sa525m-fotavm = "\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
"

VOLATILE_BINDS:sa510m = "\
/systemrw/tel.conf /etc/tel.conf\n\
"

do_install:append:sa525m(){
    #Remove deprecated StandardOutput=syslog
    for service in ${SYSTEMD_SERVICE:${PN}}; do
         sed -i '/StandardOutput=syslog/d' ${D}${systemd_system_unitdir}/$service
     done
}

do_compile () {
    while read spec mountpoint rest; do
        if [ -z "$spec" ]; then
            continue
        fi
        servicefile="$(echo "${spec#/}" | tr / -).service"
        [ "$mountpoint" != ${localstatedir}/lib ] || var_lib_servicefile=$servicefile
       # defaults
       target="basic.target"
       before_services=""
       after_services=""
       for token in $rest; do
          case $token in
              target=*)
                  target="${token#target=}"
                  ;;
              before=*)
                  before_services="${token#before=}"
                  ;;
              after=*)
                  after_services="${token#after=}"
                  ;;
           esac
        done
        sed -e "s#@what@#$spec#g; s#@where@#$mountpoint#g" \
            -e "s#@whatparent@#${spec%/*}#g; s#@whereparent@#${mountpoint%/*}#g" \
            -e "s#@avoid_overlayfs@#${@d.getVar('AVOID_OVERLAYFS')}#g" \
            -e "s/basic.target/${target}/g" \
            volatile-binds.service.in >$servicefile
       if [ -n "$before_services" ]; then
            sed -i -e "/^Before=/s/$/ $before_services/" \
                   $servicefile
       fi
       if [ -n "$after_services" ]; then
            sed -i -e "/^After=/s/$/ $after_services/" \
                   $servicefile
       fi
       if [ "$target" = "multi-user.target" ]; then
            echo $servicefile
            sed -i "/^DefaultDependencies=no$/d"  $servicefile
       fi
    done <<END
${@d.getVar('VOLATILE_BINDS').replace("\\n", "\n")}
END
    if [ -e "$var_lib_servicefile" ]; then
        # As the seed is stored under /var/lib, ensure that this service runs
        # after the volatile /var/lib is mounted.
        sed -i -e "/^Before=/s/\$/ systemd-random-seed.service/" \
               -e "/^WantedBy=/s/\$/ systemd-random-seed.service/" \
               "$var_lib_servicefile"
    fi
}
do_compile[dirs] = "${WORKDIR}"
