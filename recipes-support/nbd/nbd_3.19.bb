################################################################################
# This file is copied from
# http://cgit.openembedded.org/meta-openembedded/tree/meta-networking/recipes-support/nbd/nbd_3.19.bb?h=master
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
################################################################################

DESCRIPTION = "Network Block Device"
HOMEPAGE = "http://nbd.sourceforge.io"
SECTION = "net"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS = "glib-2.0"

SRC_URI = "git://github.com/networkblockdevice/nbd.git"
SRCREV = "e757bde96ac7a24f2be4e9d025486990ceb910ef"

SRC_URI += "file://0001-Disable-manpages-compilation.patch"
SRC_URI += "file://setup_nbdclient"
SRC_URI += "file://02-setup_nbdclient.rules"
SRC_URI += "file://nbdtab"
SRC_URI += "file://nbdclient.service"

S = "${WORKDIR}/git"

inherit autotools pkgconfig update-alternatives

PACKAGES = "${PN}-client ${PN}-server ${PN}-dbg ${PN}-trdump ${PN}-doc"

FILES_${PN}-client = "${sbindir}/${BPN}-client.${BPN}"
FILES_${PN}-server = "${bindir}/${BPN}-server"
FILES_${PN}-trdump = "${bindir}/${BPN}-trdump"

ALTERNATIVE_${PN}-client = "nbd-client"
ALTERNATIVE_TARGET[nbd-client] = "${sbindir}/nbd-client"
ALTERNATIVE_LINK_NAME[nbd-client] = "${sbindir}/nbd-client"
ALTERNATIVE_PRIORITY[nbd-client] = "100"

EXTRA_OECONF = "--enable-syslog"

do_configure_prepend() {
    (cd ${S}; ./autogen.sh; cd -)
}

do_install_append() {
   if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
       # Install script that will setup the nbd-client
       install -d ${D}${sbindir}/
       install -m 0755 ${WORKDIR}/setup_nbdclient ${D}${sbindir}/setup_nbdclient
       #Install systemd service file
       install -d ${D}${systemd_unitdir}/system
       install -m 0644 ${WORKDIR}/nbdclient.service ${D}${systemd_unitdir}/system/
       #install nbdtab conf file
       install -d ${D}${sysconfdir}/
       install -m 0644 ${WORKDIR}/nbdtab ${D}${sysconfdir}/nbdtab
       # Install udev client rule
       install -d ${D}${sysconfdir}/udev/rules.d/
       install -m 0555 ${WORKDIR}/02-setup_nbdclient.rules ${D}${sysconfdir}/udev/rules.d/02-setup_nbdclient.rules
   fi
}

FILES_${PN}-client += "${sysconfdir}/udev/rules.d/* "
FILES_${PN}-client += "${sbindir}/*"
FILES_${PN}-client += "${systemd_unitdir}/system/*"
FILES_${PN}-client += "${sysconfdir}/*"
