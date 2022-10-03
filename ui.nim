import cards

proc printHand(p: ptr Player): void =
    for i in 0..<p.hand.len:
        stdout.write i
        stdout.write ". "
        stdout.write p.hand[i].name
        stdout.write "  "

    stdout.write '\n'

import strutils
import terminal
while true:
    eraseScreen()
    echo "player 0 score: ", player0.score
    echo "player 1 score: ", player1.score
    addr(player0).printHand()
    addr(player1).printHand()

    echo "player 0 enter card:"
    var index0 = readLine(stdin)

    eraseScreen()
    echo "player 0 score: ", player0.score
    echo "player 1 score: ", player1.score
    addr(player0).printHand()
    addr(player1).printHand()

    echo "player 1 enter card:"
    var index1 = readLine(stdin)
    
    setCardPlayed(parseInt(index0), parseInt(index1))
    
    playBothEffects()

    fight()
    
    if gameover:
        echo "player 0 score:"
        echo player0.score
        echo "player 1 score:"
        echo player1.score
        echo "Press enter to exit"
        discard readLine(stdin)
        break;