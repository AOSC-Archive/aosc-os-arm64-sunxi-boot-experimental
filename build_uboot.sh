if [ "$(uname -m)" = "aarch64" ]; then
	unset CROSS_COMPILE
else
	export CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu-
fi

build_uboot(){
	pushd build
	mkdir uboot-$1
	cd uboot-$1
	git clone https://github.com/u-boot/u-boot -b v2017.11-rc4 --depth=1
	git clone https://github.com/apritzel/arm-trusted-firmware -b allwinner-stable --depth=1
	pushd arm-trusted-firmware
	make PLAT=sun50iw1p1
	cp build/sun50iw1p1/release/bl31.bin ../u-boot/
	popd
	pushd u-boot
	make $1_defconfig
	sed -i 's/# CONFIG_OF_LIBFDT_OVERLAY is not set/CONFIG_OF_LIBFDT_OVERLAY=y/g' .config # Configure fdt overlay command
	make
	dd if=spl/sunxi-spl.bin of=u-boot-sunxi-with-spl.bin bs=1024
	dd if=u-boot.itb of=u-boot-sunxi-with-spl.bin bs=1024 seek=32 conv=notrunc
	mkdir -p ../../../out/u-boot-$2
	cp u-boot-sunxi-with-spl.bin ../../../out/u-boot-$2/
	popd
	popd
}

build_uboot pine64_plus sun50i-a64-pine64-plus
build_uboot bananapi_m64 sun50i-a64-bananapi-m64
build_uboot orangepi_prime sun50i-h5-orangepi-prime
build_uboot orangepi_pc2 sun50i-h5-orangepi-pc2
build_uboot nanopi_neo2 sun50i-h5-nanopi-neo2
