! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel io.encodings.utf8 io.files sequences math prettyprint splitting math.parser ;
IN: aoc2016.day09

: read-input ( file -- str ) { "work/aoc2016/day09/" } swap suffix concat utf8 file-lines first ;

: parse-marker ( data len -- rest newlen ) over [ CHAR: ) = ] find drop
    swapd [ 1 + tail ] [ head rest ] 2bi
    "x" split [ string>number ] map
    [ first ] [ second ] bi
    dupd *
    [ tail swap ] dip + ;

: parse-next ( data len -- rest newlen ) over first CHAR: ( = [ parse-marker ] [ 1 + swap rest swap ] if ;

: decompressed-length ( data -- n ) 0 [ over length 0 > ] [ parse-next ] while nip ;

: part1 ( file -- ) read-input decompressed-length . ;

DEFER: decompressed-length-recursive

: parse-marker-recursive ( data len -- rest newlen ) over [ CHAR: ) = ] find drop
    swapd [ 1 + tail ] [ head rest ] 2bi
    "x" split [ string>number ] map
    [ first ] [ second ] bi
    [ [ tail swap ] [ head decompressed-length-recursive ] 2bi ] dip * + ;

: parse-next-recursive ( data len -- rest newlen ) over first CHAR: ( = [ parse-marker-recursive ] [ 1 + swap rest swap ] if ;

: decompressed-length-recursive ( data -- n ) 0 [ over length 0 > ] [ parse-next-recursive ] while nip ;

: part2 ( file -- ) read-input decompressed-length-recursive . ;

: day09 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day09
