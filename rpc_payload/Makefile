PREFIX=mep-elf-
CC=$(PREFIX)gcc
ADDEFS=
CFLAGS=-fno-delete-null-pointer-checks -nostdlib -fno-optimize-sibling-calls -Os -std=gnu99 -fno-inline -fstrict-volatile-bitfields -fno-builtin
LD=$(PREFIX)gcc
LDFLAGS=-Wl,-T linker.x -nodefaultlibs -nostdlib -nostartfiles
OBJCOPY=$(PREFIX)objcopy
OBJCOPYFLAGS=

SRCS=$(wildcard *.c)
OBJ=$(SRCS:.c=.o) bob_import.ao

all: output/rpcp.bin

%.o: %.c
	$(CC) -S -o $@.asm $< $(CFLAGS) $(ADDEFS)
	$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

bob_import.ao: ../output/bob_import.s
	$(CC) -c -o $@ $< $(CFLAGS) $(ADDEFS)

rpcp.elf: $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@
	
output/rpcp.bin: rpcp.bin
	-rm *.ao
	-rm *.o
	-rm -rf output
	mkdir output
	mkdir output/asm
	mv *.asm output/asm/
	mv rpcp.elf output/rpcp.elf
	mv rpcp.bin output/rpcp.bin

clean:
	-rm *.ao
	-rm *.o
	-rm *.asm
	-rm -rf output