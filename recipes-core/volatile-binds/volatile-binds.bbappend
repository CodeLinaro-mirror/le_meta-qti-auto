VOLATILE_BINDS_append_sa2150p-nand = "\
/systemrw/tel.conf /etc/tel.conf \n\
/systemrw/systemd/network/ethernet.network /etc/systemd/network/ethernet.network \n\
/systemrw/netmgrd/config /etc/netmgrd/config \n\
/systemrw/config.ini /etc/initscripts/config.ini \n\
/systemrw/modem-monitor-usb.conf /etc/modem-monitor-usb.conf \n\
/systemrw/modem-monitor-pcie.conf /etc/modem-monitor-pcie.conf \n\
/systemrw/modem-monitor-eth.conf /etc/modem-monitor-eth.conf \n\
/systemrw/power_state.conf /etc/power_state.conf \n\
/systemrw/enable /etc/cv2x/enable \n\
"

# Remove volatile binds service not applicable for sa2150p
SYSTEMD_SERVICE_${PN}_remove = "systemrw-allplay.service systemrw-adk-database.service systemrw-bluetooth.service"
