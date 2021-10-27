! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math.parser sequences io.encodings.utf8 io.files io prettyprint checksums checksums.md5 math byte-arrays strings vectors generalizations math.order sorting arrays assocs ;
IN: aoc2016.day14

: read-input ( file -- str ) { "work/aoc2016/day14/" } swap suffix concat utf8 file-lines first ;

: next-hash ( salt index -- hash ) number>string append md5 checksum-bytes bytes>hex-string ;

: any-repetition ( hash n -- char/f )
    "0123456789abcdef" >array
    [
        over swap <repetition> >string
        pick subseq-start
    ] map
    [ ] filter
    dup length 0 >
    [
        [ <=> ] sort
        first
        pick nth
    ]
    [ drop f ] if
    2nip ;

: specific-repetition? ( hash n char -- ? )
    <repetition> >string
    swap subseq? ;

: next-key ( salt index -- salt index )
    [ 2dup next-hash 3 any-repetition dup ]
    [ drop 1 + ] until
    [
        2dup
        1 +
    ] dip
    [
        3dup
        over 8 npick -
        1000 >
        [ 3drop t ]
        [
            [ next-hash 5 ] dip specific-repetition?
        ] if
    ]
    [
        [ 1 + ] dip
    ] until
    drop nip
    over -
    1000 >
    [
        1 +
        next-key
    ]
    [

    ] if ;

: find-key-indices ( salt n -- indices )
    0 swap
    V{ }
    [ dup length pick < ]
    [
        [ next-key ] 2dip
        pick swap ?push
        [ 1 + ] 2dip
    ] while
    3nip ;

: part1 ( file -- ) read-input 64 find-key-indices last . ;

: next-hash2 ( cache salt index -- hash )
    pick dupd key?
    [ nip swap at ]
    [
        dup -rot
        number>string append
        md5 checksum-bytes bytes>hex-string
        2016 [ md5 checksum-bytes bytes>hex-string ] times
        dup
        [ swap rot set-at ] dip
    ] if ;      

: next-key2 ( cache salt index -- cache salt index )
    [ 3dup next-hash2 3 any-repetition dup ]
    [ drop 1 + ] until
    [
        3dup
        1 +
    ] dip
    [
        4dup
        over 10 npick -
        1000 >
        [ 4drop t ]
        [
            [ next-hash2 5 ] dip specific-repetition?
        ] if
    ]
    [
        [ 1 + ] dip
    ] until
    drop 2nip
    over -
    1000 >
    [
        1 +
        next-key2
    ]
    [

    ] if ;

: find-key-indices2 ( salt n -- indices )
    [ H{ } clone ] 2dip
    0 swap
    V{ }
    [ dup length pick < ]
    [
        [ next-key2 ] 2dip
        pick swap ?push
        [ 1 + ] 2dip
    ] while
    4nip ;

: part2 ( file -- ) read-input 64 find-key-indices2 last . ;

: day14 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day14
