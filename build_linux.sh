if [ "$(uname -m)" = "aarch64" ]; then
	unset CROSS_COMPILE
else
	export CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu-
fi

pushd build
git clone https://github.com/Icenowy/linux -b sunxi64-4.13.y --depth=1
cd linux
git clone https://github.com/AOSC-Dev/sunxi-mali400-r6p0-module
git clone https://github.com/AOSC-Dev/sunxi-mali450-r7p0-module
cp ../../linux_config .config
make ARCH=arm64 DTC_FLAGS=-@ -j$(nproc)
mkdir -p ../../out/linux-kernel-sunxi64
cp arch/arm64/boot/Image ../../out/linux-kernel-sunxi64/
tmpdir=$(mktemp -d)
make ARCH=arm64 INSTALL_MOD_PATH="$tmpdir" modules_install
EXTRA_KMOD_DIR="$(echo "$tmpdir"/lib/modules/*)/kernel/extra"
mkdir -p "$EXTRA_KMOD_DIR"
for i in sunxi-mali400-r6p0-module sunxi-mali450-r7p0-module
do
	pushd $i
	ARCH=arm64 KDIR=$PWD/.. ./build.sh
	cp *.ko "$EXTRA_KMOD_DIR"
	popd
done
depmod -b "$tmpdir" $(basename $(readlink -f $EXTRA_KMOD_DIR/../..))
cp -r "$tmpdir"/lib/modules ../../out/linux-kernel-sunxi64/
rm -rf "$tmpdir"
for i in \
	sun50i-h5-orangepi-pc2 \
	sun50i-h5-orangepi-prime \
	sun50i-h5-nanopi-neo2 \
	sun50i-a64-bananapi-m64 \
	sun50i-a64-pine64 \
	sun50i-a64-pine64-plus
do
	mkdir -p ../../out/dtb-$i
	cp arch/arm64/boot/dts/allwinner/$i.dtb ../../out/dtb-$i/dtb.dtb
done
popd
