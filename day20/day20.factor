! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences splitting prettyprint math.parser math arrays combinators ;
IN: aoc2016.day20

: read-input ( file -- lines ) { "work/aoc2016/day20/" } swap suffix concat utf8 file-lines ;

: parse-input ( lines -- ranges )
    [
        "-" split
        [ string>number ] map
    ] map ;

: unpack-ranges ( allowed denied -- allowed denied a1 a2 d1 d2 )
    2dup
    [
        [ first ]
        [ second ] bi
    ] bi@ ;

: blacklist-ips ( allowed denies -- allowed )
    {
        {
            [ ! a1 >= d1 and a2 <= d2
                unpack-ranges
                swapd
                [ >= ] 2dip
                <=
                and
            ]
            [
                2drop { }
            ]
        }
        {
            [ ! a1 < d1 and a2 > d2
                unpack-ranges
                swapd
                [ < ] 2dip
                >
                and
            ]
            [
                over first
                over first 1 -
                2array
                pick second
                pick second 1 +
                swap 2array
                2array
                2nip
            ]
        }
        {
            [ ! a1 < d1 and d1 <= a2
                unpack-ranges
                drop dup swapd
                [ < ] 2dip
                >=
                and
            ]
            [
                over first
                over first 1 -
                2array
                1array
                2nip
            ]
        }
        {
            [ ! d2 >= a1 and a2 > d2
                unpack-ranges
                nip dup swapd
                [ <= ] 2dip
                >
                and
            ]
            [
                over second
                over second 1 +
                swap 2array
                1array
                2nip
            ]
        }
        [
            drop 1array
        ]
    } cond ;

: non-blocked-ips ( allowed denied -- allowed )
    swap
    [
        over
        blacklist-ips
    ] map
    concat
    nip ;

: part1 ( file -- )
    read-input
    parse-input
    0 4294967295 2array 1array
    [ non-blocked-ips ] reduce
    first first
    . ;

: part2 ( file -- )
    read-input
    parse-input
    0 4294967295 2array 1array
    [ non-blocked-ips ] reduce
    [
        [ second ]
        [ first ] bi
        -
        1 +
    ] map
    sum
    . ;

: day20 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day20
