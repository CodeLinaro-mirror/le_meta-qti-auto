FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_remove = " file://backport-v234-e266c06.patch "
SRC_URI += " file://0001-systemd-add-slotselect-support-in-fstab.patch "

PACKAGECONFIG = " \
    ${@bb.utils.filter('DISTRO_FEATURES', 'efi ldconfig pam selinux usrmerge', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'rfkill', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xkbcommon', '', d)} \
    backlight \
    binfmt \
    firstboot \
    hibernate \
    hostnamed \
    ima \
    localed \
    logind \
    machined \
    myhostname \
    networkd \
    nss \
    polkit \
    quotacheck \
    randomseed \
    smack \
    sysusers \
    timedated \
    timesyncd \
    utmp \
    vconsole \
    xz \
"

# In aarch64 targets systemd is not booting with -finline-functions -finline-limit=64 optimizations
# So temporarily revert to default optimizations for systemd.
FULL_OPTIMIZATION = "-O2 -fexpensive-optimizations -frename-registers -fomit-frame-pointer -ftree-vectorize"

do_install_append () {
   # Use kernel rules for network iface
   sed -i  's/^NamePolicy.*/NamePolicy=kernel/g' ${D}/lib/systemd/network/99-default.link

   # Remove orignal 60-persistent-v4l.rules
   rm ${D}/lib/udev/rules.d/60-persistent-v4l.rules
}
