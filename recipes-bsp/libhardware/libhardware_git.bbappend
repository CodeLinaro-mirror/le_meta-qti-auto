# Get Add-gralloc1.h-from-p-keystone-qcom-branch
SRC_URI += "https://source.codeaurora.org/quic/le/platform/hardware/libhardware/plain/include/hardware/gralloc1.h?h=keystone/p-keystone-qcom-release;downloadfilename=gralloc1.h;md5sum=5171fc33c1299824ede5756a4da57507"

do_install_append () {
    cp ${WORKDIR}/gralloc1.h ${D}${includedir}/hardware/
}

