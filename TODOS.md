# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## General project todos
- why does gdb sometimes jump to the middle of a function after a breakpoint?
  - is it just ignoring the pre-amble etc?
- Put a clearer not in the dependencies that explain how to setup .gdbinit

## Immediate Todos (03-timer-interrupts)
  - [implementation] if we want to do something with the elapsed time we should store an updated time variable in some const in timer.s
  - [misc cleanup] remove duplicated uart code... uart has duplicated code with memlayout
  - [misc cleanup] remove the external symbols sections where we import symbols... I added that before I understood how global symbols work.
  - [idea] maybe could be fun to make the hello world text blink on some interval... either in this chapter or the next. would require adding some more console helpers for reseting the state
