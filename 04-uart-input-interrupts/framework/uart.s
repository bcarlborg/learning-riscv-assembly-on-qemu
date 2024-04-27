
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
# Function to intialize the UART
#

.globl uart_initialize
uart_initialize:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    #
    # disable uart interrupts by writing 0 to IER register in the uart device
    #

    li t1, 0
    ld t0, UART_IER_REG
    sb t1, 0(t0)


    #
    # toggle the divisor latch access bit in the Line Control Register (LCR)
    # on the uart this has the effect of changing the 0th and 1st register in
    # the uart from acting like the transmit and receive buffer to instead
    # act as space to configure the baud rate.
    #

    # divisor latch access bit is the last bit in LCR, so we want to write
    # 1<<7 to the LCR
    li t1, 1
    slli t1, t1, 7

    # now that we have 1<<7 in x1, lets write that to the LCR
    ld t0, UART_LCR_REG
    sb t1, 0(t0)

    #
    # now that the divisor latch access bit is set in the LCR, we can set our
    # baud rate by writing to the two divisor latch access byte registers
    #

    li t1, 0x03
    ld t0, UART_DLL_REG
    sb t1, 0(t0)

    li t1, 0x00
    ld t0, UART_DLM_REG
    sb t1, 0(t0)

    #
    # Now that our baud rate is set, we can disable the divsor latch access mode
    # by writing all zeros to the LCR
    #

    ld t0, UART_LCR_REG
    sb x0, 0(t0)

    #
    # Now we want to configure the word size that our uart will use for data transmission
    # We can set the word size to 8bits by writing to the word length select bits in the
    # LCR (these are bits 0 and 1). If we set both bits to 1, then our word length will
    # be 8 bits
    #

    li t1, 0x03
    ld t0, UART_LCR_REG
    sb t1, 0(t0)


    #
    # TODO(beau): I don't understand how the fifo works
    # Now we want to enable the transmit and receive FIFOs. We do this by setting all three
    # of the lowest bits in the FIFO Control Register (FCR) to 1. The first bit in the FCR
    # is the FIFO Enable bit, the second is the RCVR FIFO reset bit, and the third bit is
    # the XMIT FIFO reset bit.
    #

    li t1, 0x07
    ld t0, UART_LCR_REG
    sb t1, 0(t0)

    #
    # lets enable interrupts incoming characters -- first bit in uart ier
    #

    li t1, 1
    ld t0, UART_IER_REG
    sb t1, 0(t0)

    #
    # lets enable interrupts from the uart source on the plic 
    #

    li t1, 1
    ld t2, UART_IRQ
    sll t1, t1, t2     # t1 holds the mask for uart irq

    ld t0, PLIC_M_ENABLE_REG
    lw t0, 0(t0)       # t0 holds the current value in PLIC_M_ENABLE_REG

    or t1, t1, t0      # t1 holds the new enable value with the uart bit set

    ld t0, PLIC_M_ENABLE_REG
    sw t1, 0(t0)

    #
    # Let's set the priority for uart interrupts to 1 on the PLIC so that UART interrupts
    # get through our hart threshold on the plic
    #

    li t1, 0x1
    ld t0, PLIC_UART_PRI_REG
    sw t1, 0(t0)


    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller

#
# Function to Write a character
#

.globl uart_put_character
uart_put_character:
    # Function prologue
    addi sp, sp, -8       # Allocate space on the stack
    sd ra, 0(sp)          # Save return address

    # Access the function argument
    mv t3, a0             # Move argument to a temporary register

    #
    # test the Transmitter Holding Register bit of the Line Status Register.
    # This bit tells us if the transmitter is ready for more bytes. If that bit
    # is 0, then we are not ready to transmit, so we need to spin for longer
    #

uart_put_character__test_ready:    
    ld t0, UART_LSR_REG
    lb t1, 0(t0)

    # Shift right by 5 bits to isolate the 6th bit
    srli t1, t1, 5
    # AND with 1 to clear all other bits except the 6th bit
    andi t1, t1, 1
    # if that 5th bit is zero, jump back to our test
    beqz t1, uart_put_character__test_ready


    #
    # Transmit our character! (first argument that we stored in t3)
    #

    ld t0, UART_THR_REG
    sb t3, 0(t0)

    # Function epilogue
    ld ra, 0(sp)          # Restore return address
    addi sp, sp, 8        # Deallocate space on the stack
    jr ra                 # Return to the caller

