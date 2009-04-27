--
-- Pythagorean numbers
--
module Main where

import Test.QuickCheck
import Test.HUnit

-- tests
{-
tests = Test.HUnit.test ["let2int 'a'" ~: let2int 'a' ~?= 0,
                         "let2int 'z'" ~: let2int 'z' ~?= 25,
-}

prop_pyths n = n > 1 ==> and $ [x ^ 2 + y ^ 2 == z ^ 2 | (x,y,z) <- pyths n]
        where types = n::Int

prop_pyths' n = n > 1 ==> and $ [x ^ 2 + y ^ 2 == z ^ 2 | (x,y,z) <- pyths' n]
        where types = n::Int

tests = do quickCheck prop_pyths
           quickCheck prop_pyths'

-- n > 1
pyths :: Int -> [(Int, Int, Int)]
pyths n | n < 1     = []
        | otherwise = [(x,y,z) | x <- [2..n-2],
                                 y <- [2..n-2],
                                 z <- [2..n],
                                 x ^ 2 + y ^ 2 == z ^ 2]

pyths' :: Int -> [(Int, Int, Int)]
pyths' n | n < 1     = []
         | otherwise = [(x,y,z) | x <- [2..n-2],
                                  y <- [x..n-1],
                                  z <- [y..n],
                                  x ^ 2 + y ^ 2 == z ^ 2]
