FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append += " \
    file://0001-Allow-powermgr-group-to-communicate.patch \
"
