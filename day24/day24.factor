! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences splitting io.encodings.utf8 io.files prettyprint math arrays accessors combinators sets dlists deques math.order sorting generalizations math.parser strings ;
IN: aoc2016.day24

TUPLE: state map location required done steps ;

: read-input ( file -- lines ) { "work/aoc2016/day24/" } swap suffix concat utf8 file-lines ;

: initial-state ( map -- state )
    dup
    [
        [
            swap
            [
                pick
                3array
            ] map-index
            nip
        ] map-index
        concat
        [ first CHAR: 0 = ] filter
        first rest
    ]
    [
        concat
        [ "0123456789" member? ] filter
        [ <=> ] sort
    ] bi
    { CHAR: 0 }
    0
    state boa ;

: done? ( state -- ? ) [ required>> ] [ done>> ] bi = ;

: update-done ( state -- newstate )
    dup
    [ done>> ]
    [ location>> ]
    [ map>> ] tri
    [
        [ first ]
        [ last ] bi
    ] dip
    nth nth
    dup
    "0123456789" member?
    [
        dup
        pick member?
        [ 2drop ]
        [
            suffix
            [ <=> ] sort
            >>done
        ] if
        ! check if in "done" else add and sort
    ]
    [ 2drop ] if
    ;

: make-move ( move state -- newstate )
    clone
    [ clone ] change-done
    [ 1 + ] change-steps
    swap
    >>location
    update-done ;

: legal? ( state -- ? )
    [ location>> ]
    [ map>> ] bi
    [
        [ first ]
        [ last ] bi
    ] dip
    nth nth
    CHAR: # = not ;

: next-moves ( state -- moves )
    location>>
    { { 0 -1 } { 1 0 } { 0 1 } { -1 0 } }
    [
        over
        [ + ] 2map
    ] map
    nip ;

: to-key ( state -- key )
    [
        location>>
        [ first number>string ]
        [ last number>string ] bi
        "-" swap
        append append
        "@" append
    ]
    [
        done>>
        >string
    ] bi
    append ;

: min-steps ( floors -- n )
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
        [ legal? ] filter
        [ to-key pick in? ] reject
        [ dup pick push-back to-key pick adjoin ] each
    ] until
    pop-front steps>>
    nip
    ;

: part1 ( file -- )
    read-input
    min-steps
    . ;

: part2 ( file -- )
    read-input
    min-steps
    . ;

: day24 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day24