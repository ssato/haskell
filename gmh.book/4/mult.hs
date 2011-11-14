--
-- multi variants
--
module Multi where
import Test.QuickCheck


multi :: Num a => a -> a -> a -> a
multi x y z = x * y * z

multi' = \x -> ( \y -> ( \z -> x * y * z))


-- tsets:
prop_multi' x y z = multi' x y z == multi x y z
        where types = (x, y, z) :: (Int, Int, Int)


runtests = quickCheck prop_multi'
