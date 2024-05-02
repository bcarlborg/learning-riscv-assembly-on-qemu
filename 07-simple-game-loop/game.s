#############################################################################
# SECTION: .data
# Any statically allocated data can go here
#############################################################################
.section .data

#
# Game grid, open characters are from line: 2 - 25 || col 2 - 70
#
game_background:
    .ascii "-----------------------------------------------------------------------\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .ascii "|                                                                     |\n"
    .asciz "-----------------------------------------------------------------------"

#
# Indicates the direction that the snake is moving
#
#            up = 0
#
#   left = 3        right = 1
#
#           down = 2

snake_direction:
    .byte 1


# snake head offset is 2 byte integer indicating how far into snake the head is
snake_head_offset:
    .word 14

# snake tail offset is 2 byte integer indicating how far into snake the tail is
snake_tail_offset:
    .word 0

# An array of 2 byte values [column, line] that define the snake
# 2048 byte array
snake:
    .byte 5          # column offset 0 (snake part 1)
    .byte 10         # line
    .byte 6          # column offset 2 (snake part 2)
    .byte 10         # line
    .byte 7          # column offset 4 (snake part 3)
    .byte 10         # line
    .byte 8          # column offset 6 (snake part 4)
    .byte 10         # line
    .byte 9          # column offset 8 (snake part 5)
    .byte 10         # line
    .byte 10         # column offset 10 (snake part 6)
    .byte 10         # line
    .byte 11         # column offset 12 (snake part 7)
    .byte 10         # line
    .byte 12         # column offset 14 (snake part 8)
    .byte 10         # line
    .zero 2032       # = 2048 - 2 * (number of snake parts = 8)

#############################################################################
# SECTION: .text
# The program!
# The framework will call setup() once
# then will call loop() in a continuous while loop
#############################################################################

.section .text

#
# Function to clear the terminal screen
#

.globl game_print_background_and_home_cursor
game_print_background_and_home_cursor:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    # clear the screen
    call terminal_clear_screen

    li a0, 1            # line
    li a1, 1           # column
    call terminal_move_cursor_to_position

    la a0, game_background 
    call print_zero_terminated_string

    li a0, 1            # line
    li a1, 1           # column
    call terminal_move_cursor_to_position

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller

#
# read chars and update snake direction
#

game_read_chars_and_update_snake_direction:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

game_read_chars_and_update_snake_direction__read_char:
    call read_character

    # If there are no more characters to read, there is no direction to update
    li t0, 0
    beq a0, t0, game_read_chars_and_update_snake_direction__exit

    # If the input was w | a | s | d then we should update the direction
    li t0, 'w'
    beq a0, t0, game_read_chars_and_update_snake_direction__direction_up
    li t0, 'd'
    beq a0, t0, game_read_chars_and_update_snake_direction__direction_right
    li t0, 's'
    beq a0, t0, game_read_chars_and_update_snake_direction__direction_down
    li t0, 'a'
    beq a0, t0, game_read_chars_and_update_snake_direction__direction_left

    # If the input was something else, we ignore it and just try to get another character
    j game_read_chars_and_update_snake_direction__read_char


game_read_chars_and_update_snake_direction__direction_up:
    # If the snake's direction is down, we don't want to
    # allow you to go back up (snake can't double back)
    li t0, 2
    lb t1, snake_direction
    beq t0, t1, game_read_chars_and_update_snake_direction__read_char

    li t0, 0
    la t1, snake_direction 
    sb t0, 0(t1)
    j game_read_chars_and_update_snake_direction__read_char

game_read_chars_and_update_snake_direction__direction_right:
    # If the snake's direction is left, we don't want to
    # allow you to go back right (snake can't double back)
    li t0, 3
    lb t1, snake_direction
    beq t0, t1, game_read_chars_and_update_snake_direction__read_char

    li t0, 1
    la t1, snake_direction 
    sb t0, 0(t1)
    j game_read_chars_and_update_snake_direction__read_char

game_read_chars_and_update_snake_direction__direction_down:
    # If the snake's direction is up, we don't want to
    # allow you to go back down (snake can't double back)
    li t0, 0
    lb t1, snake_direction
    beq t0, t1, game_read_chars_and_update_snake_direction__read_char

    li t0, 2
    la t1, snake_direction 
    sb t0, 0(t1)
    j game_read_chars_and_update_snake_direction__read_char

game_read_chars_and_update_snake_direction__direction_left:
    # If the snake's direction is right, we don't want to
    # allow you to go back down (snake can't double back)
    li t0, 1
    lb t1, snake_direction
    beq t0, t1, game_read_chars_and_update_snake_direction__read_char

    li t0, 3
    la t1, snake_direction 
    sb t0, 0(t1)
    j game_read_chars_and_update_snake_direction__read_char
    

game_read_chars_and_update_snake_direction__exit:
    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# Print the current snake head
#
game_print_snake_head:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    # a0 has snake head column
    # a1 has snake head tail
    call game_get_snake_head_pos

    addi s0, a0, 0
    addi s1, a1, 0

    addi a1, s0, 0
    addi a0, s1, 0

    li a2, '#'

    call terminal_write_character_at_position

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# erase the current snake tail
#
game_erase_snake_tail:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    # a0 has snake tail column
    # a1 has snake tail line
    call  game_get_snake_tail_pos

    addi s0, a0, 0
    addi s1, a1, 0

    addi a1, s0, 0
    addi a0, s1, 0

    call terminal_erase_character_at_position

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# get the snake tail position
# a0 = current snake head column
# a1 = current snake head line
#
game_get_snake_tail_pos:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    la t0, snake
    lh t1, snake_tail_offset

    add t0, t1, t0        # t0 has address of snake head column
    addi t1, t0, 1        # t1 has address of snake head line

    lb a0, 0(t0)
    lb a1, 0(t1)

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# get the snake head position
# a0 = current snake head column
# a1 = current snake head line
#
game_get_snake_head_pos:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    la t0, snake
    lh t1, snake_head_offset

    add t0, t1, t0        # t0 has address of snake head column
    addi t1, t0, 1        # t1 has address of snake head line

    lb a0, 0(t0)
    lb a1, 0(t1)

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# Set the snake head position
# a0 = new snake head column
# a1 = new snake head line
#
game_set_snake_head_pos:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    la t0, snake
    lh t1, snake_head_offset

    add t0, t1, t0        # t0 has address of snake head column
    addi t1, t0, 1        # t1 has address of snake head line

    sb a0, 0(t0)
    sb a1, 0(t1)

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller


game_increment_snake_tail_offset:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    lh a0, snake_tail_offset

    call game_increment_snake_offset

    la t0, snake_tail_offset
    sh a0, 0(t0)

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller

game_increment_snake_head_offset:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    lh a0, snake_head_offset

    call game_increment_snake_offset

    la t0, snake_head_offset
    sh a0, 0(t0)          # store the new offset

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller



#
# Function to increment a snake offset
# accepts current offset in a0 and returns new offset in a0
#
game_increment_snake_offset:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    addi a0, a0, 2
    li t1, 2048

    blt a0, t1, game_increment_snake_offset__exit

    # If we fall through to here, it means a0 >= 2048, 
    # so we need to wrap it back around to 0
    li a0, 0

game_increment_snake_offset__exit:

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller

#
# Function that processes the read characters and prints the new game state
# a0 = next head column   a1 = next head line
#
game_calculate_next_snake_head_position:
    # Function prologue
    addi sp, sp, -48      # Allocate space on the stack
    sd s4, 40(sp)         # Save s4
    sd s3, 32(sp)         # Save s3
    sd s2, 24(sp)         # Save s2
    sd s1, 16(sp)         # Save s1
    sd s0, 8(sp)          # Save s0
    sd ra, 0(sp)          # Save return address

    call game_get_snake_head_pos

    addi s0, a0, 0       # s0 holds current head column
    addi s1, a1, 0       # s1 holds current head line

    lb t0, snake_direction
    li t1, 0
    beq t0, t1, game_calculate_next_snake_head_position__up
    li t1, 1
    beq t0, t1, game_calculate_next_snake_head_position__right
    li t1, 2
    beq t0, t1, game_calculate_next_snake_head_position__down
    li t1, 3
    beq t0, t1, game_calculate_next_snake_head_position__left

#
# this block writes the new head (column, line) values to s0, s1
# s0 = head column, s1 = head line
#
game_calculate_next_snake_head_position__up:
    addi s1, s1, -1
    j game_calculate_next_snake_head_position__exit
game_calculate_next_snake_head_position__right:
    addi s0, s0, 1
    j game_calculate_next_snake_head_position__exit
game_calculate_next_snake_head_position__down:
    addi s1, s1, 1
    j game_calculate_next_snake_head_position__exit
game_calculate_next_snake_head_position__left:
    addi s0, s0, -1
    j game_calculate_next_snake_head_position__exit

game_calculate_next_snake_head_position__exit:
    addi a0, s0, 0
    addi a1, s1, 0

    # Function epilogue
    ld s4, 40(sp)         # Save s4
    ld s3, 32(sp)         # Save s3
    ld s2, 24(sp)         # Save s2
    ld s1, 16(sp)         # Save s1
    ld s0, 8(sp)          # Restore s0
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 48        # Deallocate space on the stack
    jr ra                 # Return to the caller


move_cursor_to_snake_head:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    call game_get_snake_head_pos

    addi t1, a0, 0     # current snake head column into t1
    addi t0, a1, 0     # current snake head line into t0

    addi a0, t0, 0    # current snake head line into a0
    addi a1, t1, 0    # current snake head line into a0

    call terminal_move_cursor_to_position


    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller



#
# Function that processes the read characters and prints the new game state
#

move_snake_head_forward:
    # Function prologue
    addi sp, sp, -48      # Allocate space on the stack
    sd s4, 40(sp)         # Save s4
    sd s3, 32(sp)         # Save s3
    sd s2, 24(sp)         # Save s2
    sd s1, 16(sp)         # Save s1
    sd s0, 8(sp)          # Save s0
    sd ra, 0(sp)          # Save return address

    # After this call:
    # a0 will have new head column
    # a1 will have new head column
    call game_calculate_next_snake_head_position

    addi s0, a0, 0         # s0 has new snake head column
    addi s1, a1, 0         # s1 has new snake head line

    call game_increment_snake_head_offset

    addi a0, s0, 0         # a0 has new snake head column
    addi a1, s1, 0         # s1 has new snake head line

    call game_set_snake_head_pos

    # Function epilogue
    ld s4, 40(sp)         # Save s4
    ld s3, 32(sp)         # Save s3
    ld s2, 24(sp)         # Save s2
    ld s1, 16(sp)         # Save s1
    ld s0, 8(sp)          # Restore s0
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 48       # Deallocate space on the stack
    jr ra                 # Return to the caller



#
# Function that prints the initial snake
#

.globl game_print_initial_snake
game_print_initial_snake:
    # Function prologue
    addi sp, sp, -16       # Allocate space on the stack
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address


    lh t0, snake_tail_offset
    addi s0, t0, 0             # s0 holds the offset we are currently processing

game_print_initial_snake__print_start:
    lh t1, snake_head_offset
    bgt s0, t1, game_print_initial_snake__print_end

    la t2, snake
    add t2, t2, s0       # t2 contains the address of the current snake segment to print

    lb t1, 0(t2)         # t1 contains the current snake segment column
    addi t2, t2, 1
    lb t2, 0(t2)         # t2 contains the current snake segment line

    mv a0, t2            # a0 has line
    mv a1, t1            # a1 has column
    li a2, '#'           # a2 has character to print

    call terminal_write_character_at_position


    addi s0, s0, 2

    j game_print_initial_snake__print_start

game_print_initial_snake__print_end:

    li a0, 1
    li a1, 1
    call terminal_move_cursor_to_position

    # Function epilogue
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 16       # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# Function that processes the read characters and prints the new game state
#

.globl update_game_state_and_refresh_view
update_game_state_and_refresh_view:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    call game_read_chars_and_update_snake_direction

    call move_snake_head_forward 

    call game_print_snake_head

    call game_erase_snake_tail

    call game_increment_snake_tail_offset

    li a0, 1
    li a1, 1
    call terminal_move_cursor_to_position

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller
