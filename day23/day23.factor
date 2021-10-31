! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences math math.parser combinators splitting prettyprint generalizations ;
IN: aoc2016.day23

: read-input ( file -- str ) { "work/aoc2016/day23/" } swap suffix concat utf8 file-lines ;

: toggle-command ( command -- toggled )
    [ rest ] [ first ] bi
    {
        { "cpy" [ "jnz" prefix ] }
        { "jnz" [ "cpy" prefix ] }
        { "inc" [ "dec" prefix ] }
        { "dec" [ "inc" prefix ] }
        { "tgl" [ "inc" prefix ] }
    } case ;

: execute-command ( program pc registers -- program pc registers )
    pick
    pick
    swap
    nth
    [ rest ] [ first ] bi
    {
        { "cpy" [
            dup second
            { "a" "b" "c" "d" } member?
            [
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
            ]
            [
                drop
            ] if
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
                second
                dup { "a" "b" "c" "d" } member?
                [ first CHAR: a - over nth ]
                [ string>number ] if
                nip
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
        { "tgl" [
            first
            dup { "a" "b" "c" "d" } member?
            [ first CHAR: a - over nth ]
            [ string>number ] if
            pick
            +
            4 npick
            2dup
            length
            <
            [
                [ toggle-command ] change-nth
            ]
            [ 2drop ] if
            [ 1 + ] dip
        ] }
    } case ;

: run-program ( program pc registers -- registers )
    [ pick length pick > ]
    [ execute-command ] while
    2nip ;

: test1 ( file -- ) read-input [ " " split ] map 0 { 0 0 0 0 } run-program first . ;

: part1 ( file -- ) read-input [ " " split ] map 0 { 7 0 0 0 } run-program first . ;

: part2 ( file -- ) read-input [ " " split ] map 0 { 12 0 0 0 } run-program first . ;

: day23 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day23
