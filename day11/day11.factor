! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences splitting io.encodings.utf8 io.files prettyprint math arrays accessors combinators sets dlists deques math.order sorting generalizations math.parser ;
IN: aoc2016.day11

TUPLE: item isotope type ;

TUPLE: move items from to ;

TUPLE: state location steps floors ;

: read-input ( file -- lines ) { "work/aoc2016/day11/" } swap suffix concat utf8 file-lines ;

: parse-floor ( line -- floor )
    [ CHAR: . = ] trim
    " " split 4 tail
    [ [ CHAR: , = ] trim "-" " " replace ] map
    [ { "a" "and" "nothing" "relevant" } member? ] reject
    [ 2array ] map-index
    [ second even? ] partition
    [ [ first ] bi@ first swap " " split first swap item boa ] 2map ;

: done? ( floors -- ? ) [ 3 = [ drop t ] [ empty? ] if ] map-index [ ] all? ;

: add-items ( move floors -- floors )
    dup
    [
        [ dup to>> ] dip 
        [ over items>> append ] change-nth
    ] dip nip ;

: remove-items ( move floors -- floors )
    dup
    [
        [ dup from>> ] dip 
        [ over items>> swap [ over member? ] reject nip ] change-nth
    ] dip nip ;

: clone-floors ( floors -- newfloors ) [ clone ] map ;

: make-move ( move state -- newstate )
    [ drop to>> ]
    [ nip steps>> 1 + ]
    [ dupd floors>> clone-floors remove-items add-items ] 2tri
    state boa
    ;

: item-combinations ( n floors -- combinations )
    nth
    [ 2array ] map-index
    dup
    [ over [ over 2array ] map nip ] map concat
    [ [ first second ] [ second second ] bi < ] filter
    [ [ first first ] [ second first ] bi 2array ] map
    [ [ first 1array ] map ] dip
    append ;

: legal? ( state -- ? )
    floors>>
    [
        dup
        [ type>> CHAR: m = ] partition
        length 0 =
        -rot
        [ isotope>> over [ isotope>> over = ] count 2 = nip ] all? nip
        or
    ] all? ;

: next-moves ( state -- moves )
    dup
    [ location>> ] [ floors>> ] bi item-combinations
    [ over location>> dup 3 < [ swap [ over dup 1 + move boa ] map nip ] [ 2drop { } ] if ]
    [ over location>> dup 0 > [ swap [ over dup 1 - move boa ] map nip ] [ 2drop { } ] if ] 2bi
    nip
    append
    nip ;

: item-string ( item -- str ) [ isotope>> ] [ type>> ] bi suffix ;

: to-key ( state -- key )
    dup
    location>> number>string
    swap
    floors>>
    dup
    concat [ [ item-string ] bi@ <=> ] sort
    swap
    [
        over [ dup pick member? [ item-string ] [ drop "#" ] if ] map nip
    ] map
    concat concat
    nip
    append ;

: min-steps ( floors -- n )
    [ 0 0 ] dip state boa
    dup
    to-key
    HS{ } clone dup swapd adjoin
    swap
    DL{ } clone dup swapd push-back
    [ dup peek-front floors>> done? ]
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

: part1 ( -- )
    "input.txt"
    read-input [ parse-floor ] map
    min-steps
    . ;

: part2 ( -- )
    "input2.txt"
    read-input [ parse-floor ] map
    min-steps
    . ;

: day11 ( -- ) part1 part2 ; 

MAIN: day11
