PV = "1.31.1"
require ${COREBASE}/meta/recipes-core/busybox/busybox_${PV}.bb

S = "${WORKDIR}/busybox-${PV}"

BUSYBOXBASEDIR = "${COREBASE}/meta/recipes-core/busybox"

FILESEXTRAPATHS_prepend := "${BUSYBOXBASEDIR}/busybox:${BUSYBOXBASEDIR}/files:"

SRC_URI += "file://busybox-init.cfg"

TARGET_CFLAGS += "-Wno-error=format-security"
