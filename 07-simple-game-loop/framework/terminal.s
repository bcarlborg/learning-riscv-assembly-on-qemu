#############################################################################
# SECTION: DATA
# Static Data
#############################################################################

.section .data

scratch_0:
    .zero 16

scratch_1:
    .zero 16

#############################################################################
# SECTION: TEXT
# Our our program text
#############################################################################

.section .text

.globl num_to_ascii

# void num_to_ascii()
# a0 = number
# a2 = address of the buffer to store the string
num_to_ascii:
    addi sp, sp, -24        # Allocate stack space for local variables
    sd ra, 0(sp)            # Save return address
    sd a0, 8(sp)            # Save the original number
    sd a2, 16(sp)           # Save buffer pointer

    li t0, 0                # Counter for digits

convert_loop:
    li t1, 10               # Divisor
    remu a1, a0, t1         # Remainder, which is the current digit
    divu a0, a0, t1         # Update number
    addi a1, a1, '0'        # Convert digit to ASCII
    sb a1, 0(a2)            # Store ASCII character in buffer
    addi a2, a2, 1          # Increment buffer pointer
    addi t0, t0, 1          # Increment digit counter
    bnez a0, convert_loop   # If number is not zero, continue

    # Adding null terminator
    sb zero, 0(a2)          # Store null terminator in buffer

    # Reverse the string
    addi a2, a2, -1         # Move back to the last digit
    ld a0, 16(sp)           # Restore the start of the buffer
reverse_loop:
    sub t1, a2, a0          # Calculate the offset
    blez t1, done_reverse   # If offset <= 0, string is reversed
    lbu t2, 0(a0)           # Load byte from start
    lbu t1, 0(a2)           # Load byte from end
    sb t2, 0(a2)            # Swap bytes
    sb t1, 0(a0)
    addi a0, a0, 1          # Increment start pointer
    addi a2, a2, -1         # Decrement end pointer
    j reverse_loop

done_reverse:
    ld ra, 0(sp)            # Restore return address
    ld a0, 8(sp)            # Restore buffer pointer
    ld a2, 16(sp)           # Restore buffer pointer
    addi sp, sp, 24         # Deallocate stack space
    ret                     # Return from function

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

    la a2, scratch_0      # ascii string for line in scratch_0
    call num_to_ascii

    addi a0, s1, 0
    la a2, scratch_1      # ascii string for column in scratch_1
    call num_to_ascii

    li a0, 0x1B           # print escape
    call uart_put_character

    li a0, '['
    call uart_put_character

    la a0, scratch_0         # line number ascii string pointer in a0
    call print_zero_terminated_string

    li a0, ';'
    call uart_put_character

    la a0, scratch_1         # line number ascii string pointer in a0
    call print_zero_terminated_string

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

    addi s0, a2, 0        # save the character to print

    # we still have the line and column in a0, and a1
    call terminal_move_cursor_to_position

    # write our character 
    addi a0, s0, 0
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
