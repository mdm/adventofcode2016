! Copyright (C) 2021 Marc Dominik Migge.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files splitting prettyprint math combinators math.parser ascii io ;
IN: aoc2016.day02

: read-input ( file -- str ) { "work/aoc2016/day02/" } swap suffix concat utf8 file-lines ;

: move1 ( btn cmd -- btn ) dupd
{
    { CHAR: U [ 3 > [ 3 - ] [ ] if ] }
    { CHAR: R [ 3 mod 0 = not [ 1 + ] [ ] if ] }
    { CHAR: D [ 7 < [ 3 + ] [ ] if ] }
    { CHAR: L [ 3 mod 1 = not [ 1 - ] [ ] if ] }
} case ;

: to-dec ( btns -- n ) 0 [ swap 10 * + ] reduce ;

: part1 ( file -- ) read-input 5 [ swap [ move1 ] reduce ] accumulate* to-dec . ;

: move2 ( btn cmd -- btn ) dupd
{
    { CHAR: U [ dup { 5 2 1 4 9 } member? [ drop ] [ { 3 13 } member? [ 2 - ] [ 4 - ] if ] if ] }
    { CHAR: R [ { 1 4 9 12 13 } member? [ ] [ 1 + ] if ] }
    { CHAR: D [ dup { 5 10 13 12 9 } member? [ drop ] [ { 1 11 } member? [ 2 + ] [ 4 + ] if ] if ] }
    { CHAR: L [ { 1 2 5 10 13 } member? [ ] [ 1 - ] if ] }
} case ;

: to-hex ( btns -- str ) 0 [ swap 16 * + ] reduce >hex ;

: part2 ( file -- ) read-input 5 [ swap [ move2 ] reduce ] accumulate* to-hex >upper print ;

: day02 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ;

MAIN: day02
