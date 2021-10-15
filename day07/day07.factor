! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files math prettyprint arrays io ;
IN: aoc2016.day07

: read-input ( file -- str ) { "work/aoc2016/day07/" } swap suffix concat utf8 file-lines ;

: within-hypernet-seq? ( seq n -- ? ) head [ [ CHAR: [ = ] count ] [ [ CHAR: ] = ] count ] bi - 0 > ;

: abba? ( seq -- ? ) first [ [ first ] [ second ] bi = not ] [ dup reverse = ] bi and ;

: supports-tls? ( ip -- ? ) dup dup length 3 - head [
        nip
        [ dup 4 + pick subseq ]
        [ within-hypernet-seq? ] 2bi 2array
    ] map-index [ [ abba? ] any? ] [ [ second ] filter [ abba? ] none? ] bi and nip ;

: part1 ( file -- ) read-input [ supports-tls? ] count . ;

: invert ( seq -- seq ) "" swap [ first ] [ second ] bi dup swapd [ suffix ] 2dip [ suffix ] dip suffix ;

: supports-ssl? ( ip -- ? ) dup dup length 2 - head [
        nip
        [ dup 3 + pick subseq ]
        [ within-hypernet-seq? ] 2bi 2array
    ] map-index
    [ [ second ] filter [ abba? ] filter [ first ] map ] [ [ second ] reject [ abba? ] filter [ first ] map ] bi
    [ invert over member? ] any? 2nip ;

: part2 ( file -- ) read-input [ supports-ssl? ] count . ;

: day07 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day07
