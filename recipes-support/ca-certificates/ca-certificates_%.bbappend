do_install:append () {
    find ${D}${datadir}/ca-certificates -type f \( -iname 'Comodo*.crt' -o -iname 'Amazon*.crt' -o -iname 'USERTrust*.crt' \)  | \
    sed 's,^${D}${datadir}/ca-certificates/,,' > ${D}${sysconfdir}/ca-certificates.conf
    find ${D}${datadir}/ca-certificates/mozilla -type f ! \( -iname 'comodo*' -o -iname 'amazon*' -o -iname 'usertrust*' \) | xargs rm -f
}
