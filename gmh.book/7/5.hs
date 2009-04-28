--
-- 7.4 The foldl function
--
module Main where

import Data.List
import Test.QuickCheck hiding (test)
import Test.HUnit


-- composition
(...) :: (b -> c) -> (a -> b) -> (a -> c)
f ... g = \x -> f (g x)

-- identify
id' :: a -> a
id' = \x -> x

-- composition of a list
compose :: [a -> a] -> (a -> a)
compose = foldr (...) id'
