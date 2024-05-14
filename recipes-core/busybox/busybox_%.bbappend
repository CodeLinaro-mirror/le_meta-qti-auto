FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"
SRC_URI += "\
            file://automountsdcard.sh \
            file://no-shell-history.cfg \
            file://console_util_opts.cfg \
            file://applets_opts.cfg \
            file://common_opts.cfg \
            file://load_set_font.cfg \
            file://core_opts.cfg \
            file://debian_utils_opts.cfg \
            file://fs_opts.cfg \
	    file://find_utils_opts.cfg \
            file://linux_system_utils_opts.cfg \
            file://network_util_opts.cfg \
            file://shell_opts.cfg \
            file://process_util_opts.cfg \
            file://misc_util_opts.cfg \
            file://debug_opts.cfg \
            file://settings_opts.cfg \
            file://installation_opts.cfg \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0744 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh
    fi
}
