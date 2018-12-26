RDEPENDS_${PN} += "\
    qtlocation \
    qtlocation-plugins \
    qtlocation-qmlplugins \
    qtquickcontrols2 \
    qtquickcontrols2-qmlplugins \
    qtsensors \
    qtsensors-plugins \
    qtsensors-qmlplugins \
    qtsvg \
    qtsvg-plugins \
    "

RDEPENDS_${PN}_remove = "\
    qtbase-dev \
    qtbase-staticdev \
    qtwayland-tools \
    "
