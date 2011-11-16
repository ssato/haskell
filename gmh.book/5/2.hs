--
-- 5.2 Guards
--
module GuardExamples where

import Test.QuickCheck
import Test.HUnit


-- list positive factors of a positive integer
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

-- other solutions:
factors' :: Int -> [Int]
factors' n = filter (\x -> n `mod` x == 0) [1..n]

-- prime number checker
isPrime :: Int -> Bool
isPrime n = factors n == [1, n]

-- prime numbers from 2 upto n
primes :: Int -> [Int]
primes n = [x | x <- [2..n], isPrime x]

-- other solutions:
primes' :: Int -> [Int]
primes' n = filter isPrime [2..n]

-- Hashmap, dict:
-- returns the list of all values that are associated with a given key in a
-- table which is a list of pairs comprising keys and values.
find :: Eq a => a -> [(a,b)] -> [b]
find k tbl = [v | (k', v) <- tbl, k == k']


-- tests:
prop_factors n = n > 0 && n < 1000 ==> null [1 | x <- xs, n `mod` x /= 0]
    where types = n :: Int
          xs = factors n

prop_factors' n = n > 0 && n < 1000 ==> factors n == factors' n
    where types = n :: Int

unittests = Test.HUnit.test [
     "primes 10" ~: primes 10 ~?= [2, 3, 5, 7]
    ,"find 1 [(1, 'a'), (2, 'b'), (3, 'c'), (1, 'd')]" ~: find 1 [(1, 'a'), (2, 'b'), (3, 'c'), (1, 'd')] ~?= ['a', 'd']
    ]

runtests = do quickCheckWith stdArgs {maxSuccess=2} prop_factors
              quickCheckWith stdArgs {maxSuccess=2} prop_factors'
              runTestTT unittests

-- vim:sw=4 ts=4 et:
