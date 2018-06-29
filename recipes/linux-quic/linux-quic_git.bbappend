require ${COREBASE}/meta-qti-auto/conf/mdm9650-auto.conf

do_configure_prepend_mdm9650 () {
    if ${@base_contains('DISTRO_FEATURES', 'ntn-pcie-dyn-mod', 'false', 'true', d)}; then
       mkdir -p ${S}/drivers/net/ethernet/neutrino
       cp -f ${WORKSPACE}/qcom-opensource/ethernet/neutrino-pcie/driver/* ${S}/drivers/net/ethernet/neutrino/
       rm ${S}/drivers/net/ethernet/neutrino/Makefile
       rm ${S}/drivers/net/ethernet/neutrino/Makefile.am
       rm ${S}/drivers/net/ethernet/neutrino/Kbuild
       mv ${S}/drivers/net/ethernet/neutrino/Makefile.builtin ${S}/drivers/net/ethernet/neutrino/Makefile
       echo "source \"drivers/net/ethernet/neutrino/Kconfig"\" >> ${S}/drivers/net/ethernet/Kconfig
       echo "obj-y += neutrino/" >> ${S}/drivers/net/ethernet/Makefile

       mkdir -p ${S}/drivers/net/ethernet/neutrino_app
       cp -f ${WORKSPACE}/qcom-opensource/ethernet/neutrino-pcie/driver/DWC_ETH_QOS_app.c ${S}/drivers/net/ethernet/neutrino_app/
       cp -f ${WORKSPACE}/qcom-opensource/ethernet/neutrino-pcie/driver/Makefile_app ${S}/drivers/net/ethernet/neutrino_app/Makefile
       cp -f ${WORKSPACE}/qcom-opensource/ethernet/neutrino-pcie/driver/Kconfig_app ${S}/drivers/net/ethernet/neutrino_app/Kconfig
       echo "source \"drivers/net/ethernet/neutrino_app/Kconfig"\" >> ${S}/drivers/net/ethernet/Kconfig
       echo "obj-y += neutrino_app/" >> ${S}/drivers/net/ethernet/Makefile
   fi
}
