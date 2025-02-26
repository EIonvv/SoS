ASM=nasm

SRC_DIR=src
BUILD_DIR=build

.PHONY: ALL floppy_image kernel bootloader clean always

#
# Floppy image
#
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel 
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880  # Create a 1.44MB floppy image
	mkfs.fat -F 12 -n "Vbuntu" $(BUILD_DIR)/main_floppy.img  # Format the floppy image with FAT32
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc  # Write the bootloader to the floppy image
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"  # Copy the kernel to the floppy image

#
# Bootloader
#
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

#
# Kernel
#
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/kernel.asm -f bin -o $(BUILD_DIR)/kernel.bin

#
# Always 
#
always:
	mkdir -p $(BUILD_DIR)

#
# Clean
#
clean:
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)
 
$(BUILD_DIR)/main.bin: bootloader kernel
	mkdir -p $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880  # Create a 1.44MB floppy image
	dd if=$(BUILD_DIR)/main.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc  # Write the binary to the floppy image
	genisoimage -o boot.iso -b $(BUILD_DIR)/main_floppy.img -no-emul-boot -boot-load-size 4 -boot-info-table .