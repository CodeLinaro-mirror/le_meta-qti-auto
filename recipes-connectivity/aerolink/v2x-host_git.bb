DESCRIPTION = "Infineon V2X Host Software"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

DEPENDS = "openssl"

TARGET_CFLAGS += "-Wno-format-security"

SRCREV = "b0b9bce7c07ea0b5d71ac382a20718e426a387e6"

SRC_URI = "${CLO_LE_GIT}/external/infineon-hsm-v2x.git;protocol=https;branch=caf_migration/glimpses/master"
SRC_URI += "file://ccard-v2x-host.patch"

S = "${WORKDIR}/git"

do_install () {
    install -d ${D}${libdir}
    install -m 0755 ${S}/libv2x.so ${D}${libdir}
    install -d ${D}${bindir}
    install -m 0755 ${S}/v2xtool ${D}${bindir}
    install -d ${D}${userfsdatadir}/v2x-host/keys
    install -m 0755 ${S}/init.txt ${D}${userfsdatadir}/v2x-host
    install -m 0755 ${S}/keys/* ${D}${userfsdatadir}/v2x-host/keys
}

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""

FILES_${PN} += "${userfsdatadir}/*"
