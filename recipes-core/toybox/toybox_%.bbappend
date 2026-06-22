DEPENDS = "kern-tools-native"
FILESEXTRAPATHS:prepend := "${THISDIR}/toybox:"
SRC_URI += "file://toybox_utilities.cfg"

# returns all the elements from the src uri that are .cfg files
def find_cfgs(d):
    sources=src_patches(d, True)
    sources_list=[]
    for s in sources:
        if s.endswith('.cfg'):
            sources_list.append(s)

    return sources_list

do_configure:append(){
  merge_config.sh -m .config ${@" ".join(find_cfgs(d))}
}

# toybox installs toybox.links with raw /bin/ paths, not honouring base_bindir with usrmerge base_bindir=/usr/bin
# Rewrite the links file after install so update-alternatives registers /usr/bin/ instead of /bin/, avoiding the mv "same file" failure caused by /bin being a symlink to /usr/bin.
do_install:append() {
    if [ -f ${D}${sysconfdir}/toybox.links ]; then
        if ${@bb.utils.contains('DISTRO_FEATURES', 'usrmerge', 'true', 'false', d)}; then
            sed -i 's|^/bin/|${base_bindir}/|' ${D}${sysconfdir}/toybox.links
            sed -i 's|^/sbin/|${base_sbindir}/|' ${D}${sysconfdir}/toybox.links
            sed -i 's|^/usr/bin/|${bindir}/|' ${D}${sysconfdir}/toybox.links
            sed -i 's|^/usr/sbin/|${sbindir}/|' ${D}${sysconfdir}/toybox.links
        fi
    fi
}
