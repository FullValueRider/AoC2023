import ../../../AoCLib/src/constants
import ../../../AoClib/src/chars
import std/strutils
import std/sequtils
import std/strformat
import std/tables
import std/sugar
import std/math
const Today                         : string = "\\2023\\Day08.txt"
    
type 

    State = object 
        LR                          : string
        Map                         : Table[string,seq[string]]
        EndSteps                    : seq[int]

var s                               : State

proc initialise() =
        
    var myData = (AoCData & Today).readfile.split("\r\n\r\n")
    
    var myMap  = myData[1]
        .multireplace([("(",""),($(chars.twRParen), ""),("=",$chars.twcomma),(" ","")])
        .split("\r\n")
        .mapIt(it.split(","))

   
    var myLocs: Table[string,seq[string]]

    for  myMove  in  myMap:
        myLocs[myMove[0]] = myMove[1 .. ^1]

    s = State(LR: $myData[0], Map: myLocs, EndSteps: @[])
 
proc getStepsToEnd(ipStart :string, ipLastchar = false) : int =
        
    var myLoc = ipStart
    var myResult  = 0
    while true:
     
        for myMove in s.LR:
            if myMove == 'R':
                myLoc = s.Map[myLoc][1]
            else:
                myLoc = s.Map[myLoc][0]
            
            myResult += 1
            
            if ipLastchar:
                if myLoc[^1] == 'Z' :
                    return myResult
            else:
                if myLoc == "ZZZ" :
                    return myResult
               
            
proc part01() =

    initialise()

    var myLoc = "AAA"
    var myResult: int = 0
    block Maps:
        while true:
            
            for  myMove  in  s.LR:
                if myMove == 'R' :
                    myLoc = s.Map[myLoc][1]
                else:
                    myLoc = s.Map[myLoc][0]
                
                myResult += 1
                
                if myLoc == "ZZZ" :
                    break Maps
        
    echo fmt"The answer to Day {Today[9 .. 10]} part 1 is 14257.  Found is {myResult}"
        
    
proc part02() =
    
    initialise()
    
    var myResult = 0
    let myAnodes = collect:
        for myKey, myItem in s.Map:
            if myKey[^1] == 'A': myKey

    for myNode in myAnodes:
        s.Endsteps.add( getStepsToEnd( myNode, true))

    myresult = s.Endsteps.lcm

    echo fmt"The answer to Day {Today[9 .. 10]} part 1 is 14257.  Found is {myResult}"

     
proc execute*() = 
    part01()
    part02()
                   
