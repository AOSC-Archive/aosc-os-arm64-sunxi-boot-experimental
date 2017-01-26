pushd build
git clone https://github.com/Icenowy/linux -b sunxi64-next-20170125 --depth=1
cd linux
cp ../../linux_config .config
make ARCH=arm64 CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu- -j$(nproc)
mkdir -p ../../out/linux-kernel-sunxi64
cp arch/arm64/boot/Image ../../out/linux-kernel-sunxi64/
tmpdir=$(mktemp -d)
make ARCH=arm64 CROSS_COMPILE=/opt/abcross/arm64/bin/aarch64-aosc-linux-gnu- INSTALL_MOD_PATH="$tmpdir" modules_install
cp -r "$tmpdir"/lib/modules ../../out/linux-kernel/sunxi64/
rm -rf "$tmpdir"
for i in sun50i-h5-orangepi-pc2 sun50i-a64-pine64 sun50i-a64-pine64-plus
do
	mkdir -p ../../out/dtb-$i
	cp arch/arm64/boot/dts/allwinner/$i.dtb ../../out/dtb-$i/dtb.dtb
done
popd
