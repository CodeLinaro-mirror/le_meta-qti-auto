require glibc.inc
require glibc-version.inc

CVE_CHECK_WHITELIST += "CVE-2020-10029 CVE-2021-27645"

# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010022
# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010023
# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010024
# Upstream glibc maintainers dispute there is any issue and have no plans to address it further.
# "this is being treated as a non-security bug and no real threat."
CVE_CHECK_WHITELIST += "CVE-2019-1010022 CVE-2019-1010023 CVE-2019-1010024"

# glibc https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2019-1010025
# Allows for ASLR bypass so can bypass some hardening, not an exploit in itself, may allow
# easier access for another. "ASLR bypass itself is not a vulnerability."
# Potential patch at https://sourceware.org/bugzilla/show_bug.cgi?id=22853
CVE_CHECK_WHITELIST += "CVE-2019-1010025"

DEPENDS += "gperf-native bison-native make-native"

NATIVESDKFIXES ?= ""
NATIVESDKFIXES:class-nativesdk = "\
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0003-nativesdk-glibc-Look-for-host-system-ld.so.cache-as-.patch;md5sum=1d7b3ffe5c0ded730f01719c15f7018d;sha256sum=0ce4d8ed78c96e729a40747e1ebe6bd84c1799d48f913020e78d94d12b0db67b \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0004-nativesdk-glibc-Fix-buffer-overrun-with-a-relocated-.patch;md5sum=a5b83e5029fb2213cd8291b06fa34d60;sha256sum=3ff8218cb302458474aeff78c40ee11ecfd0599424f046c557e15fb15819ed94 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0005-nativesdk-glibc-Raise-the-size-of-arrays-containing-.patch;md5sum=4e1b55689df57856e23f50ba3e17f80c;sha256sum=ba772ea62d85bbcea9f71524adf56766c296bcfbaf840fb507c9a70eaf478b59 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0006-nativesdk-glibc-Allow-64-bit-atomics-for-x86.patch;md5sum=3104182a84cee2e7faccc3f9b33b90a2;sha256sum=dd8c35ead8099b0dd0997c672ab253f5e42055304895ea26f1814cd71792f92c \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0007-nativesdk-glibc-Make-relocatable-install-for-locales.patch;md5sum=59e1beff89673296902fae6ff048f28d;sha256sum=abd0ed0759f05567c60a584d94c527a476063bbc941735e3ce4d0cfa1223b425 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0008-nativesdk-glibc-Fall-back-to-faccessat-on-faccess2-r.patch;md5sum=0d7cf01a4d370bf03f246f6b70f764f8;sha256sum=ab21f7f26423934382b5d926bc55f2ed7d7c72583b0c30a444545f09e16a6032 \
"

SRC_URI =  "${GLIBC_GIT_URI};branch=${SRCBRANCH};name=glibc \
           file://etc/ld.so.conf \
           file://generate-supported.mk \
           file://makedbs.sh \
           \
           ${NATIVESDKFIXES} \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0009-fsl-e500-e5500-e6500-603e-fsqrt-implementation.patch;md5sum=ac564e6510451b4d3b456fe56f7200f9;sha256sum=cfb6fc0ecbb79e0b5ccc53a05e20415c2b25760588351a6c109f4453208de4a4 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0010-ppc-sqrt-Fix-undefined-reference-to-__sqrt_finite.patch;md5sum=95a020d17148cabf1dc7059688fe2016;sha256sum=1b1d493f6565f3bcd1abf17e835b05cbe2b694a7d5823fca69108f1996331686 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0011-__ieee754_sqrt-f-are-now-inline-functions-and-call-o.patch;md5sum=0af9c720d84858e70e7dc928bdac7efc;sha256sum=cb6046aba494a90402693304826bcc3ab8a85dbeb6d069debb6426f0e4cebd10 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0012-Quote-from-bug-1443-which-explains-what-the-patch-do.patch;md5sum=e3d792b8051ac98418a6f4e3384ca682;sha256sum=e2175e612ce01e0c800cc320d9fc916bc2f243e45d6d9abb9533c89f23bf16ac \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0013-eglibc-run-libm-err-tab.pl-with-specific-dirs-in-S.patch;md5sum=b08421fe9bec689a40dc85d69d1b6006;sha256sum=5d2d54fb2012195fe765adf39909518a7887f6d9a6d07104929dd51cdfd53960 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0014-__ieee754_sqrt-f-are-now-inline-functions-and-call-o.patch;md5sum=2f14bd2d9f781d2a4e4d88e72753b3a1;sha256sum=f23377359fa3cc8d3e8ed9cf1f8b8cfcadb4edff9b5d4fa5b9c9832f3af409bd \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0015-sysdeps-gnu-configure.ac-handle-correctly-libc_cv_ro.patch;md5sum=3f757b529457f216673e3d432cd6e41e;sha256sum=d9a4f52a21fef4c67441bcb92058a5853bc67792efd4ecc6c59947a021d62021 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0016-yes-within-the-path-sets-wrong-config-variables.patch;md5sum=ca6210d30f3fdca61fa507c9b598da2c;sha256sum=9309b276321f8e5ce8e855652cc7425f6438779820421a723537c73f3f24b1c4 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0017-timezone-re-written-tzselect-as-posix-sh.patch;md5sum=f3d3d1ae27b1ea908cdbb7b569f96e11;sha256sum=f11138edadbd66f817b87e66189fd182a1a2746457d38a477822ac10e66ce87c \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0018-Remove-bash-dependency-for-nscd-init-script.patch;md5sum=2d383a884fa6aabfdd8848406f601538;sha256sum=30391f3ed533b7b38e0c02def7db57ee16865a7c5aad73cadd3822e0259303c6 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0019-eglibc-Cross-building-and-testing-instructions.patch;md5sum=50f84f9548ce4994639bc6ff6001ca30;sha256sum=c966dcb17ddc428c10627fece102a980501fd73d636ff2e292f2ca90d40c6ebd \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0020-eglibc-Help-bootstrap-cross-toolchain.patch;md5sum=d3f48c25d10256a4db7cd05b90badeac;sha256sum=6ab7fa2326cdca2413b19ce533b74d8d4fd9b8467b3bd19b6843e1a85578cd13 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0021-eglibc-Resolve-__fpscr_values-on-SH4.patch;md5sum=1297a3d172b83d1397bce5ab41f61307;sha256sum=9a3e845c2a6a9f87237a17f71abc13d4793d87f9f61e720bd0dd4cfef14bf997 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0022-eglibc-Forward-port-cross-locale-generation-support.patch;md5sum=27f486edf911abfdb382af7b7881aec2;sha256sum=441074e33c590245f63bb6cd310c985d061e68d521c47fb77ba41e0976baa2f0 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0024-localedef-add-to-archive-uses-a-hard-coded-locale-pa.patch;md5sum=157de62e54c839adae006b39f177406a;sha256sum=63bffbd5e047eff1c901faef39102f361e20e464db5464de3beb40577974ccfb \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0025-elf-dl-deps.c-Make-_dl_build_local_scope-breadth-fir.patch;md5sum=4666315e75889e4e78baf0023aa34fd2;sha256sum=98d74feeca0c0d6280c6667a369f3eeed11cefe811de900cd0a0a177b6f9ffe3 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0026-intl-Emit-no-lines-in-bison-generated-files.patch;md5sum=2bc9d84995788397e5cf6f140eeb70fd;sha256sum=08755dfb9c5fd64fc47c284591787e386f4854f63b53f4ab5f912d9f21527410 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0027-locale-prevent-maybe-uninitialized-errors-with-Os-BZ.patch;md5sum=508b96f101de8b49623931f84e690a90;sha256sum=84adf2bb4321f6c635364570742f66206492b50c450f0c7b2fbc6f5a970a8f95 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0028-readlib-Add-OECORE_KNOWN_INTERPRETER_NAMES-to-known-.patch;md5sum=08ba34cbadb6b587d0c562397dc5f7cd;sha256sum=24b1b8171759eca7a25a2ec3b852f63031261360e46feaf028ab33757027b42e \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0029-wordsize.h-Unify-the-header-between-arm-and-aarch64.patch;md5sum=107c09850b8f6866a601e270eb98d0a3;sha256sum=7fe3513b3a8fac3be8c3e1f4729814ee04225c1b1eb7e6f785a133266806d1c8 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0030-powerpc-Do-not-ask-compiler-for-finding-arch.patch;md5sum=f2626564f9e669467a185be10d5bbc7d;sha256sum=5ede139cc00fb65e43bd077a46bb0cb14fd03a6722638da137702154afb3e7d6 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-CVE-2021-38604.patch;md5sum=580f5381ed92b86ebc6696256449d46e;sha256sum=8fc98bf4eddeb4dc65a182bcbfa912bc0a2bda6106af3880cf60b0555642738d \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0002-CVE-2021-38604.patch;md5sum=ea4d97c97c328784226ec26a9843c81d;sha256sum=e4b8608d412333c66095f0f94008788a9b3ac8ae6f71381963b73e89a34ad887 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-fix-create-thread-failed-in-unprivileged-process-BZ-.patch;md5sum=5ad6a61ecd3c6b6419b67ef0742cb50b;sha256sum=ed01f608f851b94bc7c2f09bfbcf751fdb1f09d6394b1c36cbe3009ddf67c5b0 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/CVE-2021-43396.patch;md5sum=969fd3505390d4471bf798d71a660669;sha256sum=8e4420a33f5db7ded7d5f1932d69a0378dea9646b60174fe13979afcc73b471c \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-CVE-2022-23218.patch;md5sum=6ea4a6f23f6282110184e52071ccb7f8;sha256sum=8cd3498693b4f98b1ad62a786feade8f0f9a9d3e90ccf811fc20160d1baaef86 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0002-CVE-2022-23218.patch;md5sum=7a5ddb504cb9f36be0938a9b5283c544;sha256sum=f96ab5831af7fde3a88e84a28e239384170d197da6a8683b815ff7c658a52462 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-CVE-2022-23219.patch;md5sum=dded1e6e7a8cc91440ad31b113875999;sha256sum=2376433e9f1fc6e59f18563459122d238da103365a40554af9d7ef7004ebbab3 \
          https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0002-CVE-2022-23219.patch;md5sum=4c5c699364c6b471afd2a8e74a30086e;sha256sum=cc2e1dfe0bd8ef80fca87dd2a399bc384b355fb17681161a42f49c3516716ad3 \
         https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-CVE-2021-3998.patch;md5sum=5bc438629bfd163e6c3d524695e49f32;sha256sum=2a9a99e4c303f5678f39c9b2e230271c2dbebcc6d66b8eab9bb4261ddc55c936 \
         https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0002-CVE-2021-3998.patch;md5sum=bf6e224c18dc2c4681227f9aca97642c;sha256sum=317f09c6a548bfe7fe39d9a9d9631f7afb3023e47ba261be8dee1e3f97ac94a1 \
         https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0001-CVE-2021-3999.patch;md5sum=c41eec8e658c254f8dfc02e3a34c4e30;sha256sum=b563ccdcced70186be5dcc1a8cf3385bf1d8f7d7c35ed09f0d6f9d0247ee353d \
         https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/honister/meta/recipes-core/glibc/glibc/0002-CVE-2021-3999.patch;md5sum=b4d6f18669fffba074c9a2ecca74d911;sha256sum=047cc8f1d45ae9a764e82743527358158e595845b0ba0c7e14bb44f1275dc931 \
         file://glibc-upstream-2.34-fix_for_fcntl_ioctl_prctl_redirects.patch \
           "
S = "${WORKDIR}/git"
B = "${WORKDIR}/build-${TARGET_SYS}"

PACKAGES_DYNAMIC = ""

# the -isystem in bitbake.conf screws up glibc do_stage
BUILD_CPPFLAGS = "-I${STAGING_INCDIR_NATIVE}"
TARGET_CPPFLAGS = "-I${STAGING_DIR_TARGET}${includedir}"

GLIBC_BROKEN_LOCALES = ""

GLIBCPIE ??= ""

EXTRA_OECONF = "--enable-kernel=${OLDEST_KERNEL} \
                --disable-profile \
                --disable-debug --without-gd \
                --enable-clocale=gnu \
                --with-headers=${STAGING_INCDIR} \
                --without-selinux \
                --enable-tunables \
                --enable-bind-now \
                --enable-stack-protector=strong \
                --disable-crypt \
                --with-default-link \
                ${@bb.utils.contains_any('SELECTED_OPTIMIZATION', '-O0 -Og', '--disable-werror', '', d)} \
                ${GLIBCPIE} \
                ${GLIBC_EXTRA_OECONF}"

EXTRA_OECONF += "${@get_libc_fpu_setting(bb, d)}"

EXTRA_OECONF:append:x86 = " ${@bb.utils.contains_any('TUNE_FEATURES', 'i586 c3', '--disable-cet', '--enable-cet', d)}"
EXTRA_OECONF:append:x86-64 = " --enable-cet"

PACKAGECONFIG ??= "nscd memory-tagging"
PACKAGECONFIG[nscd] = "--enable-nscd,--disable-nscd"
PACKAGECONFIG[memory-tagging] = "--enable-memory-tagging,--disable-memory-tagging"

do_patch:append() {
    bb.build.exec_func('do_fix_readlib_c', d)
}

do_fix_readlib_c () {
	sed -i -e 's#OECORE_KNOWN_INTERPRETER_NAMES#${EGLIBC_KNOWN_INTERPRETER_NAMES}#' ${S}/elf/readlib.c
}

do_configure () {
# override this function to avoid the autoconf/automake/aclocal/autoheader
# calls for now
# don't pass CPPFLAGS into configure, since it upsets the kernel-headers
# version check and doesn't really help with anything
        (cd ${S} && gnu-configize) || die "failure in running gnu-configize"
        find ${S} -name "configure" | xargs touch
        CPPFLAGS="" oe_runconf
}

LDFLAGS += "-fuse-ld=bfd"
do_compile () {
	base_do_compile
	echo "Adjust ldd script"
	if [ -n "${RTLDLIST}" ]
	then
		prevrtld=`cat ${B}/elf/ldd | grep "^RTLDLIST=" | sed 's#^RTLDLIST="\?\([^"]*\)"\?$#\1#'`
		# remove duplicate entries
		newrtld=`echo $(printf '%s\n' ${prevrtld} ${RTLDLIST} | LC_ALL=C sort -u)`
		echo "ldd \"${prevrtld} ${RTLDLIST}\" -> \"${newrtld}\""
		sed -i ${B}/elf/ldd -e "s#^RTLDLIST=.*\$#RTLDLIST=\"${newrtld}\"#"
	fi
}

require glibc-package.inc

BBCLASSEXTEND = "nativesdk"

TARGET_CFLAGS_append_sa515m = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"
TARGET_CPPFLAGS_append_sa515m = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"

TARGET_CFLAGS_append_sa415m = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"
TARGET_CPPFLAGS_append_sa415m = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"

TARGET_CFLAGS_append_mdm9607 = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"
TARGET_CPPFLAGS_append_mdm9607 = " -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32"

TARGET_CFLAGS_append_sa525m = "${@bb.utils.contains('MLPREFIX', 'lib32-', ' -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32', '', d)}"
TARGET_CPPFLAGS_append_sa525m = "${@bb.utils.contains('MLPREFIX', 'lib32-', ' -D_TIME_BITS=32 -D_FILE_OFFSET_BITS=32', '', d)}"
