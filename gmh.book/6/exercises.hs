{-
 - 6.8. Exercises
 -}

module RecurExercises where

import Data.List(sort, sum, take, last)

import Test.QuickCheck
import Test.HUnit


-- 1. operator ^
exponential :: Int -> Int -> Int
_ `exponential` 0 = 1
m `exponential` n = m * (m `exponential` (n - 1))

{-

  2 `exponential` 3
= 2 * (2 `exponential` 2)
= 2 * (2 * (2 `exponential` 1))
= 2 * (2 * (2 * 1))
= ...
= 8

-}

{- TODO:
prop_exponential x y = x >= 0 && y >= 0 ==> x `exponential` y == x ^ y
    where types = (x :: Int, y :: Int)
-}

exponential_unittests = Test.HUnit.test [
     "2 `exponential` 3" ~: 2 `exponential` 3 ~?= 8
    ]


-- 2. length, drop, init:
{-

  length [1, 2, 3]
= 1 + length [2, 3]
= 1 + (1 + length [3])
= 1 + (1 + (1 + length []))
= ...
= 3

  drop 3 [1, 2, 3, 4, 5]
= drop 2 [2, 3, 4, 5]
= drop 1 [3, 4, 5]
= drop 0 [4, 5]
= [4, 5]

  init [1, 2, 3]
= 1 : init [2, 3]
= 1 : 2 : init [3]
= 1 : 2 : []
= [1, 2]

-}


-- 3.
-- and: all elements are True:
and' :: [Bool] -> Bool
and' [] = True
and' (x:xs) | x = and' xs
            | otherwise = False

-- other solution:
and'' :: [Bool] -> Bool
and'' = foldr (&&) True

and_unittests = Test.HUnit.test [
     "and' [True, False]" ~: and' [True, False] ~?= False
    ,"and'' [True, False]" ~: and'' [True, False] ~?= False
    ]


-- concat
concat' :: [[a]] -> [a]
concat' []       = []
concat' (xs:xss) = xs ++ concat' xss

concat'' :: [[a]] -> [a]
concat'' = foldr (++) []

concat_unittests = Test.HUnit.test [
     "concat' [[1,2], [3]]" ~: concat' [[1,2], [3]] ~?= [1, 2, 3]
    ,"concat'' [[1,2], [3]]" ~: concat'' [[1,2], [3]] ~?= [1, 2, 3]
    ]


-- replicate
replicate' :: Int -> a -> [a]
replicate' 0 _ = []
replicate' n x = x:replicate' (n - 1) x

replicate'' :: Int -> a -> [a]
replicate'' n = take n . repeat

replicate_unittests = Test.HUnit.test [
     "replicate' 3 2" ~: replicate' 3 2 ~?= [2, 2, 2]
    ,"replicate'' 3 2" ~: replicate'' 3 2 ~?= [2, 2, 2]
    ]


-- !! - nth element of a list
nth :: [a] -> Int -> a
[] `nth` _ = error "list must not be empty!"
(x:_) `nth` 0 = x
(_:xs) `nth` n = xs `nth` (n - 1)

nth_unittests = Test.HUnit.test [
     "[1, 2, 3, 4] `nth` 0" ~: [1, 2, 3, 4] `nth` 0 ~?= 1
    ,"[1, 2, 3, 4] `nth` 3" ~: [1, 2, 3, 4] `nth` 3 ~?= 4
    ]


-- elem - Is a value an element of a list?
elem' :: Eq a => a -> [a] -> Bool
elem' _ [] = False
elem' x (y:ys) | x == y    = True
               | otherwise = elem' x ys

elem_unittests = Test.HUnit.test [
     "elem' 0 [1, 2, 3, 4]" ~: elem' 0 [1, 2, 3, 4] ~?= False
    ,"elem' 3 [1, 2, 3, 4]" ~: elem' 3 [1, 2, 3, 4] ~?= True
    ]


-- 4. merge - merges two sorted lists to give a single sorted list
merge :: Ord a => [a] -> [a] -> [a]
merge xs []                     = xs
merge [] ys                     = ys
merge (x:xs) (y:ys) | x <= y    = x:merge xs (y:ys)
                    | otherwise = y:merge (x:xs) ys

merge_unittests = Test.HUnit.test [
     "merge [1, 3] [2, 4]" ~: merge [1, 3] [2, 4] ~?= [1, 2, 3, 4]
    ,"merge [-1, 1, 3] [0, 4]" ~: merge [-1, 1, 3] [0, 4] ~?= [-1, 0, 1, 3, 4]
    ]

-- Is this list sorted?
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x, y) <- pairs' xs]
    where pairs' xs = zip xs $ tail xs

prop_merge xs ys = sorted $ merge (sort xs) (sort ys)
    where types = (xs :: [Int], ys :: [Int])


-- 5. Merge sort
halve :: [a] -> ([a],[a])
halve [] = ([],[])
halve [x] = ([],[x])
halve xs = (take n xs, drop n xs)
    where n = (length xs) `div` 2

msort :: Ord a => [a] -> [a]
msort [] = []
msort [x] = [x]
msort xs = merge (msort ys) (msort zs)
    where (ys, zs) = halve xs


msort_unittests = Test.HUnit.test [
     "msort [1, 3, 2, 4]" ~: msort [1, 3, 2, 4] ~?= [1, 2, 3, 4]
    ]

prop_msort xs = msort xs == sort xs
    where types = xs :: [Int]


-- 6.
-- sum:
sum' :: Num a => [a] -> a
sum' []     = 0
sum' (x:xs) = x + sum' xs

sum'' = foldl (+) 0

prop_sum' xs = sum' xs == sum xs
    where types = xs :: [Int]

prop_sum'' xs = sum'' xs == sum xs
    where types = xs :: [Int]


-- take
take' :: Int -> [a] -> [a]
take' _ []     = []
take' 0 _      = []
take' n (x:xs) = x:take' (n - 1) xs

take_unittests = Test.HUnit.test [
     "take' 2 [1, 3, 2, 4]" ~: take' 2 [1, 3, 2, 4] ~?= [1, 3]
    ]


-- last
last' :: [a] -> a
last' [] = error "list must not be empty!"
last' [x] = x
last' (_:xs) = last' xs

last_unittests = Test.HUnit.test [
     "last' [1, 3, 2, 4]" ~: last' [1, 3, 2, 4] ~?= 4
    ]


-- tests:
-- unittests = and_unittests ++ concat_unittests ++ replicate_unittests ++ nth_unittests ++ elem_unittests ++ merge_unittests ++ merge_unittests ++ take_unittests ++ last_unittests

runtests = do runTestTT and_unittests
              runTestTT concat_unittests
              runTestTT exponential_unittests
              runTestTT replicate_unittests
              runTestTT nth_unittests
              runTestTT elem_unittests
              runTestTT merge_unittests
              runTestTT msort_unittests
              runTestTT take_unittests
              runTestTT last_unittests
--              quickCheckWith stdArgs {maxSuccess=5} prop_exponential
              quickCheck prop_msort
              quickCheck prop_sum'
              quickCheck prop_sum''


-- vim:sw=4 ts=4 et:
