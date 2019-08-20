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

S = "${WORKDIR}/git"

inherit autotools pkgconfig

PACKAGES = "${PN}-client ${PN}-server ${PN}-dbg ${PN}-trdump ${PN}-doc"

FILES_${PN}-client = "${sbindir}/${BPN}-client"
FILES_${PN}-server = "${bindir}/${BPN}-server"
FILES_${PN}-trdump = "${bindir}/${BPN}-trdump"

ALTERNATIVE_${PN} = "nbd-client"
ALTERNATIVE_TARGET[nbd-client] = "${base_sbindir}/nbd-client.${BPN}"
ALTERNATIVE_LINK_NAME[nbd-client] = "${base_sbindir}/nbd-client"
ALTERNATIVE_PRIORITY = "100"

EXTRA_OECONF = "--enable-syslog"

do_configure_prepend() {
    (cd ${S}; ./autogen.sh; cd -)
}
