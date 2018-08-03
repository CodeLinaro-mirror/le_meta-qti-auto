#BBMASK = "meta-qti-bsp/recipes-kernel/lk/lk_git.bb"
#BBMASK .= "|meta-selftest/recipes-test/container-image/cc.bb"

#Display bbmask
BBMASK = "meta-qti-display/recipes-products/images/machine-qsap-image.bbappend"
BBMASK .= "|meta-qti-display/recipes-products/images/automotive-image.bbappend"
BBMASK .= "|meta-qti-display/recipes/wayland/weston_1.9.0.bbappend"
BBMASK .= "|meta-qti-display/recipes-products/images/machine-minimal-image.bbappend"
