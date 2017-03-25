if [ "$(uname -m)" = "aarch64" ]; then
	unset CROSS_COMPILE
else
	export CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu-
fi

pushd build
mkdir uboot-h5
cd uboot-h5
git clone https://github.com/AOSC-Dev/u-boot-aosc-sunxi u-boot -b aosc-h5 --depth=1
git clone https://github.com/Icenowy/arm-trusted-firmware -b allwinner --depth=1
pushd arm-trusted-firmware
make PLAT=sun50iw1p1
cp build/sun50iw1p1/release/bl31.bin ../u-boot/
popd
pushd u-boot
make sun50i_h5_spl32_defconfig
make CROSS_COMPILE=/opt/abcross/armel/bin/armv7a-aosc-linux-gnueabihf- spl/sunxi-spl.bin
cp spl/sunxi-spl.bin spl32.bin
make clean
make orangepi_pc2_defconfig
make u-boot-dtb.bin u-boot.bin
mkimage -E -f sun50i_h5.its sun50i_h5.itb
dd if=spl32.bin of=u-boot-sunxi-with-spl.bin bs=1024
dd if=sun50i_h5.itb of=u-boot-sunxi-with-spl.bin bs=1024 seek=32 conv=notrunc
mkdir -p ../../../out/u-boot-sun50i-h5-orangepi-pc2
cp u-boot-sunxi-with-spl.bin ../../../out/u-boot-sun50i-h5-orangepi-pc2/
popd
popd
