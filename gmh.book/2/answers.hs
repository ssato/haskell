module Gmh2 where

-- import Data.List
import Test.QuickCheck


{-
1. 演算子の優先順位

2 ^ 3 * 4 -> (2 ^ 3) * 4
2 * 3 + 4 * 5 -> (2 * 3) + (4 * 5)
2 + 3 * 4 ^ 5 -> 2 + (3 * (4 ^ 5))


確認例:

ghci> 2 ^ 3 * 4
32
ghci> 2 ^ (3 * 4)
4096
ghci> (2 ^ 3) * 4
32
ghci> 2 * 3 + 4 * 5
26
ghci> (2 * 3) + (4 * 5)
26
ghci> 2 + 3 * 4 ^ 5
3074
ghci> 2 + (3 * (4 ^ 5))
3074
ghci>


2. session.log を参照 (hugs の代わりに ghci で実行)


3. 

a `div` length xs -->

  * length が div の仮引数として解釈されてしまう
  * length の返り値と div の仮引数の型が不一致

ghci> :t length
length :: [a] -> Int
ghci> :t div
div :: (Integral a) => a -> a -> a
ghci> :t toInteger
toInteger :: (Integral a) => a -> Integer
ghci>
ghci> a `div` $ toInteger $ le
length  lex
ghci> a `div` (toInteger $ length xs)
2
ghci>

-}

-- 4. last を定義

last_by_index :: [a] -> a
last_by_index [] = error "List must not be empty!"
last_by_index xs = xs !! (length xs - 1)

last_reverse :: [a] -> a
last_reverse = head . reverse

last_reverse' :: [a] -> a
last_reverse' xs = head $ reverse xs

last_drop :: [a] -> a
last_drop xs = head $ drop (length xs - 1) xs

last_recur :: [a] -> a
last_recur [x] = x
last_recur (_:xs) = last_recur xs


prop_last_by_index xs = length xs > 0 ==> last xs == last_by_index xs
        where types = xs::[Int]
prop_last_reverse xs = length xs > 0 ==> last xs == last_reverse xs
        where types = xs::[Int]
prop_last_reverse' xs = length xs > 0 ==> last xs == last_reverse' xs
        where types = xs::[Int]
prop_last_drop xs = length xs > 0 ==> last xs == last_drop xs
        where types = xs::[Int]
prop_last_recur xs = length xs > 0 ==> last xs == last_recur xs
        where types = xs::[Int]


-- 5. init (空でないリストから最後の要素を取り除く) の定義

init_by_take :: [a] -> [a]
init_by_take [] = error "List must not be empty!"
init_by_take xs = take (length xs - 1) xs

init_by_reverse :: [a] -> [a]
init_by_reverse xs = reverse $ tail $ reverse xs

init_by_reverse' :: [a] -> [a]
init_by_reverse' = reverse . tail . reverse


prop_init_by_take xs = length xs > 0 ==> init xs == init_by_take xs
        where types = xs::[Int]
prop_init_by_reverse xs = length xs > 0 ==> init xs == init_by_reverse xs
        where types = xs::[Int]
prop_init_by_reverse' xs = length xs > 0 ==> init xs == init_by_reverse' xs
        where types = xs::[Int]


runtests = do quickCheck prop_last_by_index
              quickCheck prop_last_reverse
              quickCheck prop_last_reverse'
              quickCheck prop_last_drop
              quickCheck prop_last_recur
              quickCheck prop_init_by_take
              quickCheck prop_init_by_reverse
              quickCheck prop_init_by_reverse'


