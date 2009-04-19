{-

'init' implementations

init - remove the last element from a non-empty list
-}

module Init where
import Test.QuickCheck


prop_init_1 xs = length xs > 0 ==> init xs == init_1 xs
prop_init_2 xs = length xs > 0 ==> init xs == init_2 xs


init_1  :: [a] -> [a]
init_1 [] = error "given list is empty!"
init_1 xs = take (length xs - 1) xs

init_2 :: [a] -> [a]
init_2 xs = reverse $ tail $ reverse xs
