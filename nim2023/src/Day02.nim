import ../../../AoCLib/src/constants
import std/strutils
import std/sequtils
import std/strformat
import std/tables

#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 
const Today                                     : string = "\\2023\\Day02.txt"

type 
    State = object
        Data                                    : OrderedTable[int,seq[seq[seq[string]]]]
        Criteria                                : seq[int]

    Colour = enum
        red = 0,
        green = 1,
        blue = 2,

var s                                           : State

let 
    redCount = 12
    greenCount = 13
    blueCount = 14
    ballColour = 1
    ballCount = 0
   
proc initialise() =

    var tmpData :seq[seq[seq[seq[string]]]] = (AoCData & Today)
        .lines
        .toseq
        .mapIt(it.multireplace(("Game ",""),(": ",";"),("; ",";"),(", ",",")))
        .mapIt(it.split(";").mapIt(it.split(",").mapIt(it.split(" "))))
   
    # convert tmpData to a table of int vs seq[seq[seq[string]] ie GameId vs seq of games
    var tmpTable = initOrderedTable[int,seq[seq[seq[string]]]]()
    for myBalls in tmpData.items:
        tmpTable[myBalls[0][0][0].parseint]=myballs[1 .. ^1]
        
    s = State(Data: tmpTable, Criteria: @[redCount, greenCount, blueCount])
    

proc isGamePossible( ipPulls: seq[seq[seq[string]]]): bool =
    var myBalls = @[0,0,0]
    for myPull in ipPulls:
        for myBall in myPull:
            var mycolour= myball[ballcolour]
            var myCount = myBall[ballcount].parseInt
            case myColour
                of $red:
                    myBalls[red.ord] = myCount.max(myBalls[red.ord])
                of $green:
                    myBalls[green.ord] = myCount.max(myBalls[green.ord])
                of $blue:
                    myBalls[blue.ord] = myCount.max(myBalls[blue.ord])
    
    for myIndex in Colour:
        if s.Criteria[myIndex.ord] < myBalls[myIndex.ord]:
            return false

    return true


proc gamePower(ipPulls:seq[seq[seq[string]]]): int =
    # multiplication of elements of myBalls required the int declaration to avoud the calclulation resulting in a float.
    var myBalls:seq[int] = @[0,0,0]
    for myPull in ipPulls:
        for myBall in myPull:
            var mycolour= myball[ballcolour]
            var myCount = myBall[ballcount].parseInt
            case myColour
                of $red:
                    myBalls[red.ord] = myCount.max(myBalls[red.ord])
                of $green:
                    myBalls[green.ord] = myCount.max(myBalls[green.ord])
                of $blue:
                    myBalls[blue.ord] = myCount.max(myBalls[blue.ord])
    return myBalls[red.ord] * myBalls[blue.ord] * myBalls[green.ord]

    

proc part01() =
    # initialse sets up s.data as a Table of game Id(int) vs seq of games, where each game is a table of game no vs sequences of 'number','colour'
    # To determine if a game is possible we have to determine the maximum number of balls of each colour ovr the number of pulls for each game
    # if any one colour exceeds its maximum the game is not possible.
    initialise()
    var myResult = 0
    for myKey, myPulls in s.Data:
        if isGamePossible(myPulls):
            myResult += myKey

    echo fmt"The answer to Day {Today[9 .. 10]} Part 01 is 2913. Found is {myResult}"   
    

proc part02() =
    # part2 requires the sum of the products of the maximum number of balls found in each game
    initialise()
    var myResult:int = 0
    for myKey, myPulls in s.Data:
        myresult += gamePower(myPulls)
    
    echo fmt"The answer to Day {Today[9 .. 10]} Part 02 is 55593. Found is {myResult}"   


proc execute*() = 
    part01()
    part02()