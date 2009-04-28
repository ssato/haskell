--
-- 7.2 Processing lists
--
module Main where

-- map
map' :: (a -> b) -> [a] -> [b]
map' f xs = [f x | x <- xs]

map'' :: (a -> b) -> [a] -> [b]
map'' f []     = []
map'' f (x:xs) = f x: map'' f xs

-- filter 
filter' :: (a -> Bool) -> [a] -> [a]
filter' p xs = [x | x <- xs, p x]

filter'' :: (a -> Bool) -> [a] -> [a]
filter'' p []                 = []
filter'' p (x:xs) | p x       = x:filter'' p xs
                  | otherwise = filter'' p xs

-- sumsqreven  - sum of the squares of the even integers from a list
sumsqreven :: [Int] -> Int
sumsqreven ns = sum (map (^ 2) (filter even ns))

