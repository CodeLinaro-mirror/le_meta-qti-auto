DEFAULT_PREFERENCE = "-1"

require ${COREBASE}/meta/recipes-multimedia/gstreamer/gstreamer1.0-plugins-bad.inc

DEPENDS += "gbm"

LIC_FILES_CHKSUM = "file://COPYING;md5=73a5855a8119deb017f5f13cf327095d \
                    file://gst/tta/filters.h;beginline=12;endline=29;md5=8a08270656f2f8ad7bb3655b83138e5a \
                    file://COPYING.LIB;md5=21682e4e8fea52413fd26c60acb907e5 \
                    file://gst/tta/crc32.h;beginline=12;endline=29;md5=27db269c575d1e5317fffca2d33b3b50"

FILESPATH =+ "${WORKSPACE}/gstreamer:"
SRC_URI = "file://gst-plugins-bad"
SRC_URI += "${CAF_GIT}/gstreamer/common;destsuffix=gst-plugins-bad/common;branch=gstreamer/common/master;name=common"
SRC_URI_remove = " \
    file://0001-introspection.m4-prefix-pkgconfig-paths-with-PKG_CON.patch \
    file://0001-Makefile.am-don-t-hardcode-libtool-name-when-running.patch \
"
GI_DATA_ENABLED="0"
SRCREV_common = "6f2d2093e84cc0eb99b634fa281822ebb9507285"
S = "${WORKDIR}/gst-plugins-bad"

DEPENDS += "wayland-native"
DEPENDS += "weston"

PACKAGECONFIG = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wayland', 'wayland', '', d)} \
    orc \
    hls \
    "

PACKAGECONFIG[wayland] = "--enable-wayland --enable-egl,--disable-wayland --disable-egl,wayland virtual/egl"

EXTRA_OECONF = " \
                --disable-accurip \
                --disable-acm \
                --disable-adpcmdec \
                --disable-adpcmenc \
                --disable-aiff \
                --disable-android_media \
                --disable-apexsink \
                --disable-asfmux \
                --disable-assrender \
                --disable-audiofxbad \
                --disable-audiofxbad \
                --disable-audiomixer \
                --disable-audiovisualizers \
                --disable-autoconvert \
                --disable-avc \
                --disable-bayer \
                --disable-bluez \
                --disable-bs2b \
                --disable-bz2 \
                --disable-camerabin2 \
                --disable-cdxaparse \
                --disable-chromaprint \
                --disable-cocoa \
                --disable-coloreffects \
                --disable-compositor \
                --disable-curl \
                --disable-daala \
                --disable-dash \
                --disable-dataurisrc \
                --disable-dc1394 \
                --disable-dccp \
                --disable-debugutils \
                --disable-decklink \
                --disable-direct3d \
                --disable-directfb \
                --disable-directsound \
                --disable-dispmanx \
                --disable-dtls \
                --disable-dts \
                --disable-dvb \
                --disable-dvdspu \
                --disable-dvbsuboverlay \
                --disable-egl \
                --disable-faac \
                --disable-faad \
                --disable-faceoverlay \
                --disable-fbdev \
                --disable-festival \
                --disable-fieldanalysis \
                --disable-flite \
                --disable-fluidsynth \
                --disable-freeverb \
                --disable-frei0r \
                --disable-gaudieffects \
                --disable-gdp \
                --disable-geometrictransform \
                --disable-gl \
                --disable-gles2 \
                --disable-glx \
                --disable-gme \
                --disable-gsm \
                --disable-gtk3 \
                --disable-hdvparse \
                --enable-id3tag \
                --disable-inter \
                --disable-interlace \
                --disable-ivfparse \
                --disable-ivtc \
                --disable-jp2kdecimator \
                --disable-jpegformat \
                --disable-ladspa \
                --disable-libde265 \
                --disable-libmms \
                --disable-librfb \
                --disable-libvisual \
                --disable-linsys \
                --disable-lv2 \
                --disable-kate \
                --enable-midi \
                --disable-mimic \
                --disable-modplug \
                --disable-mpeg2enc \
                --enable-mpegdemux \
                --enable-mpegtsdemux \
                --enable-mpegtsmux \
                --enable-mpegpsmux \
                --disable-mplex \
                --disable-musepack \
                --disable-mve \
                --disable-mxf \
                --disable-nas \
                --disable-neon \
                --disable-netsim \
                --disable-nuvdemux \
                --disable-nvenc \
                --disable-ofa \
                --disable-onvif \
                --disable-openal \
                --disable-opencv \
                --disable-openexr \
                --disable-opengl \
                --disable-openh264 \
                --disable-openjpeg \
                --disable-openni2 \
                --disable-opensles \
                --disable-opus \
                --disable-patchdetect \
                --disable-pcapparse \
                --disable-pnm \
                --disable-pvr \
                --disable-qt \
                --enable-rawparse \
                --disable-removesilence \
                --disable-resindvd \
                --disable-rsvg \
                --disable-rtmp \
                --disable-sbc \
                --disable-schro \
                --disable-sdi \
                --disable-sdl \
                --disable-sdltest \
                --disable-sdp \
                --disable-segmentclip \
                --disable-siren \
                --disable-smooth \
                --disable-smoothstreaming \
                --disable-sndfile \
                --disable-sndio \
                --disable-soundtouch \
                --disable-spandsp \
                --disable-spc \
                --disable-speed \
                --disable-srtp \
                --enable-stereo \
                --disable-subenc \
                --disable-teletextdec \
                --disable-timidity \
                --disable-tinyalsa \
                --disable-tta \
                --disable-uvch264 \
                --disable-vcd \
                --disable-vdpau \
                --disable-videofilters \
                --disable-videoframe_audiolevel \
                --disable-videomeasure \
                --enable-videoparsers \
                --disable-videosignal \
                --disable-vmnc \
                --disable-voaacenc \
                --disable-voamrwbenc \
                --disable-vulkan \
                --disable-webp \
                --disable-wasapi \
                --disable-wgl \
                --disable-wildmidi \
                --disable-wininet \
                --disable-winks \
                --disable-winscreencap \
                --disable-x11 \
                --disable-x265 \
                --enable-xvid \
                --disable-y4m \
                --disable-yadif \
                --disable-zbar \
                "
EXTRA_OECONF_append =" --with-protocal-xml-path=${STAGING_DATADIR}/weston"
do_configure_prepend() {
	cd ${S}
	./autogen.sh --noconfigure
	cd ${B}
}


INSANE_SKIP_${PN} += "installed-vs-shipped"
