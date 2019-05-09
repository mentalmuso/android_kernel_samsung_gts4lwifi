#!/bin/bash
KERN=/home/mentalmuso/github/android_kernel_samsung_gts4lwifi
TODAY=`date +%Y-%m-%d.%H:%M`

export ARCH=arm64
export CROSS_COMPILE=/home/mentalmuso/kernel/toolchain/4.9/bin/aarch64-linux-android-
export ANDROID_MAJOR_VERSION=p
export PLATFORM_VERSION=9.0.0
mkdir out

make -C $(pwd) O=out CROSS_COMPILE=/home/mentalmuso/kernel/toolchain/4.9/bin/aarch64-linux-android- KCFLAGS=-mno-android weta_defconfig
make -j64 -C $(pwd) O=out CROSS_COMPILE=/home/mentalmuso/kernel/toolchain/4.9/bin/aarch64-linux-android- KCFLAGS=-mno-android

cp $(pwd)/out/arch/arm64/boot/Image $(pwd)/arch/arm64/boot/Image
cp $(pwd)/out/arch/arm64/boot/Image.gz $(pwd)/WETA/Image.gz
cp $(pwd)/out/arch/arm64/boot/Image.gz-dtb $(pwd)/WETA/Image.gz-dtb

cd $(pwd)/WETA

echo " "
echo "###########################################"
echo "# Kernel zip and img found in WETA folder #"
echo "###########################################"
echo " "

# build anykernel zip
echo " "
echo "# Building flashable zip #"
echo " "
mv $KERN/WETA/WETA_Kernel*.zip $KERN/WETA/old
cp -f $KERN/WETA/Image.gz-dtb $KERN/WETA/weta_anykernel/zImage
cd $KERN/WETA/weta_anykernel
zip -r $KERN/WETA/WETA_Kernel_$TODAY.zip *
cd $KERN

# build weta_boot.img
echo " "
echo "# Building boot.img #"
echo " "
mv $KERN/WETA/weta_boot_*.img $KERN/WETA/old
cd $KERN/WETA/AIK
./unpackimg.sh
cp -f $KERN/WETA/Image.gz-dtb $KERN/WETA/AIK/split_img/boot.img-zImage
./repackimg.sh
mv $KERN/WETA/AIK/image-new.img $KERN/WETA/weta_boot_$TODAY.img
./cleanup.sh
cd $KERN

echo " "
echo "###########################################"
echo "# Kernel zip and img found in WETA folder #"
echo "###########################################"
echo " "
