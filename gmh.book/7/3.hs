--
-- 7.3 The foldr function
--
module Main where

import Data.List
import Test.QuickCheck hiding (test)
import Test.HUnit

prop_length' xs = length' xs == Data.List.length xs
        where types = xs::[Int]

prop_reverse' xs = reverse' xs == Data.List.reverse xs
        where types = xs::[Int]

prop_listjoin xs ys = xs `listjoin` ys == xs ++ ys
        where types = (xs,ys)::([Int],[Int])

runtests = do quickCheck prop_length'
              quickCheck prop_reverse'
              quickCheck prop_listjoin


-- foldr
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f v []     = v
foldr' f v (x:xs) = f x (foldr' f v xs)

-- length
length' :: [a] -> Int
length' = foldr' (\_ n -> 1 + n) 0

-- reverse
reverse' :: [a] -> [a]
reverse' = foldr' (\x xs -> xs ++ [x]) []

-- ++
listjoin :: [a] -> [a] -> [a]
listjoin = \xs ys -> foldr' (:) ys xs

