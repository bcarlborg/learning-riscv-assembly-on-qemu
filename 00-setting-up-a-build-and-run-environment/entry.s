    # .section .text.entry tells the assembler that everything following this directive
    # belongs in the .text.entry section of the object file
    .section .text.entry

    # .global _entry the assembler that this symbol is visible in other files
    .global _entry

_entry:
    # Load immediate values into registers a0 and a1
    li a0, 10    # Load the first number (10) into register a0
    li a1, 20    # Load the second number (20) into register a1

    # Add the numbers in a0 and a1; store the result in a1
    add a1, a0, a1

    # Normally, you would have an exit syscall here for a standalone program
    # For simplicity, this example ends without a system call to exit

.text
    # other programs can go here

# TODO: get end symbol into assembly somehow. Is that how we get the stack?
# TODO: does qemu put the stack here?
