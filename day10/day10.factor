! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences io.encodings.utf8 io.files prettyprint assocs generalizations arrays splitting math.order sorting math.parser ;
IN: aoc2016.day10

: read-input ( file -- str ) { "work/aoc2016/day10/" } swap suffix concat utf8 file-lines ;

: add-chip ( carrier chip chips -- chips ) swapd dup [
        2dup [
            ?at
            [ swap suffix ]
            [ drop 1array ] if
            [ [ string>number ] bi@ <=> ] sort
        ] 2dip set-at
    ] dip ;

: pass-chips ( lower higher carrier chips -- chips ? )
    dup [ ?at ] dip
    swap
    [ 
        over length 2 =
        [ [ [ first ] [ second ] bi swapd ] dip add-chip add-chip f ]
        [ 3nip t ] if
    ]
    [ 3nip t ] if ;

: apply-instructions ( instructions chips -- instructions chips ) swap [
        " " split
        dup first "value" =
        [ [ 5 swap nth "bot" swap append ] [ 1 swap nth ] bi pick add-chip f ]
        [
            [ [ 5 swap nth ] [ 6 swap nth ] bi append ]
            [ [ 10 swap nth ] [ 11 swap nth ] bi append ]
            [ 1 swap nth "bot"  swap append ] tri 4 npick pass-chips
        ] if nip
    ] filter swap ;

: part1 ( file -- ) read-input H{ } clone
    [ { "17" "61" } over value? ]
    [ apply-instructions ] until
    nip  { "17" "61" } swap value-at 3 tail string>number . ;

: part2 ( file -- ) read-input H{ } clone
    [ { "output0" "output1" "output2" } [ over key? ] all? ]
    [ apply-instructions ] until
    nip { "output0" "output1" "output2" } [ over at first string>number ] map product . drop ;

: day10 ( -- ) "input.txt" [ part1 ] [ part2 ] bi ; 

MAIN: day10
