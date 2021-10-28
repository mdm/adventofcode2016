! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files prettyprint math math.parser accessors checksums checksums.md5 combinators sets dlists deques arrays io ;
IN: aoc2016.day17

TUPLE: move offsets door ;

TUPLE: state passcode path location ;

: read-input ( file -- lines ) { "work/aoc2016/day17/" } swap suffix concat utf8 file-lines first ;

: done? ( state -- ? ) location>> { 3 3 } = ;

: next-moves ( -- moves )
    { 0 -1 } "U" move boa
    { 1 0 } "R" move boa
    { 0 1 } "D" move boa
    { -1 0 } "L" move boa
    4array ;

: door-open? ( state door -- ? )
    [ [ passcode>> ] [ path>> ] bi append md5 checksum-bytes bytes>hex-string ] dip
    {
        { "U" [ 0 ] }
        { "D" [ 1 ] }
        { "L" [ 2 ] }
        { "R" [ 3 ] }
    } case
    swap
    nth
    "bcdef"
    member? ;

: legal? ( move state -- ? )
    over offsets>>
    over location>>
    [ + ] 2map
    [
        first
        [ 0 < ]
        [ 3 > ] bi
        or
    ]
    [
        second
        [ 0 < ]
        [ 3 > ] bi
        or
    ] bi
    or
    [
        2drop f
    ]
    [
        swap
        door>>
        door-open?
    ] if ;

: make-move ( move state -- newstate )
    [
        nip
        passcode>> ]
    [
        path>>
        swap
        door>>
        append
    ]
    [
        location>>
        swap
        offsets>>
        [ + ] 2map
    ] 2tri
    state boa ;
    
: to-key ( state -- key )
    [
        location>>
        [
            first number>string
        ]
        [
            second number>string
        ] bi
        "x"
        swap
        append append
    ]
    [
        path>>
    ] bi
    append ;

: shortest-path ( passcode -- path )
    "" { 0 0 } state boa
    dup
    to-key
    HS{ } clone dup swapd adjoin
    swap
    DL{ } clone dup swapd push-back
    [ dup
        deque-empty?
        [ t ] [ dup peek-front done? ] if
    ]
    [
        dup pop-front
        next-moves
        [ over legal? ] filter
        [ over make-move ] map
        nip
        [ to-key pick in? ] reject
        [ dup pick push-back to-key pick adjoin ] each
    ] until
    dup deque-empty?
    [
        "IMPOSSIBLE!"
        2nip
    ]
    [
        pop-front path>>
        nip
    ] if ;

: part1 ( file -- )
    read-input
    shortest-path
    print ;

: longest-path ( passcode -- n )
    "" { 0 0 } state boa
    f
    swap
    DL{ } clone dup swapd push-back
    [
      dup deque-empty?
    ]
    [
        dup pop-front dup
        [ path>> ]
        [ done? ] bi
        [
            swap
            swapd
            [ drop ] 3dip
            { }
        ]
        [
            drop
            next-moves
        ] if
        [ over legal? ] filter
        [ over make-move ] map
        nip
        [ over push-back ] each
    ] until
    drop
    length ;

: part2 ( file -- )
    read-input
    longest-path
    . ;

: day17 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day17
