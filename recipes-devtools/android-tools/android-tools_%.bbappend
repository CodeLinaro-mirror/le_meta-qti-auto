COMPATIBLE_MACHINE = "(sa525m|sa410m|sa510m|sa510m-1g)"
SYSTEMD_SERVICE:${PN} = ""

do_install() {

    if echo ${TOOLS} | grep -q "adb " ; then
        install -d ${D}${bindir}
        install -m0755 ${B}/adb/adb ${D}${bindir}
    fi

    # Outside the if statement to avoid errors during do_package
    install -D -p -m0644 ${WORKDIR}/android-tools-adbd.service \
      ${D}${systemd_unitdir}/system/android-tools-adbd.service
}
