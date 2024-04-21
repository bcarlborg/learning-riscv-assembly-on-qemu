# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## Tomorrow todos
- split the project into many files
  - entry.s -- has the .text.entry section and the _entry symbol. Sets up the stack and jumps to _start
  - start.s -- has _start label, calls uart init, eventually calls plic init and clint init
            -- also responsible for calling setup and then loop()
  - main.s -- has setup and loop labels that are called 
  - uart.s -- has labels uart init and the functions for printing characters

- move all of those into their own framework file (except for main)
- figure out how to get the makefile to compile all *.s files in framework and in the root directory
- figure out how to build everything into a dist file