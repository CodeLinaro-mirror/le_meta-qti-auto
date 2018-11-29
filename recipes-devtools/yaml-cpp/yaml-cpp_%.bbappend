FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI[md5sum] = "e2507c3645fc2bec29ba9a1838fb3951"
SRC_URI[sha256sum] = "3492d9c1f4319dfd5588f60caed7cec3f030f7984386c11ed4b39f8e3316d763"

SRC_URI_append += "file://0001-Install-libs-to-usr-lib64.patch"
