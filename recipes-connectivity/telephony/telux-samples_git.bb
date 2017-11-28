inherit cmake

SUMMARY = "Telematics SDK Samples"
DESCRIPTION = "Telematics SDK Samples"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=3775480a712fc46a69647678acb234cb"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telux/samples/telsdk_console_app/"

SRCREV = "${AUTOREV}"
S      = "${WORKDIR}/telux/samples/telsdk_console_app"

DEPENDS += "telux telephony-lib"
