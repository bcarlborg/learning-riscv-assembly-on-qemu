# *******************************************************************
# MAKEFILE
#
# This is a makefile. When you run the command `make` in this directory,
# the make program will read this file to figure out what to do.
# In general make is used to specify how to take all of the sourcefiles
# for a program and create an executable from those files
#
# The most important content in a makefile are the rules. The rules
# tell make how build something. Rules are composed of a target, depedencies
# and a recipe as follows:
#
# target: dependencies
#    recipe
#
# if you simply run `make` in this directory with no arguments. make will
# run the first rule in this file. The first rule is called the default rule
#
# if you want make to execute a specific rule, you can run it by its target name
# like so: `make target`. For example `make all` or `make clean` or `make source1.o`
# *******************************************************************

###########################################################################
# FILE NAME CONSTANTS
###########################################################################

# List of assembly source files that will be assembled
# any source file in this list will be assembled and linked
# into the executable
SOURCES = entry.s start.s uart.s memlayout.s

# List of object files based on source file inputs
# these will all be linked into the final output executable
OBJECTS = $(SOURCES:.s=.o)

# The executable program that we will load and run with qemu
EXECUTABLE = main_executable.elf

# Linker script -- tells us how to combine all of our object
# files into one executable
LINKER_SCRIPT = linker.ld

###########################################################################
# TOOL CONSTANTS
#   any sort of executable that we use to build or
#   run our program
###########################################################################

# Different platforms have slightly different names for the gnu tools executables.
# On a debian based system, the riscv64 gnu tools are all prefixed with `riscv64-linux-gnu-`
# whereas on macos, they are prefixed with `risc64-unknown-elf-`.
#
# We need a function that will check which prefix works on this system.  This function
# does the following
# - it takes a gnu toolchain prefix to test as its first argument
# - it then attempts to run objdump -i with that prefix ($1-objdump -i)
#   - running objdump with -i will output all the object types this executable supports
#   - we use 2>&1 to pipe the stderr to stdout and we pass stdout along to a pipe
# - then we check to to see if 'elf64-big' is in the output, if it is, then we know that
#   the executable we tested will work!
#   - because we don't want the ouput of this command pollutin our makefile output
#     we also pipe stdout to /dev/null and then pipe stderr to stdout
# - if the grep command succeeds, then we echo the prefix
define test_riscv64_gnu_toolchain_prefix
$(shell if $1objdump -i 2>&1 | grep 'elf64-big' > /dev/null 2>&1; then echo "$1"; fi)
endef

# Now that we have a helper to test different prefixes, lets test all the prefixes
# that we know about to see which one will work
# - macos uses prefix risc64-unknown-elf
# - debian based systems use prefix risc64-linux-gnu
# - arch based systems use prefix risc64-unknown-linux-gnu (...I think)
# - if no prefix works, then the gnu tools are not installed
RISC64_GNU_TOOL_PREFIX := $(or \
	$(call test_riscv64_gnu_toolchain_prefix,riscv64-unknown-elf-), \
	$(call test_riscv64_gnu_toolchain_prefix,riscv64-linux-gnu-), \
	$(call test_riscv64_gnu_toolchain_prefix,riscv64-unknown-linux-gnu-), \
	$(error *** ERROR: Couldn't find a riscv64 version of the GCC/binutils.) \
)

$(echo "bcarlborg testy testy")

# Assembler that will generate valid riscv64 bytecode
AS = $(RISC64_GNU_TOOL_PREFIX)as

# Linker for riscv64 elf files
LD = $(RISC64_GNU_TOOL_PREFIX)ld

# Qemu is what we use to emulate a riscv computer
# (thankfully, this executable seems to use the same name on every system)
QEMU = qemu-system-riscv64

# Initialize a QEMU_FLAGS variable. We'll append to it below and explain
# what we are doing along the way
QEMU_FLAGS =

# The -machine option allows us to specify the board that qemu will
# run. The 'virt' board is a generic RISC-V machine.
# virt is simply a made up riscv board... invented by the qemu folks!
# The virt board has a cpu, ram, devices all wired together according to the
# virt design. TODO: explain this better
QEMU_FLAGS += -machine virt

# the -bios flag allows us to specify a bios or boot loader that we wnat to
# use to get our system started. Because we are loading our executable with
# the -kernel option, a bios only gets in the way
QEMU_FLAGS += -bios none

# -nographic disables graphical output enabling the project to run in a
# terminal.
# TODO: explain how this arugment also has the impact of determining
# where the stdin comes from and where the qemy monitor goes to
QEMU_FLAGS += -nographic


# Initialize a QEMU_DEBUG_FLAGS variable. These flags are an extension
# of what we already have in QEMU_FLAGS.
QEMU_DEBUG_FLAGS = $(QEMU_FLAGS)

# -s will start a gdb server for us to debug with on tcp port localhost:1234
# ths is a shorthand option for the option `-gdb tcp::1234`
QEMU_DEBUG_FLAGS  += -s

# -S starts qemu in a debugging mode. So qemu will be paused until it is started
# by the debugger
QEMU_DEBUG_FLAGS  += -S

###########################################################################
# BUILD RULES
#   These recipes build new files from our sources
###########################################################################

# running `make all` will build our main executable in the current directory
# note: the first rule in a makefile creates the "default target" for make.
# This means that this recipe is what is run when you simply run `make` no arguments
# and this recipe is also what is run when you execute `make all`
all: $(EXECUTABLE)

# Rule to assemble each source file to an object file. This kind of rule is called
# a pattern rule because its target and dependencies can match many different
# values. In our case, this rule creates a file.o for any file.s
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# Rule to link all object files into the executable
$(EXECUTABLE): $(OBJECTS) $(LINKER_SCRIPT)
	$(LD) -T $(LINKER_SCRIPT) $(OBJECTS) -o $@

###########################################################################
# RUN RULES
#   These recipes that we run because they perform some useful side-effect
#   like running our program, cleaning up the directory, etc
#   In make terminology, these are called phony rules
###########################################################################

# Rule to run the executable with QEMU
# The -kernel option will load our elf file executable directly 
# into DRAM on the virtual riscv board and start execution there
run: $(EXECUTABLE)
	$(QEMU) $(QEMU_FLAGS) -kernel $(EXECUTABLE)

# Rule for running the executable with QEMU in a mode that is compatible
# with attaching a debugger to inspect our program
run-debug: $(EXECUTABLE)
	$(QEMU) $(QEMU_FLAGS) $(QEMU_DEBUG_FLAGS) -kernel $(EXECUTABLE)

# Rule to clean up generated files
clean:
	rm -f $(OBJECTS) $(EXECUTABLE)

# Mark our run targets as phony. Phony targets are targets that are run 
# for the side effects of their recipe rather than to build something
.PHONY: all clean run run-debug
