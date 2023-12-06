import ../../../AoCLib/src/constants
import std/strutils
import std/strformat
import std/sequtils


#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 
const Today                                     : string = "\\2023\\Day05.txt"


type 
    State = object
        Seeds                                   : seq[int]
        Maps                                    : seq[seq[seq[int]]]
var s                                           : State


proc initialise() =
    var tmpData =  (AoCData & Today).readFile.split("\r\n\r\n")
    
    var tmpSeeds = tmpData[0].split(" ")[1 .. ^1].mapIt(it.parseInt)
    
    var tmpMaps = tmpData[1 .. ^1].mapIt(it.split("\r\n")[1 .. ^1].mapIt(it.split(" ").mapIt(it.parseInt)))
    s= State( Seeds : tmpSeeds, Maps: tmpMaps)


proc getSeedLocation( ipSeed : int64 ): int64 =
    #echo fmt"New Seed"
    var myLoc : int64 = ipSeed
    for myMap in s.Maps:
       # echo fmt"New Map"
        for myRow in myMap:
           # echo fmt"myLoc {myLoc} myRow {myRow}"
            var tmpLoc = myLoc
            if myLoc in myRow[1] .. (myRow[1] + myRow[2] - 1):
                 
                myLoc =  myLoc - myRow[1] + myRow[0]
                break
            
                #echo fmt"Pass {myLoc}"
            #echo fmt"output myloc {myLoc}"
       # echo fmt" "
    return myLoc

proc part01() =
    initialise()
    var myResult:int64 = 0x7FFFFFFFFFFFFFFF
    
    for mySeed in s.Seeds:
        var myLoc: int64 = getSeedLocation( mySeed)
        #echo fmt"mySeed {mySeed}, myLoc {myLoc}"
        myResult = if myLoc < myResult: myLoc else: myResult

    echo fmt"The answer to Day {Today[9 .. 10]} Part 01 is 227653707. Found is {myResult}"   
    

proc part02() =
    # need to convert seeds to range pairs
    initialise()
    var myResult:int64 = 0x7FFFFFFFFFFFFFFF
    
    for myIndex in countup(s.Seeds.low, s.Seeds.high-1,2):
        for mySeed in s.Seeds[myIndex] .. s.Seeds[myIndex]+s.Seeds[myIndex+1]:
            var myLoc: int64 = getSeedLocation( mySeed)
            myResult = if myLoc < myResult: myLoc else: myResult

    echo fmt"The answer to Day {Today[9 .. 10]} Part 02 is 54087. Found is {myResult}"   

proc execute*() = 

    part01()
    part02()