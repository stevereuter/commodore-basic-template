# main game loop, use for loop as it's faster than goto
for gl=zr to lm
    print gl;",";

    # set over to true (-1) to end game, or false (0) to keep going
    ov=0
    # if game over, set loop to max to end game
    if ov then gl=lm:goto gameLoopDone

    # game loop can be used as a counter for things like score multiplier, or to trigger events at certain points in the game
    # best to set it back to 0 (use -1 as next will increment) once reached to prevent the game from ending
    # gl=-1

    gameLoopDone:
next
