inherit cmake

SUMMARY = "Telematics SDK headers"
DESCRIPTION = "Telematics SDK headers"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=3775480a712fc46a69647678acb234cb"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telux/include/"

SRCREV = "${AUTOREV}"
S      = "${WORKDIR}/telux/include"

