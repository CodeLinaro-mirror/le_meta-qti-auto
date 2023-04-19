DESCRIPTION = "cannelloni a SocketCAN over Ethernet tunnel"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${S}/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

inherit pkgconfig cmake

DEPENDS = "virtual/kernel"

SRC_URI = "${CLO_LE_GIT}/platform/external/cannelloni;protocol=https;branch=caf_migration/cannelloni/master;rev=e3ac7393b566345d057c2d17a4d328007caaacac"

S = "${WORKDIR}/git"

SRC_URI += "file://Fix-cmake-for-64bit.patch \
            file://Add-socket-filters.patch"

INSANE_SKIP_${PN} = "dev-deps"
INSANE_SKIP_${PN}-dev = "dev-elf"
