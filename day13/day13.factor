! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences splitting io.encodings.utf8 io.files prettyprint math arrays accessors combinators sets dlists deques math.order sorting generalizations math.parser ;
IN: aoc2016.day13

TUPLE: state magic location steps ;

: read-input ( file -- lines ) { "work/aoc2016/day13/" } swap suffix concat utf8 file-lines first ;

: done? ( state -- ? ) location>> { 31 39 } = ;

: wall? ( state -- ? )
    {
        [ location>> first dup * ]
        [ location>> first 3 * ]
        [ location>> [ first ] [ second ] bi * 2 * ]
        [ location>> second ]
        [ location>> second dup * ]
        [ magic>> ]
    } cleave
    + + + + +
    >bin
    [ CHAR: 1 = ] filter
    length odd? ;

: make-move ( move state -- newstate )
    [
        nip
        magic>>
    ]
    [
        location>>
        [ + ] 2map
    ]
    [
        nip
        steps>>
        1 + 
    ] 2tri
    state boa
    ;

: legal? ( state -- ? )
    [
        location>>
        [ first 0 < ] [ second 0 < ] bi
        or
    ]
    [
        wall?
    ] bi
    or not ;

: next-moves ( -- moves )
    {
        { 0 -1 }
        { 1 0 }
        { 0 1 }
        { -1 0 }
    } ;

: min-steps ( magic -- n )
    { 1 1 } 0 state boa
    dup
    location>>
    HS{ } clone dup swapd adjoin
    swap
    DL{ } clone dup swapd push-back
    [ dup peek-front done? ]
    [
        dup pop-front
        next-moves [ over make-move ] map nip
        [ legal? ] filter
        [ location>> pick in? ] reject
        [ dup pick push-back location>> pick adjoin ] each
    ] until
    pop-front steps>>
    nip
    ;

: part1 ( file -- )
    read-input
    string>number
    min-steps
    . ;

: done2? ( state -- ? ) steps>> 50 > ;

: in-reach ( magic -- n )
    0 swap
    { 1 1 } 0 state boa
    dup
    location>>
    HS{ } clone dup swapd adjoin
    swap
    DL{ } clone dup swapd push-back
    [ dup peek-front done2? ]
    [
        dup pop-front
        next-moves [ over make-move ] map nip
        [ legal? ] filter
        [ location>> pick in? ] reject
        [ dup pick push-back location>> pick adjoin ] each
        [ 1 + ] 2dip
    ] until
    2drop
    ;

: part2 ( file -- )
    read-input
    string>number
    in-reach
    . ;

: day13 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day13
