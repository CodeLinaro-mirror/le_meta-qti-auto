FILESEXTRAPATHS:prepend := "${THISDIR}/systemd_250:"

SRC_URI:append = "file://0001-systemd-mask-journald-messages-and-remove-rules-with.patch "
SRC_URI:append:sa415m = "file://0001-systemd-disable-have_close_range.patch "
