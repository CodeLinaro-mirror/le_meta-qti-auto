require ${COREBASE}/meta-qti-auto/conf/machine/mdm9607.conf

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI  +=  " ${@bb.utils.contains('DISTRO_FEATURES','ntn-hsic-kern-mod','file://0001-Early-file-system-access-for-mdm-9x07-target.patch','',d)}"
SRC_URI  +=  " ${@bb.utils.contains('DISTRO_FEATURES','add-do-div-fixes', 'file://0001-ARM-asm-div64.h-include-bug.h-file-to-resolve-compil.patch','',d)}"

do_patch () {
    cd ${S}
    if ${@base_contains('DISTRO_FEATURES', 'ntn-hsic-kern-mod', 'true', 'false', d)}; then
        patch -p1 < ${WORKDIR}/0001-Early-file-system-access-for-mdm-9x07-target.patch
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'add-do-div-fixes', 'true', 'false', d)}; then
        wget https://source.codeaurora.org/quic/la/kernel/msm-4.9/patch/?id=911918aa7ef6f868c135505b0015e42072c54682 -O ${WORKDIR}/0001-div64.h-optimize-do_div-for-power-of-two-constant-di.patch
        patch -p1 < ${WORKDIR}/0001-div64.h-optimize-do_div-for-power-of-two-constant-di.patch

        wget https://source.codeaurora.org/quic/la/kernel/msm-4.9/patch/?id=461a5e51060c93f5844113f4be9dba513cc92830 -O ${WORKDIR}/0001-do_div-generic-optimization-for-constant-divisor-on-.patch
        patch -p1 < ${WORKDIR}/0001-do_div-generic-optimization-for-constant-divisor-on-.patch

        wget https://source.codeaurora.org/quic/la/kernel/msm-4.9/patch/?id=f682b27c57aec2f0ca8927f9bb7c267c6165ad5a -O ${WORKDIR}/0001-__div64_const32-abstract-out-the-actual-128-bit-cross-product-code.patch
        patch -p1 < ${WORKDIR}/0001-__div64_const32-abstract-out-the-actual-128-bit-cross-product-code.patch

        wget https://source.codeaurora.org/quic/la/kernel/msm-4.9/patch/?id=dce1eb93b19b2a1a441708f51c97c4a554054d00 -O ${WORKDIR}/0001-__div64_32-make-it-overridable-at-compile-time.patch
        patch -p1 < ${WORKDIR}/0001-__div64_32-make-it-overridable-at-compile-time.patch

        wget https://source.codeaurora.org/quic/la/kernel/msm-4.9/patch/?id=040b323b5012b5503561ec7fe15cccd6a4bcaec2 -O ${WORKDIR}/0001-ARM-asm-div64.h-adjust-to-generic-codde.patch
        patch -p1 < ${WORKDIR}/0001-ARM-asm-div64.h-adjust-to-generic-codde.patch

        patch -p1 < ${WORKDIR}/0001-ARM-asm-div64.h-include-bug.h-file-to-resolve-compil.patch
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
