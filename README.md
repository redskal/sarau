# Sarau
###### _x86asm log wiper for Windows_

A very simple, noisy log wiper for Windows written in good old x86 assembler. I've put the data in the code segment which means the binary created needs the write bit set. Any PE editor will do that. You could probably strip more out to make it even smaller. Currently assembles to a 1650 byte binary.