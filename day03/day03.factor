! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences splitting io.encodings.utf8 io.files io prettyprint math.parser arrays math ;
IN: aoc2016.day03

: read-input ( file -- str ) { "work/aoc2016/day03/" } swap suffix concat utf8 file-lines ;

: parse-input ( str -- sides ) " " split [ empty? not ] filter [ string>number ] map ;

: combinations ( seq -- perms ) [ 2array ] map-index dup dup cartesian-product concat cartesian-product concat
    [ [ last ] [ first ] bi prefix ] map
    [ [ last ] map [
        [ first ] [ second ] bi <
    ] [
        [ first ] [ third ] bi = not
    ] [
        [ second ] [ third ] bi = not
    ] tri and and ] filter
    [ [ first ] map ] map ;

: count-possible ( triangles -- n ) [ combinations [ [ third ] [ second ] [ first ] tri + < ] all? ] filter length ;

: part1 ( file -- ) read-input [ parse-input ] map count-possible . ;

: rearrange ( sides -- triangles ) [ 2array ] map-index
    [ [ last 3 mod 0 = ] filter ]
    [ [ last 3 mod 1 = ] filter ]
    [ [ last 3 mod 2 = ] filter ] tri append append [ first ] map
    { } swap [ dup length 0 > ] [ [ 3 head ] [ 3 tail ] bi [ suffix ] dip ] while drop ;

: part2 ( file -- ) read-input [ parse-input ] map concat rearrange count-possible . ;

: day03 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day03
