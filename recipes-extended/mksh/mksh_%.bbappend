SYSROOT_DIRS += "${bindir}"

sysroot_stage_all_append() {
  install -d ${SYSROOT_DESTDIR}${bindir}
  install -m 0755 ${D}/bin/mksh ${SYSROOT_DESTDIR}${bindir}/mksh
}


