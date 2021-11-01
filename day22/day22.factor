! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files prettyprint splitting combinators math math.parser accessors arrays sets dlists deques math.order sorting hashtables assocs ;
IN: aoc2016.day22

TUPLE: node id size used avail percent ;

: read-input ( file -- lines ) { "work/aoc2016/day22/" } swap suffix concat utf8 file-lines ;

: parse-input ( lines -- nodes )
    2 tail
    [
        " " split
        [ length 0 = ] reject
        {
            [
                first
                "/" split
                last
                "-" split
                rest
                [ rest string>number ] map
            ]
            [
                second
                reverse
                rest
                reverse
                string>number
            ]
            [
                third
                reverse
                rest
                reverse
                string>number
            ]
            [
                fourth
                reverse
                rest
                reverse
                string>number
            ]
            [
                4 swap nth
                reverse
                rest
                reverse
                string>number
            ]
        } cleave
        node boa
    ] map ;

: viable? ( pair -- ? )
    [ first ] [ last ] bi
    [
        drop
        used>>
        0 >
    ]
    [
        [ size>> ]
        [ used>> ] bi
        -
        swap
        used>>
        >=
    ] 2bi
    and ;

: all-pairs ( nodes -- pairs )
    [ 2array ] map-index
    dup
    [
        over
        [
            2dup
            [ second ] bi@ =
            [
                { }
            ]
            [
                2dup
                [ first ] bi@
                2array
            ] if
            nip
        ] map
        [ length 0 > ] filter
        nip
    ] map
    concat
    nip ;

: part1 ( file -- )
    read-input
    parse-input
    all-pairs
    [ viable? ] filter
    length
    . ;

TUPLE: state empty target steps nodes ;

: initial-state ( nodes -- state )
    dup
    [
        dup
        id>>
        swap
        2array
    ] map
    >hashtable
    [
        dup
        [
            used>>
            0 =
        ] find
        nip 
        id>>
        swap
        [ id>> last 0 = ] filter
        [ id>> first ] map
        [ swap <=> ] sort
        first
        0 2array
        0
    ] dip
    state boa ;

: adjacent? ( pair -- ? )
    [
        first
        id>>
        [ first ]
        [ last ] bi
    ]
    [
        last
        id>>
        [ first ]
        [ last ] bi
    ] bi
    swapd
    -
    abs
    [
        -
        abs
    ] dip
    +
    1 <= ;

: done? ( state -- ? ) dup target>> { 0 0 } = swap steps>> 11 >= or ;

: update-state ( node state -- newstate )
    [
        [ dup id>> ] dip
        clone dup
        [ set-at ] dip
    ] change-nodes ;

: make-move ( move state -- newstate )
    clone
    [
        [ clone ] map
        dup
        [ first used>> ]
        [ last used>> ] bi
        +
        over last
        swap
        >>used
        swap first
        0 >>used
    ] dip
    2dup
    target>>
    swap
    id>>
    =
    [
        pick
        id>>
        >>target
    ] when
    over
    id>>
    >>empty
    update-state
    update-state
    [ 1 + ] change-steps ;

: adjacent-pairs ( state -- pairs )
    [ nodes>> ]
    [ empty>> ] bi
    { { 0 -1 } { 1 0 } { 0 1 } { -1 0 } }
    [
        over
        [ + ] 2map
    ] map
    [ over at ] dip
    [ pick key? ] filter
    [
        pick at
        over
        2array
    ] map
    2nip ;

: next-moves ( state -- moves )
    adjacent-pairs
    [ viable? ] filter ;

: to-key ( state -- key )
    [
        target>>
        [ first number>string ]
        [ last number>string ] bi
        "x" swap
        append append
    ]
    [
        nodes>>
        [ used>> number>string ] map
        "-" join
    ] bi
    "@" swap
    append append ;

: min-steps ( nodes -- n )
    initial-state
    dup
    to-key
    HS{ } clone dup swapd adjoin
    swap
    DL{ } clone dup swapd push-back
    [ dup peek-front done? ]
    [
        dup pop-front dup
        next-moves [ over make-move ] map nip
        [ to-key pick in? ] reject
        [ dup pick push-back to-key pick adjoin ] each
    ] until
    pop-front steps>>
    nip
    ;

: part2 ( file -- )
    read-input
    parse-input
    min-steps
    . ;

: day22 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day22
