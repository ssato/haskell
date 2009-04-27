--
-- 5.1 Generators
--
module Main where
import Test.QuickCheck

-- concatenates a list of lists
concat' :: [[a]] -> [a]
concat' xss = [x | xs <- xss, x <- xs]

--  selects all the first components from a list of pairs
firsts' :: [(a,b)] -> [a]
firsts' ps = [x | (x, _) <- ps]

-- calculates the length of a list
--
-- length [] = 0
-- length x:xs = 1 + length xs
length' :: [a] -> Int
length' xs = sum [1 | _ <- xs]
