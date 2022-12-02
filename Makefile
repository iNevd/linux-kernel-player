.PHONY: build echo-cmd

# ARCH 支持 aarch64 x86_64
ARCH := aarch64
# ContainerEngine 支持 docker podman
ContainerEngine := docker
# LinuxKernelDir 支持 linux-2.6.39 linux-3.19 linux-5.15.80 linux-6.0.10
LinuxKernelDir := linux-3.19
# UbuntuVersion 支持 14.04 16.04 18.04 22.04
UbuntuVersion := 18.04
# 14.04: linux-2.6.39
# 16.04: linux-3.19
# 18.04: linux-3.19
# 22.04: linux-5.15.80 linux-6.0.10

# 获取 LinuxKernelDir 绝对路径
LinuxKernelDir := $(shell realpath $(LinuxKernelDir))

CHECK_IMAGE := $(shell $(ContainerEngine) images -q linux-kernel-player:$(UbuntuVersion) 2>/dev/null)


build:
ifeq ($(CHECK_IMAGE), )
	$(ContainerEngine) build -t linux-kernel-player:$(UbuntuVersion) -f Dockerfile.$(UbuntuVersion) .
endif
	

echo-cmd:
	# make allnoconfig
	# make menuconfig
	# make -j 4
ifeq ($(ARCH), x86_64)
	# for x86 ttyS0
	# qemu-system-x86_64 -nographic -kernel ./arch/x86_64/boot/bzImage -append console=ttyS0
endif
ifeq ($(ARCH), aarch64)
	# for arm ttyAMA0
	# qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic -kernel ./arch/arm64/boot/Image.gz --append console=ttyAMA0
endif

run: build echo-cmd
	@echo "\nrun:$(ContainerEngine) with arch:$(ARCH)  ubuntu:$(UbuntuVersion) linux kernel:$(LinuxKernelDir)\n"
	$(ContainerEngine) run --rm -it --volume=$(LinuxKernelDir):/code:rw docker.io/library/linux-kernel-player:$(UbuntuVersion) bash
	
