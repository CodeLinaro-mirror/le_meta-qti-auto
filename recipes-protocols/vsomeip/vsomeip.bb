SUMMARY = "build the vsomeip package"
LICENSE = "MPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=9741c346eef56131163e13b9db1241b3"

inherit cmake
DEPENDS = "boost"

# fetch the version 3.4.10 from github
SRCREV = "02c199dff8aba814beebe3ca417fd991058fe90c"
SRC_URI = "git://github.com/COVESA/vsomeip.git;protocol=https \
           file://0001-for-3.4.10.patch \
           file://0002-for-3.4.10.patch \
           file://0003-Fix-the-loss-of-availability-event.patch \
          "
S = "${WORKDIR}/git"

# enable multiple routing managers
EXTRA_OECMAKE += "-DENABLE_MULTIPLE_ROUTING_MANAGERS=1"

BBCLASSEXTEND = "nativesdk"
FILES:${PN} = "/usr/"
