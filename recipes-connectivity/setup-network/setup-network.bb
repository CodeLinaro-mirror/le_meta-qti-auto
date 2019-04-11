SUMMARY = "Scripts for setup 8155 LV GVM  Network"
SECTION = "network"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

inherit systemd

# Including the file depends on chipset
INCSUFFIX = "${@bb.utils.contains('MACHINE', 'qtiquingvm', 'setup-network', 'none',d)}"

FILESEXTRAPATHS_append := ":${THISDIR}/setup-network"
SRC_URI = " file://setup-network.sh \
            file://setup-network.service \
          "

do_install() {
}

RDEPENDS_${PN} += "bash"
# Including the file depends on chipset

include ${INCSUFFIX}-${MACHINE}.inc
