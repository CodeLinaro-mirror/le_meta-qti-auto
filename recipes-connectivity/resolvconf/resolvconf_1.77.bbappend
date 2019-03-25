FILESEXTRAPATHS_prepend := "${THISDIR}/resolvconf:"

RDEPENDS_${PN}_remove = "bash"

SRC_URI += "file://0001-debashing-resolvconf.patch"
