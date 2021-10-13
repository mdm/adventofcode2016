! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files math prettyprint assocs io ;
IN: aoc2016.day06

: read-input ( file -- str ) { "work/aoc2016/day06/" } swap suffix concat utf8 file-lines ;

: extract-nth-letter ( words n -- words letters ) over [ dupd nth ] map nip ;

: greater-value ( key1 val1 key2 val2 -- key val ) swapd 2dup < [ swapd 2nipd ] [ swapd 2drop ] if ;

: most-common-letter ( letters -- letter ) H{ } clone swap [ over inc-at ] each f 0 pick [ greater-value ] assoc-each drop nip ;

: part1 ( file -- ) read-input "" over first length [ swap [ extract-nth-letter most-common-letter ] dip swap suffix ] each-integer nip print ;

: lesser-value ( key1 val1 key2 val2 -- key val ) swapd 2dup > [ swapd 2nipd ] [ swapd 2drop ] if ;

: least-common-letter ( letters -- letter ) H{ } clone swap [ over inc-at ] each f 1000000 pick [ lesser-value ] assoc-each drop nip ;

: part2 ( file -- ) read-input "" over first length [ swap [ extract-nth-letter least-common-letter ] dip swap suffix ] each-integer nip print ;

: day06 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day06
