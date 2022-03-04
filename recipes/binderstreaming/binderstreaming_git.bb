SUMMARY = "support binder framework for stream update"

DESCRIPTION = "${SUMMARY}"
HOMEPAGE = "http://developer.android.com/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "liblog libcutils system-core glib-2.0"
PR = "r0"
FILESPATH =+ "${WORKSPACE}/OTA/streaming/frameworks/:"

SRC_URI  = "file://native"

S = "${WORKDIR}/native"

EXTRA_OECONF += " --with-glib"

# This recipe assumes kernel always compile for default arch even when
# multilib compilation is enabled. If kernel is 64bit and binder is compiled
# for 32bit due to multilib settings default 64bit IPC need to be supported
# as kernel is 64bit. Only when kernel is 32bit, 32bit IPC need to be enabled.
EXTRA_OECONF_append_arm = " \
    ${@bb.utils.contains('MULTILIB_VARIANTS', 'lib32','','--enable-32bit-binder-ipc',d)} \
"

# sdmsteppe uses 64bit IPC though userspace is 32bit.
EXTRA_OECONF_remove_sdmsteppe = "--enable-32bit-binder-ipc"

FILES_${PN} += "${systemd_unitdir}/system/"
inherit autotools pkgconfig useradd
