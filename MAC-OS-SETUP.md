# Getting setup on macOS
To build and run the programs in this project, we will need to install the following:
- all of the xcode command line tools and libraries
- `homebrew`: a package manager for macOS that will make it easier to install the following deps
- `riscv64-unknown-elf-as`: a riscv64 version of the gnu assembler
- `riscv64-unknown-elf-ld`: a riscv64 version of the gnu linker
- `qemu-system-riscv64`: the executable to run qemu and simulate our RISC-V 64 board
- `riscv64-elf-gdb`: a build of gdb that can attach to qemu simulating riscv64
- `socat`: a command line tool that makes it easy to forward data from files to pipes and sockets

### Installing the dependencies for this project on macOS
```bash
# basic tools needed for most projects
xcode-select --install

# install homebrew (skip this if brew is already installed on your system)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# installing the RISC-V compiler toolchain gives us the cross platform builds of the gnu tools
# we need in order to build code for a riscv64 system. Specifically the executables
# riscv64-unknown-elf-as and riscv64-unknown-elf-ld
brew tap riscv/riscv
$ brew install riscv-tools

# you may also need to add the following line to your `~/bashrc` or `~/.zshrc` file depending on how the
# RISC-V compiler toolchain installs to make sure your shell can find those executables
PATH=$PATH:/usr/local/opt/riscv-gnu-toolchain/bin

# install qemu, this will give us the qemu executables we need to run our riscv64 code
# specifically the executable qemu-system-riscv64
brew install qemu

# install a cross platform version of gdb that we can use to debug our riscv64 programs
# note: when you run this command for this project, it may throw and error telling you that you need
# to add a line to your .gdbinit file. Keep an eye out for that error! It will tell you exactly what
# to do to fix the issue, but it can be hard to spot :-)
brew install riscv64-elf-gdb

# install the socat executable
brew install socat
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

# ensure that we have the socat command line tool
# (this command outputs a big wall of text, don't be alarmed, its just a verbose program :shrug:)
socat -V
```
