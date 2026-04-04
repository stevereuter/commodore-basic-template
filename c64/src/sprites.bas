# This file contains code to add sprites to the game. It is included in main.bas and run at the start of the game. It also requires sprite data to be referenced in data.bas.

# Start sprite writing
# Sprite number from 1 to 7
sn=0
# Sprite 0 pointer is at screen_base+1016 (52224+1016=53240).
# Pointer value is offset/64 from VIC bank start: (51200-49152)/64 = 32.
poke 53240, 32

# Sprite data must live in RAM inside the active VIC bank.
# Using 51200 ($C800) keeps it in Bank 3 and avoids VIC register space at $D000.
for i=51200 to 51200+63-1
    read c
    poke i,c
next

# Enable sprite 0 (bit 0 of $D015 / 53269).
poke 53269, peek(53269) or (2^sn)

# Place sprite 0 on-screen and give it a visible color.
# Set X position
poke 53248, 80
# for x position greater than 255, set bit relative to sprite to 1, and start back at zero on the line above
poke 53264, peek(53264) or (2^sn)
# Set Y position
poke 53249, 120
# Set sprite 0 color (bit 0-3 of $D027 / 53287).
poke 53287, 1

# For resizing the sprite
# x double-width on
poke 53277, peek(53277) or (2^sn)
# y double-height on
poke 53271, peek(53271) or (2^sn)
