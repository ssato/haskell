module Main where

import Data.List
import Test.QuickCheck hiding (test)
import Test.HUnit

prop_exponential x y = x >= 0 && y >= 0 ==> x `exponential` y == x ^ y
        where types = (x,y)::(Int,Int)

prop_and' xs = length xs > 0 ==> and' xs == and xs
        where types = xs::[Bool]

prop_concat' xss = length xss > 0 ==> concat' xss == Data.List.concat xss
        where types = xss::[[Int]]

prop_replicate' n x = n >= 0 ==> replicate' n x == Data.List.replicate n x
        where types = (n,x)::(Int,Int)

prop_nth n xs = length xs > 0 && n < length xs && n > 0 ==> xs `nth` n == xs !! n
        where types = (n,xs)::(Int,[Int])

prop_elem' x ys = elem' x ys == Data.List.elem x ys
        where types = (x,ys)::(Int,[Int])

prop_sum' xs = sum' xs == Data.List.sum xs
        where types = xs :: [Int]

prop_take' n xs = n > 0 ==> take' n xs == Data.List.take n xs
        where types = (n,xs) :: (Int, [Int])

prop_last' xs = length xs > 0 ==> last' xs == Data.List.last xs
        where types = xs :: [Int]

unittests = Test.HUnit.test [
                "merge [2,5,6] [1,3,4]" ~: merge [2,5,6] [1,3,4] ~?= [1,2,3,4,5,6],
                "halve [2,5,6,1,3,4,7]" ~: halve [2,5,6,1,3,4,7] ~?= ([2,5,6],[1,3,4,7])
                -- "msort [2,5,6,1,3,4]" ~: msort [2,5,6,1,3,4] ~?= [1,2,3,4,5,6]
                ]

runtests = do quickCheck prop_exponential
              quickCheck prop_and'
              quickCheck prop_concat'
              quickCheck prop_replicate'
              quickCheck prop_nth
              quickCheck prop_elem'
              quickCheck prop_sum'
              quickCheck prop_take'
              quickCheck prop_last'
              runTestTT unittests


-- 1. operator ^
exponential :: Int -> Int -> Int
_ `exponential` 0 = 1
x `exponential` n = x * (x `exponential` (n - 1))

{-

2 `exponential` 3 ==> 2 * (2 `exponential` 2))
                  ==> 2 * (2 * (2 `exponential` 1))
                  ==> 2 * (2 * (2 * (2 `exponential` 0)))
                  ==> 2 * (2 * (2 * 1))
                  ==> 2 * (2 * 2)
                  ==> 2 * 4
                  ==> 8
-}

-- 2
{-

length [1, 2, 3] ==> 1 + length [2,3]
                 ==> 1 + (1 + length [3])
                 ==> 1 + (1 + (1 + length []))
                 ==> 1 + (1 + (1 + 0))
                 ==> 1 + (1 + 1)
                 ==> 1 + 2
                 ==> 3

drop 3 [1..5] ==> drop 2 [2..5]
              ==> drop 1 [3..5]
              ==> drop 0 [4,5]
              ==> [4,5]

init [1,2,3] ==> 1:init [2,3]
             ==> 1:2:init [3]
             ==> 1:2:[]
             ==> 1:[2]
             ==> [1,2]

-}

-- 3.
-- and
and' :: [Bool] -> Bool
and' [x]       = x
and' (False:_) = False
and' (True:xs) = and' xs

-- concat
concat' :: [[a]] -> [a]
concat' []       = []
concat' [[]]     = []
concat' (xs:xss) = xs ++ concat' xss

-- replicate
replicate' :: Int -> a -> [a]
replicate' 0 _ = []
replicate' n x = x:replicate' (n - 1) x

-- !! - nth element of a list
nth :: [a] -> Int -> a
(x:xs) `nth` 0 = x
(x:xs) `nth` n = xs `nth` (n - 1)

-- elem - Is a value an element of a list?
elem' :: Eq a => a -> [a] -> Bool
elem' _ []                 = False
elem' x (y:ys) | x == y    = True
               | otherwise = elem' x ys


-- 4. merge - merges two sorted lists to give a single sorted list
merge :: Ord a => [a] -> [a] -> [a]
merge xs []                     = xs
merge [] ys                     = ys
merge (x:xs) (y:ys) | x < y     = x:y:merge xs ys
                    | otherwise = y:merge (x:xs) ys

-- 5. Merge sort
halve :: [a] -> ([a],[a])
halve [] = ([],[])
halve xs = (take n xs, drop n xs)
        where n = (length xs - 1) `div` 2

{-
msort :: Ord a => [a] -> [a]
msort [] = []
msort [x] = [x]
msort xs = merge msort' xs
        where (ys,zs) = halve xs
              msort' 
-}

-- 6. 
-- sum
sum' :: [Int] -> Int
sum' []     = 0
sum' (x:xs) = x + sum' xs

-- take
take' :: Int -> [a] -> [a]
take' _ []     = []
take' 0 _      = []
take' n (x:xs) = x:take' (n - 1) xs

-- last
last' :: [a] -> a
last' [x] = x
last' (x:xs) = last' xs
