

#############################################################################
# SECTION: DATA
# Static Data
#############################################################################

.section .data


# these offsets only act as these registers when the divisor latch access bit
# is set in the LCR
.equ UART_DLL_OFFSET, 0 # divisor latch least significant byte register
.equ UART_DLM_OFFSET, 1 # divisor latch most significant byte register

.equ UART_RBR_OFFSET, 0 # receive buffer register (read only)
.equ UART_THR_OFFSET, 0 # transmitter holding register (write only)
.equ UART_IER_OFFSET, 1 # interrupt enable register
.equ UART_IIR_OFFSET, 2 # interrupt identify register (only is IIR when writing)
.equ UART_FCR_OFFSET, 2 # fifo control register (only is FCR when writing)
.equ UART_LCR_OFFSET, 3 # line control register
.equ UART_LSR_OFFSET, 5 # line status register

.globl UART_BASE
UART_BASE:
    .dword 0x10000000

.globl STACK_BASE
STACK_BASE:
    .dword 0x80008000
