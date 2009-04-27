--
-- 6.2
--
module Main where

import Data.List
import Test.QuickCheck

prop_zip' xs ys = zip' xs ys == Data.List.zip xs ys
        where types = (xs,ys)::([Int],[Int])

prop_drop' n xs = n > 0 ==> drop' n xs == Data.List.drop n xs
        where types = (n,xs)::(Int,[Int])

quicktests = do quickCheck prop_zip'
                quickCheck prop_drop'


-- zip
zip' :: [a] -> [b] -> [(a,b)]
zip' [] _          = []
zip' _ []          = []
zip' (x:xs) (y:ys) = (x,y):zip' xs ys

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f [] _ = []
zipWith' f _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

-- drop - removes a given number of elements from the start of a list
drop' :: Int -> [a] -> [a]
drop' 0 xs           = xs
drop' _ []           = []
drop' (n + 1) (_:xs) = drop' n xs
