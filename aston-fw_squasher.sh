git clone https://github.com/linux-msm/pil-squasher --depth 1
cd pil-squasher
make install


/usr/local/bin/pil-squasher $1/firmware-oneplus-aston/usr/lib/firmware/qcom/sm8550/aston/adsp.mbn $1/firmware-oneplus-aston/usr/lib/firmware/qcom/sm8550/aston/adsp.mdt
rm -rf $1/firmware-oneplus-aston/usr/lib/firmware/qcom/sm8550/aston/adsp.mdt $1/firmware-oneplus-aston/usr/lib/firmware/qcom/sm8550/aston/adsp.b*

cd $1
dpkg-deb --build --root-owner-group firmware-oneplus-aston