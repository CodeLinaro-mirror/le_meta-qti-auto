SUMMARY = "Cross locale generation tool for glibc"
HOMEPAGE = "http://www.gnu.org/software/libc/libc.html"
SECTION = "libs"
LICENSE = "LGPL-2.1"

LIC_FILES_CHKSUM = "file://LICENSES;md5=1541fd8f5e8f1579512bf05f533371ba \
      file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
      file://posix/rxspencer/COPYRIGHT;md5=dc5485bb394a13b2332ec1c785f5d83a \
      file://COPYING.LIB;md5=4fbd65380cdd255951079008b364516c"

require glibc-version.inc

# Tell autotools that we're working in the localedef directory
#
AUTOTOOLS_SCRIPT_PATH = "${S}/localedef"

inherit autotools
inherit native

FILESEXTRAPATHS =. "${FILE_DIRNAME}/${PN}:${FILE_DIRNAME}/glibc:"

SRC_URI = "${GLIBC_GIT_URI};branch=${SRCBRANCH};name=glibc \
           git://github.com/kraj/localedef;branch=master;name=localedef;destsuffix=git/localedef;protocol=https \
           \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-localedef-Add-hardlink-resolver-from-util-linux.patch;md5sum=dcd842b6828965d789768b1288aad20c;sha256sum=f002f073600c78cce334ea4d2e0121314fa6bc52402f015ce03b8dd034e2fbc9 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0002-localedef-fix-ups-hardlink-to-make-it-compile.patch;md5sum=b76fc6a0315e9525d8db5412b5273b80;sha256sum=644a1b0f44eeffc55cfb9dcf20d5faa2ea4e874b191ea3f33630aa01158bbecc \
           \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0018-Remove-bash-dependency-for-nscd-init-script.patch;md5sum=2d383a884fa6aabfdd8848406f601538;sha256sum=30391f3ed533b7b38e0c02def7db57ee16865a7c5aad73cadd3822e0259303c6 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0019-eglibc-Cross-building-and-testing-instructions.patch;md5sum=50f84f9548ce4994639bc6ff6001ca30;sha256sum=c966dcb17ddc428c10627fece102a980501fd73d636ff2e292f2ca90d40c6ebd \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0020-eglibc-Help-bootstrap-cross-toolchain.patch;md5sum=d3f48c25d10256a4db7cd05b90badeac;sha256sum=6ab7fa2326cdca2413b19ce533b74d8d4fd9b8467b3bd19b6843e1a85578cd13 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0021-eglibc-Resolve-__fpscr_values-on-SH4.patch;md5sum=1297a3d172b83d1397bce5ab41f61307;sha256sum=9a3e845c2a6a9f87237a17f71abc13d4793d87f9f61e720bd0dd4cfef14bf997 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0022-eglibc-Forward-port-cross-locale-generation-support.patch;md5sum=27f486edf911abfdb382af7b7881aec2;sha256sum=441074e33c590245f63bb6cd310c985d061e68d521c47fb77ba41e0976baa2f0 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0024-localedef-add-to-archive-uses-a-hard-coded-locale-pa.patch;md5sum=157de62e54c839adae006b39f177406a;sha256sum=63bffbd5e047eff1c901faef39102f361e20e464db5464de3beb40577974ccfb \
"
# Makes for a rather long rev (22 characters), but...
#
SRCREV_FORMAT = "glibc_localedef"

S = "${WORKDIR}/git"

EXTRA_OECONF = "--with-glibc=${S}"

# We do not need bash to run tzselect script, the default is to use
# bash but it can be configured by setting KSHELL Makefile variable
EXTRA_OEMAKE += "KSHELL=/bin/sh"

CFLAGS += "-fgnu89-inline -std=gnu99 -DIS_IN\(x\)='0'"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${B}/localedef ${D}${bindir}/cross-localedef
	install -m 0755 ${B}/cross-localedef-hardlink ${D}${bindir}/cross-localedef-hardlink
}
