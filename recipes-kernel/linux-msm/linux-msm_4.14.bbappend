
DEPENDS += "llvm-arm-toolchain-native"
DEPENDS += "${@bb.utils.contains('MACHINE_FEATURES', 'dt-overlay', 'mkdtimg-native', '', d)}"

COMPATIBLE_MACHINE = "(sa8155)"

CROSS_COMPILE = "aarch64-oe-linux-"

KERNEL_EXTRA_ARGS += "${@bb.utils.contains('MACHINE_FEATURES', 'dt-overlay', 'DTC_EXT=${STAGING_BINDIR_NATIVE}/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y', '', d)}"

do_compile() {
    qoe_runmake ${PARALLEL_MAKE} CROSS_COMPILE=${CROSS_COMPILE} ${KERNEL_EXTRA_ARGS} $use_alternate_initrd 
}

do_compile_kernelmodules() {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE
	if (grep -q -i -e '^CONFIG_MODULES=y$' ${B}/.config); then
    	#cc_extra=$(get_cc_option)
        qoe_runmake -C ${B} ${PARALLEL_MAKE} modules CROSS_COMPILE=${CROSS_COMPILE} ${KERNEL_EXTRA_ARGS}

		# Module.symvers gets updated during the
		# building of the kernel modules. We need to
		# update this in the shared workdir since some
		# external kernel modules has a dependency on
		# other kernel modules and will look at this
		# file to do symbol lookups
		cp ${B}/Module.symvers ${STAGING_KERNEL_BUILDDIR}/
	else
		bbnote "no modules to compile"
	fi
}


#do_install_append() {
#    oe_runmake_call CROSS_COMPILE=${CROSS_COMPILE} -C ${STAGING_KERNEL_DIR} headers_install O=${STAGING_KERNEL_BUILDDIR}
#}

qoe_runmake() {
	qoe_runmake_call "$@" || die "oe_runmake failed"

}

qoe_runmake_call() {
	bbnote make ARCH=arm64  REAL_CC=${STAGING_BINDIR_NATIVE}/llvm-arm-toolchain/bin/clang $@
	make ARCH=arm64  REAL_CC=${STAGING_BINDIR_NATIVE}/llvm-arm-toolchain/bin/clang $@
}

do_deploy_append() {
    if ${@bb.utils.contains('MACHINE_FEATURES', 'dt-overlay', 'true', 'false', d)}; then
        ${STAGING_BINDIR_NATIVE}/mkdtimg create ${DEPLOY_DIR_IMAGE}/dtbo.img ${B}/arch/${ARCH}/boot/dts/qcom/*.dtbo
    fi
}
