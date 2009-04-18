===========================
Exercises
===========================

2. First Steps
====================

1. 

Priorities of operators: ^ > * > +, -

::

    2 ^ 3 * 4 => (2 ^ 3) * 4

    2 * 3 + 4 * 5 => (2 * 3) + (4 * 5)

    2 + 3 * 4 ^ 5 => 2 + (3 * (4 ^ 5))

2.

::

    Hugs> 2 + 3
    5
    Hugs> 2 - 3
    -1
    Hugs> 2 * 3
    6
    Hugs> 7 'div' 2
    ERROR - Improperly terminated character constant
    Hugs> 7 `div` 2
    3
    Hugs> 2 ^ 3
    8
    Hugs> head [1, 2, 3, 4, 5]
    1
    Hugs> tail [1, 2, 3, 4, 5]
    [2,3,4,5]
    Hugs> [1, 2, 3, 4, 5] !! 2
    3
    Hugs> take 3 [1, 2, 3, 4, 5]
    [1,2,3]
    Hugs> drop 3 [1, 2, 3, 4, 5]
    [4,5]
    Hugs> length [1, 2, 3, 4, 5]
    5
    Hugs> sum [1, 2, 3, 4, 5]
    15
    Hugs> product [1, 2, 3, 4, 5]
    120
    Hugs> [1, 2, 3] ++ [4, 5]
    [1,2,3,4,5]
    Hugs> reverse [1, 2, 3, 4, 5]
    [5,4,3,2,1]
    Hugs> 1 `div` 0
     
    Program error: divide by zero
     
    Hugs> head []
     
    Program error: pattern match failure: head []
     
    Hugs> :edit test.hs
    Hugs> :load test.hs
    Main> quadruple 3
    12
    Main> quadruple 10
    40
    Main> double 3
    6
    Main> take double 2 [1, 2, 3, 4, 5]
    ERROR - Type error in application
    *** Expression     : take double 2 [1,2,3,4,5]
    *** Term           : take
    *** Type           : Int -> [e] -> [e]
    *** Does not match : a -> b -> c -> d

    Main> take (double 2) [1, 2, 3, 4, 5]
    [1,2,3,4]
    Main> :reload
    Main> factorial 10
    3628800
    Main> average [1,2,3,4,5]
    3
    Main> average take 5 [1..]
    ERROR - Type error in application
    *** Expression     : average take 5 (enumFrom 1)
    *** Term           : average
    *** Type           : [Int] -> Int
    *** Does not match : a -> b -> c -> d

    Main> average (take 5 [1..])
    3
    Main> :reload
    Main> [Leaving Hugs]


3. 

incorrect indents


4. 



.. vim:sw=4:ts=4:et:ai:si:sm:
