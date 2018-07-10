require ${COREBASE}/meta-qti-auto/conf/machine/mdm9607.conf

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI  +=  " ${@bb.utils.contains('DISTRO_FEATURES','ntn-hsic-kern-mod','file://0001-Early-file-system-access-for-mdm-9x07-target.patch','',d)}"

do_patch () {
    if ${@base_contains('DISTRO_FEATURES', 'ntn-hsic-kern-mod', 'true', 'false', d)}; then
        cd ${S}
        patch -p1 < ${WORKDIR}/0001-Early-file-system-access-for-mdm-9x07-target.patch
    fi
}

do_configure_prepend_mdm9607 () {
	if ${@base_contains('DISTRO_FEATURES', 'ntn-hsic-kern-mod', 'true', 'false', d)}; then
		mkdir -p ${S}/drivers/net/ethernet/neutrino
		cp -f ${WORKSPACE}/qcom-opensource/ethernet/neutrino-hsic/driver/* ${S}/drivers/net/ethernet/neutrino/
		rm ${S}/drivers/net/ethernet/neutrino/Makefile
		mv ${S}/drivers/net/ethernet/neutrino/Makefile.builtin ${S}/drivers/net/ethernet/neutrino/Makefile
		echo "obj-y += neutrino/" >> ${S}/drivers/net/ethernet/Makefile
	fi
}