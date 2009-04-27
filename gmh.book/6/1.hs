--
-- 6.1 Basic concepts
--
module Main where

import Test.QuickCheck

prop_factorial n = n > 1 ==> factorial n + 1 == (n + 1) * factorial n
        where types = n::Int

prop_factorial' n = n > 1 ==> factorial' n == factorial n
        where types = n::Int

prop_mult m n = m > 0 && n > 0 ==> m `mult` n == m * n
        where types = (m,n) :: (Int,Int)

quicktests = do quickCheck prop_factorial
                quickCheck prop_factorial'
                quickCheck prop_mult


factorial :: Int -> Int
factorial n = product [1..n]

factorial' :: Int -> Int
factorial' 0       = 1
factorial' (n + 1) = (n + 1) * factorial' n

mult :: Int -> Int -> Int
m `mult` 0       = 0
m `mult` (n + 1) = m + (m `mult` n)
