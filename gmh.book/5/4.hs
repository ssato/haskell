{-
 - 5.4 String comprehensions
-}
module StringComprehensionExamples where

import Data.Char (isLower, isAlpha)

import Test.HUnit
import Test.QuickCheck(quickCheck)

-- number of lower-case letters in a string
lowers :: String -> Int
lowers xs = length [x | x <- xs, isLower x]

-- other solutions:
lowers' :: String -> Int
lowers' xs = sum [1 | x <- xs, isLower x]

lowers'' :: String -> Int
lowers'' = length . filter isLower

-- number of particular characters that occur in a string
count :: Char -> String -> Int
count x xs = length [x' | x' <- xs, x == x']

-- other solutions:
count' :: Char -> String -> Int
count' c cs = sum [1 | c' <- cs, c == c']

count'' :: Char -> String -> Int
count'' c = length . filter (c ==)

-- tests:
unittests = Test.HUnit.test [
     "lowers' \"Haskell\"" ~: lowers' "Haskell" ~?= 6
    ,"count 's' \"Mississippi\"" ~: count 's' "Mississippi" ~?= 4
    ]

instance Arbitrary Char where
    arbitrary = choose ['a'..'z']

prop_lowers cs = lowers cs == length cs
    where types = cs :: [Char]

prop_lowers' cs = lowers' cs == length cs
    where types = cs :: [Char]

prop_lowers'' cs = lowers'' cs == length cs
    where types = cs :: [Char]

prop_count' c cs = count' c cs == count c cs
    where types = (c :: Char, cs :: [Char])

prop_count'' c cs = count'' c cs == count c cs
    where types = (c :: Char, cs :: [Char])


runtests = do runTestTT unittests
              quickCheck prop_lowers


-- vim:sw=4 ts=4 et:
