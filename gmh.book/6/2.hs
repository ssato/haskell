--
-- 6.2 
--
module ListRecursionExamples where

import Data.List(sort)

import Test.QuickCheck
import Test.HUnit


-- product
-- recursive version:
--
product' :: Num a => [a] -> a
product' [] = 1
product' (x:xs) = x * product' xs

-- w/ fold version:
-- product'' = foldl (\x -> \acc -> x * acc)
product'' :: Num a => [a] -> a
product'' = foldl (*) 1

unittests_product = [
     "product (recursive) []" ~: product' [] ~?= 1
    ,"product (recursive) [2, 3, 4]" ~: product' [2, 3, 4] ~?= 24
    ,"product (fold) []" ~: product'' [] ~?= 1
    ,"product (fold) [2, 3, 4]" ~: product'' [2, 3, 4] ~?= 24
    ]


-- length:
-- recursive:
length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs

unittests_length = [
     "length (recursive) []" ~: length' [] ~?= 0
    ,"length (recursive) [2, 3, 4]" ~: length' [2, 3, 4] ~?= 3
    ]


-- reverse:
-- recursive version:
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse xs ++ [x]

-- w/ fold version:
-- reverse'' = foldr (\x -> \acc -> acc ++ [x]) []
reverse'' :: [a] ->[a]
reverse'' = foldr (\x -> \acc -> acc ++ [x]) []

prop_reverse' xs = reverse' (reverse' xs) == xs
    where types = xs :: [Int]

prop_reverse'' xs = reverse'' (reverse'' xs) == xs
    where types = xs :: [Int]


-- append (++):
-- recursive version:
append :: [a] -> [a] -> [a]
[] `append` ys = ys
(x:xs) `append` ys = x:(xs `append` ys)

unittests_append = [
     "append (recursive) [] ys" ~: [] `append` [1..3] ~?= [1, 2, 3]
    ,"append (recursive) xs ys" ~: [1..3] `append` [4..6] ~?= [1, 2, 3, 4, 5, 6]
    ]


-- insert: insert item into sorted list
insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys) | x <= y = x:y:ys
                | otherwise = y:insert x ys

unittests_insert = [
     "insert x []" ~: insert 0 [] ~?= []
    ,"insert x xs" ~: insert 4 [1, 2, 4, 5] ~?= [1, 2, 3, 4, 5]
    ]


-- Is this list sorted?
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x,y) <- pairs' xs]
    where pairs' xs = zip xs $ tail xs

prop_insert x xs = sorted $ insert x $ sort xs
    where types = (x :: Int, xs :: [Int])


-- insertion sort
isort :: Ord a => [a] -> [a]
isort [] = []
isort (x:xs) = insert x $ isort xs

prop_isort xs = sorted $ isort xs
    where types = xs :: [Int]


-- tests
unittests = Test.HUnit.test [
     unittests_product
    ,unittests_length
    ,unittests_append
    ,unittests_insert 
    ]

runtests = do runTestTT unittests
              quickCheck prop_reverse'
              quickCheck prop_reverse''
              quickCheck prop_insert
              quickCheck prop_isort


-- vim:sw=4 ts=4 et:
