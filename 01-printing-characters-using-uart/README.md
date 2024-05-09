# 01: Printing Hello World
Ah yes! The canonical "hello world" program. This software in this directory prints that timeless and true string.

## The UART
While printing hello world might be a few lines in many projects, that is not the case here! Getting hello world to print actually takes us quite a bit of effort because we need to start communicating with our first device to do it... the UART.

UART stands for universal asynchronous transmiter. It is the device on our board that manages a serial connection to other devices. Or, in simpler terms, if we imaging that there is a wire comming out of virtual RISC-V board that we want to use to communicate (bit by bit)... the uart is the device on our end of that wire! The UART knows how to take single bytes and write them out onto that wire for whoever is on the other end to pick up and read.

## Interfacing with the UART
To make the uart easier to work with in application logic, we create two functions `uart-initialize` and `uart-put-character` that the application can call.

At the momement, all of the code for the application logic and the uart interface is in `./entry.S`... But in `02-extending-the-framework-structure/` we split `entry.s` into many sub files that can be linked together into our final output binary.