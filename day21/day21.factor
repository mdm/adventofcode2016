! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences splitting prettyprint math.parser math arrays combinators io generalizations ;
IN: aoc2016.day21

: read-input ( file -- lines ) { "work/aoc2016/day21/" } swap suffix concat utf8 file-lines ;

: parse-input ( lines -- ranges )
    [
        " " split
        [ rest ]
        [ first ] bi
        {
            { "swap" [
                [ rest ]
                [ first ] bi
                {
                    { "position" [
                        [ first string>number ]
                        [ last string>number ] bi
                        [ "SP" ] 2dip
                        3array
                    ] }
                    { "letter" [
                        [ first first ]
                        [ last first ] bi
                        [ "SL" ] 2dip
                        3array
                    ] }
                } case
            ] }
            { "rotate" [
                [ rest ]
                [ first ] bi
                {
                    { "left" [
                        first string>number
                        "RL" swap
                        2array
                    ] }
                    { "right" [
                        first string>number
                        "RR" swap
                        2array
                    ] }
                    { "based" [
                        last first
                        "RPR" swap
                        2array                        
                    ] }
                } case
            ] }
            { "reverse" [
                rest
                [ first string>number ]
                [ last string>number ] bi
                [ "RV" ] 2dip
                3array
            ] }
            { "move" [
                rest
                [ first string>number ]
                [ last string>number ] bi
                [ "MV" ] 2dip
                3array
            ] }
        } case
    ] map ;

: apply-op ( str op -- str )
    [ rest ]
    [ first ] bi
    {
        { "SP" [
            over
            over
            [ first swap nth ]
            [ last swap nth ] 2bi
            [
                pick
                pick last
                swap
                set-nth
            ] dip
            pick
            pick first
            swap
            set-nth
            drop
        ] }
        { "SL" [
            over
            [
                {
                    { [ dup pick first = ] [ drop dup second ] }
                    { [ dup pick second = ] [ drop dup first ] }
                    [ ]
                } cond
            ] map
            2nip
        ] }
        { "RL" [
            first
            over length rem
            [ head ]
            [ tail ] 2bi
            swap
            append
        ] }
        { "RR" [
            first
            over length
            swap -
            over length rem
            [ head ]
            [ tail ] 2bi
            swap
            append            
        ] }
        { "RPR" [
            first
            over
            index
            dup
            4 >=
            [ 1 + ] when
            1 +
            over length
            swap -
            over length rem
            [ head ]
            [ tail ] 2bi
            swap
            append            
        ] }
        { "RV" [
            2dup
            first
            [ head nip ]
            [
                tail
                over second
                pick first -
                1 + 
                [ head reverse ]
                [ tail ] 2bi
                append
                nip
            ] 3bi
            append
            nip
        ] }
        { "MV" [
            2dup
            first
            [ head ]
            [
               tail
               [ rest ]
               [ first ] bi
            ] 2bi
            [ append ] dip
            swap
            pick second
            [ head ]
            [ tail ] 2bi
            [ swap suffix ] dip
            append
            2nip
        ] }
    } case ;

: test1 ( file -- )
    read-input
    parse-input
    "abcde"
    [ apply-op ] reduce
    print ;

: invert-op ( op -- op )
    [ rest ]
    [ first ] bi
    {
        { "SP" [ "SP" prefix ] }
        { "SL" [ "SL" prefix ] }
        { "RL" [ "RR" prefix ] }
        { "RR" [ "RL" prefix ] }
        { "RPR" [ "RPL" prefix ] }
        { "RPL" [ "RPR" prefix ] }
        { "RV" [ "RV" prefix ] }
        { "MV" [ reverse "MV" prefix ] }
    } case ;

: part1 ( file -- )
    read-input
    parse-input
    "abcdefgh"
    [ apply-op ] reduce
    print ;

: part2 ( file -- )
    read-input
    parse-input
    reverse
    "fbgdceah"
    [
        invert-op
        dup first "RPL" =
        [
            dupd
            [
                2dup
                invert-op
                apply-op
                4 npick =
            ]
            [
                swap
                { "RL" 1 }
                apply-op
                swap
            ] until
            swap
            2nip
        ]
        [
            apply-op
        ] if
    ] reduce
    print ;

: day21 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day21
