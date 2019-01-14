SUMMARY = "Multimedia libraries and SDK"
SECTION = "multimedia"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/media/"
S = "${WORKDIR}/hardware/qcom/media"

PR = "r1"
DEPENDS = "virtual/kernel"
DEPENDS += "glib-2.0"
DEPENDS += "virtual/libc"
DEPENDS += "libion libcutils libutils system-core"
DEPENDS += "weston"
DEPENDS += "adreno-headers"
DEPENDS += "libhardware"
DEPENDS += "mm-video-noship"
DEPENDS += "display-hal-linux"
DEPENDS += "display-commonsys-intf-linux"

# Need the kernel headers
PACKAGE_ARCH = "${MACHINE_ARCH}"

LV = "1.0.0"

inherit autotools


#re-use non-perf settings
EXTRA_OECONF_append =" --with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include"
EXTRA_OECONF_append =" --with-kernel-headers=${STAGING_KERNEL_BUILDDIR}/include"
EXTRA_OECONF_append =" --with-adreno-includes=${STAGING_INCDIR}/adreno"

EXTRA_OECONF_append =" --with-cutils-headers=${STAGING_INCDIR}/cutils/"
EXTRA_OECONF_append =" --with-log-headers=${STAGING_INCDIR}/log/"
EXTRA_OECONF_append =" --with-videolibs-headers=${WORKDIR}/video/lib/mm-video-noship/utils/inc"
EXTRA_OECONF_append =" --with-usr-include-headers=${STAGING_INCDIR}/"
EXTRA_OECONF_append = "--with-libhardware-headers=${WORKSPACE}/hardware/libhardware "


EXTRA_OECONF_append =" --enable-use-glib="yes""
EXTRA_OECONF_append =" --enable-target-uses-ion="yes""
EXTRA_OECONF_append =" --enable-target-uses-gbm="yes""
EXTRA_OECONF_append =" --enable-target-${SOC_FAMILY}="yes""
EXTRA_OECONF_append =" --enable-target-uses-media-extensions="no""
EXTRA_OECONF_append =" --enable-build-mm-video="yes""
EXTRA_OECONF_append =" --enable-is-ubwc-supported="yes""


CPPFLAGS += "-I${STAGING_INCDIR} \
             -I${STAGING_INCDIR}/drm \
             -I${STAGING_INCDIR}/EGL \
             -I${STAGING_INCDIR}/GLES2 \
             -I${STAGING_INCDIR}/glib-2.0 \
             -I${STAGING_LIBDIR}/glib-2.0/include \
             -I${STAGING_LIBDIR}/glib-2.0/glib \
             -I${STAGING_INCDIR}/c++ \
             -I${STAGING_INCDIR}/c++/${TARGET_SYS} \
             -I${STAGING_INCDIR}/ion_headers  \
             -I${STAGING_INCDIR}/disp-commonsys-intf/display"

CPPFLAGS += "-include stdint.h"

LDFLAGS += "-lglib-2.0"
LDFLAGS += "-lgbm"
LDFLAGS += "-ldrm"
LDFLAGS += "-lwayland-client"
LDFLAGS += "-lEGL"
LDFLAGS += "-lqdMetaData"

do_install_append() {
install -d ${D}${includedir}/mm-core
install -m 0644 ${S}/mm-core/inc/*.h -D ${D}${includedir}/mm-core/

install -d ${D}${includedir}/libstagefrighthw
install -m 0644 ${S}/libstagefrighthw/QComOMXMetadata.h -D ${D}${includedir}/libstagefrighthw/
}

FILES_${PN}-dev = "\
    ${includedir} \
    ${libdir}/*.la"

FILES_${PN} = "\
    ${libdir}/* \
    ${bindir}/* \
    ${datadir}/*"

#Skips check for .so symlinks
INSANE_SKIP_${PN} = "dev-so"
FILES_${PN} += "${includedir}/mm-core/* \
                ${includedir}/libstagefrighthw/* "
