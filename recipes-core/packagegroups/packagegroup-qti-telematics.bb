SUMMARY = "QTI package groups for Telematics modules"
DESCRIPTION = "Package group to bring in all basic packages for LE Telematics system"
LICENSE = "BSD-3-Clause-Clear"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    packagegroup-qti-telematics \
    '
