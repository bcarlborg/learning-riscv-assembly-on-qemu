# Learning RISC-V Assembly on Qemu
This repository tracks my work learning how to riscv systems work and learning how to write assembly for them!

Each sub directory is a fully contained project that represents some step in the learning process

## Running the programs
Once you have the dependencies below installed you can `cd` into any of the numbered sub directories in this project and use the makefile to build and run the project. The following make commands will work in each sub directory

```bash
#
# Simply running the program:
# to build the program and run it with qemu use the following make invocation
#

make run

#
# Running the program with a debugger:
# To build the program and run it in a mode that can be attached to a debugger run
# the following make command and one of the following commands to start your debugger
#

make run-debug

# then in a seperate window run one of the following
gdb-multiarch # run this on debian/ubuntu
riscv64-elf-gdb # run this on macos

#
# Building sources without running the program:
# Sometimes you just want to compile, and you don't want to run it yet
#

# either run this command
make
# or run this command (for these makefiles, they do the same thing)
make all

#
# Cleaning up source files:
# when you want to remove all the compiled code, leaving just your source files
#

make clean
```

## Dependencies
The main dependencies needed for this project are as follows:
- `qemu-system-riscv64`: A build of qemu that simulates riscv boards.
- `riscv gnu tools`: We rely on a handful of gnu tools (as & ld) to build our riscv programs, we need an install of that software that understands the riscv architecture.
- `riscv or multiarch gbd`: We will use gdb to debug our programs, and so we will need a build of gdb that can process riscv code running in qemu.

### Installing the dependencies for this project on Debian/Ubuntu
```bash
# basic tools needed for most projects
sudo apt-get install git build-essential 

# install qemu exectuables that can be simulate a riscv64 system
sudo apt-get install qemu-system-misc qemu-emulators-full 

# install the cross platform builds of the gnu tools that can handle the riscv64 code we write
sudo apt-get install gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu 

# install the cross platform debugger (gdb) we can use to debug our riscv64 programs running in qemu
# note: when you run this command for this project, it may throw and error telling you that you need
# to add a line to your .gdbinit file. Keep an eye out for that error! It will tell you exactly what
# to do to fix the issue, but it can be hard to spot :-)
sudo apt-get install gdb-multiarch 
```

Verify your installation by running the following commands
```bash
# ensure that we have a version of qemu that will run riscv64 code
qemu-system-riscv64 --version

# ensure that we have the gnu tools necessary to build our riscv code
riscv64-linux-gnu-as --version
riscv64-linux-gnu-ld --version

# ensure that we have the cross platform debugger necessary to debug our programs
gdb-multiarch --version
```

### Installing the dependencies for this project on macOS
```bash
# basic tools needed for most projects
xcode-select --install

# install homebrew (skip this if brew is already installed on your system)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# installing the riscv compiler toolchain gives us the cross platform builds of the gnu tools
# we need in order to build code for a riscv64 system
brew tap riscv/riscv
$ brew install riscv-tools

# you may also need to add the following line to your `~/bashrc` or `~/.zshrc` file depending on how the
# riscv compiler toolchain installs to make sure your shell can find those executables
PATH=$PATH:/usr/local/opt/riscv-gnu-toolchain/bin

# install qemu, this will give us the qemu executables we need to run our riscv64 code
brew install qemu

# install a cross platform version of gdb that we can use to debug our riscv64 programs
# note: when you run this command for this project, it may throw and error telling you that you need
# to add a line to your .gdbinit file. Keep an eye out for that error! It will tell you exactly what
# to do to fix the issue, but it can be hard to spot :-)
brew install riscv64-elf-gdb
```

Verify you have all the necessary exectuables by the following commands

```bash
# ensure that we have a version of qemu that will run riscv64 code
qemu-system-riscv64 --version

# ensure that we have the gnu tools necessary to build our riscv code
riscv64-unknown-elf-as --version
riscv64-unknown-elf-ld --version

# ensure that we have the cross platform debugger necessary to debug our programs
riscv64-elf-gdb --version
```

## Running the programs
TODO: @beau -- clean this up

Running the program
- `make run`

Running the program with a debugger
- `make run-debug` then in a seperate window run `riscv64-elf-gdb` and you can step through the program

Qemu controls
- ctrl-a x -- exit qemu
- ctrl-a c -- start console