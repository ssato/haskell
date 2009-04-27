--
-- perfect number - equals the sum of its factors
--

module Main where
import Test.QuickCheck

prop_factors n = n > 1 ==> and [n `mod` x == 0 | x <- factors n]
        where types = n::Int

prop_factors' n = n > 1 ==> factors n == factors' n ++ [n]
        where types = n::Int

prop_perfects n = and [x == sum (init $ factors x) | x <- perfects n]
        where types = n::Int

prop_perfects' n = and [x == sum (factors' x) | x <- perfects' n]
        where types = n::Int

quicktests = do quickCheck prop_factors
                quickCheck prop_perfects
                quickCheck prop_factors'
                quickCheck prop_perfects'


-- factors
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

-- perfects
perfects :: Int -> [Int]
perfects n = [x | x <- [1..n], x == sum (init $ factors x)]

-- factors' - almost same as the above but itself is excluded.
factors' :: Int -> [Int]
factors' n = [x | x <- [1..n-1], n `mod` x == 0]

-- perfects
perfects' :: Int -> [Int]
perfects' n = [x | x <- [1..n], x == sum (factors' x)]
