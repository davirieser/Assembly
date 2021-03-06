
# ---------------------------------------------------------------------------- #

ASSEMBLER=nasm
ASM_LINKER=ld

CFLAGS=-std=c11 -Wall -Wextra -Werror -O -g -fsanitize=leak
ASM_FLAGS=

SYSCALL_FILE=/usr/include/asm/unistd_64.h
VIEWER=less

ASM_INCLUDES=$(foreach file,$(wildcard include/*.asm), --include $(file))

# Disable Implicit Rules
.SUFFIXES:

# ---------------------------------------------------------------------------- #

all:
	@ $(MAKE) -s $(patsubst %.asm,%,$(wildcard *.asm) $(wildcard **/**.asm))

sys: ## Display Syscalls
	@ $(VIEWER) $(SYSCALL_FILE)

# ---------------------------------------------------------------------------- #

%.asm.o: %.asm
	@ echo "Running NASM: $^"
	@ $(ASSEMBLER) -f elf64 -Wall -gdwarf $(ASM_INCLUDES) -o $@ $^

%.c.o: %.c
	@ echo "Running GCC: $^"
	@ $(CC) -g -c -o $@ $^

%.lst: %.asm
	@ echo "Creating Listing File: $^"
	@ $(ASSEMBLER) -f elf64 -l $@ $^

# ---------------------------------------------------------------------------- #

%: ## Helper Rule => Calls Payload (.exe) Rule
	@ $(MAKE) -s $*/$*.exe

%.exe: 
	@ ## Actual Payload Rule => Links Executable from ASM and C Code
	@ ## Has to end with .exe because otherwise it would be recursive
	@ $(MAKE) -s $(patsubst %.asm,%.asm.o,$(wildcard $*.asm)) \
				$(patsubst %.c,%.c.o, $(wildcard $*.c))
	@ echo "Linking Executable: $* from $(patsubst %.asm, %.asm.o,\
		$(patsubst %.asm,%.asm.o,$(wildcard $*.asm)) \
		$(patsubst %.c,%.c.o, $(wildcard $*.c)) \
	)"
	@ $(CC) -g -no-pie $(patsubst %.asm, %.asm.o,\
		$(patsubst %.asm,%.asm.o,$(wildcard $*.asm)) \
		$(patsubst %.c,%.c.o, $(wildcard $*.c)) \
	) -o $*
	@ echo "Running Executable: $*"
	@ echo
	@ ./$*
	@ echo

# ---------------------------------------------------------------------------- #

Makefile:;
%.asm:;

# ---------------------------------------------------------------------------- #
