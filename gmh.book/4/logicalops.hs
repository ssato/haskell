--
-- logical operators; ||, &&
--
module Logicalops where
import Test.QuickCheck


-- 3. logical or, simple patterns match: 
or1 :: Bool -> Bool -> Bool
True  `or1` True  = True
True  `or1` False = True
False `or1` True  = True
False `or1` False = False

or2 :: Bool -> Bool -> Bool
True  `or2` _     = True
_     `or2` True  = True
False `or2` False = False

or3 :: Bool -> Bool -> Bool 
False `or3` False = False
_     `or3` _     = True

or4 :: Bool -> Bool -> Bool 
a `or4` b | a == b     = if a == True then True else False
          | otherwise = True


-- 4. 
or6 :: Bool -> Bool -> Bool
True `or6` True = True
_    `or6` _    = False


or7 :: Bool -> Bool -> Bool
a `or7` b = if a == b then if a == True then True else False
            else False


-- 5. 
or8 :: Bool -> Bool -> Bool
True  `or8` b = b
False `or8` _ = False


or9 :: Bool -> Bool -> Bool
a `or9` b = if a == True then b else False


-- tsets:
prop_or2 a b = a `or2` b == a `or1` b
        where types = (a, b) :: (Bool, Bool)

prop_or3 a b = a `or3` b == a `or1` b
        where types = (a, b) :: (Bool, Bool)

prop_or4 a b = a `or4` b == a `or1` b
        where types = (a, b) :: (Bool, Bool)

prop_or7 a b = a `or7` b == a `or6` b
        where types = (a, b) :: (Bool, Bool)

prop_or9 a b = a `or9` b == a `or8` b
        where types = (a, b) :: (Bool, Bool)


runtests = mapM_ quickCheck [
                            prop_or2
                           ,prop_or3
                           ,prop_or4
                           ,prop_or7
                           ,prop_or9
                           ]
