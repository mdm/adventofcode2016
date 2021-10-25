! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences math math.parser combinators splitting prettyprint ;
IN: aoc2016.day12

: read-input ( file -- str ) { "work/aoc2016/day12/" } swap suffix concat utf8 file-lines ;

: execute-command ( pc registers command -- pc registers )
    [ rest ] [ first ] bi
    {
        { "cpy" [
            [
                first
                dup { "a" "b" "c" "d" } member?
                [ first CHAR: a - over nth ]
                [ string>number ] if
            ]
            [
                nip second first CHAR: a -
            ] 2bi
            pick set-nth
            [ 1 + ] dip
        ] }
        { "inc" [
            first first CHAR: a - 
            dup
            pick nth
            1 +
            swap
            pick set-nth
            [ 1 + ] dip
        ] }
        { "dec" [
            first first CHAR: a - 
            dup
            pick nth
            1 -
            swap
            pick set-nth
            [ 1 + ] dip
        ] }
        { "jnz" [
            [
                nip second string>number
            ]
            [
                first
                dup { "a" "b" "c" "d" } member?
                [ first CHAR: a - over nth ]
                [ string>number ] if
            ] 2bi
            swapd
            0 =
            [ drop [ 1 + ] dip ]
            [ swap [ + ] dip ] if
        ] }
    } case ;

: run-program ( program pc registers -- registers )
    [ pick length pick > ]
    [ pick pick swap nth execute-command ] while
    2nip ;

: part1 ( file -- ) read-input [ " " split ] map 0 { 0 0 0 0 } run-program first . ;

: part2 ( file -- ) read-input [ " " split ] map 0 { 0 0 1 0 } run-program first . ;

: day12 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day12
