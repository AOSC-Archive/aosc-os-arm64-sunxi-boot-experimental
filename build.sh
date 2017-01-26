rm -rf build
mkdir -p build
if [ "$BUILD_UBOOT" != "0" ]; then
	sh build_uboot_a64.sh
	sh build_uboot_h5.sh
fi
if [ "$BUILD_LINUX" != "0" ]; then
	sh build_linux.sh
fi
