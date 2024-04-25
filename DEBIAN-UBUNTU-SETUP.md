# Getting Setup on Ubuntu or other Debian Systems
To build and run the programs in this project, we will need to install the following:
- the generic build essential tools
- `riscv64-linux-gnu-as`: a riscv64 version of the gnu assembler
- `riscv64-linux-gnu-ld`: a riscv64 version of the gnu linker
- `qemu-system-riscv64`: the executable to run qemu and simulate our RISC-V 64 board
- `gdb-multiarch`: a build of gdb that can attach to qemu simulating riscv64
- `socat`: a command line tool that makes it easy to forward data from files to pipes and sockets

### Installing the dependencies for this project on Debian/Ubuntu
```bash
# basic command line tools and libraries needed for most projects
sudo apt-get install git build-essential 

# install qemu exectuables that can be simulate a riscv64 system
# specifically, we need the qemu-system-riscv64 executable
sudo apt-get install qemu-system-misc qemu-emulators-full 

# install the cross platform builds of the gnu tools that can handle the riscv64 code we write
# specifically we want riscv64-linux-gnu-as and riscv64-linux-gnu-ld
sudo apt-get install gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu 

# install the cross platform debugger (gdb) we can use to debug our riscv64 programs running in qemu
# note: when you run this command for this project, it may throw and error telling you that you need
# to add a line to your .gdbinit file. Keep an eye out for that error! It will tell you exactly what
# to do to fix the issue, but it can be hard to spot :-)
sudo apt-get install gdb-multiarch 

# install the socat executable
apt-get install -y socat
```

Verify your installation by running the following commands
```bash
# ensure that we have a version of qemu that will run riscv64 code
qemu-system-riscv64 --version

# ensure that we have the gnu tools necessary to build our RISC-V code
riscv64-linux-gnu-as --version
riscv64-linux-gnu-ld --version

# ensure that we have the cross platform debugger necessary to debug our programs
gdb-multiarch --version

# install the socat executable
brew install socat
```
