qemu-system-arm \
        -M vexpress-a9 \
        -m 256 \
        -kernel vexpress/zImage \
        -dtb vexpress/vexpress-v2p-ca9.dtb \
        -sd 2018-11-13-raspbian-stretch.img \
        -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2" \
        -serial stdio \
        -net nic -net user,hostfwd=tcp::2222-:22
