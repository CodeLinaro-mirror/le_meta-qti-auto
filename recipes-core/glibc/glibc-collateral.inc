require glibc-common.inc

LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-auto/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6 \
                     file://${COREBASE}/meta-qti-auto/files/common-licenses/LGPL-2.1-only;md5=1a6d268fd218675ffea8be556788b780"

deltask do_fetch
deltask do_unpack
deltask do_patch
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install[depends] += "virtual/${MLPREFIX}libc:do_stash_locale"
