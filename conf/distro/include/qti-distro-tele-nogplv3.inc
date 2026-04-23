#=============================================================================
# GPLv3-family license blocking policy
# This file centralizes incompatible license policy and exceptions.
#=============================================================================

# Add Incompatible license details
INCOMPATIBLE_LICENSE += "GPL-3.0* LGPL-3.0* AGPL-3.0*"

# Mask all recipes from meta-gplv2 to avoid misuse
BBMASK += "meta-gplv2"

# Some packages use bash outside of ptest
DISTRO_FEATURES:remove += "ptest"
INSANE_SKIP:${PN}-tests:pn-python3 += "file-rdeps"
INSANE_SKIP:${PN}-scripts:pn-lvm2 += "file-rdeps"
INSANE_SKIP:${PN}-templates:pn-lxc += "file-rdeps"
INSANE_SKIP:${PN}-e2scrub:pn-e2fsprogs += "file-rdeps"
INSANE_SKIP:${PN}-apply:pn-iptables += "file-rdeps"
INSANE_SKIP:pn-opkg-utils += "file-rdeps"
INSANE_SKIP:pn-eth-cli += "file-rdeps"
INSANE_SKIP:pn-eth-qos += "file-rdeps"
INSANE_SKIP:pn-ebtables += "file-rdeps"
INSANE_SKIP:pn-lvm2 += "file-rdeps"

#lvm2: do not pull coreutils via scripts
RDEPENDS:lvm2-scripts:remove = "coreutils"
RDEPENDS:packagegroup-qti-recoveryfs:remove = "coreutils"

# Do not pull binutils
RDEPENDS:selinux-python-sepolicy:remove = "binutils"

# libcheck: do not pull gawk via checkmk
RDEPENDS:checkmk:remove = "gawk"
INSANE_SKIP:pn-libcheck += "file-rdeps"

# do not pull tar
RRECOMMENDS:systemd-container:remove = "tar"

# Disable readline dependency
PACKAGECONFIG:remove:pn-python3 += "readline"
PACKAGECONFIG:remove:pn-gawk += "readline"

# Disable libidn dependency
PACKAGECONFIG:remove:pn-curl += "libidn"

#Disable gdbm dependency
PACKAGECONFIG:remove:pn-python3 += "gdbm"
PACKAGECONFIG:remove:pn-perl += "gdbm"
INSANE_SKIP:pn-perl += "file-rdeps"

# Add license and package to exception list to be able to build further
INCOMPATIBLE_LICENSE_EXCEPTIONS += " \
    sexpect:GPL-3.0-only \
"
