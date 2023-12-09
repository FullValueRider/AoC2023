import ../../../AoCLib/src/constants
#import ../../../AoClib/src/chars
import std/strutils
import std/sequtils
import std/strformat
#import std/tables
#import std/sugar
#import std/math
import tools

const Today                         : string = "\\2023\\Day09.txt"
    
type 

    State = object 
       Data                         : seq[seq[int]]

var s                               : State

proc initialise() =
        
    var myData = (AoCData & Today)
        .lines.toSeq
        .mapit(it.split(" ")
        .mapit(it.parseint))
    
    s = State(Data: myData)

proc part01() =

    initialise()

    var myResult: int = 0
    
    for myItem in s.Data:
        var myDeltas: seq[seq[int]] 
        myDeltas.add(myItem)

        while myDeltas.last.areSame(0) == false:
            myDeltas.add(myDeltas.last.delta)

        var myHigh = myDeltas.high
        for myIndex in countdown(myHigh, 0):
            if myIndex == myDeltas.high:
                myDeltas[myIndex].add(0)
            else:
                myDeltas[myIndex].add( myDeltas[myIndex + 1].last + myDeltas[myIndex].last)

        myResult += myDeltas.first.last

    echo fmt"The answer to Day {Today[9 .. 10]} part 1 is 1798691765.  Found is {myResult}"
        
    
proc part02() =
    
    initialise()

    var myResult: int = 0
    
    for myItem in s.Data:
        var myDeltas: seq[seq[int]] 
        myDeltas.add(myItem)

        while myDeltas.last.areSame(0) == false:
            myDeltas.add(myDeltas.last.delta)

        for myIndex, mySeq in myDeltas:
            if myIndex == myDeltas.high:
                myDeltas[myIndex].insert(0,0)
            else:
                myDeltas[myIndex].insert(  myDeltas[myIndex].first - myDeltas[myIndex + 1].first , 0)

        myResult += myDeltas.first.first
        
    echo fmt"The answer to Day {Today[9 .. 10]} part 1 is 1104.  Found is {myResult}"

     
proc execute*() = 
    part01()
    part02()