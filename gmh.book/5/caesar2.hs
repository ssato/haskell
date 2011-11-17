--
-- 5.7.8 The Caesar cipher: handle upper letters also.
--
module CaesarCipher2 (encode, freqs, crack) where

import Data.Char
import Data.List

import Test.QuickCheck
import Test.HUnit


alphabets = ['A'..'Z'] ++ ['a'..'z']

nlowers = length ['a'..'z']
nuppers = nlowers

-- approximate percentage frequencies of the 26 + 26 letters of alphabet
table' :: [Float]
table' = [8.2, 1.5, 2.8, 4.3, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0, 2.4,
        6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.1, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]
table = table' ++ table'


isLowerAlpha :: Char -> Bool
isLowerAlpha c = c `elem` ['a'..'z']

isUpperAlpha :: Char -> Bool
isUpperAlpha c = c `elem` ['A'..'Z']

isAlpha' :: Char -> Bool
isAlpha' c = isLowerAlpha c || isUpperAlpha c


-- count alphabet chars in given string:
alphas :: String -> Int
alphas cs = length [c | c <- cs, isLowerAlpha c || isUpperAlpha c]

-- converts a lower-case letter between 'a' and 'z' into the corresponding
-- integer between 0 and 25
let2int :: Char -> Int
let2int c | isLowerAlpha c = ord c - ord 'a'
          | isUpperAlpha c = ord c - ord 'A'
          | otherwise = error "Character must be an alphabet character"

let2int_unittests = [
     "let2int 'a'" ~: let2int 'a' ~?= 0
    ,"let2int 'z'" ~: let2int 'z' ~?= 25
    ,"let2int 'A'" ~: let2int 'A' ~?= 0
    ,"let2int 'Z'" ~: let2int 'Z' ~?= 25
    ]


-- perform the opposite conversion of the above
-- for lower alphas (same as int2let):
int2llet :: Int -> Char
int2llet n = chr (ord 'a' + n)

-- for upper alphas:
int2ulet :: Int -> Char
int2ulet n = chr (ord 'A' + n)


int2let_unittests = [
     "int2llet 0" ~: int2llet 0 ~?= 'a'
    ,"int2llet 25" ~: int2ulet 25 ~?= 'Z'
    ,"int2ulet 0" ~: int2ulet 0 ~?= 'A'
    ,"int2ulet 25" ~: int2llet 25 ~?= 'z'
    ]

-- int2?let . let2int == id 
prop_let2int_int2llet c = isLowerAlpha c ==> int2llet (let2int c) == c
    where types = c :: Char

prop_let2int_int2ulet c = isUpperAlpha c ==> int2ulet (let2int c) == c
    where types = c :: Char


-- shift
shift :: Int -> Char -> Char
shift n c | isLowerAlpha c = int2llet ((let2int c + n) `mod` nlowers)
          | isUpperAlpha c = int2ulet ((let2int c + n) `mod` nuppers)
          | otherwise      = c

shift_unittests = [
     "shift 3 'a'" ~: shift 3 'a' ~?= 'd'
    ,"shift 3 'z'" ~: shift 3 'z' ~?= 'c'
    ,"shift 3 'A'" ~: shift 3 'A' ~?= 'D'
    ,"shift 3 'Z'" ~: shift 3 'Z' ~?= 'C'
    ]

prop_shift n c = n > 0 && isAlpha' c ==> shift (- n) (shift n c) == c
    where types = (n :: Int, c :: Char)

-- encode (same)
encode :: Int -> String -> String
encode n cs = [shift n c | c <- cs]

encode_unittests = let
    s0 = "Haskell is fun"
    s1 = "Kdvnhoo lv ixq" in
    [
     "encode 3 \"Haskell is fun\"" ~: encode 3 s0 ~?= s1
    ,"encode (-3) \"Kdvnhoo lv ixq\"" ~: encode (-3) s1 ~?= s0
    ]

-- same as original version:
percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

-- frequency table for any string
freqs :: String -> [Float]
freqs cs = [percent (count c cs) n | c <- alphabets]
    where n = alphas cs
          count c cs = length [c' | c' <- cs, c == c']

-- chi-square statistic (same)
-- os : observed frequencies list, es : expected frequencies list
chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o - e) ^ 2) / e | (o,e) <- zip os es]

-- rotates the elements of a list n places to the left, wrapping around at the
-- start of the list (same as original one)
-- n: 0 .. length of xs
rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

rotate_unittests = [
    "rotate" ~: rotate 3 [1..5] ~?= [4,5,1,2,3]
    ]

-- utility functions  (same as original)
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
          ns = [0..(nlowers + nuppers - 1)]

crack_unittests = [
    "crack" ~: crack (encode 3 "Haskell is fun") ~?= "Haskell is fun"
    ]

-- tests
unittests = Test.HUnit.test $ int2let_unittests ++ int2let_unittests ++ shift_unittests ++ encode_unittests ++ rotate_unittests ++ crack_unittests



{- FIXME: This conflicts with Test.QuickCheck.Arbitrary.Char:

instance Arbitrary Char where
    arbitrary = choose ['a'..'z']
-}

runtests = do runTestTT unittests
              quickCheckWith stdArgs {maxSuccess=10} prop_let2int_int2llet
              quickCheckWith stdArgs {maxSuccess=10} prop_let2int_int2ulet
              quickCheckWith stdArgs {maxSuccess=10} prop_shift

-- vim:sw=4 ts=4 et:
