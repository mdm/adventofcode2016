! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files arrays strings math prettyprint ;
IN: aoc2016.day18

: read-input ( file -- lines ) { "work/aoc2016/day18/" } swap suffix concat utf8 file-lines first ;

: safe? ( tile -- ? ) CHAR: . = ;

: next-tile ( left center right -- tile )
    3array
    >string
    {
        "^^."
        ".^^"
        "^.."
        "..^"
    }
    member?
    [ CHAR: ^ ]
    [ CHAR: . ] if ;

: get-tile ( row n -- tile )
    2dup
    swap
    length =
    [ 2drop CHAR: . ]
    [
        dup
        -1 =
        [ 2drop CHAR: . ]
        [ swap nth ] if
    ] if ;

: next-row ( row -- row )
    dup
    [
        pick
        [ swap 1 - get-tile ]
        [ swap get-tile ]
        [ swap 1 + get-tile ] 2tri
        next-tile
        nip
    ] map-index
    >string
    nip ;

: count-safe ( start n -- n )
    [ 0 ] 2dip
    [ dup 0 > ]
    [
        dupd
        [
            [ safe? ] count
            +
        ] 2dip
        [ next-row ] dip
        1 -
    ] while
    2drop ;

: part1 ( file -- )
    read-input
    40 count-safe
    . ;

: part2 ( file -- )
    read-input
    400000 count-safe
    . ;

: day18 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day18
