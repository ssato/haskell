--
-- 1.7 Exercises
--
{- # LANGUAGE GeneralizedNewtypeDeriving # -}
module Main where

import Data.List
import Test.QuickCheck
import Test.HUnit


double :: (Num a) => a -> a
double x = x + x 

double' :: (Num a) => a -> a
double' = (*) 2


sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs


product' :: (Num a) => [a] -> a
product' [] = 1
product' (x:xs) = x * product' xs


-- quicksort 
qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
        where smaller = [a | a <- xs, a <= x]
              larger = [b | b <- xs, b > x]

rqsort :: Ord a => [a] -> [a]
rqsort [] = []
rqsort (x:xs) = rqsort larger ++ [x] ++ rqsort smaller
        where smaller = [a | a <- xs, a <= x]
              larger = [b | b <- xs, b > x]

rqsort' :: Ord a => [a] -> [a]
rqsort' = reverse . qsort


qsort' :: Ord a => [a] -> [a]
qsort' [] = []
qsort' (x:xs) = qsort' smaller ++ [x] ++ qsort' larger
        where smaller = [a | a <- xs, a < x]
              larger = [b | b <- xs, b > x]


unittests = Test.HUnit.test [
         -- FIXME:
         -- It causes error and I don't know how to fix that problem:
         -- "douple' double' 2 ==> 8" ~: double' double' 2 ~?= 8
        "product' [2, 3, 4] ==> 24" ~: product' [2, 3, 4] ~?= 24
        ,"qsort' [2, 2, 3, 1, 1] ==> [1, 2, 3]" ~: qsort' [2, 2, 3, 1, 1] ~?= [1, 2, 3]
        ]


prop_double' n = double' n == double n
        where types = n::Int

prop_sum' x = sum' [x] == x
        where types = x::Int

-- @see http://itpro.nikkeibp.co.jp/article/COLUMN/20080304/295346/
prop_qsort xs = isSorted $ qsort xs
        where types = xs::[Int]

isSorted xs = and $ zipWith (<=) xs (drop 1 xs)


prop_rqsort xs = rqsort xs == rqsort' xs
        where types = xs::[Int]


runtests = do quickCheck prop_double'
              quickCheck prop_sum'
              quickCheck prop_rqsort
              runTestTT unittests


