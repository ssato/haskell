--
-- 5.7-8 The Caesar cipher, can handle not only lower-case letters but also for
-- uppercase letters
--
module Caesar2 where

import Char
import Data.List
import Test.QuickCheck
import Test.HUnit

-- tests
tests = Test.HUnit.test ["let2int 'a'" ~: let2int 'a' ~?= 0,
                         "let2int 'z'" ~: let2int 'z' ~?= 25,
                         "let2int 'A'" ~: let2int 'A' ~?= 26,
                         "let2int 'Z'" ~: let2int 'Z' ~?= 51,
                         "int2let 0" ~: int2let 0 ~?= 'a',
                         "int2let 25" ~: int2let 25 ~?= 'z',
                         "int2let 26" ~: int2let 26 ~?= 'A',
                         "int2let 51" ~: int2let 51 ~?= 'Z',
                         "shift 3 'a'" ~: shift 3 'a' ~?= 'd',
                         "shift 3 'z'" ~: shift 3 'z' ~?= 'c',
                         "shift 3 'A'" ~: shift 3 'A' ~?= 'D',
                         "shift 3 'Z'" ~: shift 3 'Z' ~?= 'C',
                         "shift -3 'c'" ~: shift (-3) 'c' ~?= 'z',
                         "shift -3 'C'" ~: shift (-3) 'C' ~?= 'Z',
                         "shift 3 'A'" ~: shift 3 'A' ~?= 'D',
                         "shift 3 ' '" ~: shift 3 ' ' ~?= ' ',
                         "encode 3 \"Haskell is fun\"" ~: encode 3 "Haskell is fun" ~?= "Kdvnhoo lv ixq",
                         "encode (-3) \"Kdvnhoo lv ixq\"" ~: encode (-3) "Kdvnhoo lv ixq" ~?= "Haskell is fun"]


runtests = do runTestTT tests


base :: Int
base = Char.ord 'z' - Char.ord 'a' + 1

-- converts a letter between 'a' and 'z' or 'A' and 'Z' into the corresponding
-- integer between 0 and 25 + 26
let2int :: Char -> Int
let2int c | Char.isLower c = ord c - ord 'a'
          | otherwise      = ord c - ord 'A' + base

-- perform the opposite conversion of the above
int2let :: Int -> Char
int2let n | n < base  = chr (ord 'a' + n)
          | otherwise = chr (ord 'A' + n - base)

-- shift
shift :: Int -> Char -> Char
shift n c | Char.isLower c = int2let ((let2int c + n) `mod` base) 
          | Char.isUpper c = int2let ((let2int c + n) `mod` base + base)
          | otherwise      = c

-- encode
encode :: Int -> String -> String
encode n cs = [shift n c | c <- cs]


