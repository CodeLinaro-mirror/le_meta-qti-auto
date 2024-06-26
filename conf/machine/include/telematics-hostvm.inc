MACHINE_FEATURES:append = " qti-vm-host qti-virtualization"

MACHINE_MNT_POINTS = " \
    /firmware \
    /systemrw \
    /persist \
    /data \
    /vm-bootsys \
    /vm_systemrw \
"

KERNEL_VARIANT:qti-distro-debug ??= "hostvm_debug_"
KERNEL_VARIANT:qti-distro-perf ??= "hostvm_perf_"

MACHINE_FEATURES:remove = "qti-wwan-plus-cv2x"
