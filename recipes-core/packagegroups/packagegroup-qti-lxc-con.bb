SUMMARY = "Grouping of programs for lxc rootfs file system on Embedded Linux System"
DESCRIPTION = "Package group to bring in packages for lxc rootfs file system"
LICENSE = "BSD-3-Clause"

inherit packagegroup

PROVIDES = "${PACKAGES}"

PACKAGES_ARCH ?= "${MACHINE_ARCH}"

PACKAGES = ' \
    packagegroup-qti-lxc-con \
    '

# These libs has issue, will merge later
#            vsomeip \     #not present in kirk yet
#            boost \       #very large including other packages
#

RDEPENDS:packagegroup-qti-lxc-con = " \
            busybox-init  \
            lxc-con-setup  \
            libssl \
            libsepol \
            libsemanage \
            audit \
            libbz2 \
            libcap-ng \
            libstdc++ \
            libgcc \
            shadow \
"
