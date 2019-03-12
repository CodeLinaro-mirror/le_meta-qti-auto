do_configure_prepend_sdxpoorwills-auto () {
		mkdir -p ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos
		cp -f ${WORKSPACE}/data-kernel/drivers/emac-dwc-eqos/* ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/
		rm ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Makefile
		rm ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Makefile.am
		rm ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Kbuild
		mv ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Makefile.builtin ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Makefile
		echo "source \"drivers/net/ethernet/qualcomm/emac_dwc_eqos/Kconfig"\" >> ${S}/drivers/net/ethernet/Kconfig
		echo "obj-y += emac_dwc_eqos/" >> ${S}/drivers/net/ethernet/qualcomm/Makefile

		mkdir -p ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos_app
		mv ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/DWC_ETH_QOS_app.c ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos_app/
		mv ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Makefile_app.builtin ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos_app/Makefile
		mv ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos/Kconfig_app ${S}/drivers/net/ethernet/qualcomm/emac_dwc_eqos_app/Kconfig
		echo "source \"drivers/net/ethernet/qualcomm/emac_dwc_eqos_app/Kconfig"\" >> ${S}/drivers/net/ethernet/Kconfig
		echo "obj-y += emac_dwc_eqos_app/" >> ${S}/drivers/net/ethernet/qualcomm/Makefile
}