SUMMARY = "QTI package groups for Telematics LXC Module"
DESCRIPTION = "Package group to bring in all basic packages for LE Telematics LXC system"
LICENSE = "BSD-3-Clause-Clear"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    packagegroup-qti-lxc \
'

RDEPENDS:packagegroup-qti-lxc = "\
    lxc \
"
