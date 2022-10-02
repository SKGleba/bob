PREFIX=mep-elf-
CC=$(PREFIX)gcc
CFLAGS=-fno-delete-null-pointer-checks -nostdlib -fno-optimize-sibling-calls -Os -std=gnu99 -Wall -Wextra -fno-inline -fstrict-volatile-bitfields
LD=$(PREFIX)gcc
LDFLAGS=-Wl,-T linker.x -nodefaultlibs -nostdlib -nostartfiles
OBJCOPY=$(PREFIX)objcopy
OBJCOPYFLAGS=

SRCS=$(wildcard source/*.c)
OBJ=$(SRCS:.c=.o) source/ex.ao source/vector.ao

all: output/bob.bin

%.o: %.c
	$(CC) -S -o $@.asm $< $(CFLAGS)
	$(CC) -c -o $@ $< $(CFLAGS)

%.ao: %.s
	$(CC) -c -o $@ $< $(CFLAGS)

bob.elf: $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@
	
output/bob.bin: bob.bin
	-rm source/*.o
	-rm source/*.ao
	-rm -rf output
	mkdir output
	mkdir output/asm
	mv source/*.asm output/asm/
	echo static const > output/bob.bin.h
	xxd -i $< >> output/bob.bin.h
	readelf -sW bob.elf | awk '{if ($$5 == "GLOBAL" && ($$4 == "FUNC" || $$4 == "OBJECT")) printf("#define bob_%s_addr 0x%s\n", $$8, $$2)}' > output/bob_exports.h
	mv bob.elf output/bob.elf
	mv bob.bin output/bob.bin

clean:
	-rm source/*.o
	-rm source/*.ao
	-rm source/*.asm
	-rm -rf output