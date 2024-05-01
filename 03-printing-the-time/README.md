# 03: Processing timer interrupts
In this sub-directory, we add code that can interface with and handle interrupts on our RISC-V board. Specifically, we configure the system to interrupt our program execution when a certain number of ticks has passed by on the system clock. We create a simple interrupt handler that can save the system's state then call the appropriate interrupt handler.

`framework/timer.s` and `framework/interrupt.s` are the two files to check out to see how this works!
