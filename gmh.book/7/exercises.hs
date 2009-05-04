--
-- 7.8 exercises
--
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Main where

import Char
import Data.List
import Test.QuickCheck hiding (test)
import Test.HUnit

unittests = Test.HUnit.test [
        "all' ==> True" ~: all' even [2,4..10] ~?= True,
        "all' ==> False" ~: all' even [1..10]  ~?= False,
        "any' ==> True" ~: any' even [1..10]   ~?= True,
        "any' ==> False" ~: any' even [1,3..9] ~?= False,
        "takeWhile'" ~: takeWhile' odd [1,3,5,6,7,8,9,10] ~?= [1,3,5],
        "dropWhile'" ~: dropWhile' odd [1,3,5,6,7,8,9,10] ~?= [6,7,8,9,10],
        "iterate''" ~: take 10 (iterate'' (*2) 1) ~?= take 10 (iterate (*2) 1), -- [1,2,4,8,16,32,64,128,256,512],
        "dec2int'" ~: dec2int [2,3,4,0] ~?= 2340
        ]

prop_all' xs = all' f xs == all f xs
        where types = xs::[Int]
              f = even

prop_any' xs = any' f xs == any f xs
        where types = xs::[Int]
              f = odd

prop_map' xs = map' f xs == map f xs
        where types = xs::[Int]
              f = (*2)

prop_filter' xs = filter' f xs == filter f xs
        where types = xs::[Int]
              f = odd

prop_map'' xs = map'' f xs == map f xs
        where types = xs::[Int]
              f = (+2)

runtests = do quickCheck prop_all'
              quickCheck prop_any'
              quickCheck prop_map'
              quickCheck prop_filter'
              quickCheck prop_map''
              runTestTT unittests

-- 1. [f x | x <- xs, p x] ==> map f (filter p xs)
--                         ==> map f . filter p

-- 2. 
all' :: (a -> Bool) -> [a] -> Bool
all' p = and . map p

any' :: (a -> Bool) -> [a] -> Bool
any' p = or . map p

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' p []                 = []
takeWhile' p (x:xs) | p x       = x:takeWhile' p xs
                    | otherwise = []

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' p []                    = []
dropWhile' p ys@(x:xs) | p x       = dropWhile' p xs
                       | otherwise = ys

-- 3.
map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x xs -> f x:xs) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x xs -> if p x then x:xs else xs) []

-- 4.
-- dec2int:  [2,3,4,0] ==> 2340
dec2int :: [Int] -> Int
dec2int = foldl (\x y -> x * 10 + y) 0

-- 5. 
-- sumsqreven' = compose [sum, map (^2), filter even]
-- 
-- ==> type error; sum :: [Int] -> Int, map (^2) :: [Int] -> [Int]
--                 filter even :: [Int] -> [Int]
--
-- *Main> let sumsqreven' = compose [sum, map (^2), filter even]
--
-- <interactive>:1:27:
--     Occurs check: cannot construct the infinite type: a = [a]
--     Expected type: [a]
--     Inferred type: a
--     In the expression: sum
--     In the first argument of `compose', namely
--     `[sum, map (^ 2), filter even]'
-- *Main>

compose' :: [a -> a] -> (a -> a)
compose' = foldr (.) id

sumsqreven :: [Int] -> Int
sumsqreven = sum . map (^2) . filter even

-- 6. curry / uncurry
curry' :: ((a,b) -> c) -> (a -> b -> c)
curry' f = \x y -> f (x,y)

uncurry' :: (a -> b -> c) -> ((a,b) -> c)
uncurry' f = \(x,y) -> f x y


-- 7. unfold
-- p -> predicate, h -> head, t -> tail
unfold p h t x | p x       = []
               | otherwise = h x : unfold p h t (t x)

int2bin' = unfold (== 0) (`mod` 2) (`div` 2)

chop8' = unfold null (take 8) (drop 8)

-- FIXME:
map'' f = unfold null (f . hd) tl
        where hd (x:xs) = x
              tl (x:xs) = xs

iterate'' f = unfold (\_ -> False) id f


-- 8. 
-- check parity
parity :: [Bit] -> Int
parity bs = if p bs then 1 else 0
        where p = odd . sum . filter (== 1)

chop9 :: [Bit] -> [[Bit]]
chop9 []   = []
chop9 bits = take 9 bits : chop9 (drop 9 bits)

encode' :: String -> [Bit]
encode' = concat . map (f . make8 . int2bin . Char.ord)
        where f :: [Bit] -> [Bit] -- add parity bit at the head
              f bs = parity bs : bs

decode' :: [Bit] -> String
decode' = map (Char.chr . bin2int . pcf) . chop9
        where pcf []     = []   -- Parity Check Filter
              pcf (p:bs) | p == parity bs = bs
                         | otherwise      = error "Parity check failed"


-- String transmitter
type Bit = Int

bin2int :: [Bit] -> Int 
bin2int = foldr (\x y -> x + 2 * y) 0

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = n `mod` 2 : int2bin (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bits = take 8 (bits ++ repeat 0)

encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . Char.ord)

chop8 :: [Bit] -> [[Bit]]
chop8 []   = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

transmit :: String -> String
transmit = decode . channel . encode

channel :: [Bit] -> [Bit]
channel = id



