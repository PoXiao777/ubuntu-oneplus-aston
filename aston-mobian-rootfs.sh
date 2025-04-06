#!/bin/sh
cd $2

wget https://images.mobian-project.org/sdm845/mobian-sdm845-phosh-12.0.tar.gz -O mobian.tar.gz
tar xzf mobian.tar.gz
find . -type f ! -name '*.rootfs.img' -delete
mv *.rootfs.img rootfs-sparse.img
simg2img rootfs-sparse.img rootfs.img
mkdir rootdir
sudo mount -o loop,rw rootfs.img rootdir/

mkdir -p rootdir/data/local/tmp
mount --bind /dev rootdir/dev
mount --bind /dev/pts rootdir/dev/pts
mount --bind /proc rootdir/proc
mount -t tmpfs tmpfs rootdir/data/local/tmp
mount --bind /sys rootdir/sys

sudo cat rootdir/etc/apt/sources.list
chroot rootdir echo "nameserver 8.8.8.8" >> /lib/systemd/resolv.conf
rm rootdir/etc/resolv.conf
echo "nameserver 8.8.8.8" >  rootdir/etc/resolv.conf
echo "oneplus-aston" | tee rootdir/etc/hostname
echo "127.0.0.1 localhost
127.0.1.1 oneplus-aston" | tee rootdir/etc/hosts

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\$PATH
export DEBIAN_FRONTEND=noninteractive


chroot rootdir sed -i 's|http://security.debian.org/|http://security.debian.org/debian-security|g' /etc/apt/sources.list
sudo cat rootdir/etc/apt/sources.list
chroot rootdir apt update
chroot rootdir apt upgrade -y
chroot rootdir apt install wget -y
chroot rootdir wget -O - repo.mobian.org/mobian.gpg.key | sudo apt-key add -
chroot rootdir apt update
chroot rootdir apt upgrade -y
chroot rootdir apt purge linux-*sdm845* -y
chroot rootdir apt remove sdm845* -y
chroot rootdir rm -rf /lib/modules/*
chroot rootdir apt autoremove -y && apt autoclean -y

echo "#!/bin/bash
exit 0" | tee rootdir/var/lib/dpkg/info/python3-defer.postinst
chroot rootdir dpkg --configure python3-defer

chroot rootdir apt install -y bash-completion sudo ssh nano rmtfs u-boot-tools- cloud-init- wireless-regdb- libreoffice*- transmission*- remmina*- $1

echo "[Daemon]
DeviceScale=2" | tee rootdir/etc/plymouth/plymouthd.conf

echo "[org.gnome.desktop.interface]
scaling-factor=2" | tee rootdir/usr/share/glib-2.0/schemas/93_hidpi.gschema.override

echo "PARTLABEL=win / ext4 errors=remount-ro,x-systemd.growfs 0 1" | tee rootdir/etc/fstab

echo 'ACTION=="add", SUBSYSTEM=="misc", KERNEL=="udmabuf", TAG+="uaccess"' | tee rootdir/etc/udev/rules.d/99-oneplus-aston.rules

chroot rootdir glib-compile-schemas /usr/share/glib-2.0/schemas

mkdir rootdir/var/lib/gdm
touch rootdir/var/lib/gdm/run-initial-setup

chroot rootdir apt clean

umount rootdir/sys
umount rootdir/proc
umount rootdir/dev/pts
umount rootdir/data/local/tmp
umount rootdir/dev
umount rootdir

rm -d rootdir

7z a rootfs.7z rootfs.img
