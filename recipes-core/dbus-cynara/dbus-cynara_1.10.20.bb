require ${COREBASE}/meta/recipes-core/dbus/dbus_1.10.20.bb

FILESEXTRAPATHS_prepend := "${COREBASE}/meta/recipes-core/dbus/dbus:"
S = "${WORKDIR}/dbus-${PV}"

SRC_URI_append = "\
   https://source.codeaurora.org/quic/le/AGL/meta-agl/plain/meta-security/recipes-core/dbus-cynara/dbus-cynara/0001-Integration-of-Cynara-asynchronous-security-checks.patch?h=automotivelinux/flounder;downloadfilename=0001-Integration-of-Cynara-asynchronous-security-checks.patch;md5sum=3330fe1d9c99e311fd689a534a0acdf2;sha256sum=e28aad5f8b35e8c0d3cbf004fa72cc65744f175a01892e4933c67c2377aac298 \
   https://source.codeaurora.org/quic/le/AGL/meta-agl/plain/meta-security/recipes-core/dbus-cynara/dbus-cynara/0002-Disable-message-dispatching-when-send-rule-result-is.patch?h=automotivelinux/flounder;downloadfilename=0002-Disable-message-dispatching-when-send-rule-result-is.patch;md5sum=ded97761db437305341fdf8c1c7f02a4;sha256sum=e4408fd20fdaeb90daa41bf55753fc5498c8c200a6701bc20b221cc19811f0b8 \
   https://source.codeaurora.org/quic/le/AGL/meta-agl/plain/meta-security/recipes-core/dbus-cynara/dbus-cynara/0003-Handle-unavailability-of-policy-results-for-broadcas.patch?h=automotivelinux/flounder;downloadfilename=0003-Handle-unavailability-of-policy-results-for-broadcas.patch;md5sum=68314748a6d8842def74ec101742123d;sha256sum=a4b1efdc2f2bb63e38766bb48cfcf60d16e3c653babfffafdce2f0d8fd8f872e \
   https://source.codeaurora.org/quic/le/AGL/meta-agl/plain/meta-security/recipes-core/dbus-cynara/dbus-cynara/0004-Add-own-rule-result-unavailability-handling.patch?h=automotivelinux/flounder;downloadfilename=0004-Add-own-rule-result-unavailability-handling.patch;md5sum=9b9b075043d9609090c101ab01472da0;sha256sum=acc0860b923f137dddaac9e19cafa9e73f1e0568c98378b39f6001153ab08116 \
   https://source.codeaurora.org/quic/le/AGL/meta-agl/plain/meta-security/recipes-core/dbus-cynara/dbus-cynara/0005-Perform-Cynara-runtime-policy-checks-by-default.patch?h=automotivelinux/flounder;downloadfilename=0005-Perform-Cynara-runtime-policy-checks-by-default.patch;md5sum=f9901e8f2cd810b97be63ab6d3b033d1;sha256sum=152c01a0e47d5cfc6230fd39e25fb1666b78f1a48916cd476fceba13006ea044 \
   "

DEPENDS += "cynara smack"
RDEPENDS_${PN} += "dbus"

EXTRA_OECONF += "--enable-cynara --disable-selinux"

inherit distro_features_check
REQUIRED_DISTRO_FEATURES += "smack"

# Only the main package gets created here, everything else remains in the
# normal dbus recipe.
do_install_append () {
    for i in ${@' '.join([d.getVar('D', True) + x for x in (' '.join([d.getVar('FILES_${PN}-' + p, True) or '' for p in ['lib', 'dev', 'staticdev', 'doc', 'locale', 'ptest']])).split()])}; do
        rm -rf $i
    done

    # Try to remove empty directories, starting with the
    # longest path (= deepest directory) first.
    # Find needs a valid current directory. Somehow the directory
    # we get called in is gone by the time that we get invoked.
    ( cd ${D}
      for i in `find . -type d | sort -r`; do
        rmdir $i || true
      done
    )
}

# Avoid warning about dbus and dbus-cynara providing dbus-x11.
RPROVIDES_${PN}_remove = "${OLDPKGNAME}"
