cd $1
git clone https://github.com/jiganomegsdfdf/aston-mainline.git --depth 1 linux --branch aston-$2
cd linux
config=$3
if [ "$config" = "Default" ]; then
    make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig sm8550.config
else
    wget -O arch/arm64/configs/custom_defconfig $config
    make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- custom_defconfig
fi
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
_kernel_version="$(make kernelrelease -s)"
sed -i "s/Version:.*/Version: ${_kernel_version}/" $1/linux-oneplus-aston/DEBIAN/control

chmod +x $1/mkbootimg

cat $1/linux/arch/arm64/boot/Image $1/linux/arch/arm64/boot/dts/qcom/sm8550-oneplus-aston.dtb > $1/linux/Image_w_dtb
gzip Image_w_dtb
$1/mkbootimg --header_version 4 --base 0x0 --os_version 15.0.0 --os_patch_level 2025-02 --kernel $1/linux/Image_w_dtb.gz -o $1/boot16G.img

cat $1/linux/arch/arm64/boot/Image $1/linux/arch/arm64/boot/dts/qcom/sm8550-oneplus-aston_16G_A14.dtb > $1/linux/Image_w_dtb
gzip Image_w_dtb
$1/mkbootimg --header_version 4 --base 0x0 --os_version 15.0.0 --os_patch_level 2025-02 --kernel $1/linux/Image_w_dtb.gz -o $1/boot16G_A14.img

cat $1/linux/arch/arm64/boot/Image $1/linux/arch/arm64/boot/dts/qcom/sm8550-oneplus-aston_12G.dtb > $1/linux/Image_w_dtb
gzip Image_w_dtb
$1/mkbootimg --header_version 4 --base 0x0 --os_version 15.0.0 --os_patch_level 2025-02 --kernel $1/linux/Image_w_dtb.gz -o $1/boot12G.img

rm $1/linux-oneplus-aston/usr/dummy
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$1/linux-oneplus-aston/usr modules_install
rm $1/linux-oneplus-aston/usr/lib/modules/**/build
cd $1
rm -rf linux

dpkg-deb --build --root-owner-group linux-oneplus-aston
