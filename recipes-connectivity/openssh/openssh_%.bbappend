
do_install_append () {
	sed -i -e 's:#PermitRootLogin yes:PermitRootLogin yes:' ${D}${sysconfdir}/ssh/sshd_config
}

