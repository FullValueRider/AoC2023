import ../../../AoCLib/src/constants
import std/strutils
import std/sequtils
import std/strformat
import std/tables
import std/algorithm
#========1=========2=========3=========4=========5=========6=========7=========8=========9=========A=========B=========C
 

const Today                                     : string = "\\2023\\Day07.txt"
    
type 
    State = object 
        # collection of Hands
        Data                                    : Table[string,int]
        
var s                                           : State

proc initialise() =
    # to make a hand easily sortable we replace T,J,Q,K,A, with charcters in order of precedence
    # s.Data comprises hands With updated cards And bids
    # Hands can be classified in 7 ways
    # 0. aaaaa freq buckets = 1 rank = 7
    # 1. aaaab freq buckets = 2 rank = 6
    # 2. aaabb freq buckets = 2 rank = 5
    # 3. aaabc freq buckets = 3 rank = 4
    # 4. aabbc freq buckets = 3 rank = 3
    # 5. aabcd freq buckets = 4 rank = 2
    # 6. abcdef frequ buckets = 5 rank = 1
    # Thus assigning a score to a hand Is simple
    # The Hands are bucketed according to the above ranks 
    # (Not the same rank As discussed in the question)
    # the rank applied in the question Is simply a counter.  We Set it to one
    # For the first(lowest possible hand) then increase by 1 fo Each
    # hand.

    var myData = (AoCData & Today)
        .lines
        .toSeq
        .mapIt(it.multireplace( ("J", "B"),( "Q", "C"),( "K", "D"),( "A", "E"),( "T", "A")))
        .mapIt(it.split(" "))
        .mapIt((it[0],it[1].parseInt))
        .toTable

    s = State(Data: myData)


proc getRank(ipHand: string): int = 
         
    # Convert the hand string to a dictionary of character vs count
    var myFreq  = ipHand.toCountTable
    
    #For part 1 we need only the frequency counts
    # sorting the counts in reverse order (highest count at Item(1))
    var myCounts = myFreq.values.toseq.sorted
    
    case myFreq.len  #Note: Nim requires constant expressions for each of
        of 1 :     return 6
        of 2 :     return if myCounts[^1] == 4: 5 else: 4
        of 3 :     return if myCounts[^1] == 3: 3 else: 2 
        of 4 :     return 2
        of 5 :     return 1
        else:
            echo fmt"Unexpected Hand {ipHand}"

proc GetJokeredRank(ipHand: string): int = 
        
    # if no jokers get the rank; normal hand
    if '0' notin ipHand :
        return getRank(ipHand)


    # code below only needs to consider hands with the joker
    # remove jokers from hand
    var myHand = ipHand.replace("0", "")
    var myJokers = 5 - myHand.len

    # if the card count is 5 we have 5 jokers which scores a rank of 7
    if (myJokers == 5) :
        return 7


    # calculate frequency of remaining characters
    var myFreq = @myHand.toCountTable

    # Get the key "character" with the max count in freq
    # We may have more than one character with the max score
    # so get the last ma count
    # we have serendipity here; the chars just happed to be in increasing order.
    var myMaxKey = myFreq.largest
    # update the character determined to be the best to add the jokers to
    myFreq[(myMaxKey[0])] = myFreq[(myMaxKey[0])]+myJokers
    var myCounts = myFreq.values.toseq.sorted

    case myFreq.len  #Note: Nim requires constant expressions for each of
        of 1 :     return 6
        of 2 :     return if myCounts[^1] == 4: 5 else: 4
        of 3 :     return if myCounts[^1] == 3: 3 else: 2
        of 4 :     return 1
        of 5 :     return 0
        else:
            echo fmt "Unexpected Hand {ipHand}"

proc part01() =

    initialise()
    # s.Data comprises hands with updated cards and bids
    # Hands can be classified in 7 ways
    # 0. aaaaa freq buckets = 1 rank = 7
    # 1. aaaab freq buckets = 2 rank = 6
    # 2. aaabb freq buckets = 2 rank = 5
    # 3. aaabc freq buckets = 3 rank = 4
    # 4. aabbc freq buckets = 3 rank = 3
    # 5. aabcd freq buckets = 4 rank = 2
    # 6. abcdef frequ buckets = 5 rank = 1
    # Thus assigning a score to a hand is simple
    # The Hands are bucketed according to the above ranks 
    # (not the same rank; discussed in the question)
    # the rank applied in the question is simply a counter.  We set it to one
    # for the first( lowest possible hand) then increase by 1 fo each
    # hand.
    var myResult: int = 0
    
    # Each seq corresponds to a rank bucket
    var myRanked :seq[seq[string]] = @[@[],@[],@[],@[],@[],@[],@[]]
    
    for myHand, myBid in s.Data:
        
        var myRank: int = getRank(myHand)
        
        myRanked[myRank].add( myHand)
        
    # now sort the buckets in rankbuckets
    #myRanked.mapIt(it.sort, system.cmp)
    for myIndex in myRanked.low .. myRanked.high:
        myRanked[myIndex]=myRanked[myIndex].sorted
   
    # the buckets are now sorted so we proceed from bucket 1 to bucket 7 = 
    # multiply item within each bucket my a mutiplier which increases by 1 for each item processed. = 
    var myMultiplier: int = 1
    
    for myRankBucket in myRanked:
        for myHand in myRankBucket:
            myResult += (s.Data[myHand] * myMultiplier)
            myMultiplier += 1

    echo fmt"The answer to Day {Today[9 .. 10]} part 1 is 250946742.  Found is {myResult}"
        
    
proc part02() =
    
    # In part two we have jokers so we have a second substitution to 
    # replace "b" with "0".
    
    initialise()
    var myResult: int = 0
    var myRanked :seq[seq[string]] = @[@[],@[],@[],@[],@[],@[],@[]]
    
    # Remap hands to use jokers
    var myJHands : Table[string, int]
    for myHand , myBid in s.Data:
        myJHands[myHand.replace( "b", "0")] = myBid
    
    for myHand in myJHands.keys:
        
        # we need to adjust the strategy compared to part 1 but the 
        # ranking essentially works the same
        var myRank = GetJokeredRank(myHand)
        myRanked[myRank].add myHand
        
    # now sort the in each rank bucket
    for myIndex in myRanked.low .. myRanked.high:
         myRanked[myIndex] = myRanked[myIndex].sorted
    
    # the buckets are now sorted so we proceed from bucket 1 to bucket 7 = 
    # multiply item within each bucket my a mutiplier which increases by 1 for each item processed. = 
    var myMultiplier: int = 1
    for myRankBucket in myRanked:
        for myHand in myRankBucket:
            myResult += (myJHands[myHand] * myMultiplier)
            myMultiplier += 1

    echo fmt"The answer to Day {Today[9 .. 10]} part 2 is 251824095.  Found is {myResult}"
     
        
proc execute*() = 
        
    part01()
    part02()