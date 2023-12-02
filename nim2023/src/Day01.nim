import ../../AoCLib/src/constants
import std/strutils
import std/strformat
import std/setutils

#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 
const Today                                     : string = "\\2023\\Day01.txt"


type 
    State = object
        Data                                    : seq[string]

var s                                           : State


proc initialise() =
    s = State(Data:  (AoCData & Today).readFile.split("\r\n"))

 
proc part01() =
    initialise()
    var myResult:int = 0
    var myLower: set[char] ="abcdefghijklmnopqrstuvwxyz".toSet
    for myStr in s.Data:
        
        var myTrim = myStr.strip(chars = myLower )
        case mytrim.len:
            of 0:
                discard
            of 1:
                myResult += ($myTrim[0] &  $myTrim[0]).parseInt

            else:
                myResult += ($myTrim[0] &  $myTrim[^1]).parseInt
        

    echo fmt"The answer to Day {Today[9 .. 10]} Part 01 is 54708. Found is {myResult}"   
    

proc part02() =
    initialise()
    var myResult:int = 0
    for myItem in s.Data:
        #var myTrim = mystr.multiReplace(("one","o1ne"),("two","t2wo"),("three","t3hree"),("four","f4our"),("five","f5ive"),("six","s6ix"),("seven","s7even"),("eight","e8ight"), ("nine","n9ine"),("zero","z0ero"))

        var myInStr = myItem
        var myOutStr = ""
            
        for myIndex in  countup(myItem.low , myItem.high-2):
            myOutStr &= myInStr[ myIndex]
            var myStr:string
            case myOutStr[ ^1 ] 
                of 'o':
                    if myInStr[ myIndex .. ^1].startswith("one"):
                        myOutStr &= "1"
                    
                of 't':
                    if myInStr[ myIndex .. ^1].startswith("two") :
                        myOutStr &= "2"
                    elif myInStr[myIndex .. ^1].startswith("three") :
                        myOutStr &= "3"
                    
                of 'f':
                    if myInstr[myIndex .. ^1].startswith("four") :
                        myOutStr &= "4"
                    elif myInstr[myIndex .. ^1].startswith("five") :
                        myOutStr &= "5"
                    
                of 's':
                    if myInstr[myIndex .. ^1].startswith("six") :
                        myOutStr &= "6"
                    elif myInstr[myIndex .. ^1].startswith("seven") :
                        myOutStr &= "7"
                    
                of 'e':
                    if myInstr[myIndex .. ^1].startswith("eight") :
                        myOutStr &= "8"
                    
                of 'n':
                    if myInstr[myIndex .. ^1].startswith("nine") :
                        myOutStr &= "9"
                    
                of 'z':
                    if myInstr[myIndex .. ^1].startswith("zero") :
                        myOutStr &= "0"
                else: 
                    discard
  
        myOutStr &= myInStr[^2 .. ^1]

        var myTrim = myOutStr.strip(chars = "abcdefghijklmnopqrstuvwxyz".toSet )
        case mytrim.len
            of 0:
                discard
            of 1:
                myResult += ($myTrim[0] & $myTrim[0]).parseInt

            else:
                myResult += ($myTrim[0] &  $myTrim[^1]).parseInt  
    echo fmt"The answer to Day {Today[9 .. 10]} Part 02 is 54087. Found is {myResult}"   

proc execute*() = 

    part01()
    part02()