# Auto Open source Packages
require ${COREBASE}/meta-qti-auto/conf/mdm9650-auto.conf

IMAGE_INSTALL += "open-avb"
IMAGE_INSTALL += "libsensors"
IMAGE_INSTALL += " ${@base_contains('DISTRO_FEATURES', 'ntn-pcie-dyn-mod', 'ethernet-neutrino-pcie', '', d)}"
IMAGE_INSTALL += "start-scripts-init-can"
IMAGE_INSTALL += "cannelloni"
