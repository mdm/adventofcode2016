! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences splitting math.parser prettyprint accessors math arrays math.order sorting ;
IN: aoc2016.day15

TUPLE: disc number positions start ;

: read-input ( file -- lines ) { "work/aoc2016/day15/" } swap suffix concat utf8 file-lines ;

: parse-disc ( line -- disc )
    " " split
    [ 1 swap nth [ CHAR: # = ] trim string>number ]
    [ 3 swap nth string>number ]
    [ last [ CHAR: . = ] trim string>number ] tri
    disc boa ;

: first-time ( discs -- n )
    ! [ [ positions>> ] bi@ <=> ] sort
    { 0 1 }
    [
        [
            over first
            over
            [ positions>> ]
            [ number>> ]
            [ start>> ] tri
            +
            neg
            over rem
            [ rem ] dip
            =
        ]
        [
            swap
            [ first ]
            [ second ] bi
            dup
            [ + ] dip
            2array
            swap
        ] until
        positions>>
        [
            [ first ]
            [ second ] bi
        ] dip
        *
        2array
    ] reduce
    first ;

: part1 ( file -- )
    read-input
    [ parse-disc ] map
    first-time
    . ;

: part2 ( file -- )
    read-input
    [ parse-disc ] map
    dup length 1 +
    11 0 disc boa
    suffix
    first-time
    . ;

: day15 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day15
