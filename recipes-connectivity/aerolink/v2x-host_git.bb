DESCRIPTION = "Infineon V2X Host Software"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

DEPENDS = "openssl"

TARGET_CFLAGS += "-Wno-format-security"

SRCREV = "b0b9bce7c07ea0b5d71ac382a20718e426a387e6"

SRC_URI = "git://source.codeaurora.org/quic/le/external/infineon-hsm-v2x.git;protocol=git;branch=glimpses/master"
SRC_URI += "file://ccard-v2x-host.patch"
SRC_URI += "file://secureAccess.txt"

S = "${WORKDIR}/git"

do_install () {
    install -d ${D}${libdir}
    install -m 0755 ${S}/libv2x.so ${D}${libdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/v2xtool ${D}${bindir}
    install -d ${D}${userfsdatadir}/v2x-host/keys
    install -m 0755 ${S}/init.txt ${D}${userfsdatadir}/v2x-host
    install -m 0755 ${S}/keys/* ${D}${userfsdatadir}/v2x-host/keys
    install -m 0755 ${WORKDIR}/secureAccess.txt ${D}${userfsdatadir}/v2x-host
}

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""

FILES_${PN} += "${userfsdatadir}/*"
