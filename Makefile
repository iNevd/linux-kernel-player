build-14.04:
	docker build -t linux-kernel-player:14.04 -f Dockerfile.14.04 .

build-3.19:
	docker build -t linux-kernel-player:18.04 -f Dockerfile.18.04 .

build-22.04:
	docker build -t linux-kernel-player:22.04 -f Dockerfile.22.04 .

echo-cmd:
	# for x86 ttyS0
	# for arm ttyAMA0
	@echo "qemu-system-x86_64 -nographic -kernel ./arch/x86_64/boot/bzImage -append console=ttyS0"
	@echo "qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic -kernel ./arch/arm64/boot/Image.gz --append console=ttyAMA0"


run-2.6.39: build-14.04 echo-cmd
	docker run --rm -it --volume=${PWD}/linux-2.6.39:/code:rw docker.io/library/linux-kernel-player:14.04 bash

# kernel 3.19 支持 aarch-64
# linux-kernel-player:18.04 基于 ubuntu 18.04 ，其 qemu 支持 64bit arm 架构虚拟机
run-3.19: build echo-cmd
	docker run --rm -it --volume=${PWD}/linux-3.19:/code:rw docker.io/library/linux-kernel-player:18.04 bash


run-5.15.80: build-22.04 echo-cmd
	# docker run --rm -it --volume=${PWD}/linux-5.15.80:/code:rw docker.io/library/linux-kernel-player:22.04 bash
	docker run --rm -it --volume=${PWD}/linux-6.0.10:/code:rw docker.io/library/linux-kernel-player:22.04 bash

run: run-5.15.80
	@echo ""