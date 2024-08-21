ASM=nasm

SRC_DIR=src
BUILD_DIR=vm

$(BUILD_DIR)/main.bin: $(SRC_DIR)/boot.s
	$(ASM) $(SRC_DIR)/boot.s -f bin -o $(BUILD_DIR)/boot.bin
	qemu-system-x86_64 -hda $(BUILD_DIR)/boot.bin
