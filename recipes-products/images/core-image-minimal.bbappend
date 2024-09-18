# Install avbtool and vsomeip packages for SDK toolchain
TOOLCHAIN_HOST_TASK:append:sa525m += "nativesdk-avbtool"
TOOLCHAIN_TARGET_TASK:append:sa525m += "${MLIBPREFIX}common-api-c++ ${MLIBPREFIX}common-api-c++-someip"
