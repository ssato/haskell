--
-- halve - splits an even-lengthed list into two halves
--
module Halve where
import Test.QuickCheck

prop_halve xs = even_list xs ==> (fst xy, snd xy) == xy
        where xy = halve xs
              even_list :: [a] -> Bool
              even_list xs = length xs `mod` 2 == 0
--        where types = xs::[a]

halve :: [a] -> ([a],[a])
halve [] = ([],[])
halve xs = if even l then (take m xs, drop m xs)
           else error "Not even-lengthed list given!"
        where l = length xs
              m = l `div` 2

  
