inherit qcommon cmake

DESCRIPTION = "pppou is to enable uart clock and bringup ppp iface over uart via pppd"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PR = "r0"

SRC_URI = " \
           file://pppou.c \
           file://CMakeLists.txt \
           file://start_pppou_le \
           file://README.md \
           "

DEPENDS += "qmi-framework powermanager-qmilib powermanager-lib"

S = "${WORKDIR}"
