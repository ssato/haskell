--
-- 5.5 The Caesar cipher
--
module CaesarCipher where

import Data.Char
import Data.List

import Test.QuickCheck
import Test.HUnit


nlowers = length ['a'..'z']

-- converts a lower-case letter between 'a' and 'z' into the corresponding
-- integer between 0 and 25
let2int :: Char -> Int
let2int c = ord c - ord 'a'

-- perform the opposite conversion of the above
int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

-- shift
shift :: Int -> Char -> Char
shift n c | isLower c = int2let ((let2int c + n) `mod` nlowers)
          | otherwise      = c

-- encode
encode :: Int -> String -> String
encode n cs = [shift n c | c <- cs]

-- approximate percentage frequencies of the 26 letters of alphabet
table :: [Float]
table = [8.2, 1.5, 2.8, 4.3, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0, 2.4,
        6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.1, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

-- frequency table for any string
freqs :: String -> [Float]
freqs cs = [percent (count c cs) n | c <- ['a'..'z']]
    where n = lowers cs
          lowers cs = length [c | c <- cs, isLower c]
          count c cs = length [c' | c' <- cs, c == c']

-- chi-square statistic
-- os : observed frequencies list, es : expected frequencies list
chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o - e) ^ 2) / e | (o,e) <- zip os es]

-- rotates the elements of a list n places to the left, wrapping around at the
-- start of the list
-- n: 0 .. length of xs
rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

-- utility functions 
positions :: Eq a => a -> [a] -> [Int]
positions c cs = [i | (c', i) <- zip cs [0..n], c == c']
    where n = length cs - 1

-- find most likely shift factor that was used to encode the string and try
-- decoding the string
crack :: String -> String
crack cs = encode (-factor') cs
    where factor' = head $ positions (minimum chitable) chitable
          chitable = [chisqr (rotate n table') table | n <- ns]
          table' = freqs cs
          ns = [0..(nlowers - 1)]

-- tests
unittests = Test.HUnit.test [
     "let2int 'a'" ~: let2int 'a' ~?= 0
    ,"let2int 'z'" ~: let2int 'z' ~?= 25
    ,"int2let 0" ~: int2let 0 ~?= 'a'
    ,"int2let 25" ~: int2let 25 ~?= 'z'
    ,"shift 3 'a'" ~: shift 3 'a' ~?= 'd'
    ,"shift 3 'z'" ~: shift 3 'z' ~?= 'c'
    ,"shift -3 'c'" ~: shift (-3) 'c' ~?= 'z'
    ,"shift 3 ' '" ~: shift 3 ' ' ~?= ' '
    ,"shift 3 'A'" ~: shift 3 'A' ~?= 'A'
    ,"encode 3 \"Haskell is fun\"" ~: encode 3 "Haskell is fun" ~?= "Hdvnhoo lv ixq"
    ,"encode (-3) \"Hdvnhoo lv ixq\"" ~: encode (-3) "Hdvnhoo lv ixq" ~?= "Haskell is fun"
    ,"rotate" ~: rotate 3 [1..5] ~?= [4,5,1,2,3]
    ,"crack" ~: crack (encode 3 "Haskell is fun") ~?= "Haskell is fun"
    ]


isLowerAlpha :: Char -> Bool
isLowerAlpha c = c `elem` ['a'..'z']


{- FIXME: This conflicts with Test.QuickCheck.Arbitrary.Char:

instance Arbitrary Char where
    arbitrary = choose ['a'..'z']
-}

prop_let2int_int2let c = isLowerAlpha c ==> int2let (let2int c) == c
    where types = c :: Char

prop_shift n c = isLowerAlpha c ==> shift (- n) (shift n c) == c
    where types = (c :: Char, n :: Int)

runtests = do runTestTT unittests
              quickCheckWith stdArgs {maxSuccess=20} prop_let2int_int2let
              quickCheckWith stdArgs {maxSuccess=20} prop_shift


-- vim:sw=4 ts=4 et:
