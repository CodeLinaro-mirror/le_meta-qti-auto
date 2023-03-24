inherit autotools pkgconfig

SUMMARY = "sensor client api test application "
DESCRIPTION = "Sensor client test app used to get the sensor events at interested sampling rate and batch counts"
PR = "r1"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS = "sensor-client-api sensor-hal-daemon libsensors"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_client_api_testapp"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_client_api_testapp"

##Entries for VMs
PACKAGECONFIG_append = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'sensors-vm', '', d)}"
## Both VMs and EAPs will be treated in similar way
PACKAGECONFIG[sensors-vm] = "--with-vm"

EXTRA_OECONF += "--with-glib \
                 --with-core-includes=${WORKSPACE}/system/core/include"
