RDEPENDS:packagegroup-android-utils-base:append = "\
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-host', 'leproperties', '', d)} \
    "

RDEPENDS:packagegroup-android-utils-base:remove:qti-distro-teleap = "\
    binder \
    "
