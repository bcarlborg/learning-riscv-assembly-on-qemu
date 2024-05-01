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

hello_world_string:
    .asciz "Hello World!\n"

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

    # call terminal_make_cursor_invisible

    # clear the screen
    call terminal_clear_screen

    li a0, '1'            # line
    li a1, '1'           # column
    call terminal_move_cursor_to_position


    la a0, hello_world_string
    call print_zero_terminated_string


    li a0, '1'            # line
    li a1, '4'            # column
    call terminal_erase_character_at_position

    li a0, '1'            # line
    li a1, '7'            # column
    li a2, 'q'            # character to write
    call terminal_write_character_at_position

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

