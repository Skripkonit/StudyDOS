asm_src = $(shell find src/x86_64/*.asm)
asm_obj = $(patsubst src/x86_64/%.asm, build/x86_64/%.o, $(asm_src))

$(asm_obj): build/x86_64/%.o : src/x86_64/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 $(patsubst build/x86_64/%.o, src/x86_64/%.asm, $@) -o $@

.PHONY: build-x86_64
build-x86_64: $(asm_obj)
	mkdir -p dist/x86_64/
	ld -n $(asm_obj) -T target/x86_64/linker.ld -o dist/x86_64/studos.bin
	cp dist/x86_64/studos.bin target/x86_64/iso/boot/studos.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/studos.iso target/x86_64/iso