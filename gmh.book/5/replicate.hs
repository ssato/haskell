--
-- replicate - produces a list of identical elemnts
--
module Main where
import Test.QuickCheck

-- prop_replicate n x = n > 0 && x ==> and $ replicate n x
--        where types = n::Int

length' :: [a] -> Int
length' xs = sum [1 | _ <- xs]

replicate' :: Int -> a -> [a]
replicate' 0 x = []
replicate' n x = [x | _ <- [1..n]]

