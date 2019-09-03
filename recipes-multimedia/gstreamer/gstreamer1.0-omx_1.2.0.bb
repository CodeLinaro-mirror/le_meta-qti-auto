DEFAULT_PREFERENCE = "-1"

require ${COREBASE}/meta/recipes-multimedia/gstreamer/gstreamer1.0-omx.inc

DEPENDS += "media"
DEPENDS += "gbm"
RDEPENDS_${PN} = "media"
GSTREAMER_1_0_OMX_TARGET = "generic"
GSTREAMER_1_0_OMX_CORE_NAME = "${libdir}/libOmxCore.so"

LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c \
                    file://omx/gstomx.h;beginline=1;endline=21;md5=5c8e1fca32704488e76d2ba9ddfa935f"

FILESPATH =+ "${WORKSPACE}/gstreamer:"
SRC_URI = "file://gst-omx"
SRC_URI += "git://anongit.freedesktop.org/gstreamer/common;destsuffix=gst-omx/common;branch=master;name=common"
SRCREV_common = "1f5d3c3163cc3399251827235355087c2affa790"
S = "${WORKDIR}/gst-omx"

EXTRA_OECONF = " \
               --with-omx-target=qti \
               --with-omx-header-path=${STAGING_INCDIR}/mm-core \
               --with-protocal-xml-path=${STAGING_DATADIR}/weston \
              "
CPPFLAGS += "-I${STAGING_KERNEL_BUILDDIR}/usr/include"

export STAGING_INCDIR

do_configure_prepend() {
	cd ${S}
	./autogen.sh --noconfigure
	cd ${B}
}
