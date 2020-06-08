# Auto open source Packages

# Exclude components for sa2150p-nand
IMAGE_INSTALL_remove = "aerolink"
IMAGE_INSTALL_remove = "e2fsprogs-e2fsck"
IMAGE_INSTALL_remove = "e2fsprogs-mke2fs"
DISTRO_FEATURES_remove = "selinux"

