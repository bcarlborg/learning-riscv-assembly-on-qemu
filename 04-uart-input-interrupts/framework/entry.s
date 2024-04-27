#############################################################################
# External Symbols
# symbols that will be defined in a different part of the project
#############################################################################

.extern _start
.extern STACK_BASE

#############################################################################
# SECTION: .text.entry
# The program
#############################################################################

# .section .text.entry tells the assembler that everything following this directive
# belongs in the .text.entry section of the object file
.section .text.entry

.global _entry
_entry:
    #
    # initialize our stack
    # Set the stack pointer to 0x80008000
    #
    ld sp, STACK_BASE

    j _start
