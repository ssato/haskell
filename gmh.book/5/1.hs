--
-- 5.1 Generators
--
module GeneratorExamples where

import Test.QuickCheck
import Test.HUnit


-- concatenates a list of lists
concat' :: [[a]] -> [a]
concat' xss = [x | xs <- xss, x <- xs]

--  selects all the first components from a list of pairs
firsts' :: [(a, b)] -> [a]
firsts' ps = [x | (x, _) <- ps]


-- calculates the length of a list
--
length' :: [a] -> Int
length' xs = sum [1 | _ <- xs]

-- other solutions:
length'' :: [a] -> Int
length'' [] = 0
length'' (x:xs) = 1 + length xs

-- tests:
unittests = Test.HUnit.test [
     "concat' []" ~: (concat' [] :: [[Int]]) ~?= []
    ,"concat' [[]]" ~: (concat' [[]] :: [[Int]]) ~?= []
    ,"concat' [[1,2], [3], [4]]" ~: concat' [[1,2], [3], [4]] ~?= [1,2,3,4]
    ,"firsts' []" ~: (firsts' [] :: [(Int, Char)]) ~?= []
    ,"firsts' [(1, 'a'), (2, 'b')]" ~: firsts' [(1, 'a'), (2, 'b')] ~?= [1, 2]
    ]

prop_length' xs = length' xs == length xs
    where types = xs :: [Int]

prop_length'' xs = length'' xs == length xs
    where types = xs :: [Int]

runtests = runTestTT unittests >> quickCheck prop_length' >> quickCheck prop_length''


-- vim:sw=4 ts=4 et:
