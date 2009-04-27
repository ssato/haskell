--
-- 5.4 String comprehensions
--
module Main where
import Char
import Test.HUnit

-- run in ghc; "runTestTT tests"
tests = test ["lowers' \"Haskell\"" ~: lowers' "Haskell" ~?= 6,
              "count 's' \"Mississippi" ~: count 's' "Mississippi" ~?= 4 ]

-- number of lower-case letters in a string
lowers' :: String -> Int
lowers' xs = length [x | x <- xs, Char.isLower x]

-- number of particular characters that occur in a string
count :: Char -> String -> Int
count x xs = length [x' | x' <- xs, x == x']

