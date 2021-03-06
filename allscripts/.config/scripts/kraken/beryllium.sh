#!/usr/bin/env bash

pwd=$(pwd)

git config --global user.email "mamutal91@aospk.org"
git config --global user.name "Alexandre Rangel"

branchDefault="eleven"

bringup="Initial changes for Kraken"

workingDir=$(mktemp -d) && cd $workingDir

bringup="Initial changes for Kraken"

git clone https://github.com/LineageOS/android_device_xiaomi_beryllium -b lineage-18.1
git clone https://github.com/LineageOS/android_device_xiaomi_sdm845-common -b lineage-18.1

cd android_device_xiaomi_beryllium

mv overlay-lineage overlay-kraken
cd overlay-kraken
mv lineage-sdk custom-sdk
cd custom-sdk
mv lineage kraken

cd ../../

sed -i "s/lineage_/aosp_/g" AndroidProducts.mk

mv lineage_beryllium.mk aosp_beryllium.mk
sed -i "s/lineage_/aosp_/g" aosp_beryllium.mk
sed -i "s/vendor\/lineage/vendor\/aosp/" aosp_beryllium.mk
sed -i "s/Lineage stuff/Kraken stuff/g" aosp_beryllium.mk

sed -i "s/overlay-lineage/overlay-kraken/g" device.mk

rm -rf lineage.dependencies
echo '[
  {
    "repository": "device_xiaomi_sdm845-common",
    "target_path": "device/xiaomi/sdm845-common"
  },
  {
    "repository": "vendor_xiaomi_beryllium",
    "target_path": "vendor/xiaomi/beryllium"
  },
  {
    "remote": "github",
    "repository": "LineageOS/android_hardware_xiaomi",
    "target_path": "hardware/xiaomi",
    "branch": "lineage-18.1"
  }
]' > aosp.dependencies

git add . && git commit --message "beryllium: $bringup" --signoff --author "Alexandre Rangel <mamutal91@aospk.org>"
git push ssh://git@github.com/AOSPK-Devices/device_xiaomi_beryllium HEAD:refs/heads/${branchDefault} --force

cd ../android_device_xiaomi_sdm845-common

mv overlay-lineage overlay-kraken
cd overlay-kraken
mv lineage-sdk custom-sdk
cd custom-sdk
mv lineage kraken

cd ../../

sed -i "s/overlay-lineage/overlay-kraken/g" sdm845.mk
sed -i "s/vendor\/lineage/vendor\/aosp/" sdm845.mk

rm -rf lineage.dependencies
echo '[
  {
    "repository": "kernel_xiaomi_sdm845",
    "target_path": "kernel/xiaomi/sdm845"
  },
  {
    "repository": "vendor_xiaomi_sdm845-common",
    "target_path": "vendor/xiaomi/sdm845-common"
  }
]' > aosp.dependencies

git add . && git commit --message "sdm845-common: $bringup" --signoff --author "Alexandre Rangel <mamutal91@aospk.org>"

git push ssh://git@github.com/AOSPK-Devices/device_xiaomi_sdm845-common HEAD:refs/heads/${branchDefault} --force

# Kernel and Vendor
cd $workingDir

git clone https://gitlab.com/the-muppets/proprietary_vendor_xiaomi -b lineage-18.1
mv proprietary_vendor_xiaomi android_vendor_xiaomi_beryllium
cp -rf android_vendor_xiaomi_beryllium android_vendor_xiaomi_sdm845-common

cd android_vendor_xiaomi_beryllium
git filter-branch --prune-empty --subdirectory-filter beryllium lineage-18.1
git push ssh://git@github.com/AOSPK-Devices/vendor_xiaomi_beryllium HEAD:refs/heads/${branchDefault} --force
git push ssh://git@gitlab.com/AOSPK-Devices/vendor_xiaomi_beryllium HEAD:refs/heads/${branchDefault} --force

cd ../android_vendor_xiaomi_sdm845-common
git filter-branch --prune-empty --subdirectory-filter sdm845-common lineage-18.1
git push ssh://git@github.com/AOSPK-Devices/vendor_xiaomi_sdm845-common HEAD:refs/heads/${branchDefault} --force
git push ssh://git@gitlab.com/AOSPK-Devices/vendor_xiaomi_sdm845-common HEAD:refs/heads/${branchDefault} --force

cd ..
git clone https://github.com/LineageOS/android_kernel_xiaomi_sdm845 -b lineage-18.1
cd android_kernel_xiaomi_sdm845
git push ssh://git@github.com/AOSPK-Devices/kernel_xiaomi_sdm845 HEAD:refs/heads/${branchDefault} --force

cd $pwd

rm -rf $workingDir
