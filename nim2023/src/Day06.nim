import ../../../AoCLib/src/constants
import std/strutils
import std/strformat
import std/sequtils
import std/math
#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 
const Today                                     : string = "\\2023\\Day06.txt"


type 
    State = object
        Data                                    : seq[(int,int)]

var s                                           : State


proc initialise() =
    var myData =  (AoCData & Today).readFile.split("\r\n")
    var myTimes =myData[0].splitWhitespace()[1 .. ^1].mapIt(it.parseInt)
    var myDist = myData[1].splitWhiteSpace()[1 .. ^1].mapIt(it.parseInt)
    s = State(Data : myTimes.zip(myDist))
    

proc getPushRange(ipTup: (int,int)):int =

    var myTime = ipTup[0]
    var myDist = -ipTup[1]
    
    var myRoot = sqrt((myTime^2).float64 - 4.float64 * (-1.float64) * (myDist.float64))
    var myMinPress = (((-myTime.float64) + myRoot.float64) / (-2.float64))
    var myMaxPress = (((-myTime.float64) - myRoot.float64) / (-2.float64))
    # deal with rounding when myMaxPress is an integer value
    if myMaxpress.int.float64 == myMaxpress:
        myMaxPress -= 1.float64

    return  myMaxPress.int - myMinPress.int

proc part01() =
    initialise()
    var myResult:int = 1
    for myTup in s.Data:
        var myPushRange = getPushRange(myTup)
        myResult *= myPushRange

    echo fmt"The answer to Day {Today[9 .. 10]} Part 01 is 781200. Found is {myResult}"   
    

proc part02() =
    initialise()
    
    var myResult:int = 0
    var myTime : string = ""
    var myDist : string = ""
    for myTup in s.Data:
       myTime &= $myTup[0]
       myDist &= $myTup[1]

    myResult = getpushrange((myTime.parseInt, myDist.parseInt))

    echo fmt"The answer to Day {Today[9 .. 10]} Part 02 is 49240091. Found is {myResult}"   

proc execute*() = 

    part01()
    part02()