FILESEXTRAPATHS_append := ":${THISDIR}/files"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://system/core/"
S = "${WORKDIR}/system/core/libcutils"

EXTRA_OECONF_remove = " --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF_append = " --with-core-includes=${WORKDIR}/system/core/include"

SRC_URI_append = "\
	file://0001-libcutils-Remove-autotools-support.patch;apply=no \
	https://source.codeaurora.org/quic/le/platform/system/core/patch/?id=c2d8aad8d70aeb4d50f077f552044b85ef6c64b9;downloadfilename=0001-libcutils-ashmem-fortify-and-comply-with-Android-cod.patch;md5sum=e84ac5eb35c16ec10dd537393b7f0cd5;sha256sum=88d5e213db61aa65c3e4def24722d2bc24af27d0ecefe5ae9e389819a4026f11;apply=no \
	https://source.codeaurora.org/quic/le/platform/system/core/patch/?id=1186f3a5ad6581fae6e284fef4bfcefe50462cda;downloadfilename=0002-libcutils-ashmem-check-fd-validity.patch;md5sum=23e846e5f788d8354f22bfcca1b97dfa;sha256sum=090299fe5acb998918d0a970318f4a8a3d6ffd8511bcff7ae50fa27cbdd92399;apply=no \
        https://source.codeaurora.org/quic/le/platform/system/core/patch/?id=e37111d7516827489232c6c894e114a58952fe4a;downloadfilename=0003-libcutils-ashmem-print-error-message-for-invalid-fd.patch;md5sum=0e1e2636aa36114362293103c8da5224;sha256sum=c1b52d57dc6a04653c19669238cc7ad9dd833cc77631c90d4ef409f3caa35132;apply=no \ 
	https://source.codeaurora.org/quic/le/platform/system/core/patch/?id=53c0ca6520528f53aa9ed3368e5c6fcbd3152851;downloadfilename=0004-libcutils-abort-for-invalid-fd.patch;md5sum=8a70aab2809b83730b48369c37f291ba;sha256sum=a382117538b0a2fb1cfecb0f2dfd4ee6a22a6baff5a710853dedfe72203b5d1c;apply=no \
	https://source.codeaurora.org/quic/le/platform/system/core/patch/?id=ee431112ff0d9bab8b4bd4259adc361d46f130cc;downloadfilename=0005-libcutils-Add-ashmem_valid-function.patch;md5sum=6eaf69fbe8a793c46442ea36682a9a7c;sha256sum=bd1b2192105aec07f7d8388beefb5e7200da69c9d50ab1cd7789eadb090c090b;apply=no \
	file://0001-libcutils-Add-autotools-support.patch;apply=no \
	"

do_patch_more() {
    cd ${S}/../
    patch -f -p1 < ../../0001-libcutils-Remove-autotools-support.patch
    patch -f -p1 < ../../0001-libcutils-ashmem-fortify-and-comply-with-Android-cod.patch
    patch -f -p1 < ../../0002-libcutils-ashmem-check-fd-validity.patch
    patch -f -p1 < ../../0003-libcutils-ashmem-print-error-message-for-invalid-fd.patch
    patch -f -p1 < ../../0004-libcutils-abort-for-invalid-fd.patch
    patch -f -p1 < ../../0005-libcutils-Add-ashmem_valid-function.patch
    patch -f -p1 < ../../0001-libcutils-Add-autotools-support.patch
}

addtask patch_more after do_patch before do_configure

do_install_append () {
    ln -sf ../private/android_filesystem_capability.h ${D}${includedir}/cutils/android_filesystem_capability.h
    ln -sf ../private/android_filesystem_config.h ${D}${includedir}/cutils/android_filesystem_config.h
}

