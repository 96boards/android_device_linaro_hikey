
REALTOP=$(realpath $(TOP))
boot_fatimage: bootimage all_dtbs
	mkdir -p $(PRODUCT_OUT)/boot_fat/
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.img bs=512 count=98304
	sudo mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.img
	mkdir -p $(PRODUCT_OUT)/boot_tmp && sudo mount -o loop,rw,sync $(PRODUCT_OUT)/boot_fat.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/Image $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/hi6220-hikey.dtb $(PRODUCT_OUT)/boot_tmp/lcb.dtb
	sudo cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(REALTOP)/device/linaro/hikey/cmdline $(PRODUCT_OUT)/boot_tmp/cmdline
	sync
	sudo umount -f $(PRODUCT_OUT)/boot_tmp
	FASTBOOT_EFI_BUILD_NUMBER=`wget -q --no-check-certificate -O - https://ci.linaro.org/job/96boards-hikey-uefi/lastSuccessfulBuild/buildNumber`
	FASTBOOT_EFI_URL="http://builds.96boards.org/snapshots/hikey/linaro/uefi/${FASTBOOT_EFI_BUILD_NUMBER}/AndroidFastbootApp.efi"
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.uefi.img bs=512 count=98304
	sudo mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.uefi.img
	mkdir -p $(PRODUCT_OUT)/boot_tmp && sudo mount -o loop,rw,sync $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/Image $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/hi6220-hikey.dtb $(PRODUCT_OUT)/boot_tmp/hi6220-hikey.dtb
	sudo cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot_tmp/
	sync
	sudo umount -f $(PRODUCT_OUT)/boot_tmp


droidcore: boot_fatimage
