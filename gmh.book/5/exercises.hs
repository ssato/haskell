--
-- 5.7 Exercises
--

module ListComprehensionExercises where


import Test.QuickCheck
import Test.HUnit


-- 1. 1 ^ 2 + 2 ^ 2 + ... + 100 ^ 2 = ?
sum_of_square_from_1_to_100 = sum [n ^ 2 | n <- [1..100]]
sum_of_square_from_1_to_100' = foldl (\n -> \m -> n + m ^ 2) 0 [1..100]
{-

ghci> sum [n ^ 2 | n <- [1..100]]
338350
ghci> foldl (\n -> \m -> n + m ^ 2) 0 [1..100]
338350
ghci>

-}


-- 2. replicate
replicate' :: Int -> a -> [a]
replicate' n x = [x | _ <- [0..(n - 1)]]

-- other solutions:
replicate'' :: Int -> a -> [a]
replicate'' n = take n . repeat


prop_replicate' n x = replicate' n x == replicate n x
    where types = (n :: Int, x :: Int)

prop_replicate'' n x = replicate'' n x == replicate n x
    where types = (n :: Int, x :: Int)


-- 3. Pythagorean triples
pyths :: Int -> [(Int, Int, Int)]
pyths n | n < 1     = []
        | otherwise = [(x,y,z) | x <- [2..n-2],
                                 y <- [x..n-2],
                                 z <- [y..n],
                                 x ^ 2 + y ^ 2 == z ^ 2]

prop_pyths n = n > 1 ==> and [x ^ 2 + y ^ 2 == z ^ 2 | (x, y, z) <- pyths n]
    where types = n :: Int


-- 4. Perfect numbers: http://en.wikipedia.org/wiki/Perfect_number

-- factors
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

-- perfects
perfects :: Int -> [Int]
perfects n | n >= 3 = [x | x <- [3..n], f x]
           | otherwise = error "n must be greater than 2"
    where f x = x == g x
          g = sum . init . factors
          -- or: g x = sum (factors x) - x :: Int -> Bool


unittest_perfects = "perfects 500" ~: perfects 500 ~?= [6, 28, 496]


-- 5.
list_comprehension_5_7_5_org = [(x, y) | x <- [1, 2, 3], y <- [4, 5, 6]]
list_comprehension_5_7_5 =
    concat [[(x, y) | y <- [4, 5, 6]] | x <- [1, 2, 3]]

unittest_5 = "double generators -> single generator in list comprehension" ~: list_comprehension_5_7_5 ~?= list_comprehension_5_7_5_org

{-

ghci> concat [[(x, y) | x <- [1, 2, 3]] | y <- [4, 5, 6]]
[(1,4),(2,4),(3,4),(1,5),(2,5),(3,5),(1,6),(2,6),(3,6)]
ghci> [(x, y) | x <- [1, 2, 3], y <- [4, 5, 6]]
[(1,4),(1,5),(1,6),(2,4),(2,5),(2,6),(3,4),(3,5),(3,6)]
ghci>

-}


-- 6. 'positions' implemented in find:

-- find
find :: Eq a => a -> [(a,b)] -> [b]
find k t = [v | (k',v) <- t, k' == k]

-- positions (original):
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip xs [0..n], x == x']
    where n = length xs - 1

-- positions implemented with using 'find'
positions' :: Eq a => a -> [a] -> [Int] 
positions' x xs = find x (zip xs [0..n])
    where n = length xs - 1

unittest_find_0 = "find -> some results" ~: find 'b' [('a',1),('b',2),('c',3),('b',4)] ~?= [2,4]
unittest_find_1 = "find -> empty" ~: find 'd' [('a',1),('b',2),('c',3),('b',4)] ~?= []


prop_positions' x xs = length xs > 0 ==> positions x xs == positions' x xs
        where types = (x :: Int, xs :: [Int])


-- 7. scalar product:

scalarproduct :: [Int] -> [Int] -> Int
scalarproduct xs ys = sum [x * y | (x,y) <- zip xs ys]

unittest_scalarproduct = "scalarproduct" ~: scalarproduct [1,2,3] [4,5,6] ~?= 32


unittests = Test.HUnit.test [
     unittest_perfects
    ,unittest_5
    ,unittest_find_0
    ,unittest_find_1
    ,unittest_scalarproduct
    ]

runtests = do runTestTT unittests
              quickCheckWith stdArgs {maxSuccess=7} prop_replicate'
              quickCheckWith stdArgs {maxSuccess=7} prop_replicate''
              quickCheckWith stdArgs {maxSuccess=7} prop_pyths


-- vim:sw=4 ts=4 et:
