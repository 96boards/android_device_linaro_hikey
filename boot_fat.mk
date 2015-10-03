.PHONY: bootimage all_dtbs

REALTOP=$(realpath $(TOP))
FASTBOOT_EFI_BUILD_NUMBER := `wget -q --no-check-certificate -O - https://ci.linaro.org/job/96boards-hikey-uefi/lastSuccessfulBuild/buildNumber`
FASTBOOT_EFI_URL := "http://builds.96boards.org/snapshots/hikey/linaro/uefi/${FASTBOOT_EFI_BUILD_NUMBER}/AndroidFastbootApp.efi"
GRUB_EFI_URL := "http://builds.96boards.org/snapshots/hikey/linaro/grub/latest"
HISI_BOOT_COMPAT_DTB := "http://builds.96boards.org/releases/hikey/linaro/debian/15.06/hi6220-hikey.dtb"

boot_fatimage: bootimage all_dtbs
	mkdir -p $(PRODUCT_OUT)/boot_fat/
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.img bs=512 count=98304
	sudo mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.img
	mkdir -p $(PRODUCT_OUT)/boot_tmp && sudo mount -o loop,rw,sync $(PRODUCT_OUT)/boot_fat.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/Image $(PRODUCT_OUT)/boot_tmp
	sudo wget  --progress=dot ${HISI_BOOT_COMPAT_DTB} -O $(PRODUCT_OUT)/boot_tmp/lcb.dtb
	sudo cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(REALTOP)/device/linaro/hikey/cmdline $(PRODUCT_OUT)/boot_tmp/cmdline
	sync
	sudo umount -f $(PRODUCT_OUT)/boot_tmp
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.uefi.img bs=512 count=98304
	sudo mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.uefi.img
	mkdir -p $(PRODUCT_OUT)/boot_tmp && sudo mount -o loop,rw,sync $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/Image $(PRODUCT_OUT)/boot_tmp
	sudo cp $(PRODUCT_OUT)/obj/kernel/arch/arm64/boot/hi6220-hikey.dtb $(PRODUCT_OUT)/boot_tmp/hi6220-hikey.dtb
	echo ${FASTBOOT_EFI_URL}
	sudo wget --progress=dot ${FASTBOOT_EFI_URL} -O $(PRODUCT_OUT)/boot_tmp/fastboot.efi
	sudo cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot_tmp/
	sudo mkdir -p $(PRODUCT_OUT)/boot_tmp/grub/
	sudo wget --progress=dot ${GRUB_EFI_URL}/grubaa64.efi -O $(PRODUCT_OUT)/boot_tmp/grubaa64.efi
	sudo cp device/linaro/hikey/grub.cfg  $(PRODUCT_OUT)/boot_tmp/grub/
	sync
	sudo umount -f $(PRODUCT_OUT)/boot_tmp


droidcore: boot_fatimage
