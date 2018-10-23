do_install_append () {
    ln -sf ../private/android_filesystem_capability.h ${D}${includedir}/cutils/android_filesystem_capability.h
    ln -sf ../private/android_filesystem_config.h ${D}${includedir}/cutils/android_filesystem_config.h
}

