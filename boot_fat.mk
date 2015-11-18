
REALTOP=$(realpath $(TOP))
FASTBOOT_EFI_BUILD_NUMBER := `wget -q --no-check-certificate -O - https://ci.linaro.org/job/96boards-hikey-uefi/lastSuccessfulBuild/buildNumber`
FASTBOOT_EFI_URL := "http://builds.96boards.org/snapshots/hikey/linaro/uefi/${FASTBOOT_EFI_BUILD_NUMBER}/AndroidFastbootApp.efi"
GRUB_EFI_URL := "http://builds.96boards.org/snapshots/hikey/linaro/grub/latest"
HISI_BOOT_COMPAT_DTB := "http://builds.96boards.org/releases/hikey/linaro/debian/15.06/hi6220-hikey.dtb"

boot_fatimage: bootimage all_dtbs
	mkdir -p $(PRODUCT_OUT)/EFI/BOOT/
	echo ${FASTBOOT_EFI_URL}
	wget --progress=dot ${FASTBOOT_EFI_URL} -O $(PRODUCT_OUT)/fastboot.efi
	wget --progress=dot ${GRUB_EFI_URL}/grubaa64.efi -O $(PRODUCT_OUT)/grubaa64.efi
	cp device/linaro/hikey/grub.cfg  $(PRODUCT_OUT)/EFI/BOOT/
	cp $(PRODUCT_OUT)/grubaa64.efi  $(PRODUCT_OUT)/EFI/BOOT/
	cp $(PRODUCT_OUT)/fastboot.efi  $(PRODUCT_OUT)/EFI/BOOT/
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.uefi.img bs=512 count=98304
	mkfs.fat -n "boot" $(PRODUCT_OUT)/boot_fat.uefi.img
	mcopy -i  $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/Image ::Image
	mcopy -i  $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/hi6220-hikey.dtb ::hi6220-hikey.dtb
	mcopy -i $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/ramdisk.img ::ramdisk.img
	mcopy -s -i $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/EFI/ ::

droidcore: boot_fatimage
