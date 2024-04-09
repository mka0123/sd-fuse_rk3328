#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/friendlyarm/kernel-rockchip
KERNEL_BRANCH=nanopi4-v4.19.y

# hack for me
[ -f /etc/friendlyarm ] && source /etc/friendlyarm $(basename $(builtin cd ..; pwd))

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git -b kernel-4.19 sd-fuse_rk3328
cd sd-fuse_rk3328
if [ -f ../../friendlycore-focal-arm64-images.tgz ]; then
	tar xvzf ../../friendlycore-focal-arm64-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3328/images-for-eflasher/friendlycore-focal-arm64-images.tgz
	tar xvzf friendlycore-focal-arm64-images.tgz
fi

if [ -f ../../kernel-RK3328.tgz ]; then
	tar xvzf ../../kernel-RK3328.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-RK3328
fi

KERNEL_SRC=$PWD/kernel-RK3328 ./build-kernel.sh friendlycore-focal-arm64
cp prebuilt/dtbo.img friendlycore-focal-arm64
./mk-sd-image.sh friendlycore-focal-arm64
