--
-- 5.3 The zip function
--
module ZipExamples where

import Test.QuickCheck
import Test.HUnit


-- zip
zip' :: [a] -> [b] -> [(a, b)]
zip' [] _ = []
zip' _ [] = []
zip' (x:xs) (y:ys) = (x, y):zip' xs ys


-- list of all pairs of adjacent elements
pairs' :: [a] -> [(a, a)]
pairs' xs = zip' xs $ tail xs

-- is given list sorted?
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x,y) <- pairs' xs]

-- other solutions:
sorted' :: Ord a => [a] -> Bool
sorted' (x:y:zs) = x <= y && sorted' zs
sorted' _ = True

-- list of al positions at which a value occurs in a list
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip' xs [0..n], x == x']
    where n = length xs - 1

-- higher order "zip"
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f [] _ = []
zipWith' f _ [] = []
zipWith' f (x:xs) (y:ys) = f x y:zipWith' f xs ys

-- another "zip" implementation with zipWith'
zip'' :: [a] -> [b] -> [(a,b)]
zip'' = zipWith' (\x y -> (x,y))


-- tests:
unittests = Test.HUnit.test [
     "pairs' [1..4]" ~: pairs' [1..4] ~?= [(1,2),(2,3),(3,4)]
    ,"sorted [1..4]" ~: sorted [1..4] ~?= True
    ,"sorted <random list>" ~: sorted [2, 1] ~?= False
    ,"positions" ~: positions False [True, False, True, False] ~?= [1,3]
    ]

prop_zip' xs ys = zip' xs ys == zip xs ys
    where types = (xs, ys) :: ([Int], [Int])

prop_zip'' xs ys = zip'' xs ys == zip xs ys
    where types = (xs, ys) :: ([Int], [Int])


runtests = quickCheck prop_zip' >> quickCheck prop_zip'' >> runTestTT unittests

-- vim:sw=4 ts=4 et:
