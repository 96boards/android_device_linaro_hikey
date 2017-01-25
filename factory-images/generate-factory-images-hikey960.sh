# Copyright 2011, 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


DEVICE_DIR=device/linaro/hikey/
DEVICE=hikey960
PRODUCT=hikey960

BUILD=eng.`whoami`
BUILDNAME=`ls ${ANDROID_BUILD_TOP}/${PRODUCT}-img-${BUILD}.zip 2> /dev/null`
if [ $? -ne 0 ]; then
  VERSION=linaro-`date +"%Y.%m.%d"`
else
  BUILDNAME=`ls ${ANDROID_BUILD_TOP}/${PRODUCT}-img-*.zip 2> /dev/null`
  BUILD=`basename ${BUILDNAME} | cut -f3 -d'-' | cut -f1 -d'.'`
  VERSION=$BUILD
fi

# Prepare the staging directory
rm -rf tmp
mkdir -p tmp/$PRODUCT-$VERSION

# copy over bootloader binaries
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/bl31.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/fastboot.img tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/lpm3.img tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/nvme.img tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/ptable.img tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/README tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/sec_xloader.img tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/hikey960/vector.img tmp/$PRODUCT-$VERSION/

# copy over dts.img
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/../hikey-kernel/dt-hikey960.img tmp/$PRODUCT-$VERSION/

# copy over the update image
cp ${SRCPREFIX}$PRODUCT-img-$BUILD.zip tmp/$PRODUCT-$VERSION/image-$PRODUCT-$VERSION.zip


# Write flash-all.sh
cat > tmp/$PRODUCT-$VERSION/flash-all.sh << EOF
#!/bin/bash

# Copyright 2012, 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



fastboot flash xloader		sec_xloader.img
fastboot flash fastboot		fastboot.img
fastboot flash ptable		ptable.img
fastboot flash nvme		nvme.img
fastboot flash vector		vector.img
fastboot flash fw_lpm3		lpm3.img
fastboot flash trustfirmware	bl31.bin
fastboot flash dts		dt-hikey960.img
fastboot update image-$PRODUCT-$VERSION.zip
EOF

chmod a+x tmp/$PRODUCT-$VERSION/flash-all.sh

# Create the distributable package
(cd tmp ; zip -r ../$PRODUCT-$VERSION-factory.zip $PRODUCT-$VERSION)
mv $PRODUCT-$VERSION-factory.zip $PRODUCT-$VERSION-factory-$(sha256sum < $PRODUCT-$VERSION-factory.zip | cut -b -8).zip

# Clean up
rm -rf tmp
