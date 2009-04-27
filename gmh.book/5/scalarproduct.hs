--
-- 5.6-7 Scalar Product
--
module Main where

import Test.QuickCheck
import Test.HUnit


unittests = Test.HUnit.test [ "scalarproduct" ~: scalarproduct [1,2,3] [4,5,6] ~?= 32 ]

runtests = do runTestTT unittests

-- scalarproduct
scalarproduct :: [Int] -> [Int] -> Int
scalarproduct xs ys = sum [x * y | (x,y) <- zip xs ys]
