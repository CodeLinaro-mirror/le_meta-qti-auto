FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-Fix-adb-shell-env-issue.patch"

EXTRA_OECONF_append = " --disable-libsync"

COMPOSITION = "901D"
