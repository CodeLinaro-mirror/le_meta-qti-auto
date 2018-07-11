SUMMARY = "Telematics SDK stub library"
DESCRIPTION = "Stub library that can be used to compile telematics applications."

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PACKAGES = "${PN}"
FILES_${PN} = "${libdir}/*.so"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI += "file://telux/public/bin/libtelux_tel.sym"
SRC_URI += "file://telux/public/bin/stubs.c"
SRC_URI += "file://telux/public/bin/libtelux_common.sym"
SRC_URI += "file://telux/public/bin/libtelux_loc.sym"

S        = "${WORKDIR}/telux/public/bin/"

do_compile() {
    ${CXX} -march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 -shared -Wall -fPIC \
           -DFNAME=so_stub_for_libtelux_tel stubs.c \@libtelux_tel.sym -o libtelux_tel.so

    ${CXX} -march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 -shared -Wall -fPIC \
           -DFNAME=so_stub_for_libtelux_common stubs.c \@libtelux_common.sym -o libtelux_common.so

    ${CXX} -march=armv7-a -mfloat-abi=hard -mfpu=neon -mtune=cortex-a8 -shared -Wall -fPIC \
           -DFNAME=so_stub_for_libtelux_loc stubs.c \@libtelux_loc.sym -o libtelux_loc.so
}

do_install_append() {
    install -d ${D}/usr/lib
    install -m 0755 libtelux_tel.so ${D}${libdir}/libtelux_tel.so
    install -m 0755 libtelux_common.so ${D}${libdir}/libtelux_common.so
    install -m 0755 libtelux_loc.so ${D}${libdir}/libtelux_loc.so
}
