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


5. List comprehensions
========================

5.1 Generators
------------------------

::

    Prelude> [(x,y) | x <- [1..5], y <- [6,7]]
    [(1,6),(1,7),(2,6),(2,7),(3,6),(3,7),(4,6),(4,7),(5,6),(5,7)]
    Prelude> [(x,y) | x <- [1..3], y <- [x..3]]
    [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
    Prelude> :load ./5/1.hs
    [1 of 1] Compiling Main             ( 5/1.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> concat' [[1,2],[3,4,5]]
    Loading package syb ... linking ... done.
    Loading package base-3.0.3.0 ... linking ... done.
    Loading package old-locale-1.0.0.1 ... linking ... done.
    Loading package old-time-1.0.0.1 ... linking ... done.
    Loading package random-1.0.0.1 ... linking ... done.
    Loading package QuickCheck-1.2.0.0 ... linking ... done.
    [1,2,3,4,5]
    *Main> firsts' [(1,2),(3,4),(5,6)]
    [1,3,5]
    *Main> length' [1,3..100]
    50
    *Main>


5.2 Guards
------------------

::

    *Main> :load ./5/2.hs
    [1 of 1] Compiling Main             ( 5/2.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> factors 15
    [1,3,5,15]
    *Main> prime 15
    False
    *Main> prime 7
    True
    *Main> primes 20
    [2,3,5,7,11,13,17,19]
    *Main> find 'c' [('c',0), ('a',2), ('b',3), ('c',7)]
    [0,7]
    *Main>


5.3 The zip function
----------------------------

::

    *Main> :load ./5/3.hs
    [1 of 1] Compiling Main             ( 5/3.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> zip' "abcd" [1..5]
    [('a',1),('b',2),('c',3),('d',4)]
    *Main> pairs' [1..5]
    [(1,2),(2,3),(3,4),(4,5)]
    *Main>


::

    *Main> :reload
    Ok, modules loaded: Main.
    *Main> runTestTT tests
    Cases: 4  Tried: 4  Errors: 0  Failures: 0
    Counts {cases = 4, tried = 4, errors = 0, failures = 0}
    *Main> quickCheck prop_zip'
    OK, passed 100 tests.
    *Main> quickCheck prop_zip''
    OK, passed 100 tests.
    *Main>


5.4 String comprehensions
-------------------------------------

::

    *Main> :load ./5/4.hs
    [1 of 1] Compiling Main             ( 5/4.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runTestTT tests
    Cases: 2  Tried: 2  Errors: 0  Failures: 0
    Counts {cases = 2, tried = 2, errors = 0, failures = 0}
    *Main>


::

    Prelude> :load ./5//caesar.hs
    [1 of 1] Compiling Caesar           ( 5/caesar.hs, interpreted )
    Ok, modules loaded: Caesar.
    *Caesar> runTestTT tests
    Cases: 11  Tried: 11  Errors: 0  Failures: 0
    Counts {cases = 11, tried = 11, errors = 0, failures = 0}
    *Caesar> freqs "abbcccddddeeeee"
    [6.666667,13.333334,20.0,26.666668,33.333336,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    *Caesar>

::

    Prelude> :load ./5//caesar.hs
    [1 of 1] Compiling Caesar           ( 5/caesar.hs, interpreted )
    Ok, modules loaded: Caesar.
    *Caesar> runTestTT tests
    Cases: 12  Tried: 12  Errors: 0  Failures: 0
    Counts {cases = 12, tried = 12, errors = 0, failures = 0}
    *Caesar>



5.7 Excercises
-------------------

1.

::

    Prelude> [x ^ 2 | x <- [1..100]]
    [1,4,9,16,25,36,49,64,81,100,121,144,169,196,225,256,289,324,361,400,441,484,529,576,
    625,676,729,784,841,900,961,1024,1089,1156,1225,1296,1369,1444,1521,1600,1681,1764,
    1849,1936,2025,2116,2209,2304,2401,2500,2601,2704,2809,2916,3025,3136,3249,3364,3481,
    3600,3721,3844,3969,4096,4225,4356,4489,4624,4761,4900,5041,5184,5329,5476,5625,5776,
    5929,6084,6241,6400,6561,6724,6889,7056,7225,7396,7569,7744,7921,8100,8281,8464,8649,
    8836,9025,9216,9409,9604,9801,10000]
    Prelude>


2. 5/replicate.hs

::

    *Main> length' [1..45]
    45
    *Main> length' [1,3..50]
    25
    *Main> replicate' 4 11
    [11,11,11,11]
    *Main>


3. 

::

    *Main> :load ./5/pyths.hs
    [1 of 1] Compiling Main             ( 5/pyths.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> tests
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main> pyths 10
    [(3,4,5),(4,3,5),(6,8,10),(8,6,10)]
    *Main> pyths 15
    [(3,4,5),(4,3,5),(5,12,13),(6,8,10),(8,6,10),(9,12,15),(12,5,13),(12,9,15)]
    *Main> pyths' 15
    [(3,4,5),(5,12,13),(6,8,10),(9,12,15)]
    *Main>


4. 

::

    *Main> :load ./5/perfects.hs
    [1 of 1] Compiling Main             ( 5/perfects.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> quicktests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main> factors 15
    [1,3,5,15]
    *Main> factors' 15
    [1,3,5]
    *Main> perfects 500
    [6,28,496]
    *Main>


::

    *Main> :load ./5/perfects.hs
    [1 of 1] Compiling Main             ( 5/perfects.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> quicktests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main>


5.


x = 1, y = [4..6]; x = 2, y = [4..6], ...

::

    $ ghci
    GHCi, version 6.10.1: http://www.haskell.org/ghc/  :? for help
    Loading package ghc-prim ... linking ... done.
    Loading package integer ... linking ... done.
    Loading package base ... linking ... done.
    Prelude> [(x,y) | x <- [1,2,3], y <- [4,5,6]]
    [(1,4),(1,5),(1,6),(2,4),(2,5),(2,6),(3,4),(3,5),(3,6)]
    Prelude> :i concat
    concat :: [[a]] -> [a]  -- Defined in GHC.List
    Prelude> concat [[(x,y) | y <- [4,5,6]] | x <- [1,2,3]]
    [(1,4),(1,5),(1,6),(2,4),(2,5),(2,6),(3,4),(3,5),(3,6)]
    Prelude> ^DLeaving GHCi.
    $


6. 

::

    *Main> :load ./5/positions.hs
    [1 of 1] Compiling Main             ( 5/positions.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> quicktests
    OK, passed 100 tests.
    *Main> positions 1 [1,2,3,1]
    [0,3]
    *Main> positions' 1 [1,2,3,1]
    [0,3]
    *Main>

7.

::

    *Main> :load ./5/scalarproduct.hs
    [1 of 1] Compiling Main             ( 5/scalarproduct.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runtests
    Cases: 1  Tried: 1  Errors: 0  Failures: 0
    Counts {cases = 1, tried = 1, errors = 0, failures = 0}
    *Main> scalarproduct [1,2,3] [4,5,6]
    32
    *Main>


8.

modify let2int, int2let and shift to support uppercase letters.

::

    *Caesar2> :load ./5/caesar2.hs
    [1 of 1] Compiling Caesar2          ( 5/caesar2.hs, interpreted )
    Ok, modules loaded: Caesar2.
    *Caesar2> runtests
    Cases: 18  Tried: 18  Errors: 0  Failures: 0
    Counts {cases = 18, tried = 18, errors = 0, failures = 0}
    *Caesar2> encode 5 "Haskell is fun"
    "Mfxpjqq nx kzs"
    *Caesar2> encode (-5) (encode 5 "Haskell is fun")
    "Haskell is fun"
    *Caesar2>


6. Recursive functions
========================================


6.1 Basic concepts
------------------------------

::

    Prelude> :load ./6/1.hs
    [1 of 1] Compiling Main             ( 6/1.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> quicktests
    Falsifiable, after 0 tests:
    3
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main>


6.2 Recursion on lists
--------------------------------

::

    Prelude> :load ./6/2.hs
    [1 of 1] Compiling Main             ( 6/2.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> quicktests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main>


6.3 Multiple arguments
-----------------------------

::

    Prelude> :load ./6/3.hs
    [1 of 1] Compiling Main             ( 6/3.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> quicktests
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main>


6.8 Exercises
-------------------------

Made answers except for merge sort implementation.

::

    *Main> :load ./6/8.hs
    [1 of 1] Compiling Main             ( 6/8.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runtests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    Cases: 2  Tried: 2  Errors: 0  Failures: 0
    Counts {cases = 2, tried = 2, errors = 0, failures = 0}
    *Main>


7. Higher order functions
=================================

7.2 Processing lists
------------------------

::

    Prelude> :load ./7/2.hs
    [1 of 1] Compiling Main             ( 7/2.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> map' (+1) [1,3..10]
    [2,4,6,8,10]
    *Main> map'' (+1) [1,3..10]
    [2,4,6,8,10]
    *Main> Data.List.map (+1) [1,3..10]
    [2,4,6,8,10]
    *Main> filter' even [1..10]
    [2,4,6,8,10]
    *Main> filter'' even [1..10]
    [2,4,6,8,10]
    *Main> Data.List.filter even [1..10]
    [2,4,6,8,10]
    *Main> sumsqreven [1..10]
    220
    *Main>


7.3 The foldr function
---------------------------

::

    Prelude> :load ./7//3.hs
    [1 of 1] Compiling Main             ( 7/3.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runtests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main>


7.4 The foldl function
---------------------------

::

    *Main> :load ./7//4.hs
    [1 of 1] Compiling Main             ( 7/4.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runtests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    *Main>


7.5 The composition operator
----------------------------------

::

    *Main> :load ./7//5.hs
    [1 of 1] Compiling Main             ( 7/5.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> let odd = not ... even
    *Main> odd 3
    True
    *Main> odd 4
    False
    *Main> let twice = \f -> f ... f
    *Main> twice (\x -> x + 3) 2
    8
    *Main>

7.6 String transmitter
-----------------------------------

::

    *Main> :load ./7//6.hs
    [1 of 1] Compiling Main             ( 7/6.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runtests
    Cases: 7  Tried: 7  Errors: 0  Failures: 0
    Counts {cases = 7, tried = 7, errors = 0, failures = 0}
    *Main>


7.8 Exercises
-------------------------

::

    *Main> :load ./7/exercises.hs
    [1 of 1] Compiling Main             ( 7/exercises.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> runtests
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    OK, passed 100 tests.
    Cases: 7  Tried: 7  Errors: 0  Failures: 0
    Counts {cases = 7, tried = 7, errors = 0, failures = 0}
    *Main>

6:

::

    *Main> let g = curry (\(x,y) -> x + y :: Int)
    *Main> let g' = curry' (\(x,y) -> x + y :: Int)
    *Main> g 1 2
    3
    *Main> g' 1 2
    3
    *Main> let h = uncurry g
    *Main> let h' = uncurry g'
    *Main> h (3,4)
    7
    *Main> h' (3,4)
    7
    *Main>


7,8:

::

    *Main> :load ./7/exercises.hs
    [1 of 1] Compiling Main             ( 7/exercises.hs, interpreted )
    Ok, modules loaded: Main.
    *Main> encode' "Haskell is fun"
    [0,0,0,0,1,0,0,1,0,1,1,0,0,0,0,1,1,0,1,1,1,0,0,1,1,1,0,1,1,1,0,1,0,1,1,0,0,1,0,1,0,0,1,1,0,0,0,0,1,1,0,1,1,0,0,0,0,1,1,0,1,1,0,1,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,0,1,1,1,0,0,1,1,1,0,1,0,0,0,0,0,1,0,0,0,0,1,1,0,0,1,1,0,1,1,0,1,0,1,1,1,0,1,0,1,1,1,0,1,1,0]
    *Main> let r0 = encode' "Haskell is fun"
    *Main> let bs0 = encode' "Haskell is fun"
    *Main> length bs0
    126
    *Main> length "Haskell is fun"
    14
    *Main> 14 * 8
    112
    *Main> decode' bs0
    "Haskell is fun"
    *Main> let fchan = tail :: [Bit] -> [Bit] -- erronous channel
    *Main> let transmit' = decode' . fchan . encode'
    *Main> transmit' "Haskell is fun"
    "*** Exception: Parity check failed
    *Main>



.. vim:sw=4:ts=4:et:ai:si:sm:
