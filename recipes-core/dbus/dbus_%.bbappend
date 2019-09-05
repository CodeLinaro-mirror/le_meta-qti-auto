FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://extra-users-auto.conf"
SRC_URI += "file://Removed-symlink-for-machine-id.patch"

do_install_append() {
   install -d ${D}/${datadir}/dbus-1/system.d/
   install -m 0644 ${WORKDIR}/extra-users-auto.conf -D ${D}${datadir}/dbus-1/system.d/extra-users-auto.conf
}
