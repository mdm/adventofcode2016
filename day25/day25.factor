! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences math math.parser combinators splitting prettyprint generalizations vectors ;
IN: aoc2016.day25

: read-input ( file -- str ) { "work/aoc2016/day25/" } swap suffix concat utf8 file-lines ;

: execute-command ( program pc registers -- program pc registers output )
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
            f
        ] }
        { "inc" [
            first first CHAR: a - 
            dup
                pick nth
            1 +
            swap
            pick set-nth
            [ 1 + ] dip
            f
        ] }
        { "dec" [
            first first CHAR: a - 
            dup
            pick nth
            1 -
            swap
            pick set-nth
            [ 1 + ] dip
            f
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
            f
        ] }
        { "out" [
            first
            dup { "a" "b" "c" "d" } member?
            [ first CHAR: a - over nth ]
            [ string>number ] if
            [ 1 + ] 2dip
        ] }
    } case ;

: clock? ( seq -- ? )
    V{ 0 1 0 1 0 1 0 1 0 1 } = ;

: run-program ( program -- seed )
    [ 0 f ] dip
    [ over clock? ]
    [
        [ 1 + ] 2dip
        0 { 0 0 0 } 5 npick prefix
        V{ } clone
        [ dup length 10 < ]
        [
            [ execute-command ] dip
            over
            [ ?push ]
            [ nip ] if
        ] while
        2nip
        rot drop
        swap
    ] until
    2drop ;

: part1 ( file -- ) read-input [ " " split ] map run-program . ;

: day25 ( -- ) "input.txt" part1 ; 

MAIN: day25
