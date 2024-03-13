inherit cmake

DESCRIPTION = "Aerolink V2X security library configurations"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

DEPENDS += "telux-samples"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI = "file://cv2x/security/aerolink-public/configurations"
SRC_DIR = "${WORKSPACE}/cv2x/security/aerolink-public/configurations"
S =  "${WORKDIR}/cv2x/security/aerolink-public/configurations"

FILES:${PN} += "${userfsdatadir}/*"
FILES:${PN} += "/usr"

do_install:append() {
    chown -R its:its ${D}${userfsdatadir}/aerolink
    chmod -R ug=rw,o=r,a+X ${D}${userfsdatadir}/aerolink
}
