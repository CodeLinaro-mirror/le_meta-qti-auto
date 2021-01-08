FILES_${PN}-misc = "${libdir}/ssl/misc"
do_install () {
        # Create ${D}/${prefix} to fix parallel issues
        mkdir -p ${D}/${prefix}/

        oe_runmake INSTALL_PREFIX="${D}" MANDIR="${mandir}" install

        oe_libinstall -so libcrypto ${D}${libdir}
        oe_libinstall -so libssl ${D}${libdir}

        # Moving libcrypto to /lib
        if [ ! ${D}${libdir} -ef ${D}${base_libdir} ]; then
                mkdir -p ${D}/${base_libdir}/
                mv ${D}${libdir}/libcrypto* ${D}${base_libdir}/
                sed -i s#libdir=\$\{exec_prefix\}\/lib#libdir=${base_libdir}# ${D}/${libdir}/pkgconfig/libcrypto.pc
        fi

        install -d ${D}${includedir}
        cp --dereference -R include/openssl ${D}${includedir}

        oe_multilib_header openssl/opensslconf.h
        install -Dm 0755 ${S}/tools/c_rehash ${D}${bindir}/c_rehash
        sed -i -e '1s,.*,#!${bindir}/env perl,' ${D}${bindir}/c_rehash

        if [ "${@bb.utils.contains('PACKAGECONFIG', 'perl', 'perl', '', d)}" = "perl" ]; then
                sed -i -e '1s,.*,#!${bindir}/env perl,' ${D}${libdir}/ssl/misc/CA.pl
                sed -i -e '1s,.*,#!${bindir}/env perl,' ${D}${libdir}/ssl/misc/tsget
                # The c_rehash utility isn't installed by the normal installation process.
        else
                rm -f ${D}${libdir}/ssl/misc/CA.pl ${D}${libdir}/ssl/misc/tsget
        fi
}
