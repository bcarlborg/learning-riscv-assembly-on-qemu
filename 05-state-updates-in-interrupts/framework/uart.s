
#############################################################################
# SECTION: DATA
# Static Data
#############################################################################

.section .data

uart_receive_ring_buffer:
    .zero 1024

receive_ring_buffer_producer_offset:
    .dword 0

receive_ring_buffer_consumer_offset:
    .dword 0


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

.globl read_character

# TODO: probably need to stop interrupts during this block
# TODO: I think the way I am loading values from 
read_character:

    # function prologue
    addi sp, sp, -24 # allocate space on the stack for the return address and frame pointer
    sd ra, 16(sp)        # save the return address
    sd s0, 8(sp)
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 24 # set a new frame pointer

    jal disable_interrupts

    ld t1, receive_ring_buffer_consumer_offset

    ld t2, receive_ring_buffer_producer_offset

    # If our producer and consumer pointers are at the same offset,
    # then there are no characters to read
    beq t1, t2, read_character__no_chars_to_read  

    la t0, uart_receive_ring_buffer
    ld t1, receive_ring_buffer_consumer_offset

    add t0, t0, t1     # t0 holds ring buffer base + offset (i.e. the address our character is at)
    ld a0, 0(t0)       # a0 holds the character we are reading

    jal increment_consumer_offset

    j read_character__exit

read_character__no_chars_to_read:
    li a0, 1

read_character__exit:

    jal enable_interrupts

    # Epilogue
    ld ra, 16(sp)     # Restore return address
    ld s0, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 24  # Deallocate stack space
    ret              # Return to caller

#
# Increment the consumer offset
#
.globl increment_consumer_offset
increment_consumer_offset:
    # function prologue
    addi sp, sp, -24 # allocate space on the stack for the return address and frame pointer
    sd ra, 16(sp)        # save the return address
    sd s0, 8(sp)
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 24 # set a new frame pointer

    ld t1, receive_ring_buffer_consumer_offset # t1 contains the consumer offset

    addi t1, t1, 1          # t1 contains the new consumer offset

    li t0, 1024

    # If our offset is not at the end of the ring buffer, we can just store this new offset
    blt t1, t0, increment_consumer_offset__store_new_offset  

    # If our offset is at or past the end of the array, we set it back to 0
    li t1, 0
    
increment_consumer_offset__store_new_offset:
    la t0, receive_ring_buffer_consumer_offset
    sb t1, 0(t0)

    # Epilogue
    ld ra, 16(sp)     # Restore return address
    ld s0, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 24  # Deallocate stack space
    ret              # Return to caller

#
# Increment the producer offset
#
.globl increment_producer_offset
increment_producer_offset:
    # function prologue
    addi sp, sp, -24 # allocate space on the stack for the return address and frame pointer
    sd ra, 16(sp)        # save the return address
    sd s0, 8(sp)
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    ld t0, receive_ring_buffer_producer_offset # t1 contains the producer offset

    addi t1, t0, 1          # t1 contains the new producer offset

    li t0, 1024

    # If our offset is not at the end of the ring buffer, we can just store this new offset
    blt t1, t0, increment_producer_offset__store_new_offset  

    # If our offset is at or past the end of the array, we set it back to 0
    li t1, 0
    
increment_producer_offset__store_new_offset:
    la t0, receive_ring_buffer_producer_offset
    sb t1, 0(t0)

    # Epilogue
    ld ra, 16(sp)     # Restore return address
    ld s0, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 24  # Deallocate stack space
    ret              # Return to caller


#
# Interrupt handler for external interrupts from the PLIC
#
.globl handle_uart_interrupt
handle_uart_interrupt:
    # function prologue
    addi sp, sp, -24 # allocate space on the stack for the return address and frame pointer
    sd ra, 16(sp)        # save the return address
    sd s0, 8(sp)
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 24 # set a new fram pointer

    call read_uart_chars_until_buffer_empty

    # Epilogue
    ld ra, 16(sp)     # Restore return address
    ld s0, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 24  # Deallocate stack space
    ret              # Return to caller


#
# Read Uart chars until buffer is empty
#
read_uart_chars_until_buffer_empty:
    # function prologue
    addi sp, sp, -24 # allocate space on the stack for the return address and frame pointer
    sd ra, 16(sp)        # save the return address
    sd s0, 8(sp)
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 24 # set a new fram pointer


read_uart_chars_until_buffer_empty__start:

    #
    # Read the line status register to figure out what we can do.
    # Are we ready to transmit a character? or to read one? both?
    #

    ld t0, UART_LSR_REG
    lb t1, 0(t0)

    li t0, 1
    and t0, t1, t0       # t0 has the first bit in the lsr register
                         # which is the data ready bit, tell us if
                         # a byte is received

    # t0 == 0, then exit... there are no chars to read
    beq t0, x0, read_uart_chars_until_buffer_empty__end 

    ld t0, UART_RBR_REG
    lb s0, 0(t0)          # s0 holds the byte we read from the receive buffer

    la t0, uart_receive_ring_buffer

    ld t1, receive_ring_buffer_producer_offset

    add t0, t0, t1        # t0 contains the address where we should add the next character
                          # to our ring buffer

    sb s0, 0(t0)          # write the character we read into the received buffer

    jal increment_producer_offset

    # jal uart_put_character

    j read_uart_chars_until_buffer_empty__start 

read_uart_chars_until_buffer_empty__end:


    # Epilogue
    ld ra, 16(sp)     # Restore return address
    ld s0, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 24  # Deallocate stack space
    ret              # Return to caller

