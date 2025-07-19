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

KCONFIG := Config.in
DEFCONFIG := .defconfig
SAVECONFIG := $(shell cat $(DEFCONFIG))


PHONY += all
all: loader uboot kernel rootfs pack

PHONY += help
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

PHONY += loader
loader:
	@echo 构建loader
	@make -C $(LOADER_DIR)
	@cp $(LOADER_BIN) $(OUTDIR)

PHONY += uboot
uboot:
	@echo 构建uboot

PHONY += kernel
kernel:
	@echo 构建kernel

PHONY += rootfs
rootfs:
	@echo 构建rootfs

PHONY += pack
pack:
	@echo 开始打包

PHONY += clean
clean:
	@echo 执行清理

# 检查命令函数
check-command = $(if $(shell command -v $(1) 2>/dev/null),,$(error 命令 '$1' 未找到，请先安装))

# 加载默认配置
define load_defconfig
	@if [ -f "$1" ]; then \
		kconfig-conf --defconfig="$1" $(KCONFIG) \
		&& echo "已加载默认配置 '$1'" \
		&& echo $1 > $(DEFCONFIG); \
	else \
		echo "默认配置 '$1' 不存在"; \
		exit 1; \
	fi
endef

#
# Kconfig/menuconfig 支持
#

# 依赖伪目标的目标相当于伪目标
PHONY += kconfig
kconfig:
	@$(call check-command, kconfig)

menuconfig: kconfig
	@kconfig-mconf $(KCONFIG)

nconfig: kconfig
	@kconfig-nconf $(KCONFIG)

%_defconfig: kconfig
	@$(call load_defconfig,configs/$@)		# 逗号后不要加空格！！！

defconfig: kconfig
	@$(call load_defconfig,configs/$@)

savedefconfig: kconfig $(DEFCONFIG)
	@if [ -f "$(SAVECONFIG)" ]; then \
		kconfig-conf --savedefconfig=$(SAVECONFIG) $(KCONFIG) \
		&& echo "已保存最小配置到 '$(SAVECONFIG)'"; \
	else \
		echo "默认配置 '$(SAVECONFIG)' 不存在"; \
		exit 1; \
	fi


.PHONY: $(PHONY)
