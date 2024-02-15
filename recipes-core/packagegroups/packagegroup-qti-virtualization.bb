SUMMARY = "Grouping of programs for running VMs on Embedded Linux System"
DESCRIPTION = "Package group to bring in packages for running VMs"
LICENSE = "BSD-3-Clause"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup features_check

REQUIRED_MACHINE_FEATURES += "qti-virtualization"

PROVIDES = "${PACKAGES}"

PACKAGES = " \
    packagegroup-qti-virtualization \
"

RDEPENDS:packagegroup-qti-virtualization = "\
    qcrosvm \
"
