{-

'last' implementations

last - select the last element of a non-empty list.

-}

module Last where
import Test.QuickCheck


prop_last_1 xs = length xs > 0 ==> last xs == last_1 xs
prop_last_2 xs = length xs > 0 ==> last xs == last_2 xs
prop_last_3 xs = length xs > 0 ==> last xs == last_3 xs
prop_last_4 xs = length xs > 0 ==> last xs == last_4 xs


-- last :: [a] -> a

last_1 :: [a] -> a
last_1 xs = xs !! (length xs - 1)

last_2 :: [a] -> a
last_2 xs = head $ reverse xs

last_3 :: [a] -> a
last_3 xs = head $ drop (length xs - 1) xs

last_4 :: [a] -> a
last_4 [] = error "Given list is empty!"
last_4 [x] = x
last_4 (_:xs) = last_4 xs
