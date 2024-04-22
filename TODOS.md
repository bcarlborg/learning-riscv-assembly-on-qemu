# Todos
I like to keep a very simple todo list for little (and big) things that I am planning to do in the near future.
These notes are really just for me, I make no promises that any of this will be done, or that these todos are even coherent.

## Immediate Todos (03-timer-interrupts)
  - store an updated time variable in some const in timer.s
  - [misc] remove duplicated uart code
  - [misc] remove the external thing?


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