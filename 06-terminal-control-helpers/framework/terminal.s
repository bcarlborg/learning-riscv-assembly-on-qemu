#############################################################################
# SECTION: DATA
# Static Data
#############################################################################

.section .data

#############################################################################
# SECTION: TEXT
# Our our program text
#############################################################################

.section .text


#
# Function to clear the terminal screen
#

.globl terminal_clear_screen
terminal_clear_screen:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    li a0, 0x1B           # print escape
    call uart_put_character

    li a0, '['
    call uart_put_character

    li a0, '2'
    call uart_put_character

    li a0, 'J'
    call uart_put_character

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller



#
# Function to move the cursor to a specific location
# - line number in a0
# - column number in a1
#

.globl terminal_move_cursor_to_position
terminal_move_cursor_to_position:
    # Function prologue
    addi sp, sp, -24       # Allocate space on the stack
    sd s1, 16(sp)
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address

    addi s0, a0, 0        # line number in s0
    addi s1, a1, 0        # column number in s1

    li a0, 0x1B           # print escape
    call uart_put_character

    li a0, '['
    call uart_put_character

    addi a0, s0, 0            # line number in a0
    call uart_put_character

    li a0, ';'
    call uart_put_character

    addi a0, s1, 0            # column number in a0
    call uart_put_character

    li a0, 'H'
    call uart_put_character

    # Function epilogue
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 24       # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# Function to make cursor invisible
#

.globl terminal_make_cursor_invisible
terminal_make_cursor_invisible:
    # Function prologue
    addi sp, sp, -24       # Allocate space on the stack
    sd s1, 16(sp)
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address

    li a0, 0x1B           # print escape
    call uart_put_character

    li a0, '['
    call uart_put_character

    li a0, '?'
    call uart_put_character

    li a0, '2'
    call uart_put_character

    li a0, '5'
    call uart_put_character

    li a0, 'l'
    call uart_put_character

    # Function epilogue
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 24       # Deallocate space on the stack
    jr ra                 # Return to the caller


.globl terminal_make_cursor_visible
terminal_make_cursor_visible:
    # Function prologue
    addi sp, sp, -24       # Allocate space on the stack
    sd s1, 16(sp)
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address

    li a0, 0x1B           # print escape
    call uart_put_character

    li a0, '['
    call uart_put_character

    li a0, '?'
    call uart_put_character

    li a0, '2'
    call uart_put_character

    li a0, '5'
    call uart_put_character

    li a0, 'h'
    call uart_put_character

    # Function epilogue
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 24       # Deallocate space on the stack
    jr ra                 # Return to the caller


# Function to move the cursor to a location and erase a character
# - line number in a0
# - column number in a1
#

.globl terminal_erase_character_at_position
terminal_erase_character_at_position:
    # Function prologue
    addi sp, sp, -24       # Allocate space on the stack
    sd s1, 16(sp)
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address

    # we still have the line and column in a0, and a1
    call terminal_move_cursor_to_position

    li a0, 0x7F                  # del character
    call uart_put_character

    # move our cursor back to the position of the erased character
    li a0, 0x08           # backspace character
    call uart_put_character

    # Function epilogue
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 24       # Deallocate space on the stack
    jr ra                 # Return to the caller


#
# Function to move the cursor to a location and write a character
# - line number in a0
# - column number in a1
# - character to write a2
#

.globl terminal_write_character_at_position
terminal_write_character_at_position:
    # Function prologue
    addi sp, sp, -24       # Allocate space on the stack
    sd s1, 16(sp)
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address

    # we still have the line and column in a0, and a1
    call terminal_move_cursor_to_position

    # write our character 
    addi a0, a2, 0
    call uart_put_character

    # move our cursor back to the position of the added character
    li a0, 0x08           # backspace character
    call uart_put_character

    # Function epilogue
    ld s1, 16(sp)
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 24       # Deallocate space on the stack
    jr ra                 # Return to the caller
