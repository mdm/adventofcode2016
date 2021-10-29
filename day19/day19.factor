! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files math math.parser math.ranges combinators prettyprint ;
IN: aoc2016.day19

: read-input ( file -- lines ) { "work/aoc2016/day19/" } swap suffix concat utf8 file-lines first ;

: josephus ( n k -- survivor )
    {
        { [ over 1 = ] [ 2drop 0 ] }
        { [ dup 1 = ] [ drop 1 - ] }
        { [ 2dup < ] [
            over 1 -
            over
            josephus
            +
            swap
            mod
        ] }
        [
            2dup /i
            [ 2dup ] dip
            swap
            [ - ] dip
            josephus
            [ 2dup mod ] dip
            swap -
            dup
            0 <
            [ pick + ]
            [ dup pick 1 - /i + ] if
            2nip
        ]
    } cond
    ;

: josephus-slow ( n k -- survivor )
    0
    pick
    [
        1 +
        swap
        pick +
        swap
        mod
    ] each-integer
    2nip ;

: part1 ( file -- )
    read-input
    string>number
    2 josephus
    1 +
    . ;

: josephus-modified ( n -- survivor )
    0
    2 pick 1 <range>
    [
        swap
        over 2 /i 1 -
        -
        over 1 -
        rem
        over even?
        [ over 2 /i 1 - ]
        [ over 2 /i ] if
        -
        over
        rem
        swap drop
    ] each
    nip ;

: part2 ( file -- )
    read-input
    string>number
    josephus-modified
    1 +
    . ;

: day19 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day19
