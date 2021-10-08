! Copyright (C) 2021 Marc Dominik Migge.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.files io.encodings.utf8 splitting ascii sequences lists accessors combinators math math.parser prettyprint ;
IN: aoc2016.day01

: read-input ( file -- str ) { "work/aoc2016/day01/" } swap suffix concat utf8 file-contents ;

: parse-input ( str -- steps ) "," split [ [ blank? ] trim ] map ;

TUPLE: location x y orientation ;

: turn-left ( old -- new ) [ 1 - 4 rem ] change-orientation ;

: turn-right ( old -- new ) [ 1 + 4 rem ] change-orientation ;

: move ( oldloc cmd -- newloc ) 1 tail string>number over dup orientation>>
{
    { 0 [ [ y>> + >>y ] ] }
    { 1 [ [ x>> + >>x ] ] }
    { 2 [ [ y>> swap - >>y ] ] }
    { 3 [ [ x>> swap - >>x ] ] }
} case call( loc dist loc -- loc ) ;

: step ( oldloc cmd -- newloc ) swap clone over first
{
    { CHAR: F [ swap move ] }
    { CHAR: L [ turn-left swap move ] }
    { CHAR: R [ turn-right swap move ] }
} case ;

: find-destination ( steps -- location ) 0 0 0 location boa [ step ] reduce ;

: distance ( location -- n ) [ x>> abs ] [ y>> abs ] bi + ;

: part1 ( file -- ) read-input parse-input find-destination distance . ;

: expand-steps ( compressed -- expanded ) [ [ rest string>number 1 - "F1" <repetition> ] [ first "1" swap prefix ] bi prefix ] map concat ;

: append-locs ( oldlocs steps newlocs -- locs steps start ) [ 0 >>orientation ] map swapd append dup last swapd ;

: record-steps ( oldlocs steps oldstart -- newlocs steps newstart ) dupd [ step ] accumulate* append-locs ;

: first-duplicate ( locs -- loc ) { } swap [ [ suffix ] [ swap member? ] 2bi ] find 2nip ;
 
: part2 ( file -- ) read-input parse-input expand-steps
    { } 0 0 0 location boa suffix swap 0 0 0 location boa
    [ pick first-duplicate not ] [ record-steps ] while 2drop first-duplicate distance . ;

: day01 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ;

MAIN: day01
