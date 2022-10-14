#!/bin/sh
# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted (subject to the limitations in the
# disclaimer below) provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of Qualcomm Innovation Center, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE
# GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
# HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

mkdir $PWD/destn/
unzip -o -q $1 -d $PWD/destn/
cp -rf destn/BOOTABLE_IMAGES/boot.img destn/IMAGES/
cd destn
zip -r target-sa515.zip BOOT/ BOOTABLE_IMAGES/ DATA/ IMAGES/ META/ OTA/ RADIO/ RECOVERY/ SYSTEM/
cd ..
cp destn/target-sa515.zip $PWD/../../../stream-update-native/git-r0/OTA/streaming/system/update_engine/payload_generator/destn-target-sa515.zip

cd $PWD/../../../stream-update-native/git-r0/OTA/streaming/system/update_engine/payload_generator
export PATH=$PATH:$PWD:$PWD/../../../../../../../libsparse-native/1.0-r0/build/:$PWD/../../lib:$PWD/../../usr/bin:$PWD/../../usr/lib:$PWD/../../../recipe-sysroot-native/usr/bin:$PWD/../../../recipe-sysroot-native/usr/lib
LD_LIBRARY_PATH=$PWD/../../lib:$PWD/../../usr/lib
export  LD_LIBRARY_PATH
sdgsgsdhgs

mkdir -p lib/shflags

cp -rf ../../../../../../../../../../../../OTA/streaming/external/shflags/src/shflags lib/shflags/
cp -rf ../../../../../../../../../../../../OTA/streaming/system/update_engine/scripts/brillo_update_payload scripts_brillo_update_payload
chmod 0777 *
echo "start generating payload.bin"
scripts_brillo_update_payload generate --payload payload.bin --target_image  destn-target-sa515.zip
scripts_brillo_update_payload properties --payload payload.bin > properties.txt

cp payload.bin    ../../../../../../../../../deploy/images/sa515m-nad/
cp properties.txt ../../../../../../../../../deploy/images/sa515m-nad/

