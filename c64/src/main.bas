# This is the main file for the c64 game. It includes all the other files and runs the main loop.
print "{clr}game title v1.0.0"
print "by steviesaurus dev"
print "loading..."

#include "variables.bas"
#include "characters.bas"

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
