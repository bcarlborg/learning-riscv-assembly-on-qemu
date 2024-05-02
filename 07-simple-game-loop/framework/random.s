#############################################################################
# SECTION: .data
# Any statically allocated data can go here
#############################################################################
.section .data

seed:
    .dword 123456789   # Initial seed

#############################################################################
# SECTION: .text
# The program!
# The framework will call setup() once
# then will call loop() in a continuous while loop
#############################################################################

.section .text

# Input: a0 = min, a1 = max
# Output: a0 = random number between min and max
.globl random
random:
    # Function prologue
    addi sp, sp, -16       # Allocate space on the stack
    sd s0, 8(sp)
    sd ra, 0(sp)          # Save return address

    li t0, 1103515245      # Load multiplier
    li t1, 12345           # Load increment
    ld t2, seed            # Load the current seed value
    mul t2, t2, t0         # t2 = seed * multiplier
    add t2, t2, t1         # t2 = seed * multiplier + increment
    la s0, seed
    sd t2, 0(s0)           # Update seed in memory
    
    # Apply the range min to max
    sub a1, a1, a0         # Calculate the range size: range = max - min
    addi a1, a1, 1         # Increase range by 1 to include max in result
    remu t2, t2, a1        # t2 = new_seed % (max - min + 1)
    add a0, t2, a0         # Shift result by min to fit into desired range
    
    # Function epilogue
    ld s0, 8(sp)
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 16       # Deallocate space on the stack
    jr ra                 # Return to the caller
