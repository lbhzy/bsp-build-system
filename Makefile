# 包含 Kconfig 生成的配置
-include .config

OUTDIR := output/
LOADER_DIR := loader
LOADER_BIN := $(LOADER_DIR)/loader.bin
UBOOT_DIR := uboot
UBOOT_BIN := $(UBOOT_DIR)/u-boot.bin
KERNEL_DIR := kernel
KERNEL_BIN := $(KERNEL_DIR)/zImage.bin
ROOTFS_DIR := rootfs
ROOTFS_BIN := $(ROOTFS_DIR)/initramfs.cpio.gz

PHONY += all help loader uboot kernel rootfs pack clean

all: loader uboot kernel rootfs pack

help:
	@echo  'BSP 构建框架 v0.0.1'
	@echo  ''
	@echo  '可用目标:'
	@echo  '  all               - 默认目标，一键编译并打包'
	@echo  '  help              - 显示此帮助信息'
	@echo  '  pack              - 打包镜像生成固件'
	@echo  ''
	@echo  '编译目标:'
	@echo  '  loader            - 编译 Loader'
	@echo  '  kernel            - 编译 Linux Kernel'
	@echo  '  uboot             - 编译 U-Boot'
	@echo  '  rootfs            - 编译根文件系统'
	@echo  ''
	@echo  '配置目标:'
	@echo  '  defconfig             - 通过默认配置文件生成 .config 文件'
	@echo  '  {board}_defconfig     - 通过默认配置文件生成 .config 文件'
	@echo  '  menuconfig            - 通过mconf图形菜单生成或修改 .config'
	@echo  '  nconfig               - 通过nconf图形菜单生成或修改 .config'
	@echo  '  savedefconfig         - 更新 .config 的最小化配置到 defconfig'
	@echo  ''
	@echo  '清理目标:'
	@echo  '  clean             - 清理编译产物'

loader:
	@echo 构建loader
	@make -C $(LOADER_DIR)
	@cp $(LOADER_BIN) $(OUTDIR)

uboot:
	@echo 构建uboot

kernel:
	@echo 构建kernel

rootfs:
	@echo 构建rootfs

pack:
	@echo 开始打包

clean:
	@echo 执行清理


#
# Kconfig/menuconfig 支持
#
KCONFIG := Config.in

PHONY += menuconfig nconfig defconfig savedefconfig

menuconfig:
	kconfig-mconf $(KCONFIG)

nconfig:
	kconfig-nconf $(KCONFIG)

%_defconfig:
	kconfig-conf --defconfig=configs/$@ $(KCONFIG)

defconfig:
	kconfig-conf --defconfig=configs/$@ $(KCONFIG)

savedefconfig:
	kconfig-conf --$@=defconfig $(KCONFIG)


.PHONY: $(PHONY)
