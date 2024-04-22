#############################################################################
# SECTION: .data
# Any statically allocated data can go here
#############################################################################
.section .data

ticks_interval: 
    .dword 1000000 # about 1/10th of a second

.globl ticks_time
ticks_time:
    .dword 0

#############################################################################
# SECTION: .text
# the program
#############################################################################

.section .text

.globl initialize_timer
initialize_timer:
    # function prologue
    addi sp, sp, -16    # allocate space on the stack for the return address and frame pointer
    sd ra, 8(sp)        # save the return address
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    call reset_mtimecmp

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller

reset_mtimecmp:
    # load the current time (THIS HAS THE ADDRESS NOT THE VALUE)
    ld t0, CLINT_MTIME
    ld t1, 0(t0)

    # get the interval we want between interrupts
    ld t0, ticks_interval

    # add the interval to that time
    add t2, t0, t1

    # store that updated time in MTIMECMP so that we will
    # generate an interrupt once we get to that time
    la t1, CLINT_MTIMECMP
    ld t0, 0(t1)
    sd t2, 0(t0)

    ret

.globl handle_timer_interrupt
handle_timer_interrupt:
    # function prologue
    addi sp, sp, -16    # allocate space on the stack for the return address and frame pointer
    sd ra, 8(sp)        # save the return address
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    # get the current ticks from clint
    la t1, CLINT_MTIME

    # store that in ticks time
    la t0, ticks_time
    sd t1, 0(t0)

    # reset the interval for timer interrupts
    call reset_mtimecmp

    li a0, 't'
    jal uart_put_character

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller


