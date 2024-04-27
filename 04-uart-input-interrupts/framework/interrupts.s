
#############################################################################
# SECTION: .data
# Any statically allocated data can go here
#############################################################################
.section .data

#############################################################################
# SECTION: .text
# the program itself
#############################################################################

.section .text

#
# A function that can be called by other modules to enable interrupts
#

.globl enable_interrupts
enable_interrupts:
    # function prologue
    addi sp, sp, -16    # allocate space on the stack for the return address and frame pointer
    sd ra, 8(sp)        # save the return address
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    #
    # Set mtvec to point to interrupt_vec
    #
    la t0, interrupt_vec
    csrw mtvec, t0


    #
    # enable interrupts from all sources in mie
    #

    li t1, -1           # set t1 to all 1s (-1 is FFFFFFFFFFFFFFFF)
    csrw mie, t1        # set every bit in mie to 1

    #
    # set mstatus.mie to turn on machine mode interrupts
    #

    csrr t1, mstatus        # Read mstatus into x1
    li t2, (1 << 3)         # Load the bit mask for the MIE bit (which is bit 3)
    or t1, t1, t2           # use the mask to set the mie bit
    csrw mstatus, t1        # Write back the modified value to mstatus

    #
    # Set the M mode plic priority to 0 so all interrupts meet the appropriate
    # threshold to trigger an interrupt
    #

    ld t0, PLIC_M_PRI_REG
    sw x0, 0(t0)


    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller

#
# A function that can be called by other modules to disable interrupts
#

.globl disable_interrupts 
disable_interrupts:
    # function prologue
    addi sp, sp, -16    # allocate space on the stack for the return address and frame pointer
    sd ra, 8(sp)        # save the return address
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    #
    # disable mstatus.mie to turn off all interrupts
    #

    csrr t1, mstatus        # Read mstatus into x1
    li t2, ~(1 << 3)         # Load the inverse of the bit mask for the MIE bit (which is bit 3)
    and t1, t1, t2          # Clear the MIE bit
    csrw mstatus, t1        # Write back the modified value to mstatus

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller


#
# the handler that processes every incoming interrupt on the system
#

interrupt_handler:

    # function prologue
    addi sp, sp, -16    # allocate space on the stack for the return address and frame pointer
    sd ra, 8(sp)        # save the return address
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    #
    # check if this is a timer intterupt
    #

    # Read the mcause register
    csrr t0, mcause
    # TODO: need to actually check the top most bit to make sure we aren't dealing with an exception.
    andi t0, t0, 0xFF # we only want the part of the register that has information about 

    # Check if mcause is 7 (Machine Timer Interrupt)
    li t1, 7
    bne t0, t1, interrupt_handler__not_timer_interrupt # if not 7, jump over call to handle_timer_interrupt

    # Call the handler function if mcause is 7
    call handle_timer_interrupt

interrupt_handler__not_timer_interrupt:

    # Check if mcause is 11 (Machine External Interrupt)
    li t1, 11
    bne t0, t1, interrupt_handler__not_external_interrupt # if not 11, jump over call to handle_timer_interrupt

    # Call the handler function if mcause is 7
    call handle_external_interrupt

interrupt_handler__not_external_interrupt:

    # todo, add checks for other interrupt types here

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller


#
# handler for external interrupts, we need to claim an interrupt on the plic to figure
# out what caused the interrupt
#

handle_external_interrupt:
    # function prologue
    addi sp, sp, -16    # allocate space on the stack for the return address and frame pointer
    sd ra, 8(sp)        # save the return address
    sd fp, 0(sp)        # save the frame pointer
    addi fp, sp, 16     # set a new fram pointer

    # claim
    ld t0, PLIC_M_CLAIM_REG
    lw t1, 0(t0)        # t1 has the interrupt cause

    // TODO: check if t1 is 10, if so then call uart_interrupt

    # complete
    ld t0, PLIC_M_CLAIM_REG
    sw t1, 0(t0)

    # Epilogue
    ld ra, 8(sp)     # Restore return address
    ld fp, 0(sp)     # Restore frame pointer
    addi sp, sp, 16  # Deallocate stack space
    ret              # Return to caller


#
# The label we jump to when an interrupt happens
#

interrupt_vec:
    # make room to save registers.
    addi sp, sp, -256

    # save the registers.
    sd ra, 0(sp)
    sd sp, 8(sp)
    sd gp, 16(sp)
    sd tp, 24(sp)
    sd t0, 32(sp)
    sd t1, 40(sp)
    sd t2, 48(sp)
    sd s0, 56(sp)
    sd s1, 64(sp)
    sd a0, 72(sp)
    sd a1, 80(sp)
    sd a2, 88(sp)
    sd a3, 96(sp)
    sd a4, 104(sp)
    sd a5, 112(sp)
    sd a6, 120(sp)
    sd a7, 128(sp)
    sd s2, 136(sp)
    sd s3, 144(sp)
    sd s4, 152(sp)
    sd s5, 160(sp)
    sd s6, 168(sp)
    sd s7, 176(sp)
    sd s8, 184(sp)
    sd s9, 192(sp)
    sd s10, 200(sp)
    sd s11, 208(sp)
    sd t3, 216(sp)
    sd t4, 224(sp)
    sd t5, 232(sp)
    sd t6, 240(sp)

    call interrupt_handler

    # restore registers.
    ld ra, 0(sp)
    ld sp, 8(sp)
    ld gp, 16(sp)
    # not tp (contains hartid), in case we moved CPUs
    ld t0, 32(sp)
    ld t1, 40(sp)
    ld t2, 48(sp)
    ld s0, 56(sp)
    ld s1, 64(sp)
    ld a0, 72(sp)
    ld a1, 80(sp)
    ld a2, 88(sp)
    ld a3, 96(sp)
    ld a4, 104(sp)
    ld a5, 112(sp)
    ld a6, 120(sp)
    ld a7, 128(sp)
    ld s2, 136(sp)
    ld s3, 144(sp)
    ld s4, 152(sp)
    ld s5, 160(sp)
    ld s6, 168(sp)
    ld s7, 176(sp)
    ld s8, 184(sp)
    ld s9, 192(sp)
    ld s10, 200(sp)
    ld s11, 208(sp)
    ld t3, 216(sp)
    ld t4, 224(sp)
    ld t5, 232(sp)
    ld t6, 240(sp)

    addi sp, sp, 256

    # return to whatever we were doing before the interrupt
    mret



