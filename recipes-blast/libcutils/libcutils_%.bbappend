EXTRA_OECONF:append:qti-distro-debug = "\
            ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sdx qti-vm-host', '--enable-leproperties', '', d)} \
"
