! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences splitting io.encodings.utf8 io.files prettyprint math arrays accessors combinators sets vectors math.order sorting generalizations math.parser ;
IN: aoc2016.day11

TUPLE: move items from to ;

TUPLE: state location steps floors ;

: read-input ( file -- lines ) { "work/aoc2016/day11/" } swap suffix concat utf8 file-lines ;

: parse-floor ( line -- floor )
    [ CHAR: . = ] trim
    " " split 4 tail
    [ [ CHAR: , = ] trim "-" " " replace ] map
    [ { "a" "and" "nothing" "relevant" } member? ] reject
    [ 2array ] map-index
    [ [ second even? ] filter ] [ [ second odd? ] filter ] bi
    [ [ first ] bi@ " " swap append append ] 2map ;

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
        [ "generator" swap subseq? ] none?
        swap dup
        [ "microchip" swap subseq? ] filter
        [ " " split first over [ " " split first over = ] count 2 = nip ] all? nip
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

: to-key ( state -- key )
    dup
    location>> number>string
    swap
    floors>>
    dup
    concat [ <=> ] sort
    swap
    [
        over [ dup pick member? [ ] [ drop "#" ] if ] map nip
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
    f ?push
    [ dup first floors>> done? ]
    [
        dup first dup
        next-moves [ over make-move ] map nip
        [ legal? ] filter
        [ to-key pick in? ] reject
        [ dup pick ?push drop to-key pick adjoin ] each
        rest
    ] until
    first steps>>
    nip
    ;

: part1 ( file -- )
    read-input [ parse-floor ] map
    min-steps
    . ;

: part2 ( file -- ) read-input drop ;

: day11 ( -- ) "test1.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day11
