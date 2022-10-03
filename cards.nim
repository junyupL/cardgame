#game mechanics
#setcardplayed, play effects, fight, repeat until game ends 

import winConditions

type
    Card = object
        name*: string
        power: int
        effect: proc(c: ptr Player): void
    Player* = object
        hand*: seq[Card]
        effects: seq[proc(c: ptr Player): void]
        score*: int
        playedIndex: int


var scoreIncrease = 1

template played(p: Player): untyped = p.hand[p.playedIndex]
#template `played=`(p: Player; v: ptr Card): untyped = 

proc playEffects(p: ptr Player): void =
    for effect in p.effects:
        effect(p)
    p.effects = @[]
    
    p[].played.effect(p)



var gameWinConds: seq[proc(power0, power1: int): int] = @[(proc(power0, power1: int): int)higherWins]

proc extraScore(p: ptr Player): void =
    scoreIncrease += 1

proc addPower[power: static int](p: ptr Player): void =
    p[].played.power += power


template addEffectnextturn(effectToAdd: proc(p: ptr Player): void): proc(p: ptr Player): void =
    (proc(p: ptr Player): void = p.effects.add effectToAdd)

template addWinCondition(winCond: proc(power0, power1: int): int): proc(p: ptr Player): void =
    (proc(p: ptr Player): void = gameWinConds.add winCond)


const supporter = Card(name: "Supporter", power: 1, effect: addEffectnextturn(addPower[2]))
const lord = Card(name: "Lord", power: 4, effect: proc(c: ptr Player): void = return)
const jester = Card(name: "Jester", power: 2, effect: addWinCondition(lowerWins))
const peasant = Card(name: "Peasant", power: 0, effect: addWinCondition(specificpowerloses[4]))
const gambler = Card(name: "Gambler", power: 3, effect: extraScore)

proc newPlayer(): Player =
    Player(hand: @[
        supporter,
        peasant,
        jester,
        gambler,
        lord
        ], score: 0)

var player0* = newPlayer()
var player1* = newPlayer()
var gameover* = false

proc fight*(): void =
    while true:
        let winner = gameWinConds.pop()(player0.played.power, player1.played.power)

        if winner == 0:
            player0.score += scoreIncrease
            break
        elif winner == 1:
            player1.score += scoreIncrease
            break
        elif gameWinConds.len == 0:
            break

    player0.hand.delete player0.playedIndex
    player1.hand.delete player1.playedIndex
    scoreIncrease = 1
    
    gameWinConds = @[(proc(power0, power1: int): int)higherWins]
    if player0.hand.len == 0:
        gameover = true


proc setCardPlayed*(index0: int, index1: int): void =
    player0.playedIndex = index0
    player1.playedIndex = index1

proc playBothEffects*(): void =
    addr(player0).playEffects
    addr(player1).playEffects