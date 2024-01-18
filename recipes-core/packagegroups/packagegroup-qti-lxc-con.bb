SUMMARY = "Grouping of programs for lxc rootfs file system on Embedded Linux System"
DESCRIPTION = "Package group to bring in packages for lxc rootfs file system"
LICENSE = "BSD-3-Clause"

inherit packagegroup

PROVIDES = "${PACKAGES}"


PACKAGES = ' \
    packagegroup-qti-lxc-con \
    '

RDEPENDS_packagegroup-qti-lxc-con = " \
            busybox-init  \
            lxc-con-setup  \
            libssl \
            libsepol \
            libsemanage \
            audit \
            libbz2 \
            libcap-ng \
            vsomeip \
            boost \
            libstdc++ \
            libgcc \
            shadow \
"
