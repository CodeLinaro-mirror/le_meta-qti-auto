SRC_URI:append:sa415m = " \
    file://0001-minadbd-Added-cflags-to-support-strlcpy-function.patch \
    file://0002-minadbd-Update-adb-function-calls.patch \
    file://0003-Update-TRACE_TAGS-to-reflect-latest-adb-changes.patch \
"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
