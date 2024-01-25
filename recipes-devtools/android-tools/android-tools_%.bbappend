COMPATIBLE_MACHINE = "(sa525m|sa410m)"
SYSTEMD_SERVICE:${PN} = ""

do_install() {

    if echo ${TOOLS} | grep -q "adb " ; then
        install -d ${D}${bindir}
        install -m0755 ${B}/adb/adb ${D}${bindir}
    fi
}
