# This file contains code to add custom characters to the game. It is included in main.bas and run at the start of the game. It also requiresthe custom characters data to be referenced in data.bas.

# we're going to skip loading the characters here if the first one is set, which means this is the second time this has run
if peek(49152)=60 then endCharacterLoading

# Start custom characters writing
# Switch VIC to Bank 3
poke 56576, peek(56576) and 252

# Set Chars to 49152
poke 53272, 48

# Tell BASIC the screen moved
poke 648, 204

#include "loading.bas"

# load the characters into memory
load "chars", 8, 1

endCharacterLoading:
