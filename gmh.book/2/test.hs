{-

test.hs in chapter 2. (p.15)

-}
module Double(double, quadruple, factorial, average) where

-- import Data.List
import Test.QuickCheck
import Test.HUnit

double x = x + x
quadruple = double . double


-- Factorial of a positive integer
factorial n = product [1..n]

-- Average of a list of integers
average ns = sum ns `div` length ns


prop_double n = double n == n * 2
        where types = n::Int

prop_quadruple n = quadruple n == n * 4
        where types = n::Int


unittests = Test.HUnit.test [
             "factorial 1" ~: factorial 1 ~?= 1
            ,"factorial 3" ~: factorial 3 ~?= 6
            ,"average [1]" ~: average [1] ~?= 1
            ,"average [1, 2, 3]" ~: average [1, 2, 3] ~?= 2
            ]

runtests = do quickCheck prop_double
              quickCheck prop_quadruple
              runTestTT unittests

