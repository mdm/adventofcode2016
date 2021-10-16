! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: ;
IN: aoc2016.day09

: read-input ( file -- str ) { "work/aoc2016/day09/" } swap suffix concat utf8 file-lines first ;

: part1 ( file -- ) read-input . ;

: part2 ( file -- ) read-input . ;

: day09 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day09
