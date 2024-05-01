# 06: Setting up a build and run environment
In this sub-directory, we add code that processes interrupts from our uart device. Specifically interrupts that tell us a new character is ready to be read on our device.

We intialie the UART device to provide us with these interrupts and we also configure the PLIC to provide these interrupts to the hart running our code.

When the incoming character interrupt is processed correctly, we print the character to the screen.