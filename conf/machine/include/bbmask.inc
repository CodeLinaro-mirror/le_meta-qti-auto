#BBMASK = "meta-qti-bsp/recipes-kernel/lk/lk_git.bb"
#BBMASK .= "|meta-selftest/recipes-test/container-image/cc.bb"

#Display bbmask
BBMASK = "meta-qti-display/recipes-products/images/machine-qsap-image.bbappend"
BBMASK .= "|meta-qti-display/recipes-products/images/automotive-image.bbappend"
BBMASK .= "|meta-qti-display/recipes/wayland/weston_1.9.0.bbappend"
BBMASK .= "|meta-qti-display/recipes-products/images/machine-minimal-image.bbappend"

BBMASK .= "|meta-agl/meta-agl/recipes-graphics/wayland/"
BBMASK .= "|meta-agl/meta-ivi-common/recipes-graphics/wayland/"
BBMASK .= "|meta-agl-demo/recipes-graphics/wayland/"
BBMASK .= "|meta-agl/meta-ivi-common/recipes-test/wayland/"
BBMASK .= "|meta-agl/meta-app-framework/recipes-kernel/linux/linux-yocto_4.1.bbappend"
BBMASK .= "|meta-agl/meta-agl/recipes-devtools/autogen/autogen-native_5.18.12.bbappend"
BBMASK .= "|meta-agl/meta-agl/recipes-connectivity/connman/"
BBMASK .= "|meta-agl/meta-agl/recipes-connectivity/rygel/"
BBMASK .= "|meta-agl/meta-agl/recipes-core/psplash/"
BBMASK .= "|meta-agl/meta-ivi-common/recipes-test/freetype/"
BBMASK .= "|meta-agl-demo/recipes-support/opencv/"
BBMASK .= "|meta-agl-demo/recipes-qt/qt5/qtmultimedia_%.bbappend"
BBMASK .= "|meta-agl-demo/recipes-core/packagegroups/"

BBMASK .= "|meta-qti-bsp/recipes-devtools/gdb/gdb_%.bbappend"
BBMASK .= "|meta-qti-bsp/recipes-core/systemd/systemd_%.bbappend"
BBMASK .= "|meta-qti-bsp/recipes-core/volatile-binds/volatile-binds.bbappend"

BBMASK .= "|meta-qti-data/recipes/iproute2/"
BBMASK .= "|meta-qti-data/recipes/avahi/"

