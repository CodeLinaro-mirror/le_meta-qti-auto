CACHED_CONFIGUREVARS += " \
     libc_cv_ssp_strong=yes \
     libc_cv_ssp=yes \
"

TARGET_CFLAGS:append:sa525m = "${@bb.utils.contains('MLPREFIX', 'lib32-', ' -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32', '', d)}"
TARGET_CPPFLAGS:append:sa525m = "${@bb.utils.contains('MLPREFIX', 'lib32-', ' -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32', '', d)}"

do_install:append(){
       rm -f ${D}${bindir}/sprof
}
