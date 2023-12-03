import ../../../AoCLib/src/constants
import std/strutils
import std/sequtils
import std/strformat

#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 
const Today                                     : string = "\\2023\\Day03.txt"

type 
    State = object
        Data                                    : seq[string]
        Symbols                                 : seq[char]
        FirstMin                                : int
        FirstMax                                : int
        SecondMin                               : int
        SecondMax                               : int
    
    GearLocation = tuple
        first: int 
        second: int
    
    NumberLocation = tuple
        row: int
        start: int
        fini: int  # because I can't use 'end'

let 
    PERIOD = '.'
    GEAR = '*'


var 
    s                                           : State
    numerals                                    :seq[char] = "0123456789".toseq
    
proc initialise() =

    s= State(Data:  (AoCData & Today).lines.toseq)
    
    # validate that all rows are the same legth
    let mylen = s.Data.len
    for myTest in s.Data:
        if myTest.len != myLen:
            raise newException(ValueError, "Rows not of equal length")
   
    # don't need to convert to array of array of longs

    # scan for symbols and add to symbol table
    for forRow in s.Data:
        for forChar in forRow:
            if forChar == PERIOD:
                continue
            if forChar in numerals:
                continue
            if forChar in s.Symbols:
                continue
            s.Symbols.add(forChar)

    s.FirstMin = s.Data.low
    s.FirstMax = s.Data.high 
    s.SecondMin = s.Data[0].low
    s.SecondMax = s.Data[0].high  
   

proc getNumberList(): seq[NumberLocation]   =

    # declarations here required due to scoping rules of nim
    var myInNumber :bool
    var myFirst: int
    var mySecond: int
    var myStart = 0
    var mySymbols = s.Symbols
    mySymbols.add(PERIOD)
    
    for forFirst in s.Firstmin .. s.FirstMax :

        myfirst = forfirst
        myInNumber = false
        myStart = 0

        for forSecond in s.SecondMin .. s.SecondMax:
            mySecond = forsecond
            var myChar  = s.Data[forFirst][forSecond]
           
            if myInNumber :
                if myChar in mySymbols:
                    result.add( (myFirst, myStart, mySecond - 1) )
                    myStart = 0
                    myInNumber = false
            else:
                if  myChar in numerals:
                    myStart = mySecond
                    myInNumber = true
        
       
        if myInNumber:
        # why is the line below correct without the 'mySecond -1' which is needed in the tb version
        # most likekly a bug in the tb version
            result.add((myFirst, myStart, mySecond ) )
            myStart = 0
            myInNumber = false
    
    return result


proc AdjacentNumber(ipSeq : NumberLocation ): int =

    var myFoundSymbol = false 
    
    # fairly striaghtforward to convert a sub section of an array to a string then int
    var myNumber: int = ( $s.Data[ipSeq[0]][ipSeq.start .. ipSeq.fini]).parseInt
    
    var mySum: int = 0

    let myFirstStart = if ipSeq.row == s.FirstMin: ipSeq.row else: ipSeq.row - 1
    let myFirstEnd = if ipSeq.row == s.FirstMax: ipSeq.row else: ipSeq.row + 1

    let mySecondStart = if ipSeq.start == s.SecondMin: ipSeq.start else: ipSeq.start - 1 
    let mySecondEnd = if ipSeq.fini == s.SecondMax: ipSeq.fini else: ipSeq.fini + 1

    var myFirst: int
    var mySecond: int

    for forFirst in myfirststart .. myfirstend:
        myFirst = forFirst
        
        for forSecond in mySecondStart .. mySecondEnd:
            mySecond = forSecond

            if  s.Data[myFirst][mySecond] in s.Symbols:
                myFoundSymbol = true
                mySum += myNumber

    if myFoundSymbol: 
        return mySum 
    else: 
        return 0


proc getGearList(): seq[GearLocation] =
    
    for forFirst in s.FirstMin .. s.FirstMax:
        for forSecond in s.SecondMin .. s.SecondMax:
            if s.Data[forFirst][forSecond] == GEAR: 
                result.add( ( forFirst,  forSecond))


proc parseNumberv2( ipFirst: int, ipSecond: var int): int =

    var myNumber:string = $s.Data[ipFirst][ipSecond]
    var myLeft: int = ipSecond

    while s.Data[ipFirst][myLeft - 1] in numerals :
        myLeft -= 1
        myNumber = $s.Data[ipFirst][myLeft] & myNumber
        
        if myLeft - 1 < s.SecondMin:
            break

    while  numerals.contains(s.Data[ipFirst][ipSecond + 1]):
        ipSecond   += 1
        myNumber &= $s.Data[ipFirst][ipSecond]
        
        if ipSecond + 1 > s.SecondMax:
            break

    return myNumber.parseInt        


proc gearRatio( ipSeq: GearLocation): int =
    var myGears: seq[int] = @[]

    let myFirstStart = if ipSeq.first == s.FirstMin: ipSeq.first else: ipSeq.first - 1
    let myFirstEnd = if ipSeq.first == s.FirstMax: ipSeq.first else: ipSeq.first + 1
    
    let mySecondStart = if ipSeq.second == s.SecondMin: ipSeq.second else: ipSeq.second - 1
    let mySecondEnd = if ipSeq.second == s.SecondMax: ipSeq.second else: ipSeq.second + 1
 
    var myFirst = myFirstStart
    var mySecond: int

    while myFirst <= myFirstEnd:
        mySecond = mySecondStart

        while mySecond <= mySecondEnd:

            var myChar = s.Data[myFirst][mySecond]
            if numerals.contains(myChar):
                myGears.add( parseNumberv2( myFirst,  mySecond))

            mySecond += 1

        myFirst += 1

    if myGears.len == 2:
        return mygears[0] * myGears[1]
    else:
        return 0


proc part01() =
    # initialse sets up s.data as a Table of game Id(int) vs seq of games, where each game is a table of game no vs sequences of 'number','colour'
    # To determine if a game is possible we have to determine the maximum number of balls of each colour ovr the number of pulls for each game
    # if any one colour exceeds its maximum the game is not possible.
    initialise()
    var myResult = 0
    var myNumbers = getNumberList()
    for forNumber in myNumbers:
        myResult += AdjacentNumber(forNumber)

    echo fmt"The answer to Day {Today[9 .. 10]} Part 01 is 550934. Found is {myResult}"   
    

proc part02() =
    # part2 requires the sum of the products of the maximum number of balls found in each game
    initialise()
    var myResult = 0
    var myGears = getGearList()
    for forGear in myGears:
        myResult += gearRatio(forGear)

    echo fmt"The answer to Day {Today[9 .. 10]} Part 02 is 81997870. Found is {myResult}"   


proc execute*() = 
    part01()
    part02()