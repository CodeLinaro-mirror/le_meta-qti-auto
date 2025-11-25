FILESEXTRAPATHS:prepend := "${THISDIR}/systemd_255:"

SRC_URI:append += " \
    file://0001-systemd-mask-journald-messages-and-remove-rules-with.patch \
    ${@bb.utils.contains('MACHINE_FEATURES','tele-squashfs-ubi', 'file://0002-remove-provision.conf-from-the-builds-as-squashfs-is.patch', '', d)} \
    "

do_install:append () {
   #  'systemctl unmask' can be used on device to enable them if needed.
   if [ "${SYSTEMD_ENABLE_JOURNAL}" != "1" ]; then
       ln -sf /dev/null ${D}${sysconfdir}/systemd/system/systemd-journald-audit.socket
   fi
}
