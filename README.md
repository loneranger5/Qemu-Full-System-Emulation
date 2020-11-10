# Qemu Full System Emulation
Some qemu images and instructions for full system emulation of various architectures
# Building Qemu armv7 raspbian full system emulation
# Download and build files

Download and unzip the image of Raspbian :

```
wget http://downloads.raspberrypi.org/raspbian/images/raspbian-2020-02-07/2020-02-05-raspbian-buster.zip
unzip 2020-02-05-raspbian-buster.zip
```

Download and untar Buildroot package:

```
wget https://buildroot.org/downloads/buildroot-2020.08.tar.gz
tar xz buildroot-2020.08.tar.gz
```

Set Buildroot configuration file to build QEMU ARM using V-Express and start:

```
cd buildroot-2019.02/
make qemu_arm_vexpress_defconfig
make
```

Output files are located in the output/images folder. This will create default rootfs, the kernel to be used zImage and the DTB ```vexpress-v2p-ca9.dtb.```

You now have everything needed to start Raspbian on QEMU.

# Start Raspbian on QEMU

```
qemu-system-arm \
        -M vexpress-a9 \
        -m 256 \
        -kernel vexpress/zImage \
        -dtb vexpress/vexpress-v2p-ca9.dtb \
        -sd 2018-11-13-raspbian-stretch.img \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2" \
        -serial stdio \
        -net nic -net user,hostfwd=tcp::2222-:22 \
        -nographic
```

If everything went well, Raspbian should boot (default username and password of Raspbian are pi and raspberry respectively).

You may enable SSH using sudo raspi-config from Raspbian, go to Interfacing Options, SSH and select <Yes>. After that, you may access your emulated Raspbian machine using SSH from your local OS:

```ssh -p 2222 pi@localhost```
Password is required to establish connection.


# Resize Pi's filesystem
On the host, run
```qemu-img resize <image_name>.img +<size>G```
Then, on the PI, run
```sudo fdisk /dev/mmcblk0```
fdisk is in interactive mode by default. Run sequentially :
```
>p  #Get the first segment for /dev/mmcblk0p2 (probably 98304)
>d
>2
>n
>2
>p
>98304
>w
```
then reboot the pi

```sudo reboot -h now```
then, on the pi, run

```sudo resize2fs /dev/mmcblk0p2```
