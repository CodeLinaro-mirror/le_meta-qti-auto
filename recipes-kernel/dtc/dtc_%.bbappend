
# change the SRC dir
FILESPATH =+ "${WORKSPACE}/external/:"
SRC_URI = "file://dtc"
S = "${WORKDIR}/dtc"
EXTRA_OEMAKE_append = " NO_PYTHON=1"

FILESEXTRAPATHS_append := ":${THISDIR}/files"
SRC_URI_append += "file://0001-dtc-fix-Android-dtc-compile-issue.patch"

do_fetch_prepend(){
    bb.warn('NOTE: bbappend overrides dtc recipe\'s version and sets it to Android 1.4.4')
}

