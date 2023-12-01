proc first*[T](ipSeq: seq[T] or string): T =
    return ipSeq[ipSeq.low]

proc last*[T](ipSeq: seq[T] or string): T =
    if ipSeq.len == 0:
        echo "sequence is empty"
    else:
        return ipSeq[ipSeq.high]