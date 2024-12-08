PSP2REF_DIR=psp2ref

PREFIX=mep-elf-
CC=$(PREFIX)gcc
ADDEFS=-I$(PSP2REF_DIR)
CFLAGS=-ml -Os -std=gnu99 -nostdlib -fno-builtin -fno-inline -fno-strict-aliasing -Wall -Wno-volatile-register-var
LD=$(PREFIX)gcc
LDFLAGS=-Wl,-T linker.x -nodefaultlibs -nostdlib -nostartfiles
OBJCOPY=$(PREFIX)objcopy
OBJCOPYFLAGS=
BOB_MAX_SIZE=32768

SRCS=$(wildcard source/*.c)
OBJ=$(SRCS:.c=.o) source/ex.ao source/vector.ao source/debug.ao source/util.ao
OBJ_GLITCH=$(SRCS:.c=.o) source/ex.ao source/glitch_vector.ao source/debug.ao source/util.ao

all: output/bob.bin

%.o: %.c
	@echo "\033[0;35mMidASM:\033[0;33m $< -> $<.asm\033[0m"
	@$(CC) -S -o $@.asm $< $(CFLAGS) $(ADDEFS)
	@echo "\033[0;35mCompile:\033[0;33m $< -> $@\033[0m"
	@$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

%.ao: %.s
	@echo "\033[0;35mAssemble:\033[0;33m $< -> $@\033[0m"
	@$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

bob.elf: $(OBJ)
	@echo "\033[0;35mLink:\033[0;33m $^ -> $@\033[0m"
	@$(LD) -o $@ $^ $(LDFLAGS)

bob_glitch.elf: $(OBJ_GLITCH)
	@echo "\033[0;35mLink (glitch):\033[0;33m $^ -> $@\033[0m"
	@$(LD) -o $@ $^ $(LDFLAGS)

%.bin: %.elf
	@echo "\033[0;35mStrip:\033[0;33m $< -> $@\033[0m"
	@$(OBJCOPY) -O binary $< $@
	
output/bob.bin: bob.bin bob_glitch.bin
	@echo "\033[0;35mPost-compilation:\033[0;33m"
	@echo " | clean source dir"
	@-rm source/*.o
	@-rm source/*.ao
	@-rm -rf output
	@echo " | create output tree"
	@mkdir output
	@mkdir output/asm
	@echo " | midway assembly -> output"
	@mv source/*.asm output/asm/
	@echo " | bob (glitch) -> output"
	@mv bob_glitch.elf output/bob_glitch.elf
	@mv bob_glitch.bin output/bob_glitch.bin
	@echo " | create bob binary include"
	@echo static const > output/bob.bin.h
	@xxd -i $< >> output/bob.bin.h
	@echo " | create bob exports header"
	@readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("#define bob_%s_addr 0x%s\n", $$8, $$2)}' > output/bob_exports.h
	@echo " | create bob import assembly"
	@readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && $$4 == "FUNC") printf(".global %s\n%s:\njmp 0x%s\n\n", $$8, $$8, $$2)}' > output/bob_import.s
	@echo " | create bob linker"
	@echo ".bob_linker : {" > output/bob_linker.x && readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("\t%s = 0x%s;\n", $$8, $$2)}' >> output/bob_linker.x && echo "}" >> output/bob_linker.x
# readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) print $$8}' | while IFS= read -r entry; do def=$$(grep -whR $$entry source/include/ | grep -v -e "#define" | grep -i ";" | sed 's/extern //'); [ -z "$$def" ] || echo "$${def%??} = (void *)bob_"$$entry"_addr;"; done > output/bob_imports.c
	@echo " | bob (main) -> output"
	@mv bob.elf output/bob.elf
	@mv bob.bin output/bob.bin
	@echo " | ensure bob fits (BOB_MAX_SIZE: $(BOB_MAX_SIZE))"
	@if [ $$(stat -c %s output/bob.bin) -gt $(BOB_MAX_SIZE) ]; then echo "\033[0;31m\nERROR: bob.bin is too large\033[0m"; exit 1; fi
	@if [ $$(stat -c %s output/bob_glitch.bin) -gt $(BOB_MAX_SIZE) ]; then echo "\033[0;31m\nERROR: bob_glitch.bin is too large\033[0m"; exit 1; fi
	@echo "  \-> \033[0;32mall done\n\033[0m"

clean:
	-rm source/*.o
	-rm source/*.ao
	-rm source/*.asm
	-rm -rf output