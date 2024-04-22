#############################################################################
# SECTION: TEXT
# Our our program text
#############################################################################

.section .text

.global _start
_start:
    #
    # First we need to initialize our uart device to prepare to transmit things
    #

    jal uart_initialize


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

spin:
    j spin
