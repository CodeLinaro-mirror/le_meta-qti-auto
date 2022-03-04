inherit autotools-brokensep pkgconfig
PR = "r0"

DESCRIPTION = "generate stream update interface files"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=48b43ba58d0f8e9ef3704313a46b7a43"

DEPENDS = "aidl"
RDEPENDS_${PN} = "aidl"
FILESPATH = "${WORKSPACE}/poky/meta-qti-auto/recipes/aidl/:"
SRC_URI += "file://gen.sh"

SYSTEMD_SUPPORT = "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}"

SELINUX_SUPPORT = "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux', '', d)}"
PARALLEL_MAKE = ""
INITSCRIPT_NAME = "aidl"


FILES_${PN}  = "${sysconfdir}"
FILES_${PN}  = "/recovery/etc/"
FILES_${PN} += "/cache"
FILES_${PN} += "/data"
FILES_${PN} += "/recovery/res"
FILES_${PN} += "/system"
FILES_${PN} += "/recovery/res"
FILES_${PN} += "/data"
FILES_${PN} += "/recovery/lib"

PACKAGES += "${PN}-bin"
FILES_${PN}-bin += "${bindir}"

do_configure[depends] += "aidl:do_compile"

do_configure() {
    echo "Running update engine interface files "
    cp ${WORKDIR}/gen.sh ${S}
    chmod 755 ${S}/gen.sh
    cd ${S}
    ./gen.sh
    cd -
}

do_compile[noexec] = "1"
do_install[noexec] = "1"
