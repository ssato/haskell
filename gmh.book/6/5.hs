--
-- 6.5 Mutual recursions
--
module MutualRecursionExamples where

import Test.QuickCheck
import Test.HUnit


-- even / odd (avoiding n + k pattern):
even' :: Int -> Bool
even' 0 = True
even' 1 = False
even' n = odd' (n - 1)

odd' :: Int -> Bool
odd' 0 = False
odd' 1 = True
odd' n = even' (n - 1)


unittests = Test.HUnit.test [
     "even' 3" ~: even' 3 ~?= False
    ,"even' 8" ~: even' 8 ~?= True
    ,"odd' 8" ~: odd' 8 ~?= False
    ,"odd' 9" ~: odd' 9 ~?= True
    ]

{-
prop_even' n = even' n == (n `mod` 2 == 0)
    where types = n :: Int

prop_odd' n = odd' n == (n `mod` 2 == 1)
    where types = n :: Int

runtests = runTestTT unittests >> quickCheck prop_even' >> quickCheck prop_odd'
-}

runtests = runTestTT unittests


-- vim:sw=4 ts=4 et:
