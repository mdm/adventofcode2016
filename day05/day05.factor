! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math.parser sequences io.encodings.utf8 io.files io prettyprint checksums checksums.md5 math byte-arrays assocs ;
IN: aoc2016.day05

: read-input ( file -- str ) { "work/aoc2016/day05/" } swap suffix concat utf8 file-lines first ;

: next-checksum ( door start -- chksum ) number>string append md5 checksum-bytes bytes>hex-string ;

: next-letter ( door start -- door newstart letter )
    [ 2dup next-checksum 5 head "00000" = ]
    [ 1 + ] until 2dup next-checksum 5 tail first [ 1 + ] dip ;

: crack-password ( door -- password ) 0 "" 8 [ [ next-letter ] dip swap suffix ] times 2nip ;

: part1 ( file -- ) read-input crack-password print ;

: next-position-and-letter ( door start -- door newstart position letter )
    [ 2dup next-checksum 5 head "00000" = ]
    [ 1 + ] until 2dup next-checksum 5 tail [ first ] [ second ] bi [ 1 + ] 2dip ;

: all-positions-fillled? ( positions -- positions ? ) t 8 [ CHAR: 0 + pick key? and ] each-integer ;

: assemble-password ( positions -- password ) "" 8 [ CHAR: 0 + pick at suffix ] each-integer nip ;

: crack-password2 ( door -- password )
    0 H{ } clone
    [ all-positions-fillled? ]
    [ [ next-position-and-letter ] dip pick over key? [ 2nip ] [ dup [ swapd set-at ] dip ] if ] until 2nip ;

: part2 ( file -- ) read-input crack-password2 assemble-password print ;

: day05 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day05
