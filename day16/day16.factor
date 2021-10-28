! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences prettyprint math math.parser splitting arrays strings ;
IN: aoc2016.day16

: read-input ( file -- lines ) { "work/aoc2016/day16/" } swap suffix concat utf8 file-lines first ;

: generate-data ( initial n -- data n )
    over length over <
    [
        swap dup reverse
        [ CHAR: 1 = [ CHAR: 0 ] [ CHAR: 1 ] if ] map
        "0" swap
        append append
        swap
        generate-data
    ]
    [
        dup
        [ head ] dip
    ] if ;

: checksum ( data -- chksum )
    [ 2array ] map-index
    [ second even? ] partition
    [ [ first ] bi@ 2array ] 2map
    [
        [ first ] [ second ] bi
        =
        [ CHAR: 1 ]
        [ CHAR: 0 ] if
    ] map
    >string
    dup length even?
    [ checksum ]
    [ ] if ;

: part1 ( file -- )
    read-input
    272 generate-data
    drop
    checksum
    . ;

: part2 ( file -- )
    read-input
    35651584 generate-data
    drop
    checksum
    . ;

: day16 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day16
