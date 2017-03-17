pushd build
mkdir uboot-a64
cd uboot-a64
git clone https://github.com/AOSC-Dev/u-boot-aosc-sunxi u-boot -b aosc-a64 --depth=1
git clone https://github.com/Icenowy/arm-trusted-firmware -b allwinner --depth=1
pushd arm-trusted-firmware
make PLAT=sun50iw1p1 CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu-
cp build/sun50iw1p1/release/bl31.bin ../u-boot/
popd
pushd u-boot
make pine64_plus_defconfig
make CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu-
dd if=spl/sunxi-spl.bin of=u-boot-sunxi-with-spl.bin bs=1024
dd if=u-boot.itb of=u-boot-sunxi-with-spl.bin bs=1024 seek=32 conv=notrunc
mkdir -p ../../../out/u-boot-sun50i-a64-pine64-plus
cp u-boot-sunxi-with-spl.bin ../../../out/u-boot-sun50i-a64-pine64-plus/
popd
popd
