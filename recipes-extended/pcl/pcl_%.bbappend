INSANE_SKIP_${PN} += "installed-vs-shipped"
do_install_append() {
    install -d ${D}/usr/lib64/
    mv ${D}/usr/lib/* ${D}/usr/lib64/
}
FILES_${PN} += "/usr/lib64/*"
