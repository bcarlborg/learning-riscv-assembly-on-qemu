# 00: Setting up a build and run environment
The purpose of the software in this directory is to simply get qemu up and running code that we've written.

When you run the program contained in this directory with `make run`, you won't see anything happen in the terminal. That's expected! The program that I've written here simply spins in a loop of no-ops. If you want to see that for yourself, you can run `make run-debug` and `make debugger` to step through the execution and see that.

The "interesting" files to look at here are the makefile and the linker script. But ultimately, this project is more about learning assembly than it is about learning build systems... and this makefile might throw you too far into the deep-end.

To get to more interesting programs, continue on to `01`.
