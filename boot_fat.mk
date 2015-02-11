
REALTOP=$(realpath $(TOP))
boot_fatimage: bootimage all_dtbs
	mkdir -p $(PRODUCT_OUT)/boot_fat/
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.img bs=512 count=98304
	sudo mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.img
	sudo mkdir -p $(PRODUCT_OUT)/boot_tmp && sudo mount -o loop,rw,sync $(PRODUCT_OUT)/boot_fat.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/Image $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/hi6220-hikey.dtb $(PRODUCT_OUT)/boot_tmp/lcb.dtb
	sudo cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(REALTOP)/device/linaro/hikey/cmdline $(PRODUCT_OUT)/cmdline
	sudo umount -f $(PRODUCT_OUT)/boot_tmp

droidcore: boot_fatimage
