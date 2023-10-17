FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append += " \
                    file://lxc_networking.conf  \
                    file://lxc_launch.service   \
                    file://lxc_launch.sh  \
                    file://lxc_system.conf"

FILES_${PN}-configs = " \
                    ${S}/lxc_networking.conf"

FILES_${PN}-service = " \
                    ${S}/lxc_launch.service"

FILES_${PN}-initscript = " \
                    ${S}/lxc_launch.sh"

# Install the necessary files into usrfs (/data)
do_install_append() {
   install -m 0755  -d ${D}${userfsdatadir}/lxc
   install -m 0755  -d ${D}${userfsdatadir}/lxc/conf
   install -d 0644 ${D}${sysconfdir}/initscripts
   install -d 0644 ${D}${sysconfdir}/lxc
   install -d 0644 ${D}${sysconfdir}/default

   #disabled for now until se policy is not enabled
   if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'false', 'false', d)}; then

      install -d 0644 ${D}${systemd_unitdir}/system
      install -d ${D}${systemd_unitdir}/system/multi-user.target.wants
      install -m 0640 ${WORKDIR}/lxc_launch.service ${D}${systemd_unitdir}/system/lxc_launch.service
      ln -sf ${systemd_unitdir}/system/lxc_launch.service ${D}${systemd_unitdir}/system/multi-user.target.wants/lxc_launch.service
   fi

   install -m 0644 ${WORKDIR}/lxc_networking.conf \
      ${D}${sysconfdir}/lxc/
   install -m 0740 ${WORKDIR}/lxc_launch.sh ${D}${sysconfdir}/initscripts/lxc_launch.sh
   install -m 0740 ${WORKDIR}/lxc_system.conf ${D}${sysconfdir}/lxc/lxc.conf

}
FILES_${PN} += "${userfsdatadir}/lxc/*"
FILES_${PN} += "${systemd_unitdir}/system/*"
FILES_${PN} += "${sysconfdir}/initscripts/*"
FILES_${PN} += "${sysconfdir}/lxc/*"

SYSTEMD_AUTO_ENABLE_${PN} = "disable"
