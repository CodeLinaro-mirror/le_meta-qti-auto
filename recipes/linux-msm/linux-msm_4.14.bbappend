
do_patch_append () {
    if ${@bb.utils.contains('MACHINE', 'sa2150p-nand', 'true', 'false', d)}; then
        cd ${S}
        sed -i 's/0x87400000 0x0 0x1200000/0x87400000 0x0 0x1400000/' arch/arm64/boot/dts/qcom/qcs403.dtsi
        cd -
    fi
}
