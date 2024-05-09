# Learning RISC-V Assembly on Qemu By Building Snake

I created this project to learn how to setup a simulated embedded program in riscv running on qemu. I wanted to write assembly code at a "bare metal" level to learn a little bit about how code runs directly on a computer system.

This project is simply for learning, and so I chose to implement a clone of the classic snake game.

## Repository Organization
This project is organized into sub-directories that show each stage of my development of the snake game. Every folder is created as a copy of the one preceding it, and then added to until I was able to introduce a new feature. I chose to structure the repository this way because I wanted the repository to show how I incrementally built the game up one bit of functionality at a time.

See the README.md in each of the sub-directories for information about what the software in that directory does.

## What is a virtual RISC-V Qemu board? 
**To start: what is RISC-V?**

RISC-V (commonly pronounced as "risc five") is an open source instruction set architecture for CPUs. This means that processors which implement the RISC-V ISA can all run the same binary programs. The ISA is designed to be simple and modular, itss specification is all open source, and it is very well supported in Qemu. All of these qualities make which makes it the perfect architecture to target for when learning assembly programming.

**Ok... and what is a virtual Qemu board?**

QEMU (possibly pronounce "queue-emu" or "keh-moo") is a tool that lets us emulate a complete computer system, like a RISC-V board, right on your desktop! This means you can write and test assembly programs in a simulated environment without needing real hardware. It's ideal for exploring and debugging.

## FAQS
<details>
<summary>What are the dependencies for running the project and how do I install them?</summary>
For instructions on installing the dependencies see the [macOS setup instructions](MAC-OS-SETUP.md) or the [debian/ubuntu setup instructions](DEBIAN-UBUNTU-SETUP.md). 

If you come accross this project and know how to set this up for other platforms, please open a PR! I specifically would love to add instructions for Windows and Arch Linux.
</details>

<details>
<summary>How do I run the assembly programs in this project?</summary>
Once you have the dependencies below installed you can `cd` into any of the numbered sub directories in this project and use the makefile to build and run the project. The following make commands will work in each sub directory

```bash
# begin by changing directory into any of this projects numbered sub directories.

# To build and run the program:
make run

# Running the program with a debugger:
make run-debug     # run this in a terminal to start up qemu then
make debugger      # run this in a sperate terminal to start the debugger

# Running the program with the qemu monitor:
make run-monitor   # run this in a terminal to start up qemu then
make monitor       # run this in a sperate terminal to start the qemu monitor


# Running the program with both the qemu monitor and the debugger:
make run-debug-monitor    # run this in a terminal and then
make debugger             # run this in a sperate terminal
make monitor              # and run this in yet another terminal
```
</details>