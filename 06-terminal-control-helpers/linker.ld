/****************************************************************************
 *
 * This linker script is passed to ld in our build process (see our makefile). The 
 * linker script gives the linker additional information about where to place the data
 * from our input object fils in the output executable.
 *
 ****************************************************************************/

OUTPUT_ARCH( "riscv" )
ENTRY( _entry )

/*
 * Define the memory layout and specify that our ram begins at 0x80000000
 * note that this address is not something we have control over, qemu defines
 * this as the location of ram for the virt board on riscv
 */
MEMORY
{
    RAM (wx) : ORIGIN = 0x80000000, LENGTH = 128M
}

/*
 * We will load all sections into RAM. Our output executable will only have
 * a .text section
 */
SECTIONS
{

    /*
    * . is a variable that indicates the current address we are outputing data
    * in our executable to. By setting . to 0x80000000 before we specify any
    * sections, we are ensuring that our sections will start at that address.
    * note that this address is not something we have control over, qemu defines
    * this as the location of ram for the virt board on riscv
    */
    . = 0x80000000;


    /*
     * Place the output .text section at the beginning of RAM
     * Our output .text seciont will contain any text or rodata sections
     * from our input
     */
    .text : {
        /*
         * qemu starts execution right at the beginning of our text section, so we want
         * to have .text.entry before anything else
         */
        *(.text.entry)
        *(.text)
    }

    /*
     * word align the current location
     */
    . = ALIGN(8);

    /*
     * Place the data section for static variables right after our program
     */
    .data : {
        *(.data)
    }


    /*
     * word align the current location
     */
    . = ALIGN(8);


    /*
     * PROVIDE() will export a symbol that we assign here for use in our programs.
     * Sometimes it is useful for a program to know the last address of its data
     * its executable
     */
    PROVIDE(end = .);
}
