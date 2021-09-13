do_install_append () {
    find ${D}${datadir}/ca-certificates -type f -iname 'Comodo*.crt' | \
    sed 's,^${D}${datadir}/ca-certificates/,,' > ${D}${sysconfdir}/ca-certificates.conf
    find ${D}${datadir}/ca-certificates/ -type f ! -iname 'comodo*' | xargs rm -f
}
