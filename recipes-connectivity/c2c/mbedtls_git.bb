inherit pkgconfig cmake

SUMMARY = "mbedtls library"
DESCRIPTION = "mbedtls library"

HOMEPAGE         = "https://github.com/ARMmbed/mbedtls"
LICENSE          = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=302d50a6369f5f22efdb674db908167a"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://c2c/external/ARMmbed/mbedtls"
S = "${WORKDIR}/c2c/external/ARMmbed/mbedtls"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""
