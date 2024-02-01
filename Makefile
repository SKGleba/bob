PSP2REF_DIR=psp2ref

PREFIX=mep-elf-
CC=$(PREFIX)gcc
ADDEFS=-I$(PSP2REF_DIR)
CFLAGS=-ml -Os -std=gnu99 -nostdlib -fno-builtin -fno-inline -fno-strict-aliasing -Wall -Wno-volatile-register-var
LD=$(PREFIX)gcc
LDFLAGS=-Wl,-T linker.x -nodefaultlibs -nostdlib -nostartfiles
OBJCOPY=$(PREFIX)objcopy
OBJCOPYFLAGS=

SRCS=$(wildcard source/*.c)
OBJ=$(SRCS:.c=.o) source/ex.ao source/vector.ao source/debug.ao
OBJ_GLITCH=$(SRCS:.c=.o) source/ex.ao source/glitch_vector.ao source/debug.ao

all: output/bob.bin

%.o: %.c
	$(CC) -S -o $@.asm $< $(CFLAGS) $(ADDEFS)
	$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

%.ao: %.s
	$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

bob.elf: $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

bob_glitch.elf: $(OBJ_GLITCH)
	$(LD) -o $@ $^ $(LDFLAGS)

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@
	
output/bob.bin: bob.bin bob_glitch.bin
	-rm source/*.o
	-rm source/*.ao
	-rm -rf output
	mkdir output
	mkdir output/asm
	mv source/*.asm output/asm/
	mv bob_glitch.elf output/bob_glitch.elf
	mv bob_glitch.bin output/bob_glitch.bin
	echo static const > output/bob.bin.h
	xxd -i $< >> output/bob.bin.h
	readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("#define bob_%s_addr 0x%s\n", $$8, $$2)}' > output/bob_exports.h
	readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && $$4 == "FUNC") printf(".global %s\n%s:\njmp 0x%s\n\n", $$8, $$8, $$2)}' > output/bob_import.s
	echo ".bob_linker : {" > output/bob_linker.x && readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("\t%s = 0x%s;\n", $$8, $$2)}' >> output/bob_linker.x && echo "}" >> output/bob_linker.x
# readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) print $$8}' | while IFS= read -r entry; do def=$$(grep -whR $$entry source/include/ | grep -v -e "#define" | grep -i ";" | sed 's/extern //'); [ -z "$$def" ] || echo "$${def%??} = (void *)bob_"$$entry"_addr;"; done > output/bob_imports.c
	mv bob.elf output/bob.elf
	mv bob.bin output/bob.bin

clean:
	-rm source/*.o
	-rm source/*.ao
	-rm source/*.asm
	-rm -rf output