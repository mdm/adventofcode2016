! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files math prettyprint strings generalizations splitting math.parser combinators io ;
IN: aoc2016.day08

: read-input ( file -- str ) { "work/aoc2016/day08/" } swap suffix concat utf8 file-lines ;

: parse-line ( line -- a b op ) "rect" over subseq?
    [ " " split last "x" split [ first string>number ] [ last string>number ] bi  "rect" ]
    [ " " split rest dup first "row" = 
        [ rest [ first "=" split last string>number ] [ last string>number ] bi "rotate row" ]
        [ rest [ first "=" split last string>number ] [ last string>number ] bi "rotate column" ] if
    ] if ;

: init-grid ( w h -- grid ) swap CHAR: . <repetition> >string { } rot [ over clone suffix ] times nip ;

: turn-on ( grid x y -- grid ) pick nth CHAR: # -rot set-nth ;

: rect ( grid w h -- grid ) [ over [ 4 npick swap pick turn-on drop ] each-integer drop ] each-integer drop ;

: read-row ( grid y -- row ) swap nth ;

: write-row ( grid y row -- ) swap rot set-nth ;

: rotate-row ( grid y n -- grid ) [ dupd 2dup read-row dup length ] dip - [ head ] [ tail ] 2bi swap append write-row ;

: read-column ( grid x -- column ) swap [ dupd nth ] map nip >string ;

: write-column ( grid x column -- ) rot [ pick swap set-nth ] 2each drop ;

: rotate-column ( grid y n -- grid ) [ dupd 2dup read-column dup length ] dip - [ head ] [ tail ] 2bi swap append write-column ;

: execute-op ( grid a b op -- grid ) {
    { "rect" [ rect ] }
    { "rotate row" [ rotate-row ] }
    { "rotate column" [ rotate-column ] }
} case ;

: count-on ( grid -- n ) [ [ CHAR: # = ] count ] map sum ;

! : part1 ( file -- ) read-input 7 3 init-grid [ parse-line execute-op ] reduce count-on . ;
: part1 ( file -- ) read-input 50 6 init-grid [ parse-line execute-op ] reduce count-on . ;

: print-grid ( grid -- ) [ print ] each ;

: part2 ( file -- ) read-input 50 6 init-grid [ parse-line execute-op ] reduce print-grid ;

: day08 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day08
