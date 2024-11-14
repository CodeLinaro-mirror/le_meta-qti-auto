FILESEXTRAPATHS:prepend := "${THISDIR}/systemd_255:"

SRC_URI:append = "file://0001-systemd-mask-journald-messages-and-remove-rules-with.patch "
