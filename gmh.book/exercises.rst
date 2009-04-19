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


4. see 2/last.hs

::

    Hugs> :load 2/last.hs
    Main> last_1 [1,2,3,4,5]
    5
    Main> last_2 [1,2,3,4,5]
    5
    Main> :reload
    Main> last_3 [1,2,3,4,5]
    5
    Main> last_3 [1,2,3,4,5, 6]
    6
    Hugs> :reload
    Main> last_4 [1,2,3,4,5,6,7]
    7
    Main> last_4 []
     
    Program error: Given list is empty!
     
    Main>


Testing with ghci:

::

    *Last> quickCheck prop_last_1
    Loading package syb ... linking ... done.
    Loading package base-3.0.3.0 ... linking ... done.
    Loading package old-locale-1.0.0.1 ... linking ... done.
    Loading package old-time-1.0.0.1 ... linking ... done.
    Loading package random-1.0.0.1 ... linking ... done.
    Loading package QuickCheck-1.2.0.0 ... linking ... done.
    OK, passed 100 tests.
    *Last> quickCheck prop_last_2
    OK, passed 100 tests.
    *Last> quickCheck prop_last_3
    OK, passed 100 tests.
    *Last> quickCheck prop_last_4
    OK, passed 100 tests.
    *Last>


5. 2/init.hs

compile and run it in ghci:

::

    Prelude> :load 2/init.hs
    [1 of 1] Compiling Init             ( 2/init.hs, interpreted )
    Ok, modules loaded: Init.
    *Init> init [1,2,3,4,5]
    [1,2,3,4]
    *Init> init_1 [1,2,3,4,5]
    Loading package syb ... linking ... done.
    Loading package base-3.0.3.0 ... linking ... done.
    Loading package old-locale-1.0.0.1 ... linking ... done.
    Loading package old-time-1.0.0.1 ... linking ... done.
    Loading package random-1.0.0.1 ... linking ... done.
    Loading package QuickCheck-1.2.0.0 ... linking ... done.
    [1,2,3,4]
    *Init> init_2 [1,2,3,4,5]
    [1,2,3,4]
    *Init> QuickCheck prop_init_1
        
    <interactive>:1:0: Not in scope: data constructor `QuickCheck'
    *Init> quickCheck prop_init_1
    OK, passed 100 tests.
    *Init> quickCheck prop_init_2
    OK, passed 100 tests.
    *Init>


.. vim:sw=4:ts=4:et:ai:si:sm:
