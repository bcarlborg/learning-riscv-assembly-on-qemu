#############################################################################
# SECTION: TEXT
# Our our program text
#############################################################################

.section .text

.global _start
_start:
    jal disable_interrupts

    #
    # First we need to initialize our uart device to prepare to transmit things
    #

    jal uart_initialize

    #
    # Now lets setup the timer to give us interrutps at a regular interval
    #

    jal initialize_timer

    #
    # Finally lets enable all system interrupts
    #

    jal enable_interrupts


    #
    # Call the user generated setup() function
    #

    call setup

_start__pre_loop:
    call loop
    j _start__pre_loop

    j spin

#############################################################################
# Jump here to spin after you finish your work
#############################################################################

.globl spin
spin:
    j spin
