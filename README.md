# NelaOS
simple real mode x86 assembly kernel (os?) in bootsector

make:
nasm kernel.asm -o kernel.bin

run (qemu):
qemu-system-x86_64 kernel.bin
