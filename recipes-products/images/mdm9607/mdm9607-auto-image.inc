# Auto Open source Packages
require ${COREBASE}/meta-qti-auto/conf/machine/mdm9607.conf
IMAGE_INSTALL += "libsensors"
IMAGE_INSTALL += "open-avb"
IMAGE_INSTALL += "start-scripts-init-can"
IMAGE_INSTALL += " ${@base_contains('DISTRO_FEATURES', 'ntn-hsic-kern-mod', '', 'ethernet-neutrino-hsic', d)}"
