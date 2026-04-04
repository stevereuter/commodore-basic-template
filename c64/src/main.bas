# This is the main file for the c64 game. It includes all the other files and runs the main loop.
print "{clr}game title v###VERSION### c64"
print "by steviesaurus dev"
print "loading..."

#include "variables.bas"
#include "characters.bas"

# TODO: temporary end so that I can view the sprite
# green background
poke 53281, 5
# brown border
poke 53280, 9

print "{clr}{brown}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}{down}"
# show characterset
for i=. to 255
  poke 52224+i, i
next
# sprite 0  moving across the screen
x=334
xm=255
x1=0
x2=-1
for i=x to 0 step -1
    x1=i
    if i>255 then x1=i-255
    poke 53248, x1
    if i=x1 then if x2 then poke 53264, peek(53264) and 254:x2=0
next
poke 53269, peek(53269) and 254
end

start:
#include "intro.bas"

# load game
#include "gameLoad.bas"

# main loop
#include "gameLoop.bas"

# game over
#include "gameOver.bas"
goto start
end

#include "subroutines.bas"
#include "data.bas"
