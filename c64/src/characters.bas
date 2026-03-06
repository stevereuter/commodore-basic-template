# This file contains code to copy characters from the ROM to RAM and set up the VIC to use them.
# by default this copies the entire character set, but you could modify it to only copy the characters you need for your game.
# WARNING: this is slow, so it's best to only copy the characters you need.


# Stop Interrupts
poke 56334, peek(56334) and 254

# Reveal Character ROM (CPU sees ROM at $D000)
poke 1, 51

# Copy main characters from ROM to RAM
# default characters, both sets
for i=0 to 1023*8
    c=peek(53248+i)
    poke 49152+i, c
next

# Restore I/O and BASIC
poke 1, 55
poke 56334, peek(56334) or 1

# Switch VIC to Bank 3
poke 56576, peek(56576) and 252

# Set Screen to 52224 and Chars to 49152
poke 53272, 48

# Tell BASIC the screen moved
poke 648, 204

# add custom characters from data.bas, this is only the first character @
# for i=49152 to 49152+7
#     read c
#     poke i,c
# next
