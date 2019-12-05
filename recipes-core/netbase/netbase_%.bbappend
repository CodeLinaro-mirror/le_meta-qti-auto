do_install_append () {
   if ${@bb.utils.contains('DISTRO_FEATURES', 'flashless', 'true', 'flase', d)}; then
      echo "192.168.225.40 qti-host" >> ${D}${sysconfdir}/hosts
   fi
}
