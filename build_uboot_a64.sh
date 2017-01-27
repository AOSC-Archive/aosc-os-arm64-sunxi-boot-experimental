pushd build
mkdir uboot-a64
cd uboot-a64
git clone https://github.com/apritzel/u-boot -b spl-fit-rfc --depth=1
git clone https://github.com/Icenowy/arm-trusted-firmware -b allwinner --depth=1
pushd arm-trusted-firmware
sed -i 's/1689/ffff/g' ./plat/sun50iw1p1/sunxi_clocks.c
make PLAT=sun50iw1p1 CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu- DEBUG=1
cp build/sun50iw1p1/debug/bl31.bin ../u-boot/
popd
pushd u-boot
make pine64_plus_defconfig
make CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu-
mkimage -E -f board/sunxi/pine64_atf.its pine64_atf.itb
dd if=spl/sunxi-spl.bin of=u-boot-sunxi-with-spl.bin bs=1024
dd if=pine64_atf.itb of=u-boot-sunxi-with-spl.bin bs=1024 seek=32 conv=notrunc
mkdir -p ../../../out/u-boot-sun50i-a64-pine64-plus
cp u-boot-sunxi-with-spl.bin ../../../out/u-boot-sun50i-a64-pine64-plus/
popd
popd
