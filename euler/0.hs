--
-- 5.3 The zip function
--
module Main where

import Test.QuickCheck hiding (test)
import Test.HUnit


--
-- Problem 1:
--
-- If we list all the natural numbers below 10 that are multiples of 3 or 5, we
-- get 3, 5, 6 and 9. The sum of these multiples is 23.
--
-- Find the sum of all the multiples of 3 or 5 below 1000.
--
sum_of_mul_3_or_5 :: Int -> Int
sum_of_mul_3_or_5 n = foldl (+) 0 [x | x <- [3..n-1], x `mod` 3 == 0 || x `mod` 5 == 0]

{-
 - Result:

Prelude> :load ./0.hs
[1 of 1] Compiling Main             ( 0.hs, interpreted )
Ok, modules loaded: Main.
*Main> runTestTT tests
Cases: 1  Tried: 1  Errors: 0  Failures: 0
Counts {cases = 1, tried = 1, errors = 0, failures = 0}
*Main> sum_of_mul_3_or_5 1000
233168
*Main>
-}



tests = Test.HUnit.test [
                "1. sum of multiples of 3 or 5 below 10" ~: sum_of_mul_3_or_5 10 ~?= 23]

