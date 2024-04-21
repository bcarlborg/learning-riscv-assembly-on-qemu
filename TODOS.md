# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## immediate todos
I want the project (loosely) to follow this structure
steps to get there
- break out uart from start.s
- break out memlayout from start and entry
- rename labels in framework to use _
- create a file main.s that calls the program behavior
- move all the framework code into its own directory

### Desired directory structure
framework/
  entry.s
  framework.s
  interrupt.s
  uart.s
  memlayout.s

### Desired exectuable memory layout
section: text.entry (only has _entry)
section: text       (has all other program content)
section: data       (has all static data)


### Label Names
all framework label names start with a '_'