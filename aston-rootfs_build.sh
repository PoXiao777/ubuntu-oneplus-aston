#!/bin/sh
VERSION="25.04"

cd $2

truncate -s 5G rootfs.img
mkfs.ext4 rootfs.img
mkdir rootdir
mount -o loop rootfs.img rootdir

wget https://cdimage.ubuntu.com/ubuntu-base/releases/$VERSION/release/ubuntu-base-$VERSION-base-arm64.tar.gz
tar xzvf ubuntu-base-$VERSION-base-arm64.tar.gz -C rootdir

mkdir -p rootdir/data/local/tmp
mount --bind /dev rootdir/dev
mount --bind /dev/pts rootdir/dev/pts
mount --bind /proc rootdir/proc
mount -t tmpfs tmpfs rootdir/data/local/tmp
mount --bind /sys rootdir/sys

echo "nameserver 1.1.1.1" | tee rootdir/etc/resolv.conf
echo "oneplus-aston" | tee rootdir/etc/hostname
echo "127.0.0.1 localhost
127.0.1.1 oneplus-aston" | tee rootdir/etc/hosts

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\$PATH
export DEBIAN_FRONTEND=noninteractive

chroot rootdir apt update
chroot rootdir apt upgrade -y
chroot rootdir apt install -y python3-defer
chroot rootdir apt install -y openssh-server
chroot rootdir sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
chroot rootdir systemctl enable ssh

echo "#!/bin/bash
exit 0" | tee rootdir/var/lib/dpkg/info/python3-defer.postinst
chroot rootdir dpkg --configure python3-defer

chroot rootdir apt install -y bash-completion sudo ssh nano rmtfs qrtr-tools u-boot-tools- cloud-init- wireless-regdb- libreoffice*- transmission*- remmina*- $1

echo "[Daemon]
DeviceScale=2" | tee rootdir/etc/plymouth/plymouthd.conf

echo "[org.gnome.desktop.interface]
scaling-factor=2" | tee rootdir/usr/share/glib-2.0/schemas/93_hidpi.gschema.override

echo "PARTLABEL=win / ext4 errors=remount-ro,x-systemd.growfs 0 1" | tee rootdir/etc/fstab

echo 'ACTION=="add", SUBSYSTEM=="misc", KERNEL=="udmabuf", TAG+="uaccess"' | tee rootdir/etc/udev/rules.d/99-oneplus-aston.rules

chroot rootdir glib-compile-schemas /usr/share/glib-2.0/schemas

mkdir rootdir/var/lib/gdm
touch rootdir/var/lib/gdm/run-initial-setup

chroot rootdir pw-metadata -n settings 0 clock.force-quantum 2048

chroot rootdir apt clean

umount rootdir/sys
umount rootdir/proc
umount rootdir/dev/pts
umount rootdir/data/local/tmp
umount rootdir/dev
umount rootdir

rm -d rootdir

7z a rootfs.7z rootfs.img
