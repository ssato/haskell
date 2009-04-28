--
-- 7.6 String transmitter
--
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Main where

import Char
import Test.QuickCheck hiding (test)
import Test.HUnit

unittests = Test.HUnit.test [
        "bin2int" ~: bin2int [1,0,1,1] ~?= 13,
        "bin2int'" ~: bin2int' [1,0,1,1] ~?= 13,
        "int2bin'" ~: int2bin 13 ~?= [1,0,1,1],
        "make8" ~: make8 [1,0,1,1] ~?= [1,0,1,1,0,0,0,0],
        "encode" ~: encode "abc" ~?= [1,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0],
        "decode" ~: decode [1,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0] ~?= "abc",
        "transmit" ~: transmit "higher-order functions are easy" ~?= "higher-order functions are easy"
        ]

-- Bit
-- FIXME:
{-
newtype Bitnumber = Bitnumber Int deriving (Eq, Ord, Show, Num)
instance Arbitrary Bitnumber where
        arbitrary = oneof [0, 1]


prop_bin2int' bs = bin2int' bs == bin2int bs
        where types = bs::[Bitnumber]

prop_encode_decode cs = decode (encode cs) == cs
        where types = cs::[Char]

prop_transmit s = transmit s == s
        where types = s::String
-}

runtests = do runTestTT unittests
              -- quickCheck prop_encode_decode
              -- quickCheck prop_transmit


-- Base conversion
type Bit = Int

-- convert binary representation to int
-- 1. naive implementation using list comprehension
bin2int :: [Bit] -> Int
bin2int bits = sum [w * b | (w,b) <- zip weights bits]
        where weights = iterate (* 2) 1

-- 2. another version
bin2int' :: [Bit] -> Int 
bin2int' = foldr (\x y -> x + 2 * y) 0

-- convert int to binary representation
int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = n `mod` 2 : int2bin (n `div` 2)

-- truncates or exnteds a binary number as appropriate to make it precisely
-- eight bits
make8 :: [Bit] -> [Bit]
make8 bits = take 8 (bits ++ repeat 0)


-- Transmission
-- encodes a string of characters as a list of bits by converting each
-- character into a Unicode number, converting each such number into an 8-bit
-- binary number, and concatenating each of these numbers together to produce a
-- list of bits.
encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . Char.ord)

-- chops such a list up into 8-bit binary numbers
chop8 :: [Bit] -> [[Bit]]
chop8 []   = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

-- decode
decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

-- simulates the transmission of a string of characters as a list of bits
transmit :: String -> String
transmit = decode . channel . encode

channel :: [Bit] -> [Bit]
channel = id



