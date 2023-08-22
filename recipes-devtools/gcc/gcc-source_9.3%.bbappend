FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_sa415m += "file://0001-libstdc-Use-custom-timespec-in-system-calls-PR-93421.patch \
                          file://0001-libstdc-Disable-gthreads-weak-symbols-for-glibc-2.34.patch \
                         "
SRC_URI_append_mdm9607 += "file://0001-libstdc-Use-custom-timespec-in-system-calls-PR-93421.patch \
                          file://0001-libstdc-Disable-gthreads-weak-symbols-for-glibc-2.34.patch \
                         "
