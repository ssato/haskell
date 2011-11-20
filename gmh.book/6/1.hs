--
-- 6.1 Basic concepts
--
module RecursiveBasic where

import Test.QuickCheck


factorial :: Int -> Int
factorial n = product [1..n]
-- or: factorial = product (\n -> [1..n])   [point-free sytle]

factorial' :: Int -> Int
factorial' 0 = 1
-- deprecated n + k pattern:
-- factorial' (n + 1) = (n + 1) * factorial' n
factorial' 1 = 1
factorial' n = n * factorial' (n - 1)

{- 

  factorial' 4 
= 4 * factorial' 3
= 4 * (3 * factorial' 2)
= 4 * (3 * (2 * factorial' 1)
= 4 * (3 * (2 * 1)
= 4 * (3 * 2)
= 4 * 6
= 24

-}


multi :: Int -> Int -> Int
m `multi` 0 = 0
-- deprecated n + k pattern:
-- m `multi` (n + 1) = m + (m `multi` n)
m `multi` 1 = m 
m `multi` n = m + (m `multi` (n - 1))


prop_factorial n = n > 1 && n < 1000 ==> factorial n == n * factorial (n - 1)
    where types = n :: Int

prop_factorial' n = n > 1 && n < 1000 ==> factorial' n == factorial n
    where types = n :: Int

prop_multi m n = m > 0 && n > 0 && n < 1000 ==> m `multi` n == m * n
    where types = (m :: Int, n :: Int)

runtests = do quickCheckWith stdArgs {maxSuccess=2} prop_factorial
              quickCheckWith stdArgs {maxSuccess=2} prop_factorial'
              quickCheckWith stdArgs {maxSuccess=2} prop_multi


-- vim:sw=4 ts=4 et:
