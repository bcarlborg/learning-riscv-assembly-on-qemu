

#############################################################################
# SECTION: DATA
# Static Data
#############################################################################

.section .data

#
# UART Device
#

.globl UART_BASE
UART_BASE:
    .dword 0x10000000

.globl UART_DLL_REG
UART_DLL_REG:              # divisor latch least significant byte register
    .dword 0x10000000

.globl UART_DLM_REG
UART_DLM_REG:              # divisor latch most significant byte register
    .dword 0x10000001

.globl UART_RBR_REG
UART_RBR_REG:              # receive buffer register (read only)
    .dword 0x10000000

.globl UART_THR_REG
UART_THR_REG:              # transmitter holding register (write only)
    .dword 0x10000000

.globl UART_IER_REG
UART_IER_REG:              # interrupt enable register
    .dword 0x10000001

.globl UART_IIR_REG
UART_IIR_REG:              # interrupt identify register (only is IIR when writing)
    .dword 0x10000002

.globl UART_FCR_REG
UART_FCR_REG:              # fifo control register (only is FCR when writing)
    .dword 0x10000002

.globl UART_LCR_REG
UART_LCR_REG:              # line control register
    .dword 0x10000003

.globl UART_LSR_REG
UART_LSR_REG:              # line status register
    .dword 0x10000005


#
# System Stack
#

.globl STACK_BASE
STACK_BASE:
    .dword 0x80008000
