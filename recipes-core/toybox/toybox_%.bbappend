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
