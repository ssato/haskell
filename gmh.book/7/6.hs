{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-
 - 7.6. String conversion: string <-> bit (int)
 -}

module StringBinEncoder where


import Data.Char

import Test.QuickCheck
import Test.HUnit


{-

decimal:

234 = (2 * 10 ^ 2) + (3 * 10 ^ 1) + (4 * 10 ^ 0)
    = (4 * 10 ^ 0) + (3 * 10 ^ 1) + (2 * 10 ^ 2)
    = 4 + 10 * (3 + 10 * 2)

binary:

1101 = (2 ^ 3 * 1) + (2 ^ 2 * 1) + (2 ^ 1 * 1) + (2 ^ 0 * 1)
     = (2 ^ 0 * 1) + (2 ^ 1 * 1) + (2 ^ 2 * 1) + (2 ^ 3 * 1)
     = 1 + 2 * (1 + 2 * (1 + 2 * 1))

-}
type Bit = Int  -- Synonim


-- binary -> int
bin2int :: [Bit] -> Int
bin2int bits = sum [w * b | (w, b) <- zip weights bits]
    where weights = iterate' (* 2) 1

iterate' :: (a -> a) -> a -> [a]
iterate' f x = x : iterate' f (f x)

-- other solution
bin2int' :: [Bit] -> Int
bin2int' = foldr (\x -> \acc -> x + 2 * acc) 0


unittests_bin2int = Test.HUnit.test [
     "bin2int [1, 1, 0, 1]" ~: bin2int [1, 1, 0, 1] ~?= 11
    ,"bin2int' [1, 1, 0, 1]" ~: bin2int' [1, 1, 0, 1] ~?= 11
    ]

{-

int -> binary:


13 ==> [13 `mod` 2, (13 `div` 2) `mod` 2, (13 `div` 2 `div` 2) `mod` 2, (13 `div` 2 `div` 2 `div` 2) `mod` 2]

-}

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = m : int2bin d
    where m = n `mod` 2
          d = n `div` 2


unittests_int2bin = Test.HUnit.test [
     "int2bin 11" ~: int2bin 11 ~?= [1, 1, 0, 1]
    ]


-- normalize to 8 bit:
-- (only 8 bit chars are processed)
--
make8 :: [Bit] -> [Bit]
make8 bits = take 8 $ bits ++ repeat 0

unittests_make8 = Test.HUnit.test [
     "make8 [1, 1, 0, 1]" ~: make8 [1, 1, 0, 1] ~?= [1, 1, 0, 1, 0, 0, 0, 0]
    ,"make8 [1, 1, 0, 1, 0, 0, 0, 0, 1, 1]" ~: make8 [1, 1, 0, 1, 0, 0, 0, 0, 1, 1] ~?= [1, 1, 0, 1, 0, 0, 0, 0]
    ]


-- Encode: String -> [Bit] (8 bits)
--
-- String ==> [Unicode codepoint]  (w/ ord)
--        ==> [8 bits binary representation]  (w/ make8 . int2bin)
{-
encode cs = concat [ c |c <- cs]
    where f c = make8 $ int2bin $ ord c

f ==> make8 . int2bin . ord
-}

encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . ord)

unittests_encode = Test.HUnit.test [
     "encode \"abc\"" ~: encode "abc" ~?= [1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0]
    ]


-- Decode: [Bit] -> original string
--
-- [Bit] ==> [[Bit]]   (split per each 8 bits)
--       ==> [[Int]]   (w/ bit2int)
--       ==> [[Char]]  (w/ chr :: Int -> Char)
--
chop8 :: [Bit] -> [[Bit]]
chop8 [] = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

-- decode bits = [chr (bin2int bs) | bs <- chop8 bits]
--             ==> map (chr . bin2int) (chop8 bits)
decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

unittests_decode = Test.HUnit.test [
     "decode [1, 0, ..., 1, 1]" ~: decode [1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0] ~?= "abc"
    ]

prop_encode_decode s = decode (encode s) == s
    where types = s :: String



-- transmit
transmit :: String -> String
transmit = decode . channel . encode

channel :: [Bit] -> [Bit]
channel = id   -- no errors (no change, no noise, ...)


runtests = do runTestTT unittests_bin2int
              runTestTT unittests_int2bin
              runTestTT unittests_make8
              runTestTT unittests_encode
              runTestTT unittests_decode
              quickCheck prop_encode_decode



{- session log:

ghci> :l 7/6.hs
[1 of 1] Compiling StringBinEncoder ( 7/6.hs, interpreted )
Ok, modules loaded: StringBinEncoder.
ghci> runtests
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
+++ OK, passed 100 tests.
ghci>

-}


-- vim:sw=4 ts=4 et:
