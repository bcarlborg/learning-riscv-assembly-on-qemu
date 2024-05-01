# 05: Removing side effects from interrupts
In this directory, we update our uart interrupt to store the read characters in a ring buffer that can be consumed from in the main thread.

Essentially, we want the information from our interrupts to be stored somewhere so that it can be processed when the program gets to it. This abides by the principle that interrupts should be transparent to the underlying program.
