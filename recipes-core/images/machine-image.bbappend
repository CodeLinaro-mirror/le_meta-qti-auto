AEROLINK_DIR ?= "${USR_IMAGE_ROOTFS}/aerolink"

do_generate_usrfs_fsconfig_append() {
   if ${@bb.utils.contains('IMAGE_FSTYPES', 'ext4', 'true', 'false', d)}; then
      aerolink_files=$(find ${AEROLINK_DIR} | sed 's,${USR_IMAGE_ROOTFS}/,,')
      for file in $aerolink_files; do
        echo $file 4024 4024 0770 >> ${WORKDIR}/usrfs_fsconfig.conf
      done
   fi
}
