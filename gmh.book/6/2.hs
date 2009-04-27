--
-- 6.2 
--
module Main where

import Data.List
import Test.QuickCheck

prop_product' ns = product' ns == Data.List.product ns
        where types = ns::[Int]

prop_length' ns = length' ns == Data.List.length ns
        where types = ns::[Int]

prop_reverse' ns = reverse' ns == Data.List.reverse ns
        where types = ns::[Int]

prop_reverse'_1 ns = reverse' (reverse' ns) == ns
        where types = ns::[Int]

prop_listjoin xs ys = (xs `listjoin` ys) == xs ++ ys
        where types = (xs,ys) :: ([Int],[Int])

prop_isort xs = isort xs == Data.List.sort xs
        where types = xs :: [Int]

quicktests = do quickCheck prop_product'
                quickCheck prop_length'
                quickCheck prop_reverse'
                quickCheck prop_reverse'_1
                quickCheck prop_listjoin
                quickCheck prop_isort


-- product of elements in a list
product' :: Num a => [a] -> a
product' []     = 1
product' (n:ns) = n * product' ns

-- length of a list
length' :: [a] -> Int
length' []     = 0
length' (_:xs) = 1 + length' xs

-- reverse a list
reverse' :: [a] -> [a]
reverse' []     = []
reverse' (x:xs) = reverse' xs ++ [x]

-- ++
listjoin :: [a] -> [a] -> [a]
[] `listjoin` ys     = ys
(x:xs) `listjoin` ys = x:(xs `listjoin` ys)

-- insertion sort
--
insert' :: Ord a => a -> [a] -> [a]
insert' x []                 = [x]
insert' x (y:ys) | x <= y    = x:y:ys
                | otherwise = y:insert' x ys

isort :: Ord a => [a] -> [a]
isort []     = []
isort (x:xs) = insert' x (isort xs)

