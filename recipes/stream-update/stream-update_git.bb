SUMMARY = "stream update engine daemon"
DESCRIPTION = "\
update engine daemon support fota update for full AB systems \
update can be applied in small chunks removing dependency for space \
required for update operation"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "glib-2.0 libmincrypt-native system-core oem-recovery libsparse bison-native curl bzip2 e2fsprogs zlib xz lzo lz4 liblog libbspatch libxz libbrillo protobuf libalzma libbinderwrapper boringssl binderstreaming libevent libchrome protobuf-native aidl-native aidl-lib-native telaf-flash-access"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'ab-boot-support', 'abctl', '', d)}"
PR = "r0"
SRC_URI = "file://OTA/streaming/system/update_engine/ \
           file://stream-update.service \
          "
S = "${WORKDIR}/OTA/streaming/system/update_engine/"
SYSTEMD_SERVICE_${PN} = "stream-update.service"

inherit autotools-brokensep pkgconfig systemd useradd

EXTRA_OECONF_append = " --with-glib"
EXTRA_OECONF += "${@bb.utils.contains('DISTRO_FEATURES', 'ab-boot-support', 'TARGET_SUPPORTS_AB=true', '', d)}"
EXTRA_OECONF += " ${@bb.utils.contains('DISTRO_FEATURES', 'nand-boot', '--with-nand_boot=true', '', d)}"

FILES_${PN} += "/${userfsdatadir}"
do_compile_prepend () {
   echo "Running interface generation"
   ${S}/update_metadata_proto.sh
   ${S}/update_aidl_interface.sh
}

do_install() {
   install -d ${D}${userfsdatadir}
   install -m 0755 ${S}/update_engine_sideload -D ${D}/usr/bin/update_engine_sideload
   install -d ${D}${sysconfdir}/initscripts/
   install -m 0755 ${S}/start_update_engine -D ${D}${sysconfdir}/initscripts/start_update_engine
   install -d ${D}${systemd_unitdir}/system/
   install -m 0644 ${WORKDIR}/stream-update.service -D ${D}${systemd_unitdir}/system/stream-update.service
   install -m 0755 -o system -g system -d ${D}${userfsdatadir}/stream_update/
}
FILESPATH =+ "${WORKSPACE}:"
FILES_${PN} += "${systemd_unitdir}/system/* ${userfsdatadir}/stream_update/*"
