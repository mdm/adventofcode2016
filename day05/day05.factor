! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math.parser sequences io.encodings.utf8 io.files io prettyprint checksums checksums.md5 math byte-arrays ;
IN: aoc2016.day05

: read-input ( file -- str ) { "work/aoc2016/day05/" } swap suffix concat utf8 file-lines first ;

: next-checksum ( door start -- chksum ) number>string append md5 checksum-bytes bytes>hex-string ;

: next-letter ( door start -- door newstart letter )
    [ 2dup next-checksum 5 head "00000" = ]
    [ 1 + ] until 2dup next-checksum 5 tail first [ 1 + ] dip ;

: crack-password ( door -- password ) 0 "" 8 [ [ next-letter ] dip swap suffix ] times 2nip ;

: part1 ( file -- ) read-input crack-password print ;

: part2 ( file -- ) read-input . ;

: day05 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day05
