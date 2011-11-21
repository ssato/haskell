--
-- 7.8 exercises
--
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module HigherOrderFunctionsExercises where

import Data.Char
import Data.List

import Test.QuickCheck
import Test.HUnit


-- 1. mapfilter f p xs = [f x | x <- xs, p x]
mapfilter :: (a -> b) -> (a -> Bool) -> [a] -> [b]
mapfilter f p xs = [f x | x <- xs, p x]

-- mapfilter' f p xs = map f $ filter p xs
mapfilter' :: (a -> b) -> (a -> Bool) -> [a] -> [b]
mapfilter' f p = map f . filter p


unittests_mapfilter = Test.HUnit.test [
     "mapfilter" ~: mapfilter (2 *) (\x -> x `mod` 3 == 0) [1..10] ~?= [6, 12, 18]
    ,"mapfilter'" ~: mapfilter' (2 *) (\x -> x `mod` 3 == 0) [1..10] ~?= [6, 12, 18]
    ]


-- vim:sw=4 ts=4 et:
