FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append += " \
                    file://lxc_networking.conf  \
                    file://qti-lxc-common.conf  \
                    file://telaf_lxc.service   \
                    file://lxc_system.conf \
                    file://seccom_attach_unsupported_fix.patch \
                    file://container_launch.sh \
                    "

FILES:${PN}-configs = " \
                    ${S}/lxc_networking.conf \
                    ${S}/qti-lxc-common.conf"

FILES:${PN}-service = " \
                    ${S}/telaf_lxc.service"


EXTRA_OEMAKE += "CFLAGS+="-flto""

do_install:append() {

   install -m 0655  -d ${D}${sysconfdir}/lxc
   install -m 0644  -d ${D}${sysconfdir}/default
   install -m 0644  -d ${D}${sysconfdir}/initscripts

   #shared RW space for lxc container
   install -m 0644  -d ${D}${userfsdatadir}/lxc_rw

   if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
      #installing service file for telaflxc container
      install -d 0644 ${D}${systemd_unitdir}/system
      install -d ${D}${systemd_unitdir}/system/multi-user.target.wants
      install -m 0640 ${WORKDIR}/telaf_lxc.service ${D}${systemd_unitdir}/system/telaf_lxc.service
      ln -sf ${systemd_unitdir}/system/telaf_lxc.service ${D}${systemd_unitdir}/system/multi-user.target.wants/telaf_lxc.service
   fi

   install -m 0444 ${WORKDIR}/qti-lxc-common.conf \
      ${D}${sysconfdir}/lxc/

   install -m 0444 ${WORKDIR}/lxc_networking.conf \
      ${D}${sysconfdir}/lxc/

   install -m 0444 ${WORKDIR}/lxc_system.conf ${D}${sysconfdir}/lxc/lxc.conf
   install -m 0555 ${WORKDIR}/container_launch.sh ${D}${sysconfdir}/initscripts/container_launch.sh

}

FILES:${PN} += "${systemd_unitdir}/system/*"
FILES:${PN} += "${sysconfdir}/lxc/*"
FILES:${PN} += "${sysconfdir}/initscripts/*"
FILES:${PN} += "${userfsdatadir}/lxc_rw"
SYSTEMD_SERVICE:${PN} = "telaf_lxc.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
RDEPENDS:${PN}:remove = "curl rsync"
