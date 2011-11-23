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


q1_tests = runTestTT $ Test.HUnit.test [
     "mapfilter" ~: mapfilter (2 *) (\x -> x `mod` 3 == 0) [1..10] ~?= [6, 12, 18]
    ,"mapfilter'" ~: mapfilter' (2 *) (\x -> x `mod` 3 == 0) [1..10] ~?= [6, 12, 18]
    ]


-- 2. all, any, takeWhile, dropWhile
all' :: [Bool] -> Bool
all' = foldl (&&) True

any' :: [Bool] -> Bool
any' = foldl (||) False

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' p []                 = []
takeWhile' p (x:xs) | p x       = x : takeWhile' p xs
                    | otherwise = []

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' p []                 = []
dropWhile' p (x:xs) | p x       = dropWhile' p xs
                    | otherwise = x : xs

q2_tests = runTestTT $ Test.HUnit.test [
     "all' [True, True]" ~: all' [True, True] ~?= True
    ,"all' [True, False, True]" ~: all' [True, False, True] ~?= False
    ,"any' [False, False]" ~: any' [False, False] ~?= False
    ,"any' [False, False, True]" ~: any' [False, False, True] ~?= True
    ,"takeWhile' even [0, 2, 4, 5]" ~: takeWhile' even [0, 2, 4, 5] ~?= [0, 2, 4]
    ,"dropWhile' even [0, 2, 4, 5]" ~: dropWhile' even [0, 2, 4, 5] ~?= [5]
    ]


-- 3. define map f and filter p w/ foldr
map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x -> \acc -> f x : acc) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x -> \acc -> if p x then x : acc else acc) []

q3_tests = runTestTT $ Test.HUnit.test [
     "map' (* 2) [0..3]" ~: map' (* 2) [0..3] ~?= [0, 2, 4, 6]
    ,"filter' odd [0..3]" ~: filter' odd [0..3] ~?= [1, 3]
    ]


-- 4. define dec2int w/ foldl
type Decimal = Int

dec2int :: [Decimal] -> Int
dec2int ds = sum $ zipWith (*) weights $ reverse ds
    where weights = iterate (* 10) 1

{-

ghci> :l 7/exercises.hs
[1 of 1] Compiling HigherOrderFunctionsExercises ( 7/exercises.hs, interpreted )
Ok, modules loaded: HigherOrderFunctionsExercises.
ghci> dec2int [2..5]
2345
ghci>

-}

q4_tests = runTestTT $ Test.HUnit.test [
     "dec2int [2..5]" ~: dec2int [2..5] ~?= 2345
    ]


-- 5. sumsqreven

compose :: [a -> a] -> (a -> a)
compose = foldr (.) id

-- wrong version:
-- sumsqreven = compose [sum, map (^ 2), filter even]
-- 
-- sum :: [a] -> a
-- map (^ 2) :: [a] -> [a]
-- filter even :: [a] -> [a]

-- sumsqreven xs = sum $ map (^ 2) $ filter even xs
sumsqreven = sum . (map (^ 2) . filter even)

q5_tests = runTestTT $ Test.HUnit.test [
     "sumsqreven [1..5]" ~: sumsqreven [1..5] ~?= 20
    ]


-- 6. curry & uncurry
curry' :: ((a, b) -> c) -> a -> b -> c
curry' f x y = f (x, y)

uncurry' :: (a -> b -> c) -> ((a, b) -> c)
uncurry' f (x, y) = f x y

q6_tests = runTestTT $ Test.HUnit.test [
     "curry' fst 1 2" ~: curry' fst 1 2 ~?= 1
    ,"uncurry' (*) (2, 3)" ~: uncurry' (*) (2, 3) ~?= 6
    ]


-- 7. unfold
unfold' :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold' p h t x | p x       = []
                | otherwise = h x : unfold' p h t (t x)

type Bit = Int


int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = m : int2bin d
    where m = n `mod` 2
          d = n `div` 2

{-

ghci> :l 7/exercises.hs
[1 of 1] Compiling HigherOrderFunctionsExercises ( 7/exercises.hs, interpreted )
Ok, modules loaded: HigherOrderFunctionsExercises.
ghci> int2bin 1024
[0,0,0,0,0,0,0,0,0,0,1]
ghci>

-}

int2bin' :: Int -> [Bit]
int2bin' = unfold' (== 0) (`mod` 2) (`div` 2)


chop8 :: [Bit] -> [[Bit]]
chop8 bits | null bits = []
           | otherwise = take 8 bits : chop8 (drop 8 bits)

chop8' :: [Bit] -> [[Bit]]
chop8' = unfold' null (take 8) (drop 8)


{-
map :: (a -> b) -> [a] -> [b]
map f xs | null xs   = []
         | otherwise = f . head xs : map f . tail xs
-}

map'' f = unfold' null (f . head) tail


iterate' :: (a -> a) -> a -> [a]
iterate' f x | const False x = []
             | otherwise     = x : iterate' f (f x)

iterate'' f = unfold' (const False) id f


q7_tests = runTestTT $ Test.HUnit.test [
     "chop8'" ~: chop8' (int2bin 1024) ~?= chop8 (int2bin 1024)
    ,"map''" ~: map'' (+ 1) [0..5] ~?= [1..6]
    ,"iterate'" ~: take 4 (iterate'' (* 2) 1) ~?= take 4 (iterate' (* 2) 1)
    ]


-- 8. decde w/ parity check
-- original:
encode :: String -> [Bit]
encode = concat . map (make8 . int2bin . ord)

make8 :: [Bit] -> [Bit]
make8 bits = take 8 $ bits ++ repeat 0

bin2int :: [Bit] -> Int
bin2int bits = sum (zipWith (*) weights bits)
    where weights = iterate (* 2) 1

decode :: [Bit] -> String
decode = map (chr . bin2int) . chop8

channel :: [Bit] -> [Bit]
channel = id

transmit :: String -> String
transmit = decode . channel . encode


--- w/ parity addition
parity :: [Bit] -> Int
parity bits | f bits    = 1
            | otherwise = 0
    where f = odd . length . filter (== 1)


parity_tests = runTestTT $ Test.HUnit.test [
     "parity [1]" ~: parity [1] ~?= 1
    ,"parity [1, 0, 1]" ~: parity [1, 0, 1] ~?= 0
    ]


encode' :: String -> [Bit]
encode' = concat . map (f . make8 . int2bin . ord)
    where f :: [Bit] -> [Bit]
          f bits = parity bits : bits

encode_tests = runTestTT $ Test.HUnit.test [
     "encode \"a\"" ~: encode' "a" ~?= 1 : encode "a"
    ,"encode \"abc\"" ~: encode' "abc" ~?= f "a" ++ f "b" ++ f "c"
    ]
    where f :: String -> [Bit]
          f s = let bs = encode s in parity bs : bs

prop_encode' s = encode' s == concat [f [c] | c <- s]
    where types = s :: String
          f :: String -> [Bit]
          f s = let bs = encode s in parity bs : bs

{-

ghci> :l 7/exercises.hs
[1 of 1] Compiling HigherOrderFunctionsExercises ( 7/exercises.hs, interpreted )
Ok, modules loaded: HigherOrderFunctionsExercises.
ghci> encode "abc"
[1,0,0,0,0,1,1,0,0,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0]
ghci> encode' "abc"
[1,1,0,0,0,0,1,1,0,1,0,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,0]
ghci>

-}

chop9 :: [Bit] -> [[Bit]]
chop9 [] = []
chop9 bits = take 9 bits : chop9 (drop 9 bits)

chop9_tests = runTestTT $ Test.HUnit.test [
     "chop9" ~: chop9 (concat bits) ~?= bits
    ]
    where bits = [encode' "a" | _ <- [0..2]]


-- parity check
pcheck :: [Bit] -> [Bit]
pcheck bits | f bits    = tail bits
            | otherwise = error "Parity check error!"
    where f :: [Bit] -> Bool
          f bits = head bits == (parity (tail bits))

prop_pcheck n = pcheck bits == tail bits
    where types = n :: Int
          bits = let bs = make8 $ int2bin n in parity bs : bs


decode' :: [Bit] -> String
decode' = map (chr . bin2int . pcheck) . chop9

prop_decode' s = decode' (encode' s) == s
    where types = s :: String


-- lost last bit of each char.
channel' :: [Bit] -> [Bit]
channel' = concat . map tail . chop9

transmit' :: String -> String
transmit' = decode' . channel' . encode'

{-

ghci> :l 7/exercises.hs
[1 of 1] Compiling HigherOrderFunctionsExercises ( 7/exercises.hs, interpreted )
Ok, modules loaded: HigherOrderFunctionsExercises.
ghci> (decode' . channel' . encode') "abc"
"*** Exception: Parity check error!
ghci> (decode' . channel'' . encode') "abc"
"\176*** Exception: Parity check error!
ghci> let channel''' = concat . tail . chop9 :: [Bit] -> [Bit]  -- drop first char
ghci> (decode' . channel''' . encode') "abc"
"bc"
ghci>

-}


-- run all tests:
runtests = do q1_tests
              q2_tests
              q3_tests
              q4_tests
              q5_tests
              q6_tests
              q7_tests
              parity_tests
              encode_tests
              chop9_tests
              quickCheck prop_encode'
              quickCheck prop_pcheck
              quickCheck prop_decode'

{-

ghci> :l 7/exercises.hs
[1 of 1] Compiling HigherOrderFunctionsExercises ( 7/exercises.hs, interpreted )
Ok, modules loaded: HigherOrderFunctionsExercises.
ghci> runtests
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 6  Tried: 6  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 3  Tried: 3  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 2  Tried: 2  Errors: 0  Failures: 0
Cases: 1  Tried: 1  Errors: 0  Failures: 0
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
+++ OK, passed 100 tests.
ghci>

-}


-- vim:sw=4 ts=4 et:
