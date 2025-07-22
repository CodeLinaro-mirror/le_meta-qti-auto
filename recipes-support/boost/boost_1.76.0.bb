require boost-${PV}.inc
require ${COREBASE}/meta/recipes-support/boost/boost.inc

BOOST_LIBS = "\
    atomic \
    chrono \
    filesystem \
    log \
    regex \
    serialization \
    system \
    thread \
    "
TARGET_CC_ARCH:append = " -O2 "
