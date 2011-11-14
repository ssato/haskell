--
-- halve - splits an even-lengthed list into two halves
--
module Halve where
import Test.QuickCheck

halve :: [a] -> ([a],[a])
halve [] = ([],[])
halve xs = if even l then (take m xs, drop m xs)
           else error "Not even-lengthed list given!"
        where l = length xs
              m = l `div` 2


halve' :: [a] -> ([a], [a])
halve' [] = ([], [])
halve' xs = if even l then splitAt m xs
            else error "Not even-lengthed list given!"
        where l = length xs
              m = l `div` 2

prop_halve xs = even_list xs ==> (fst xy, snd xy) == xy
        where xy = halve xs
              even_list xs = length xs `mod` 2 == 0
              types = xs :: [Int]

prop_halve' xs = even_list xs ==> (fst xy, snd xy) == xy
        where xy = halve' xs
              even_list xs = length xs `mod` 2 == 0
              types = xs :: [Int]
 
runtests = quickCheck prop_halve >> quickCheck prop_halve'
