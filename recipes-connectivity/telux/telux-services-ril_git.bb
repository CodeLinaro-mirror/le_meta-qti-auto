inherit qcommon cmake pythonnative

SUMMARY = "Telephony service for QTI's Modem"
DESCRIPTION = "Telephony service for QTI's Modem"

LICENSE = "Apache-2.0 & BSD-3-Clause"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10 \
                    file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

SRC_DIR = "${WORKSPACE}/telux/services/ril"
S = "${WORKDIR}/telux/services/ril"

EXTRA_OECMAKE += "${@bb.utils.contains('MACHINE_FEATURES', 'external-ap', '-DRIL_FOR_EXTERNAL_AP=ON', '', d)}"

DEPENDS += "glib-2.0 nanopb python-protobuf-native"
