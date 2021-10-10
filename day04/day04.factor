! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files splitting prettyprint accessors math.order sorting arrays math strings math.parser ;
IN: aoc2016.day04

TUPLE: room id chksum name ;

: read-input ( file -- str ) { "work/aoc2016/day04/" } swap suffix concat utf8 file-lines ;

: parse-checksum ( str -- chksum ) "[" split1 nip 5 head ;

: parse-room ( str -- id name ) "[" split1 drop "-" split reverse [ first string>number ] [ rest reverse "-" join ] bi ;

: parse-input ( str -- room ) [ parse-checksum ] [ parse-room ] bi swapd room boa ;

: calculate-checksum ( room -- room chksum ) dup name>> [ CHAR: - = not ] filter
    [ <=> ] sort
    { } swap
    [ 0 = [ 1 2array prefix ] [ [ dup first first ] dip dup [ = ] dip swap 
        [ drop dup 0 swap [ [ first ] [ last 1 + ] bi 2array ] change-nth ]
        [ 1 2array prefix ]
    if ] if ] each-index
    [ 2dup [ last ] bi@ = [ [ first ] bi@ <=> ] [ [ last ] bi@ swap <=> ] if ] sort
    [ first 1string ] map 5 short head concat ;

: verify-checksum ( room checksum -- ? ) swap chksum>> = ;

: real-rooms ( rooms -- rooms ) [ calculate-checksum [ chksum>> ] dip = ] filter ;

: part1 ( file -- ) read-input [ parse-input ] map real-rooms [ id>> ] map sum . ;

: decrypt-name ( room -- name ) [ id>> ] [ name>> ] bi [ dup CHAR: - = [ drop CHAR: \x20 ] [ CHAR: a - over + 26 mod CHAR: a + ] if ] map nip ;

: part2 ( file -- ) read-input [ parse-input ] map real-rooms [ decrypt-name "northpole object storage" swap subseq? ] filter first id>> . ;

: day04 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day04
