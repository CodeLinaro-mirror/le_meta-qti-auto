SUMMARY = "Grouping of programs for lxc rootfs file system on Embedded Linux System"
DESCRIPTION = "Package group to bring in packages for lxc rootfs file system"
LICENSE = "BSD-3-Clause"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PROVIDES = "${PACKAGES}"

PACKAGES = ' \
    packagegroup-qti-lxc-con \
    '
RDEPENDS:packagegroup-qti-lxc-con = " \
            busybox-init  \
            lxc-con-setup  \
            audit \
            libcap-ng \
            shadow \
            libssl   \
            libsepol \
            libsemanage \
            libbz2 \
            vsomeip \
            boost \
            libstdc++ \
            libgcc \
"
