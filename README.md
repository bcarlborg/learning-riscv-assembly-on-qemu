# 🎮 Learning RISC-V Assembly By Building Snake
I created this project to learn how to write and configure an embedded RISC-V program running in Qemu. I wanted to write assembly code at a "bare metal" level to learn a little bit about how code runs directly on a computer system and learn about interfacing with hardware devices, handling interrupts, and building executables for an embedded environment.

For this project, I wanted to implement a program that was substantial enough to be exciting, but not so complex that I would be mired in application logic. Ultimately, I chose to implement a clone of the classic snake game (gif below shows a demo of my clone). The game has simple mechanics that are easy to understand, but is complex enough to be interesting to play and watch.

![snake_demo](./snake-final-demo.gif)

## What is RISC-V? What is Qemu? And what does Embedded mean?
All great questions!

**To start: What is RISC-V?**

RISC-V (commonly pronounced as "risk five") is an open source instruction set architecture for CPUs. This means that processors which implement the RISC-V ISA can all run the same binary programs. The ISA is designed to be simple and modular, its specification is all open source, and it is very well supported in Qemu. All of these qualities make which makes it the perfect architecture to target for when learning assembly programming.

It is worth stating that even though RISC-V is great for learning, it is far from a toy or teaching prop! RISC-V is early in it's adoption, but there are more and more vendors building RISC-V chips every year.

**Ok, and what is Qemu?**

QEMU (possibly pronounce "queue-emu" or "keh-moo") is a tool that lets us emulate a complete computer system, like a RISC-V board. This means you can write and test assembly programs in a simulated environment without needing the real hardware. Even though the computers I use for development have Arm or Intel chips, I can still run RISC-V programs using qemu.

**Great, and what does embedded or "bare-metal" mean?**
While these terms don't have precise definitions, I can share my understanding of these words. Embedded software is code that's built to run specifically on certain hardware, often times without a traditional operating system. Embedded software is often responsible for interfacing directly with the hardware it is running on and must work without using the primitives that an operating system typically provides.

## Project Organization
This project is organized into sub-directories that show each stage of my development of the snake game. Every folder is created as a copy of the one preceding it, and then added to until I was able to introduce a new feature. I chose to structure the repository this way because I wanted the repository to show how I incrementally built the game up one bit of functionality at a time.

See the README.md in each of the sub-directories for information about what the software in that directory does.
- [00-setting-up-a-build-and-run-environment/](00-setting-up-a-build-and-run-environment/README.md)
- [01-printing-characters-using-uart/](01-printing-characters-using-uart/README.md)
- [02-expanding-framework-structure/](02-expanding-framework-structure/README.md)
- [03-printing-the-time/](03-printing-the-time/README.md)
- [04-uart-input-interrupts/](04-uart-input-interrupts/README.md)
- [05-state-updates-in-interrupts/](05-state-updates-in-interrupts/README.md)
- [06-terminal-control-helpers/](06-terminal-control-helpers/README.md)
- [07-simple-game-loop/](07-simple-game-loop/README.md)

## How is the game implemented?
The assembly program I wrote is loaded directly into memory when qemu is invoked, and begins executing immediately. This very stripped down environment has a few implications for how our software is built. Because our program is running without the utilities an operating system provides, we are on the line for writing code that serves the same purposes as an operating systems device drivers, or a distributions standard library. Our project also needs a build system that can assemble and link our files to create a binary that is appropriately formatted to run on a "bare metal" system.

This program only uses a single device to read and print characters to the terminal -- the UART device. UART stands for universal asynchronous receiver-transmitter. Computers can use a uart to communicate with other devices using a serial connection. We invoke qemu in such a way that the host terminal is "hooked up" to the uart such that any characters typed in the terminal are sent to the guest, and any characters written by the guest are printed on the terminal.

The "graphics" for the program are implemented by printing terminal control characters to move the cursor, erase characters and write characters on every frame. The "interactions" for the game are implemented by handling all key presses in a system wide interrupt handler which stores those key presses in a buffer that the main game loop can consume.

## How to run the programs
Once you have followed the setup instructions for your platform ([macOS setup instructions](MAC-OS-SETUP.md) or [debian/ubuntu setup instructions](DEBIAN-UBUNTU-SETUP.md)), you can `cd` into any of the numbered sub directories in this project and use the makefile to build and run the project. The following make commands will work in each sub directory.

If you are interested in running the snake game specifically, `cd` into `07-simple-game-loop/` and use the makefile commands below to run the game there.

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

## FAQS
<details>
<summary>What are the dependencies for running the project and how do I install them?</summary>
For instructions on installing the dependencies see the [macOS setup instructions](MAC-OS-SETUP.md) or the [debian/ubuntu setup instructions](DEBIAN-UBUNTU-SETUP.md). 

If you come accross this project and know how to set this up for other platforms, please open a PR! I specifically would love to add instructions for Windows and Arch Linux.
</details>

<details>
<summary>There aren't instalation instructions for my operating system type!</summary>
Sorry! I wish I could test this project on every machine and every OS to get the instalation instructions just so for everyone... but in practice, that is just not feasible.

If you are able to install and run this project on another OS type, please share the instructions and I will encorporate them into this repo.
</details>

<details>
<summary>I started running the game... but can't make it stop, help!</summary>
When qemu is running in it's terminal mode, you need to press `ctrl-a x` to exit.
</details>