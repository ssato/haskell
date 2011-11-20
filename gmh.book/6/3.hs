--
-- 6.3. Recursive functions use multiple arguments 
--
module MultiArgumentsForRecursiveFunctions where

import Data.List(zip, drop)

import Test.QuickCheck
import Test.HUnit


-- zip
zip' :: [a] -> [b] -> [(a, b)]
zip' [] _          = []
zip' _ []          = []
zip' (x:xs) (y:ys) = (x, y):zip' xs ys

-- More general 'zip'
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f [] _ = []
zipWith' f _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

-- ... another solution:
zip'' :: [a] -> [b] -> [(a, b)]
zip'' = zipWith' $ \x -> \y -> (x, y)


unittests_zip = Test.HUnit.test [
     "zip' [1, 3..9] [2, 4..10]" ~: zip' [1, 3..9] [2, 4..10] ~?= [(1,2),(3,4),(5,6),(7,8),(9,10)]
    ,"zip'' [1, 3..9] [2, 4..10]" ~: zip'' [1, 3..9] [2, 4..10] ~?= [(1,2),(3,4),(5,6),(7,8),(9,10)]
    ]

prop_zip' xs ys = zip' xs ys == zip xs ys
        where types = (xs :: [Int], ys :: [Int])


-- drop - removes a given number of elements from the start of a list
drop' :: Int -> [a] -> [a]
drop' _ [] = []
drop' 0 xs = xs
drop' 1 (_:xs) = xs
drop' n (_:xs) = drop' (n - 1) xs


prop_drop' n xs = n >= 0 ==> drop' n xs == drop n xs
        where types = (n :: Int, xs :: [Int])

runtests = runTestTT unittests_zip >> quickCheck prop_zip' >> quickCheck prop_drop'


-- vim:sw=4 ts=4 et:
