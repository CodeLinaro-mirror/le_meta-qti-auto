
SUMMARY = "multimedia framework"
DESCRIPTION = "packages for multimedia"
LICENSE = "GPLv2+ & LGPLv2+"

inherit packagegroup

ALLOW_EMPTY_${PN} = "1"
PACKAGES = "${PN}"


RDEPENDS_${PN} = " \
        gstreamer1.0 \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-omx \
        gdk-pixbuf-loader-bmp \
        gdk-pixbuf-loader-gif \
        alsa-lib \
        alsa-utils \
        alsa-plugins \
"
