# Learning RISC-V Assembly on Qemu
This repository tracks my work learning how to riscv systems work and learning how to write assembly for them! Each sub directory is a fully contained project that represents some step in the learning process. Each sub-directory builds on the last in some meaningful way. Some extend the functionality of the assembly code and program while other sub-directories refactor and improve the project structure without changing much functionality.

See the README.md in each of the sub-directories for information about what the software in that directory does.

## Running the programs
Once you have the dependencies below installed you can `cd` into any of the numbered sub directories in this project and use the makefile to build and run the project. The following make commands will work in each sub directory

```bash
# Simply running the program:
# to build the program and run it with qemu use the following make invocation

make run

# Running the program with a debugger:
# To build the program and run it in a mode that can be attached to a debugger run
# the following two commands in seperate terminals

make run-debug     # run this in on terminal and then,
make debugger      # run this in a sperate terminal

# Running the program with the qemu monitor in another terminal:
# To build the program and run it in a mode that allows another terminal to attach
# to qemu's system monitor, run the following two commands in seperate terminals

make run-monitor   # run this in on terminal and then,
make monito        # run this in a sperate terminal

# And finally, to run the program in such a way that allows both the monitor
# and the debugger to be attached at the same time, run the following three
# commands in three seperate terminals

make run-debug-monitor    # run this in on terminal and then,
make debugger             # run this in a sperate terminal
make monitor              # and run this in yet another sperate terminal
```

## Dependencies
This project depends on a few executables
- *A riscv64 qemu build*: A build of qemu that simulates riscv boards.
- *the riscv64 gnu tools*: We rely on a handful of gnu tools (as & ld) to build our riscv programs, we need an install of that software that understands the riscv architecture.
- *A riscv64 compatible gdb*: We will use gdb to debug our programs, and so we will need a build of gdb that can process riscv code running in qemu.
- *socat*: A tool for easily connecting data sources like sockets, files, and pipes. We use it as a way to connect to the qemu monitor.

For instructions on installing the dependencies see the [macOS setup instructions](MAC-OS-SETUP.md) or the [debian/ubuntu setup instructions](DEBIAN-UBUNTU-SETUP.md). 
