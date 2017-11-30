SUMMARY = "Telematics SDK stub library"
DESCRIPTION = "Stub library that can be used to compile telematics applications."

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=3775480a712fc46a69647678acb234cb"

PACKAGES = "${PN}"
FILES_${PN} = "${libdir}/*.so"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI += "file://telux/bin/libtelux_tel.sym"
SRC_URI += "file://telux/bin/stubs.c"
SRC_URI += "file://telux/bin/libtelux_common.sym"

S        = "${WORKDIR}/telux/bin/"

do_compile() {
    ${CXX} -march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 -shared -Wall -fPIC \
           -DFNAME=so_stub_for_libtelux_tel stubs.c \@libtelux_tel.sym -o libtelux_tel.so

    ${CXX} -march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 -shared -Wall -fPIC \
           -DFNAME=so_stub_for_libtelux_common stubs.c \@libtelux_common.sym -o libtelux_common.so
}

do_install_append() {
    install -d ${D}/usr/lib
    install -m 0755 libtelux_tel.so ${D}${libdir}/libtelux_tel.so
    install -m 0755 libtelux_common.so ${D}${libdir}/libtelux_common.so
}
