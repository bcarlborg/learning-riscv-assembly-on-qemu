# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## Immediate Todos (03-timer-interrupts)
  - create new directory and copy over everything from 02
  - create the enable interrupt and disable interrupt functions, also create the interrupt_vec label
  - create branching structure in interrupt_vec for the different values of mcause
  - create the timer file with initialize timer and handle interrupt
  - debug and test
  - get the characters to print on some interval

### new files
- timer.s
- interrupt.s

### general structure
- start
  - disable_interrupts
    - unsets mstatus.mie
  - initialize_timer
    - sets up the apppropriate state for timer intterupts
    - calls set_timer_interrupt_interval
  - initialize_uart
    - for now doesn't do anything with interrupts
  - enable_interrupts
    - sets mtvec and mstatus.mie

- timer.s
  - initialize_timer
  - set_timer_interrupt_interval
  - some global symbol TIME or something like that
  - handle_timer_interrupt

- interrupt
  - disable interrupts
  - enable interrupts
  - _interrupt_vec
    - calls handle_timer_interrupt