
DESCRIPTION = "Open AVB"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD;md5=3775480a712fc46a69647678acb234cb"

FILESEXTRAPATHS_prepend := "${WORKSPACE}/external:"
SRC_URI = "file://open-avb"

PR = "r0"
PV = "0.1"

DEPENDS += "alsa-lib libpcap pciutils cmake-native glib-2.0 gstreamer1.0 gstreamer1.0-plugins-base"

S = "${WORKDIR}/open-avb"

PACKAGE_ARCH = "${MACHINE_ARCH}"

TARGET_CC_ARCH += "${LDFLAGS}"

SECURITY_CFLAGS_remove_pn-open-avb = "-D_FORTIFY_SOURCE=2"

do_compile_prepend() {
}

do_compile() {
	export AVB_FEATURE_NEUTRINO=1
	export AVB_FEATURE_INTF_ALSA2=0
	export AVB_FEATURE_GSTREAMER=1
	export GSTREAMER_1_0=1
	echo ${FILESEXTRAPATHS}
	echo ${subdir}

	mkdir -p ${S}/daemons/maap/build
	oe_runmake daemons_all
	make avtp_pipeline
}

do_install() {
	mkdir -p ${D}/${bindirr}/
	mkdir -p ${D}/${bindir}/avb/
	install ${S}/daemons/maap/linux/maap_daemon ${D}/${bindir}/avb
	install ${S}/daemons/mrpd/mrpd ${D}/${bindir}/avb
	install ${S}/daemons/mrpd/mrpctl ${D}/${bindir}/avb
	install ${S}/daemons/gptp/linux/build/obj/daemon_cl ${D}/${bindir}/avb
	install ${S}/lib/avtp_pipeline/build/bin/* ${D}/${bindir}/avb
	mkdir -p ${D}/${libdir}/
	install ${S}/lib/avtp_pipeline/build/lib/*.so ${D}/${libdir}
}

FILES_${PN} =+ "${bindir}/avb/*"
FILES_${PN} =+ "${libdir}/*"
FILES_${PN}-dev = ""
FILES_${PN}-dbg += "${bindir}/avb/.debug/*"

