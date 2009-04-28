--
-- 7.8 exercises
--
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Main where

import Char
import Test.QuickCheck hiding (test)
import Test.HUnit

unittests = Test.HUnit.test [
        "all' ==> True" ~: all' even [2,4..10] ~?= True,
        "all' ==> False" ~: all' even [1..10]  ~?= False,
        "any' ==> True" ~: any' even [1..10]   ~?= True,
        "any' ==> False" ~: any' even [1,3..9] ~?= False
        -- "takeWhile'" ~: takeWhile' odd [1,3,5,6,7,8,9,10] ~?= [1,3,5],
        -- "dropWhile'" ~: dropWhile' odd [1,3,5,6,7,8,9,10] ~?= [6,7,8,9,10]
        ]

prop_all' xs = all' f xs == all f xs
        where types = xs::[Int]
              f = even

prop_map' xs = map' f xs == map f xs
        where types = xs::[Int]
              f = (*2)

prop_filter' xs = filter' f xs == filter f xs
        where types = xs::[Int]
              f = odd

runtests = do quickCheck prop_all'
              quickCheck prop_map'
              quickCheck prop_filter'
              runTestTT unittests

-- 1. [f x | x <- xs, p x] ==> map f (filter p xs)
--                         ==> map f . filter p

-- 2. 
all' :: (a -> Bool) -> [a] -> Bool
all' p = and . map p

any' :: (a -> Bool) -> [a] -> Bool
any' p = or . map p

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' p xs = foldl f [] xs
        where f v x | p x       = v ++ [x]
                    | otherwise = v

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' p xs = foldl f [] xs
        where f v x | p x       = []
                    | otherwise = v ++ [x]

-- 3.
map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x xs -> f x:xs) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x xs -> if p x then x:xs else xs) []


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



