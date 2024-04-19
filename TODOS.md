# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## overall todos
- make the comments in the readme look nicer
- check that this works on apple silicon macs and on intel based macs then add a comment

## chapter 00 todos
- write the readme
- add something that detects your platform and echos the correct instruction to open gdb in another window
- update it to just spin in circles
- make it a multi-file program just to highlight the linker
- maybe make it so that we don't have to specify all the source files explicitly
- cleanup the makefile output consistent objec names

## 01-printing-characters-using-uart
- now that we are a bit more familiar with assembly, we can actually get to our hello world
- shows how to print characters using the uart

## 02-receiving-characters-using-uart
- now that we are a bit more familiar with assembly, we can actually get to our hello world
- shows how to print characters using the uart

## Up Next
- Immediate goal is to figure out how xv6 uses the uart by reading though the code there.
- https://www.notion.so/xv6-uart-driver-96efe574fd7446248754539dca464ac3
- write a single character to the screen following the xv6 approach
- figure out how to write an interrupt handler and register it. Also figure out how the plic works and gets configured


## Tomorrow todos
- print a character.
- setup a ring buffer to try writing with a spin for as long as you need.
- setup a timer interrupt to write a character every few seconds? (mmode interrupt with clint)
- setup an interrupt from the plic for reading characters and store them... somewhere?