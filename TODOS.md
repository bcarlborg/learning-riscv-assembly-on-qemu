# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## Immediate Todos (02-expanding-framework-structure)
I want the project (loosely) to follow this structure
steps to get there
- rename labels in framework to use _
- create a file main.s that calls the program behavior
- move all the framework code into its own directory

### Desired Directory Structure
framework/
  entry.s
  framework.s
  interrupt.s
  uart.s
  memlayout.s

### Desired Exectuable Memory Layout
section: text.entry (only has _entry)
section: text       (has all other program content)
section: data       (has all static data)


### Label Names
all framework label names start with a '_'