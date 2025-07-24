# 包含 Kconfig 生成的配置
-include .config

OUTDIR := output
INSTALL_DIR := $(OUTDIR)/rootfs
LOADER_DIR := loader
LOADER_BIN := $(LOADER_DIR)/loader.bin
UBOOT_DIR := uboot
UBOOT_BIN := $(UBOOT_DIR)/u-boot.bin
KERNEL_DIR := kernel
KERNEL_BIN := $(KERNEL_DIR)/arch/arm64/boot/Image
ROOTFS_DIR := rootfs
ROOTFS_BIN := $(ROOTFS_DIR)/initramfs.cpio.gz
BUSYBOX_DIR := $(ROOTFS_DIR)/busybox

UBOOT_DEFCONFIG := qemu_arm64_defconfig
KERNEL_DEFCONFIG := my_defconfig
BUSYBOX_DEFCONFIG := my_defconfig

PHONY += all help env loader uboot kernel rootfs pack clean

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

# define get_lastest_time	
# `find $1 -type f -printf "%T@\n" | sort -nr | head -n1`
# endef
# define save_lastest_time	
# `cat .$1_lastest_time 2> /dev/null || echo 0`
# endef
# define uppercase
# $(shell echo $(1) | tr 'a-z' 'A-Z')
# endef

# loader:
# 	@if [ $(call get_lastest_time,$(LOADER_DIR)) \
# 			= $(call save_lastest_time,$@) ]; then \
# 		echo 无需构建 $@; \
# 	else \
# 		echo 开始构建 $@ && \
# 		make -C $(LOADER_DIR) -j$(shell nproc) && \
# 		mkdir -p $(OUTDIR) && \
# 		cp $(LOADER_BIN) $(OUTDIR) && \
# 		echo $(call get_lastest_time,$(LOADER_DIR)) > .$@_lastest_time; \
# 	fi

# uboot:
# 	@if [ $(call get_lastest_time,$(UBOOT_DIR)) \
# 			= $(call save_lastest_time,$@) ]; then \
# 		echo 无需构建 $@; \
# 	else \
# 		echo 开始构建 $@ && \
# 		make -C $(UBOOT_DIR) $(UBOOT_DEFCONFIG) && \
# 		make -C $(UBOOT_DIR) -j$(shell nproc) && \
# 		mkdir -p $(OUTDIR) && \
# 		cp $(UBOOT_BIN) $(OUTDIR) && \
# 		echo $(call get_lastest_time,$(UBOOT_DIR)) > .$@_lastest_time; \
# 	fi

# kernel:
# 	@if [ $(call get_lastest_time,$(KERNEL_DIR)) \
# 			= $(call save_lastest_time,$@) ]; then \
# 		echo 无需构建 $@; \
# 	else \
# 		echo 开始构建 $@ && \
# 		make -C $(KERNEL_DIR) $(KERNEL_DEFCONFIG) && \
# 		make -C $(KERNEL_DIR) -j$(shell nproc) && \
# 		mkdir -p $(OUTDIR) && \
# 		cp $(KERNEL_BIN) $(OUTDIR) && \
# 		echo $(call get_lastest_time,$(KERNEL_DIR)) > .$@_lastest_time; \
# 	fi

# rootfs:
# 	@if [ $(call get_lastest_time,$(ROOTFS_DIR)) \
# 			= $(call save_lastest_time,$@) ]; then \
# 		echo 无需构建 $@; \
# 	else \
# 		echo 开始构建 $@ && \
# 		make -C $(BUSYBOX_DIR) $(BUSYBOX_DEFCONFIG) && \
# 		make -C $(BUSYBOX_DIR) -j$(shell nproc) && \
# 		make -C $(BUSYBOX_DIR) install && \
# 		mkdir -p $(OUTDIR) && \
# 		cp -r $(ROOTFS_DIR)/root/. $(OUTDIR)/rootfs && \
# 		bash -c 'mkdir -p $(OUTDIR)/rootfs/{proc,sys,dev,tmp}' && \
# 		cd $(OUTDIR)/rootfs && \
# 		find . | cpio --quiet -o -H newc  > ../initramfs.cpio && \
# 		cd - > /dev/null && \
# 		echo $(call get_lastest_time,$(ROOTFS_DIR)) > .$@_lastest_time; \
# 	fi

define start
@echo "\033[44m开始构建 $@\033[0m"
@echo -n "$$(date +'%s')" > /tmp/starttime
endef

define end
@cost=$$(($$(date +'%s') - $$(cat /tmp/starttime)));\
echo "\033[42m$@ 构建完成，耗时 $$cost s\033[0m"
endef

loader:
	$(call start)
	make -C $(LOADER_DIR) -j$(shell nproc)
	mkdir -p $(OUTDIR)
	cp $(LOADER_BIN) $(OUTDIR)
	$(call end)

uboot:
	$(call start)
	make -C $(UBOOT_DIR) $(UBOOT_DEFCONFIG)
	make -C $(UBOOT_DIR) -j$(shell nproc)
	mkdir -p $(OUTDIR)
	cp $(UBOOT_BIN) $(OUTDIR)
	$(call end)

kernel:
	$(call start)
	make -C $(KERNEL_DIR) $(KERNEL_DEFCONFIG)
	make -C $(KERNEL_DIR) -j$(shell nproc)
	mkdir -p $(OUTDIR)
	cp $(KERNEL_BIN) $(OUTDIR)
	$(call end)

rootfs:
	$(call start)
	make -C $(BUSYBOX_DIR) $(BUSYBOX_DEFCONFIG)
	make -C $(BUSYBOX_DIR) -j$(shell nproc)
	make -C $(BUSYBOX_DIR) install
	mkdir -p $(OUTDIR)
	cp -r $(ROOTFS_DIR)/root/. $(OUTDIR)/rootfs
	bash -c 'mkdir -p $(OUTDIR)/rootfs/{proc,sys,dev,tmp}'
	cd $(OUTDIR)/rootfs && find . | cpio --quiet -o -H newc  > ../initramfs.cpio
	$(call end)

pack:
	@echo "\033[44m开始打包 $@\033[0m"

clean:
	@echo "\033[44m执行清理 $@\033[0m"
	make -C $(UBOOT_DIR) clean
	make -C $(KERNEL_DIR) clean
	make -C $(BUSYBOX_DIR) clean
	rm -rf $(OUTDIR) defconfig

run:
# 按ctrl+a 再按x 退出qemu
	@qemu-system-aarch64 \
		-machine virt \
		-cpu cortex-a57 \
		-nographic \
		-kernel output/Image \
		-append "console=ttyAMA0 rdinit=linuxrc" \
		-initrd output/initramfs.cpio


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
