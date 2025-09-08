FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://y2038-syslog.patch"

CACHED_CONFIGUREVARS += " \
     libc_cv_ssp_strong=yes \
     libc_cv_ssp=yes \
"

do_install:append(){
       rm -f ${D}${bindir}/sprof
}

TARGET_CFLAGS:append:sa415m = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"
TARGET_CPPFLAGS:append:sa415m = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"
