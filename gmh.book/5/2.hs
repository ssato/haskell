--
-- 5.2 Guards
--
module Main where

-- list positive factors of a positive integer
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

-- prime number
prime :: Int -> Bool
prime n = factors n == [1, n]

-- prime numbers upto n
primes :: Int -> [Int]
primes n = [x | x <- [2..n], prime x]

-- returns the list of all values that are associated with a given key in a
-- table which is a list of pairs comprising keys and values.
find :: Eq a => a -> [(a,b)] -> [b]
find k tbl = [v | (k', v) <- tbl, k == k']
