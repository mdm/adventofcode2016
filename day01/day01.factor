! Copyright (C) 2021 Marc Dominik Migge.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.files io.encodings.utf8 splitting ascii sequences lists accessors combinators math math.parser prettyprint ;
IN: aoc2016.day01

: read-input ( file -- str ) { "work/aoc2016/day01/" } swap suffix concat utf8 file-contents ;

TUPLE: location x y orientation ;

: parse-input ( str -- steps ) "," split [ [ blank? ] trim ] map ;

: left-cmd? ( cmd -- ? ) first CHAR: L = ;

: right-cmd? ( cmd -- ? ) first CHAR: R = ;

: turn-left ( old -- new ) [ 1 - 4 rem ] change-orientation ;

: turn-right ( old -- new ) [ 1 + 4 rem ] change-orientation ;

: move ( oldloc cmd -- newloc ) 1 tail string>number over dup orientation>>
{
    { 0 [ [ y>> + >>y ] ] }
    { 1 [ [ x>> + >>x ] ] }
    { 2 [ [ y>> swap - >>y ] ] }
    { 3 [ [ x>> swap - >>x ] ] }
} case call( loc dist loc -- loc ) ;

: step ( oldloc cmd -- newloc ) swap over first
{
    { CHAR: L [ turn-left swap move ] }
    { CHAR: R [ turn-right swap move ] }
} case ;

: find-destination ( steps -- location ) >list 0 0 0 location boa [ step ] foldl ;

: distance ( location -- n ) [ x>> abs ] [ y>> abs ] bi + ;

: part1 ( file -- ) read-input parse-input find-destination distance . ;

: day01 ( -- ) "input.txt" part1 ;

MAIN: day01
