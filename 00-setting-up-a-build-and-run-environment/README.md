# 00: Setting up a build and run environment
The purpose of the software in this directory is to simply get qemu up and running some assembly code that we've written.

So, most of the code in the project at this point is in the Makefile and the linker script.

## The Makefile
The makefile drives our building and running of the code in this project. The makefile describes how to run the assembler and linker with the source files in this project. It describes how to invoke qemu with the appropraite arguments to configure it for our project. It describes how to run the debugger and how to start the qemu monitor.

## The linker script
The linker script describes how to structure the output binary that qemu runs for this project. It specifically instructs the linker which parts of memory the sections in our assembly files should be loaded into. This is essential so that our program is loaded into Qemu's RAM and to ensure that our entry function is loaded at the address that qemu jumps to when the program starts.

## What the code in this directory does
When you run the program contained in this directory with `make run`, you won't see anything happen in the terminal. That's expected! The program that I've written here simply spins in a loop of no-ops. If you want to see that for yourself, you can run `make run-debug` and `make debugger` to step through the execution and see that.

The "interesting" files to look at here are the makefile and the linker script. But ultimately, this project is more about learning assembly than it is about learning build systems... and this makefile might throw you too far into the deep-end.

To get to more interesting programs, continue on to `01`.
