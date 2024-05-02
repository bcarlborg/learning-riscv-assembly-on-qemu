#####################################################################
# .gdbinit files contain a list of commands that are run when gdb 
# starts up. When you run gdb within this directory it is as if you
# typed these commands into your 
#####################################################################
set architecture riscv:rv64
target remote 127.0.0.1:1234
file main_executable.elf

# beau's personal preference for this project
tui enable
layout next