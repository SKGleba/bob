PSP2REF_DIR=../../psp2ref
BOBIHDR_DIR=../../source/include

XM_LOAD_ADR=0x0004a000
XM_MAX_SIZE=65536

PREFIX=mep-elf-
CC=$(PREFIX)gcc
LD=$(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy

ADDEFS=-I$(PSP2REF_DIR) -I$(BOBIHDR_DIR)
CFLAGS=-ml -Os -std=gnu99 -nostdlib -fno-builtin -fno-inline -fno-strict-aliasing -Wall -Wno-volatile-register-var
LDFLAGS=-Wl,-T linker.x -nodefaultlibs -nostdlib -nostartfiles -Wl,-Map=xm.map

SRCS=$(wildcard source/*.c)
ASMS=$(wildcard source/*.s)
OBJ=$(SRCS:.c=.o) $(ASMS:.s=.ao)

all: output/xm.bin

%.o: %.c
	@echo "\033[0;35mMidASM:\033[0;33m $< -> $<.asm\033[0m"
	@$(CC) -S -o $@.asm $< $(CFLAGS) $(ADDEFS)
	@echo "\033[0;35mCompile:\033[0;33m $< -> $@\033[0m"
	@$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

%.ao: %.s
	@echo "\033[0;35mAssemble:\033[0;33m $< -> $@\033[0m"
	@$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

xm.elf: $(OBJ)
	@echo "\033[0;35mLink:\033[0;33m $^ -> $@\033[0m"
	@$(LD) -o $@ $^ $(LDFLAGS)

%.bin: %.elf
	@echo "\033[0;35mStrip:\033[0;33m $< -> $@\033[0m"
	@$(OBJCOPY) -O binary $< $@

output/xm.bin: xm.bin
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
	@echo " | create xm binary include"
	@echo static const > output/xm.bin.h
	@xxd -i $< >> output/xm.bin.h
	@echo " | create xm exports header"
	@readelf -sW xm.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("#define xm_%s_addr 0x%s\n", $$8, $$2)}' > output/xm_exports.h
	@echo " | create xm import assembly"
	@readelf -sW xm.elf | awk '{if ($$5 == "GLOBAL" && $$4 == "FUNC") printf(".global %s\n%s:\njmp 0x%s\n\n", $$8, $$8, $$2)}' > output/xm_import.s
	@echo " | create xm linker"
	@echo ".xm_linker : {" > output/xm_linker.x && readelf -sW xm.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("\t%s = 0x%s;\n", $$8, $$2)}' >> output/xm_linker.x && echo "}" >> output/xm_linker.x
	@echo " | xm (main) -> output"
	@mv xm.elf output/xm.elf
	@mv xm.bin output/xm.bin
	@mv xm.map output/xm.map
	@echo " | ensure xm fits (XM_MAX_SIZE: $(XM_MAX_SIZE))"
	@if [ $$(stat -c %s output/xm.bin) -gt $(XM_MAX_SIZE) ]; then echo "\033[0;31m\nERROR: xm.bin is too large\033[0m"; exit 1; fi
	@echo "  \-> \033[0;32mall done\n\033[0m"

clean:
	-rm source/*.o
	-rm source/*.ao
	-rm source/*.asm
	-rm -rf output