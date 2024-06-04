FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append += " \
                    file://lxc_networking.conf  \
                    file://qti-lxc-common.conf  \
                    file://lxc_launch.service   \
                    file://lxc_launch.sh  \
                    file://lxc_system.conf \
                    file://seccom_attach_unsupported_fix.patch \
                    "

FILES_${PN}-configs = " \
                    ${S}/lxc_networking.conf \
                    ${S}/qti-lxc-common.conf"

FILES_${PN}-service = " \
                    ${S}/lxc_launch.service"

FILES_${PN}-initscript = " \
                    ${S}/lxc_launch.sh"

do_install_append() {


   install -m 0644  -d ${D}${sysconfdir}/initscripts
   install -m 0744  -d ${D}${sysconfdir}/lxc
   install -m 0644  -d ${D}${sysconfdir}/default

   #shared RW space for lxc container
   install -m 0644  -d ${D}${userfsdatadir}/lxc_rw

   #disabled for now until se policy is not enabled
   if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'false', 'false', d)}; then

      install -d 0644 ${D}${systemd_unitdir}/system
      install -d ${D}${systemd_unitdir}/system/multi-user.target.wants
      install -m 0640 ${WORKDIR}/lxc_launch.service ${D}${systemd_unitdir}/system/lxc_launch.service
      ln -sf ${systemd_unitdir}/system/lxc_launch.service ${D}${systemd_unitdir}/system/multi-user.target.wants/lxc_launch.service
   fi

   install -m 0444 ${WORKDIR}/qti-lxc-common.conf \
      ${D}${sysconfdir}/lxc/

   install -m 0444 ${WORKDIR}/lxc_networking.conf \
      ${D}${sysconfdir}/lxc/


   install -m 0555 ${WORKDIR}/lxc_launch.sh ${D}${sysconfdir}/initscripts/lxc_launch.sh
   install -m 0744 ${WORKDIR}/lxc_system.conf ${D}${sysconfdir}/lxc/lxc.conf

}
FILES_${PN} += "${systemd_unitdir}/system/*"
FILES_${PN} += "${sysconfdir}/initscripts/*"
FILES_${PN} += "${sysconfdir}/lxc/*"
FILES_${PN} += "${userfsdatadir}/lxc_rw"

SYSTEMD_AUTO_ENABLE_${PN} = "disable"
RDEPENDS_${PN}_remove += "curl"
