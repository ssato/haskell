--
-- logical operators; ||, &&
--
module Logicalops where
import Test.QuickCheck

-- prop_safetail_b xs = not (null xs) ==> safetail_b xs == tail xs

(||) :: Bool -> Bool -> Bool
True  || True  = True
True  || False = True
False || True  = True
False || False = False

-- variant
v :: Bool -> Bool -> Bool
True  `v` _    = True
_     `v` True = True
_     `v` _    = False


-- 4.
(&) :: Bool -> Bool -> Bool
x & y = if x then
              if y then True else False
          else False

-- 5.
(^^) :: Bool -> Bool -> Bool
a ^^ b = if a then b
         else False
