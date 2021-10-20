! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files prettyprint ;
IN: aoc2016.day10

: read-input ( file -- str ) { "work/aoc2016/day10/" } swap suffix concat utf8 file-lines ;

: part1 ( file -- ) read-input . ;

: part2 ( file -- ) read-input . ;

: day10 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day10
