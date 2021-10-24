! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences splitting io.encodings.utf8 io.files prettyprint math arrays accessors combinators ;
IN: aoc2016.day11

: read-input ( file -- lines ) { "work/aoc2016/day11/" } swap suffix concat utf8 file-lines ;

: parse-floor ( line -- floor )
    [ CHAR: . = ] trim
    " " split 4 tail
    [ [ CHAR: , = ] trim ] map
    [ { "a" "and" "nothing" "relevant" } member? ] reject
    [ 2array ] map-index
    [ [ second even? ] filter ] [ [ second odd? ] filter ] bi
    [ [ first ] bi@ " " swap append append ] 2map ;

: done? ( floors -- ? ) [ 3 = [ drop t ] [ empty? ] if ] map-index [ ] all? ;

TUPLE: move item from to ;

: add-item ( move floors -- floors )
    dup
    [
        [ dup to>> ] dip 
        [ over item>> suffix ] change-nth
    ] dip nip ;

: remove-item ( move floors -- floors )
    dup
    [
        [ dup from>> ] dip 
        [ over item>> swap remove ] change-nth
    ] dip nip ;

: clone-floors ( floors -- newfloors ) [ clone ] map ;

: make-move ( move floors -- newfloors ) dupd clone-floors remove-item add-item ;

: item-combinations ( n floors -- combinations )
    nth
    [ 2array ] map-index
    dup
    [ over [ over 2array ] map nip ] map concat
    [ [ first second ] [ second second ] bi < ] filter
    [ [ first first ] [ second first ] bi 2array ] map
    [ [ first 1array ] map ] dip
    append ;

: part1 ( file -- ) read-input [ parse-floor ] map done? . ;

: part2 ( file -- ) read-input . ;

: day11 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day11
