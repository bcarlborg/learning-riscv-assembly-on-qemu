    # .section .text.entry tells the assembler that everything following this directive
    # belongs in the .text.entry section of the object file
    .section .text.entry

    # .global _entry the assembler that this symbol is visible in other files
    .global _entry

_entry:
    j _entry
