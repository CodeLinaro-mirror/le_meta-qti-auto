HOMESCREEN-OLD = "${@bb.utils.contains('DISTRO_FEATURES', 'agl-apps', 'homescreen', '', d)}"
HOMESCREEN-NEW = "${@bb.utils.contains('DISTRO_FEATURES', 'agl-apps', 'packagegroup-hmi-framework packagegroup-hmi-framework-dev', '', d)}"

EXTRA_APPS_remove = "qtwebkit qtwebkit-examples-examples"
