inherit autotools-brokensep pkgconfig update-rc.d

PR = "r0"

DESCRIPTION = "AB Stream updater "
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "glib-2.0 libmincrypt-native system-core oem-recovery libsparse bison-native curl bzip2 e2fsprogs zlib xz lzo lz4 liblog libbspatch libxz libbrillo protobuf libalzma libbinderwrapper boringssl binderstreaming libevent libchrome \
protobuf protobuf-native \
aidl-native aidl-lib-native \
telaf-flash-access"

RDEPENDS_${PN} = "zlib"
RDEPENDS_${PN}-bin = "recovery-lib"
SRC_URI = "file://OTA/streaming/system/update_engine/"
SRC_URI =+ "file://stream-update.service"
SRC_URI =+ "file://stream-update.rules"
S = "${WORKDIR}/OTA/streaming/system/update_engine/"

INSANE_SKIP_${PN} += "file-rdeps"
INSANE_SKIP_${PN}-bin += "file-rdeps"

EXTRA_OECONF = "--with-glib --with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include \
                --with-core-headers=${STAGING_INCDIR} "

CFLAGS += "-lsparse -llog"

HEADERS_PATH="${WORKDIR}/recipe-sysroot/telaf/legato/legato-af/framework/include"
HEADERS_CONFIG_PATH="${WORKDIR}/recipe-sysroot/telaf/legato/legato-af/build/sa515m/framework/include"

SYSTEMD_SUPPORT = "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}"

SELINUX_SUPPORT = "${@bb.utils.contains('DISTRO_FEATURES', 'selinux', 'selinux', '', d)}"

AB_SUPPORT = "${@bb.utils.contains('DISTRO_FEATURES', 'ab-boot-support', 'TARGET_SUPPORTS_AB=true', '', d)}"
NEED_ABCTL = "${@bb.utils.contains('DISTRO_FEATURES', 'ab-boot-support', 'abctl', '', d)}"
EXTRA_OECONF += " ${@bb.utils.contains('DISTRO_FEATURES', 'nand-boot', '--with-nand_boot=true', '', d)}"
# temp enable abctl with nand-boot, later enable with ab once partition changes are done
EXTRA_OECONF += " ${AB_SUPPORT}"
DEPENDS += " ${NEED_ABCTL}"
DEPENDS += "qemu-native"
DEPENDS += "telaf-build"


BBCLASSEXTEND = "native"

EXTRA_OECONF += "--with-telaf-headers=${HEADERS_PATH}"
EXTRA_OECONF += "--with-telafconfig-headers=${HEADERS_CONFIG_PATH}"

PARALLEL_MAKE = ""
INITSCRIPT_NAME = "update_engine"
INITSCRIPT_PARAMS = "start 99 5 . stop 80 0 1 6 ."

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
PACKAGES += "${PN}-bin"
FILES_${PN} += "/lib"
FILES_${PN} += "/data"
FILES_${PN}-bin += "${bindir}"

do_compile_prepend () {
   echo "Running interface generation"
   ${S}/update_metadata_proto.sh
   ${S}/update_aidl_interface.sh
}

do_install_append() {
        install -d ${D}/cache/
        install -d ${D}/res/
        install -d ${D}/data/
        install -d ${D}/system/
        install -d ${D}${sysconfdir}/initscripts/
        install -d ${D}${systemd_unitdir}/system/
        install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/
        install -m 0755 ${S}/start_update_engine -D ${D}${sysconfdir}/initscripts/start_update_engine
        install -m 0644 ${WORKDIR}/stream-update.service -D ${D}${systemd_unitdir}/system/stream-update.service
        ln -sf ${systemd_unitdir}/system/stream-update.service \
        ${D}${systemd_unitdir}/system/multi-user.target.wants/stream-update.service
        install -d ${D}${sysconfdir}/udev/rules.d/
        install -m 0644 ${WORKDIR}/stream-update.rules -D ${D}${sysconfdir}/udev/rules.d/stream-update.rules
        install -m 0755 -o system -g system -d ${D}${userfsdatadir}/stream_update/

        install -m 0755 ${WORKSPACE}/poky/meta-qti-bsp/recipes-bsp/base-files-recovery/fstab_AB -D ${D}/res/recovery_volume_config
}
FILESPATH =+ "${WORKSPACE}:"
