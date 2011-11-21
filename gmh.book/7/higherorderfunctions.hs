{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-
 - 7. Higher order functionns
 -}

module HigherOrderFunctionExamples where

import Data.List(sum, product, length)

import Test.QuickCheck
import Test.HUnit


-- 7.1 Basics
-- add:
add :: Num a => a -> a -> a
-- add x y = x + y
add = \x -> \y -> x + y

add' :: Num a => a -> a -> a
add' = binop (+)
    where binop :: Num a => (a -> a -> a) -> a -> a -> a
          binop op x y = x `op` y


prop_add' x y = add' x y == add x y
    where types = (x :: Int, y :: Int)


-- twice:
twice :: (a -> a) -> a -> a
twice f x = f $ f x

-- point free style:
twice' :: (a -> a) -> a -> a
twice' f = f . f

unittests_twice = Test.HUnit.test [
     "twice (1 +) 2" ~: twice (1 +) 2 ~?= 4
    ,"twice' (1 +) 2" ~: twice' (1 +) 2 ~?= 4
    ]


-- 7.2 Processing lists
-- map
map' :: (a -> b) -> [a] -> [b]
map' f xs = [f x | x <- xs]

map'' :: (a -> b) -> [a] -> [b]
map'' f []     = []
map'' f (x:xs) = f x: map'' f xs


-- filter 
filter' :: (a -> Bool) -> [a] -> [a]
filter' p xs = [x | x <- xs, p x]

filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p []                 = []
filter'' p (x:xs) | p x       = x:filter'' p xs
                  | otherwise = filter'' p xs

-- sumsqreven  - sum of the squares of the even integers from a list
sumsqreven :: [Int] -> Int
sumsqreven ns = sum $ map (^ 2) (filter even ns)

--
-- 7.3 The foldr function
--

-- foldr
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f v []     = v
foldr' f v (x:xs) = f x (foldr' f v xs)

{-
  foldr' f v [x0, x1, x2, ... xn]
=  (f x0 (f x1 (f x2 (... (f v xn) ...)
-}

-- length
-- length' = foldr' (\x -> \acc -> 1 + acc) 0
length' :: [a] -> Int
length' = foldr' (\_ -> \n -> 1 + n) 0

prop_length' xs = length' xs == length xs
    where types = xs :: [Int]

-- reverse
reverse' :: [a] -> [a]
reverse' = foldr' (\x -> \acc -> acc ++ [x]) []

unittests_reverse' = Test.HUnit.test [
     "reverse' []" ~: reverse' [] ~?= ([] :: [Int])
    ,"reverse' [1..5]" ~: reverse' [1..5] ~?= [5, 4, 3, 2, 1]
    ]

{- FIXME: This does not work.

prop_reverse' xs = reverse' . reverse' xs == xs
    where types = xs :: [Int]


Error message was:

7/higherorderfunctions.hs:155:32:
    Couldn't match expected type `a -> [a1]'
           against inferred type `[Int]'
    In the second argument of `(.)', namely `reverse'' xs'
    In the first argument of `(==)', namely `reverse'' . reverse'' xs'
    In the expression: reverse'' . reverse'' xs == xs
-}

-- ++
append :: [a] -> [a] -> [a]
append = \xs -> \ys -> foldr' (\x -> \acc -> x:acc) ys xs

unittests_append = Test.HUnit.test [
     "[1..3] `append` [4..7]" ~: [1..3] `append` [4..7] ~?= [1, 2, 3, 4, 5, 6, 7]
    ]


-- 7.4 The foldl function
-- foldl
foldl' :: (a -> b -> a) -> a -> [b] -> a
foldl' f v []     = v
foldl' f v (x:xs) = foldl' f (f v x) xs

{-
  foldl' f v [x0, x1, x2, ... xn]
=  ( ... (f (f (f v x0) x1) x2) ... xn)
-}

-- sum
-- sum' = foldl'' (\acc -> \x -> acc + x) 0
sum' :: [Int] -> Int
sum' = foldl' (+) 0

prop_sum' xs = sum' xs == sum xs
    where types = xs :: [Int]

-- product
-- product' = foldl' (\acc -> \x -> acc * x) 1
product' :: [Int] -> Int
product' = foldl' (*) 1

prop_product' xs = product' xs == product xs
    where types = xs :: [Int]

-- or
-- or' = foldl' (\acc -> \x -> acc || x) False
or' :: [Bool] -> Bool
or' = foldl' (||) False

-- and
-- and' = foldl' (\acc -> \x -> acc && x) True
and' :: [Bool] -> Bool
and' = foldl' (&&) True

-- length
-- length'' = foldl' (\acc -> \x -> acc + 1) 0
length'' :: [a] -> Int
length'' = foldl' (\n -> \_ -> n + 1) 0

prop_length'' xs = length'' xs == length xs
    where types = xs :: [Int]

-- reverse
-- reverse'' = foldl' (\acc -> \x -> x:acc) []
reverse'' :: [a] -> [a]
reverse'' = foldl' (\xs -> \x -> x:xs) []

{- FIXME: This does not work. (same as prop_reverse')

prop_reverse'' xs = reverse'' . reverse'' xs == xs
    where types = xs :: [Int]

-}

unittests_reverse'' = Test.HUnit.test [
     "reverse'' []" ~: reverse'' [] ~?= ([] :: [Int])
    ,"reverse'' [1..5]" ~: reverse'' [1..5] ~?= [5, 4, 3, 2, 1]
    ]


-- 7.4 The foldl function
-- composition
compose :: (b -> c) -> (a -> b) -> (a -> c)
f `compose` g = \x -> f $ g x

-- identify
id' :: a -> a
id' = \x -> x

{- FIXME: This does not work. (same as prop_reverse')

prop_id' x = id . id x == x
    where types = x :: Int
-}


runtests = do runTestTT unittests_twice
              runTestTT unittests_append
              runTestTT unittests_reverse'
              runTestTT unittests_reverse''
              quickCheck prop_add'
              quickCheck prop_length'
              -- quickCheck prop_reverse'
              quickCheck prop_sum'
              quickCheck prop_product'
              quickCheck prop_length''
              -- quickCheck prop_reverse''
              -- quickCheck prop_id'


{- session log:

ghci> :l 7/higherorderfunctions.hs
[1 of 1] Compiling HigherOrderFunctionExamples ( 7/higherorderfunctions.hs, interpreted )
Ok, modules loaded: HigherOrderFunctionExamples.
ghci> runtests
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
ghci>

-}


-- vim:sw=4 ts=4 et:
