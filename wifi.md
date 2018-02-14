# kali boot and wifi

```bash


    end=7gb
    read start _ < <(du -bcm kali-linux-1.0.8-amd64.iso | tail -1); echo $start
    parted /dev/sdb mkpart primary $start $end
```

```bash
    cryptsetup --verbose --verify-passphrase luksFormat /dev/sdb3
    cryptsetup luksOpen /dev/sdb3 my_usb
    Create the ext3 filesystem, and label it “persistence”.
    mkfs.ext3 -L persistence /dev/mapper/my_usb
    e2label /dev/mapper/my_usb persistence
    mkdir -p /mnt/my_usb
    mount /dev/mapper/my_usb /mnt/my_usb
    echo "/ union" > /mnt/my_usb/persistence.conf
    umount /dev/mapper/my_usb
    cryptsetup luksClose /dev/mapper/my_usb
```

```bash
   32  wget -N https://github.com/csssuf/rtl8812au/archive/master.zip
   33  ls
   34  mv master.zip ../
   35  cd ../
   36  unzip master.zip 
   37  la
   38  cd rtl8812au-master/
   39  la
   40  apt-get install build-essential linux-headers-$(uname -r)
   41  ls
   42  vim Makefile 
   43  make Makefile
   44  make
   45  insmod 8812au.ko
   46  mkdir -p /lib64/modules$(uname -r)/kernel/drivers/net/wireless/rtlwifi/rtl8812au
   47  ls $_
   48  pwd $_
   49  cp 8812au.ko /lib64/modules$(uname -r)/kernel/drivers/net/wireless/rtlwifi/rtl8812au/
   50  depmod
   51  ifconfig
   52  iwconfig
```

```bash
   58  lspci -vnn |grep -i net
   59  cat /etc/*-release
   60  uname -a
   61  cat /etc/apt/sources.list
   62  vim $_
   63  apt-get update
   64  apt-get install broadcom-sta-dkms
   65  modprobe wl

```




### Additional

Whenever I get some free time. Customize usb image:

```bash
apt-get install git live-build cdebootstrap
git clone git://git.kali.org/live-build-config.git
cd live-build-config
./build.sh --distribution kali-rolling --verbose
```