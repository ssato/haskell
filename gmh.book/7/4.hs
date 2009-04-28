--
-- 7.4 The foldl function
--
module Main where

import Data.List hiding (foldl)
import Test.QuickCheck hiding (test)
import Test.HUnit

prop_sum' xs = sum' xs == Data.List.sum xs
        where types = xs::[Int]

prop_product' xs = product' xs == Data.List.product xs
        where types = xs::[Int]

prop_and' xs = and' xs == Data.List.and xs
        where types = xs::[Bool]

prop_or' xs = or' xs == Data.List.or xs
        where types = xs::[Bool]

prop_length' xs = length' xs == Data.List.length xs
        where types = xs::[Int]

prop_reverse' xs = reverse' xs == Data.List.reverse xs
        where types = xs::[Int]

runtests = do quickCheck prop_sum'
              quickCheck prop_product'
              quickCheck prop_and'
              quickCheck prop_or'
              quickCheck prop_length'
              quickCheck prop_reverse'

-- foldl
foldl'' :: (a -> b -> a) -> a -> [b] -> a
foldl'' f v []     = v
foldl'' f v (x:xs) = foldl'' f (f v x) xs

-- sum
sum' :: [Int] -> Int
sum' = foldl'' (+) 0

-- product
product' :: [Int] -> Int
product' = foldl'' (*) 1

-- or
or' :: [Bool] -> Bool
or' = foldl'' (||) False

-- and
and' :: [Bool] -> Bool
and' = foldl'' (&&) True

-- length
length' :: [a] -> Int
length' = foldl'' (\n _ -> n + 1) 0

-- reverse
reverse' :: [a] -> [a]
reverse' = foldl'' (\xs x -> x:xs) []

