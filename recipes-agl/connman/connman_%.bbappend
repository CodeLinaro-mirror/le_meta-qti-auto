SRC_URI += "https://source.codeaurora.org/quic/le/AGL/meta-agl/plain/meta-agl-profile-core/recipes-connectivity/connman/files/0001-disable-when-booting-over-nfs.patch?h=automotivelinux/flounder;downloadfilename=0001-disable-when-booting-over-nfs.patch;md5sum=dad2c158b24e000341ef595f884e519d;sha256sum=9d0fdbc5706e68aa80c11f3d168812c97ace2ddecde004c136ffcd516375b88d"

do_install_append() {
    if ${@bb.utils.contains('IMAGE_FEATURES','read-only-rootfs','true','false',d)}; then
        sed -i -e '/^L+/d'  ${D}${sysconfdir}/tmpfiles.d/connman_resolvconf.conf
    fi
}
