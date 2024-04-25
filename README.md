# Learning RISC-V Assembly on Qemu
Welcome to my repository of assembly programs designed for an emulated RISC-V computer!

This project is organized into sub-directories, each representing a different stage of my journey learning assembly programming for a virtual RISC-V system. Every folder is a complete project in itself, building upon the last by introducing new features or enhancing the structure and efficiency of the code. Dive into each one to see the progression of functionality and improvements!

Feel free to explore and get inspired as you see assembly programming in action!
See the README.md in each of the sub-directories for information about what the software in that directory does.

## What is a qemu virtual riscv board?
*What is RISC-V Assembly?*

RISC-V is a type of assembly language for processors that follow the open RISC-V instruction set architecture. It's designed to be simple and modular, perfect for learning how CPUs interpret commands. Learn more about RISC-V.

*What is a Virtualized QEMU Board?*
QEMU is a tool that lets us emulate a complete computer system, like a RISC-V board, right on your desktop! This means you can write and test assembly programs in a simulated environment without needing real hardware. It's ideal for exploring and debugging. Explore QEMU.

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
