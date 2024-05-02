#############################################################################
# SECTION: .data
# Any statically allocated data can go here
#############################################################################
.section .data

next_render:
    .dword 0

#############################################################################
# SECTION: .text
# The program!
# The framework will call setup() once
# then will call loop() in a continuous while loop
#############################################################################

.section .text

.globl setup
setup:
    # Prologue
    addi sp, sp, -16  # Allocate stack space; adjust size as needed for alignment and locals
    sd ra, 8(sp)      # Save return address at an appropriate offset
    sd fp, 0(sp)      # Save frame pointer
    addi fp, sp, 16   # Set up new frame pointer

    #
    # YOUR SETUP CODE HERE
    # this code runs once before the loop starts
    #

    # call terminal_make_cursor_invisible
    call terminal_make_cursor_visible

    call game_print_background_and_home_cursor

    call game_print_initial_snake

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller


.globl loop
loop:
    # Prologue
    addi sp, sp, -16  # Allocate stack space; adjust size as needed for alignment and locals
    sd ra, 8(sp)      # Save return address at an appropriate offset
    sd fp, 0(sp)         # Save frame pointer
    addi fp, sp, 16 # Set up new frame pointer

    ld t0, next_render
    ld t1, ticks_time

    # If next_render is still greater than ticks_time, then we don't
    # want to render yet
    bgt t0, t1, loop__finish

    # If we are here it means ticks_time has passed the next render threshold

loop__render:
    li t0, 1300000
    add t0, t0, t1     # t0 = 10000000 + ticks_time

    la t2, next_render
    sd t0, 0(t2)

    call update_game_state_and_refresh_view

loop__finish:

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller

