
# ---------------------------------------------------------------------------- #

ASSEMBLER=nasm
ASM_LINKER=ld

SYSCALL_FILE=/usr/include/asm/unistd_64.h
VIEWER=less

# ---------------------------------------------------------------------------- #

all:
	@ $(MAKE) -s $(patsubst %.asm,%,$(wildcard *.asm) $(wildcard **/**.asm))

sys: ## Display Syscalls
	@ $(VIEWER) $(SYSCALL_FILE)

# ---------------------------------------------------------------------------- #

%.o: %.asm
	@ echo "Running NASM: $^"
	@ $(ASSEMBLER) -f elf64 -g -F dwarf -o $@ $^

%.lst: %.asm
	@ echo "Creating Listing File: $^"
	@ $(ASSEMBLER) -f elf64 -l $@ $^

.o:
	@ echo "Linking Executable: $^"
	@ $(ASM_LINKER) -o $@ $^
	@ echo "Running Executable: $^"
	@ ./$@
	@ echo

# ---------------------------------------------------------------------------- #

Makefile:;
%.asm:;

# ---------------------------------------------------------------------------- #
