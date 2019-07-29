do_install_append() {
	sed -i -e 's/yes/no/' ${D}/etc/xinetd.d/telnet
}
