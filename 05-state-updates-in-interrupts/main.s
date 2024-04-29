#############################################################################
# External Symbols
# symbols that will be defined in a different part of the project
#############################################################################

# for example:
# .extern my_cool_function
# .extern UART_BASE

#############################################################################
# SECTION: .data
# Any statically allocated data can go here
#############################################################################
.section .data

#############################################################################
# SECTION: .text
# The program!
# The framework will call setup() once
# then will call loop() in a continuous while loop
#############################################################################

.section .text

.global setup
setup:
    # Prologue
    addi sp, sp, -16  # Allocate stack space; adjust size as needed for alignment and locals
    sd ra, 8(sp)      # Save return address at an appropriate offset
    sd fp, 0(sp)      # Save frame pointer
    addi fp, sp, 16   # Set up new frame pointer

    #
    # YOUR SETUP CODE HERE
    #

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

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller


.global loop
loop:
    # Prologue
    addi sp, sp, -16  # Allocate stack space; adjust size as needed for alignment and locals
    sd ra, 8(sp)      # Save return address at an appropriate offset
    sd fp, 0(sp)         # Save frame pointer
    addi fp, sp, 16 # Set up new frame pointer

    #
    # YOUR LOOPING CODE HERE
    #

    jal read_character

    beq a0, x0, loop__finish

    jal uart_put_character

loop__finish:

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller

