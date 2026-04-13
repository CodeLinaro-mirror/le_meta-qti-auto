RDEPENDS:packagegroup-android-utils-base:append:qti-distro-debug = "\
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-host', 'leproperties', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sdx', 'leproperties', '', d)} \
    "

RDEPENDS:packagegroup-android-utils-base:remove:qti-distro-teleap = "\
    binder \
    "
RDEPENDS:packagegroup-android-utils-base += "    procrank     "
RDEPENDS:packagegroup-android-utils-base:remove:sa415m = "leproperties"
RDEPENDS:packagegroup-android-utils-base:remove:sa510m = "leproperties"
