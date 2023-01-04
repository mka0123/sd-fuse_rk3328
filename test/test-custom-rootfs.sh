#!/bin/bash
set -eux

HTTP_SERVER=112.124.9.243

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
       HTTP_SERVER=127.0.0.1
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-4.19 sd-fuse_rk3328
cd sd-fuse_rk3328
git checkout kernel-4.19
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-focal-arm64-images.tgz
tar xzf friendlycore-focal-arm64-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/emmc-flasher-images.tgz
tar xzf emmc-flasher-images.tgz
wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/rootfs/rootfs-friendlycore-focal-arm64.tgz
tar xzf rootfs-friendlycore-focal-arm64.tgz
echo hello > friendlycore-focal-arm64/rootfs/root/welcome.txt
(cd friendlycore-focal-arm64/rootfs/root/ && {
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-focal-arm64-images.tgz -O deleteme.tgz
});
./build-rootfs-img.sh friendlycore-focal-arm64/rootfs friendlycore-focal-arm64
./mk-sd-image.sh friendlycore-focal-arm64
./mk-emmc-image.sh friendlycore-focal-arm64
