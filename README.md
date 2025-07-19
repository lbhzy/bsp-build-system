# 介绍
嵌入式BSP项目构建系统，使用`Makefile`+`Kconfig`实现，与`Busybox`、`Buildroot`、`Linux Kernel`、`OpenWRT`、`U-Boot`等主流项目构建方式保持一致

# 特性
- 设计灵活，方便适配不同SOC厂商`SDK`
- 图形化配置参数
- 符合人体工程学

# 依赖
``` shell
sudo apt update
sudo apt install kconfig-frontends  # Kconfig 支持
```

# 用法
``` shell
$ make help
BSP 构建框架 v0.0.1

可用目标:
  all               - 默认目标，一键编译并打包
  help              - 显示此帮助信息
  pack              - 打包镜像生成固件

编译目标:
  loader            - 编译 Loader
  kernel            - 编译 Linux Kernel
  uboot             - 编译 U-Boot
  rootfs            - 编译根文件系统

配置目标:
  defconfig             - 通过默认配置文件生成 .config 文件
  {board}_defconfig     - 通过默认配置文件生成 .config 文件
  menuconfig            - 通过mconf图形菜单生成或修改 .config
  nconfig               - 通过nconf图形菜单生成或修改 .config
  savedefconfig         - 更新 .config 的最小化配置到 defconfig

清理目标:
  clean             - 清理编译产物
```