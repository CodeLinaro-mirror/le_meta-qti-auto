# Get list of packages to be installed onto the root filesystem.
# If product is specified try to include product inc otherwise include base inc.
def get_img_inc_file(d):
    product     = d.getVar('PRODUCT', True)
    basemachine = d.getVar('BASEMACHINE', True)
    if product != 'base' or '':
        inc_file_name = basemachine + "-" + product + "-image.inc"
    else:
        inc_file_name = basemachine + "-" + "base-image.inc"
    img_inc_file_path = os.path.join(d.getVar('THISDIR', True), basemachine, inc_file_name)
    if os.path.exists(img_inc_file_path):
        img_inc_file = inc_file_name
    else:
        img_inc_file = basemachine + "-base-image.inc"
    return img_inc_file

include ${BASEMACHINE}/${@get_img_inc_file(d)}

# Below is to generate sparse ext4 system image (OE by default supports raw ext4 images)

do_makesystem() {
    echo "TODO: do makesystem"
}


DEPENDS += "mkbootimg-native"

EXTRA_IMAGECMD_ext4 = "-i 4096 -b 4096"

IMAGE_ROOTFS_SIZE = "1048576"

SSTATE_MANFILEPREFIX="${@base_conditional('PERF_BUILD', '1', '${SSTATE_MANIFESTS}/manifest-${SSTATE_MANMACH}-${PN}-perf', '${SSTATE_MANIFESTS}/manifest-${SSTATE_MANMACH}-${PN}' , d)}"

