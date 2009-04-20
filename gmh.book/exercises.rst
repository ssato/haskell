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


3. Types and classes
====================

1.

::

    ['a', 'b', 'c'] => "abc" :: [Char]
    ('a', 'b', 'c') :: (Char, Char, Char)
    [(False, '0'), (True, '1')] :: [(Bool, Char)]
    ([False, True], ['0', '1']) :: ([Bool], [Char])
    [tail, init, reverse] :: [[a] -> [a]]

Confirm with ghci:
::

    $ ghci
    GHCi, version 6.10.1: http://www.haskell.org/ghc/:? for help
    Loading package ghc-prim ... linking ... done.
    Loading package integer ... linking ... done.
    Loading package base ... linking ... done.
    Prelude> :t ['a', 'b', 'c']
    ['a', 'b', 'c'] :: [Char]
    Prelude> :t ('a', 'b', 'c')
    ('a', 'b', 'c') :: (Char, Char, Char)
    Prelude> :t [(False, '0'), (True, '1')]
    [(False, '0'), (True, '1')] :: [(Bool, Char)]
    Prelude> :t ([False, True], ['0', '1'])
    ([False, True], ['0', '1']) :: ([Bool], [Char])
    Prelude> :t [tail, init, reverse]
    [tail, init, reverse] :: [[a] -> [a]]
    Prelude> ^DLeaving GHCi.
    $

2. 

::

    second :: [a] -> a
    swap :: (a, b) -> (b, a)
    pair :: a -> b -> (a, b)
    double :: Int -> Int
    palindrome :: Eq a => [a] -> Bool
    twice :: (a -> a) -> a -> a


tryed with ghci.

::

    $
    GHCi, version 6.10.1: http://www.haskell.org/ghc/  :? for help
    Loading package ghc-prim ... linking ... done.
    Loading package integer ... linking ... done.
    Loading package base ... linking ... done.
    Prelude> :load 3/functions.hs
    [1 of 1] Compiling Main             ( 3/functions.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> :t second
    second :: [a] -> a
    *Main> :t swap
    swap :: (t, t1) -> (t1, t)
    *Main> :t pair
    pair :: t -> t1 -> (t, t1)
    *Main> :t double
    double :: (Num a) => a -> a
    *Main> :t palindrome
    palindrome :: (Eq a) => [a] -> Bool
    *Main> :t twice
    twice :: (t -> t) -> t -> t
    *Main> ^DLeaving GHCi.
    $



4. Defining functions
========================

1. 4/halve.hs

::

    Prelude> :load ./4//halve.hs
    [1 of 1] Compiling Halve            ( 4/halve.hs, interpreted )
    Ok, modules loaded: Halve.
    *Halve> quickCheck prop_halve
    Loading package syb ... linking ... done.
    Loading package base-3.0.3.0 ... linking ... done.
    Loading package old-locale-1.0.0.1 ... linking ... done.
    Loading package old-time-1.0.0.1 ... linking ... done.
    Loading package random-1.0.0.1 ... linking ... done.
    Loading package QuickCheck-1.2.0.0 ... linking ... done.
    OK, passed 100 tests.
    *Halve> halve [1..10]
    ([1,2,3,4,5],[6,7,8,9,10])
    *Halve>


2. 4/safetail.hs

::

    Prelude> :reload
    [1 of 1] Compiling Safetail         ( 4/safetail.hs, interpreted )
    Ok, modules loaded: Safetail.
    *Safetail> quickCheck prop_safetail_c
    OK, passed 100 tests.
    *Safetail> quickCheck prop_safetail_a
    OK, passed 100 tests.
    *Safetail> quickCheck prop_safetail_b
    OK, passed 100 tests.
    *Safetail>


3, 4, 5: 4/logicalops.hs

6.

::

    mult x y z = x * y * z ==> \x -> (\y -> y + z)



.. vim:sw=4:ts=4:et:ai:si:sm:
