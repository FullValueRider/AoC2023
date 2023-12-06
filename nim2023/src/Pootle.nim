# import ../../../AoCLib/src/constants
# import std/strutils
# import std/sequtils
import std/strformat

proc test() =
    if 3 in 1 .. 3:
        echo fmt"3 in range"
    else:
        echo fmt"3 not in range"
