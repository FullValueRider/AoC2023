proc first*[T](ipSeq: seq[T]): T =
    return ipSeq[0]

proc first*(ipSeq:  string): char =
    return ipSeq[0]

proc last*[T](ipSeq: seq[T]): T =
    if ipSeq.len == 0:
        echo "sequence is empty"
    else:
        return ipSeq[^1]

proc last*(ipSeq: string): char =
    if ipSeq.len == 0:
        echo "string is empty"
    else:
        return ipSeq[^1]

proc areSame*[T]( self : seq[T], ipItem: T  ) : bool =

    var myCompare  = ipItem

    for myTest in self:
        if myTest != myCompare:
            return false

    return true

proc areSame*[T](self : seq[T]) : bool =
    var mycompare = self[0]
    for myTest in self:
        if myTest != myCompare  :
            return false
    return true

proc delta*(self: seq[int]): seq[int] =
    for myIndex in self.low .. self.high - 1:
        result.add( self[myindex + 1] - self[myIndex])
