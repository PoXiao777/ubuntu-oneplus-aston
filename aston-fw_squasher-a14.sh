git clone https://github.com/linux-msm/pil-squasher --depth 1
cd pil-squasher
make install

mkdir -p $1/firmware-oneplus-aston-a14/usr/lib/firmware/qca/
cp -rf $1/firmware-oneplus-aston-a15/usr/lib/firmware/qca/* $1/firmware-oneplus-aston-a14/usr/lib/firmware/qca/
cp -rf $1/firmware-oneplus-aston-a15/usr/lib/firmware/qcom/gmu_gen70200.bin $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/
cp -rf $1/firmware-oneplus-aston-a15/usr/lib/firmware/qcom/a740_sqe.fw $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/
cp -rf $1/firmware-oneplus-aston-a15/usr/lib/firmware/qcom/sm8550/astonsnd-tplg.bin $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/sm8550/
cp -rf $1/firmware-oneplus-aston-a15/usr/lib/firmware/regulatory.db* $1/firmware-oneplus-aston-a14/usr/lib/firmware/
cp -rf $1/firmware-oneplus-aston-a15/usr/lib/firmware/qcom/sm8550/aston/modem* $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/sm8550/aston/

/usr/local/bin/pil-squasher $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/sm8550/aston/adsp.mbn $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/sm8550/aston/adsp.mdt
rm -rf $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/sm8550/aston/adsp.mdt $1/firmware-oneplus-aston-a14/usr/lib/firmware/qcom/sm8550/aston/adsp.b*

cd $1
dpkg-deb --build --root-owner-group firmware-oneplus-aston-a14