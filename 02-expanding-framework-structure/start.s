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

    # Call the put_uart_function with each character of hello world
    li a0, 'h'
    jal uart_put_character
    li a0, 'e'
    jal uart_put_character
    li a0, 'l'
    jal uart_put_character
    li a0, 'l'
    jal uart_put_character
    li a0, 'o'
    jal uart_put_character
    li a0, ' '
    jal uart_put_character
    li a0, 'w'
    jal uart_put_character
    li a0, 'o'
    jal uart_put_character
    li a0, 'r'
    jal uart_put_character
    li a0, 'l'
    jal uart_put_character
    li a0, 'd'
    jal uart_put_character
    li a0, '\n'
    jal uart_put_character

    j spin

#############################################################################
# Jump here to spin after you finish your work
#############################################################################

spin:
    j spin
