inherit pkgconfig cmake

SUMMARY = "coreJSON library"
DESCRIPTION = "coreJSON library"

HOMEPAGE         = "https://github.com/FreeRTOS/coreJSON"
LICENSE          = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=7ae2be7fb1637141840314b51970a9f7"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://c2c/external/FreeRTOS/coreJSON"
S = "${WORKDIR}/c2c/external/FreeRTOS/coreJSON"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""
