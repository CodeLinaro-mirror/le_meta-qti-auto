EXTRA_OECONF:append:qti-distro-debug = "\
            ${@bb.utils.contains_any('MACHINE_FEATURES', 'qti-sdx qti-vm-host', '--enable-leproperties', '', d)} \
"
