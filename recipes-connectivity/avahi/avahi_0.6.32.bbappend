# fix LV systemd avahi support

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://avahi-daemon.service.in.patch"

