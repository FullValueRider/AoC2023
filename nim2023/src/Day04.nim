import ../../../AoCLib/src/constants
import std/strutils
import std/strformat
import std/sequtils
import std/tables
#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 
const Today                                     : string = "\\2023\\Day04.txt"


type 
    State = object
        Data                                    : OrderedTable[string,seq[seq[string]]]

var s                                           : State


proc initialise() =
    var myData =(AoCData & Today)
        .lines
        .toSeq
        .mapIt(it.multireplace(("   "," "),("  "," "),(": ","|"), (" | ","|")))
        .mapIt(it.split("|"))
    echo fmt"{myData[0]}"
    echo fmt"{myData.len}"
    
    s= State(Data : initOrderedTable[string,seq[seq[string]]]())
    for myCard in myData:
        s.Data[myCard[0].replace("  "," ")] = @[myCard[1].split(" "), myCard[2].split(" ")]
        # echo fmt" myCard {myCard[0]}, s.Data[myCard[0]] {s.Data[myCard[0]]}"
        
 
proc winningNumbers( ipSeq: seq[seq[string]]): int =
    result = 0
    for myNumber in ipSeq[0]:
        if myNumber in ipSeq[1]:
            result += 1


proc score( ipNumber : int): int =

    if ipNumber < 2:
        return ipNumber

    result = 1

    for myCount in 2 .. ipNumber:
        result *= 2


proc part01() =

    initialise()

    var myResult:int = 0
    for myKey, myNumbers in s.Data:
        myResult += score(winningNumbers(myNumbers))
        
    echo fmt"The answer to Day {Today[9 .. 10]} Part 01 is 15268. Found is {myResult}"   
    

proc part02() =

    initialise()

    var myResult:int = 0
    var mySumcards : seq[(string, seq[seq[string]])]
    for myKey, myNumbers in s.Data:
        mySumCards.add( (myKey, s.Data[myKey]) )

    var myIndex :int = 0
    while myIndex <= mySumCards.high:

        var myWins = winningNumbers(s.Data[mySumCards[myIndex][0]])
        if myWins > 0:
            # echo fmt"myWins {myWins}"
            var myCardNo = (mySumCards[myIndex][0].split(" "))[1].parseInt
            for myOffset in 1 .. myWins:
                
                var myKey : string = "Card " & $(myOffset + myCardNo)
                # echo fmt("Adding card {myKey}")
                mySumCards.add( (myKey, s.Data[myKey]) )

        myIndex += 1
        #echo fmt"myIndex {myIndex}, myLen {mySumCards.len}"
        # if myIndex > 1999:
        #     break
        
    myResult = mySumCards.len

    echo fmt"The answer to Day {Today[9 .. 10]} Part 02 is 54087. Found is {myResult}"   

proc execute*() = 

    #part01()
    part02()