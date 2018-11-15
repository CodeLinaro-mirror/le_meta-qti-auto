AGL_APPS = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'agl-apps', ' \
    dashboard \
    hvac \
    mediaplayer \
    mixer \
    navigation \
    phone \
    radio \
    settings \
    low-can-demo', '' , d)} \
    "

RDEPENDS_${PN}_remove = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'agl-apps', '', ' \
    qtquickcontrols2-agl \
    qtquickcontrols2-agl-style' , d)} \
    ${MOST_HVAC} \
    "
