--
-- positions
--

module Main where

import Test.QuickCheck
import Test.HUnit


unittests = Test.HUnit.test [
        "find -> some results" ~: find 'b' [('a',1),('b',2),('c',3),('b',4)] ~?= [2,4],
        "find -> empty" ~: find 'd' [('a',1),('b',2),('c',3),('b',4)] ~?= [] ]


prop_positions' x xs = length xs > 0 ==> positions x xs == positions' x xs
        where types = x :: Int

quicktests = do quickCheck prop_positions'


-- find
find :: Eq a => a -> [(a,b)] -> [b]
find k t = [v | (k',v) <- t, k' == k]

-- positions
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip xs [0..n], x == x']
        where n = length xs - 1

-- positions implemented with using 'find'
positions' :: Eq a => a -> [a] -> [Int] 
positions' x xs = find x (zip xs [0..n])
        where n = length xs - 1

